# Bug Design Document: Preference Cache Returns Stale Data After Update

**Bug ID**: `ntf-bug-7`
**Related Issue / Epic**: `ntf-pref` (Notification Preferences & Compliance)
**Related Low Level Design**: `design_example/epic_example/ntf-pref_LLD.md`
**Status**: Fixed v1.0
**Severity**: Sev-2 (high)
**Priority**: P2
**Target Languages / Runtimes**: TypeScript (Node.js 20 LTS)
**Framework Stack**: Fastify 4, Prisma 5, PostgreSQL 16, Redis 7
**Affected Modules / Components**: `shared/preferences`

---

## 1. Header / Metadata

- **Title**: Preference cache returns stale data after update
- **Bug ID**: `ntf-bug-7`
- **Related Issue / Epic**: `ntf-pref` (Notification Preferences & Compliance)
- **Status**: Fixed v1.0
- **Severity**: Sev-2 (high)
- **Priority**: P2
- **Author**: Alex Rivera
- **Reviewers**: Priya Shah
- **Date Created**: 10/19/26
- **Date Last Updated**: 10/22/26
- **Affected Modules / Components**: `shared/preferences`
- **Target Languages / Runtimes**: TypeScript (Node.js 20 LTS)
- **Framework Stack**: Fastify 4, Prisma 5, PostgreSQL 16, Redis 7

---

## 2. Problem Description

### 2.1 Summary
After a user opts out of marketing emails, the dispatcher still sends marketing emails for up to 60 seconds because the preference cache is not invalidated on the `BulkCheck` code path.

### 2.2 Steps to Reproduce
1. User u1 opts out of marketing email via `PUT /v1/preferences`.
2. Within 60s, trigger a marketing email notification for u1.
3. Observe the email is still sent.

### 2.3 Expected Behavior
Marketing email should be dropped immediately after opt-out; audit row status=dropped.

### 2.4 Actual Behavior
Email is sent; audit row status=delivered; cache shows stale enabled=true.

### 2.5 Frequency / Impact
Always reproducible within the 60s TTL window. Affects all users who opt out; compliance risk (GDPR opt-out not honored promptly).

---

## 3. Environment

- **Environment**: staging (reproduced) and prod (reported)
- **Version / Build**: ntf-1.0.0-rc.2
- **Configuration**: `preference.cache.ttl=60s`
- **Dependencies**: Redis 7, PostgreSQL 16

---

## 4. Root Cause Analysis

### 4.1 Investigation
- Traced dispatcher logs: `BulkCheck` returned `allowed=true` immediately after opt-out.
- Compared with single `Check` path, which invalidated correctly.
- Found `BulkCheck` reads from cache but never deletes the cache key on write (the `update` path only invalidates the single-check key).

### 4.2 Root Cause
In `shared/preferences/PreferenceCache.ts`, `update()` calls `redis.del(key)` for the single-check key format `pref:{userId}:{channel}:{category}` but `BulkCheck` uses a composite key `pref:bulk:{userId}` that is never invalidated. Stale bulk entry persists until TTL expiry.

### 4.3 Contributing Factors
- Two cache key schemes (single + bulk) introduced without a unified invalidation strategy.
- Missing test for bulk path invalidation.

---

## 5. Fix Design

### 5.1 Proposed Fix
Unify cache invalidation: on any preference write, delete both the single key and the bulk key for the affected user. Extract a `invalidateUser(userId)` helper used by both `Check` and `BulkCheck` paths.

### 5.2 Affected Files / Modules
- `shared/preferences/PreferenceCache.ts`: add `invalidateUser(userId)`; call from `update()`.
- `shared/preferences/PreferenceRepository.ts`: ensure update triggers invalidation.

### 5.3 Design Patterns Used

#### Strategy
> **Pattern**:
> ```mermaid
> classDiagram
>     class PreferenceCheck { <<interface>> +check(userId, channel, category) }
>     class CachedPreferenceCheck
>     PreferenceCheck <|.. CachedPreferenceCheck
> ```
> **Why Chosen**: Allows swapping between cached and direct DB checks; invalidation logic centralized in the cache strategy.

### 5.4 Alternatives Considered
- **Reduce TTL to 5s**: rejected — increases DB load; doesn't eliminate stale window.
- **Write-through cache (update cache on write)**: considered; invalidation is simpler and sufficient.

### 5.5 Rollback / Feature Flag Plan
- **Reversibility**: revert commit; cache behavior reverts to prior (buggy) state but no data loss.
- **Data Migration Rollback**: N/A (no schema change).

---

## 6. Impact Analysis

### 6.1 Affected Components
- `shared/preferences` (cache), `pipeline/dispatcher` (consumes bulk check).

### 6.2 Performance / Security Impact
- Extra `DEL` on write (negligible). No security impact.

### 6.3 Backward Compatibility
- No breaking changes; cache key format unchanged.

---

## 7. Quality Assurance & Verification

### 7.1 Reproduction Verification
- Reproduced on staging before fix (email sent within 60s of opt-out).
- Verified fixed: opt-out honored within 1s.

### 7.2 Regression Tests Added
- `pref-dispatch-bulk-invalidation`: bulk check reflects update within 1s.
- `pref-cache-invalidate-user`: both single and bulk keys deleted on update.

### 7.3 Quality Gates Executed

```bash
pnpm lint && pnpm typecheck
pnpm test --filter=preferences
```

### 7.4 Test Matrix

| Module / Component | Build Status | Test Count | Test Pass Rate |
| :--- | :--- | :--- | :--- |
| `shared/preferences` | Pass | 20 | 100% (20/20) |
| `pipeline/dispatcher` | Pass | 9 | 100% (9/9) |

---

## 8. Risks & Open Questions

### 8.1 Risks
- Cross-instance races: another instance may hold a stale bulk key; 60s TTL bounds residual risk.

### 8.2 Open Questions
- Should we unify to a single cache key scheme? (Owner: Alex Rivera, due 11/05/26.)

---

## 9. Changelog / Revision History

| Version | Date | Author | Summary of Changes |
| :--- | :--- | :--- | :--- |
| 0.1 | 10/19/26 | Alex Rivera | Initial draft |
| 1.0 | 10/22/26 | Alex Rivera | Fixed and verified |