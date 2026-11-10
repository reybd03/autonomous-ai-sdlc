# Test Cases: Per-User Notification Preference and Opt-Out Management

- File Name: `ntf-pref.1_test_cases.md`
- File Location: `notification-service/tests/`
- Related Test Plan: `design_example/epic_example/ntf_TEST_PLAN.md`
- Related High Level Design: `design_example/epic_example/ntf_HLD.md`
- Related Low Level Design: `design_example/epic_example/ntf-pref_LLD.md`
- Related Feature Design: `design_example/epic_example/features_example/ntf-pref.1_design_document.md`
- Table of Contents: see section headings below

## Document Control

| Field | Value |
| :--- | :--- |
| Version | v1.0 |
| Status | Approved v1.0 |
| Date Created | 10/20/26 |
| Date Last Updated | 10/22/26 |
| Author | Alex Rivera (alex.rivera@example.com) |
| Reviewers | Priya Shah |

---

## 1. Test Case Naming Convention

Format: `pref-<area>-<scenario>` (e.g. `pref-api-optout-blocks-marketing`). IDs are lowercase, hyphenated.

---

## 2. Test Case Index

| Area | ID Range | Count |
| :--- | :--- | :--- |
| Preference API | `pref-api-*` | 3 |
| Preference Enforcement (dispatcher) | `pref-dispatch-*` | 3 |
| Boundary / Negative | `pref-neg-*` | 4 |
| Authorization | `pref-auth-*` | 0 (matrix only, no dedicated cases) |
| Acceptance | `pref-accept-*` | 1 |

---

## 3. Test Case Specification

### 3.1 `pref-api-get-defaults`
- **ID**: `pref-api-get-defaults`
- **Title**: New user receives default preferences
- **HLD / Feature Ref**: ntf-pref.1 §5.1
- **Type**: Integration
- **Priority**: P2
- **Automation Status**: Automated
- **Owner**: Priya Shah
- **Preconditions**: User registered; no preference rows exist.
- **Test Data**: `userId = u1`
- **Steps**:
  1. `GET /v1/preferences` with JWT for u1.
- **Expected Results**: 200; transactional + security channels enabled; marketing disabled.
- **Actual Results / Status**: Pass
- **Defects**: none

### 3.2 `pref-api-optout-marketing`
- **ID**: `pref-api-optout-marketing`
- **Title**: User opts out of marketing emails
- **HLD / Feature Ref**: ntf-pref.1 §5.1, §5.6
- **Type**: Integration
- **Priority**: P1
- **Automation Status**: Automated
- **Owner**: Priya Shah
- **Preconditions**: User u1 with defaults.
- **Test Data**: `{ channel: "email", category: "marketing", enabled: false }`
- **Steps**:
  1. `PUT /v1/preferences` with body.
  2. `GET /v1/preferences`.
- **Expected Results**: 200; marketing.email = false; audit row created with actor=user.
- **Actual Results / Status**: Pass
- **Defects**: none

### 3.3 `pref-api-reset-defaults`
- **ID**: `pref-api-reset-defaults`
- **Title**: Reset restores defaults
- **HLD / Feature Ref**: ntf-pref.1 §5.1
- **Type**: Integration
- **Priority**: P3
- **Automation Status**: Automated
- **Owner**: Priya Shah
- **Preconditions**: User u1 with modified prefs.
- **Steps**:
  1. `DELETE /v1/preferences`.
  2. `GET /v1/preferences`.
- **Expected Results**: marketing reset to disabled; transactional/security enabled.
- **Actual Results / Status**: Pass
- **Defects**: none

### 3.4 `pref-dispatch-drops-opted-out`
- **ID**: `pref-dispatch-drops-opted-out`
- **Title**: Dispatcher drops notification when user opted out
- **HLD / Feature Ref**: ntf-pref.1 §5.3, §5.4
- **Type**: Integration
- **Priority**: P1
- **Automation Status**: Automated
- **Owner**: Priya Shah
- **Preconditions**: u1 opted out of marketing email; Kafka event published.
- **Steps**:
  1. Publish `NotificationRequested` (u1, marketing, email).
  2. Observe dispatcher.
- **Expected Results**: No email sent; audit row with status=dropped; metric `preference_check_total{result=denied}` incremented.
- **Actual Results / Status**: Pass
- **Defects**: none

### 3.5 `pref-dispatch-allows-transactional`
- **ID**: `pref-dispatch-allows-transactional`
- **Title**: Transactional notification delivered when opted in
- **HLD / Feature Ref**: ntf-pref.1 §5.3
- **Type**: Integration
- **Priority**: P1
- **Automation Status**: Automated
- **Owner**: Priya Shah
- **Preconditions**: u1 defaults.
- **Steps**:
  1. Publish `NotificationRequested` (u1, transactional, email).
- **Expected Results**: Email sent via SendGrid; audit row status=delivered.
- **Actual Results / Status**: Pass
- **Defects**: none

### 3.6 `pref-dispatch-security-forced`
- **ID**: `pref-dispatch-security-forced`
- **Title**: Security notification delivered even when user opts out of all
- **HLD / Feature Ref**: ntf-pref.1 §5.6
- **Type**: Integration
- **Priority**: P1
- **Automation Status**: Automated
- **Owner**: Priya Shah
- **Preconditions**: u1 opted out of all channels/categories (except security forced).
- **Steps**:
  1. Publish `NotificationRequested` (u1, security, email).
- **Expected Results**: Email sent; preference shows security.email = true.
- **Actual Results / Status**: Pass
- **Defects**: none

### 3.7 Test Case Summary Table *(optional)*

| ID | Title | Type | Priority | Status |
| :--- | :--- | :--- | :--- | :--- |
| `pref-api-get-defaults` | New user receives default preferences | Integration | P2 | Pass |
| `pref-api-optout-marketing` | User opts out of marketing emails | Integration | P1 | Pass |
| `pref-api-reset-defaults` | Reset restores defaults | Integration | P3 | Pass |
| `pref-dispatch-drops-opted-out` | Dispatcher drops opted-out notification | Integration | P1 | Pass |
| `pref-dispatch-allows-transactional` | Transactional delivered when opted in | Integration | P1 | Pass |
| `pref-dispatch-security-forced` | Security notification forced delivery | Integration | P1 | Pass |

---

## 4. Acceptance Tests

### 4.1 `pref-accept-optout-e2e`
- **ID**: `pref-accept-optout-e2e`
- **Title**: End-to-end opt-out enforcement
- **Preconditions**: u1 registered; marketing preference enabled.
- **Steps**:
  1. u1 opts out of marketing via UI.
  2. Trigger marketing notification.
  3. Verify no delivery; audit shows dropped.
- **Expected Results**: No marketing email received; audit row present.

---

## 5. Authorization / Permission Matrix

| Function / Endpoint | User (self) | Admin | Other User |
| :--- | :--- | :--- | :--- |
| `GET /v1/preferences` (own) | r | r | denied |
| `PUT /v1/preferences` (own) | w | w (audited) | denied |
| `DELETE /v1/preferences` (own) | w | w (audited) | denied |
| `GET /v1/preferences` (other) | denied | r | denied |

Legend: `r` = read, `w` = write, `denied` = no access.

---

## 6. Boundary & Negative Test Cases

### 6.1 `pref-neg-invalid-channel`
- **ID**: `pref-neg-invalid-channel`
- **Type**: Negative
- **Input**: `{ channel: "sms", category: "marketing", enabled: false }`
- **Expected**: `400 INVALID_PREFERENCE`

### 6.2 `pref-neg-invalid-category`
- **ID**: `pref-neg-invalid-category`
- **Type**: Negative
- **Input**: `{ channel: "email", category: "promo", enabled: false }`
- **Expected**: `400 INVALID_PREFERENCE`

### 6.3 `pref-neg-user-not-found`
- **ID**: `pref-neg-user-not-found`
- **Type**: Negative
- **Input**: `GET /v1/preferences` for unknown userId
- **Expected**: `404 USER_NOT_FOUND`

### 6.4 `pref-neg-security-disable`
- **ID**: `pref-neg-security-disable`
- **Type**: Negative
- **Input**: `PUT` security category `enabled: false`
- **Expected**: `400` or forced to true; audit records attempt.

---

## 7. Regression Test Cases *(optional)*
- Existing notification delivery unchanged for users with default preferences.

---

## 8. Traceability Matrix

| Test Case ID | Requirement / HLD § / Feature § | Coverage |
| :--- | :--- | :--- |
| `pref-api-get-defaults` | ntf-pref.1 §5.1 | Default preference retrieval |
| `pref-api-optout-marketing` | ntf-pref.1 §5.1, §5.6 | Opt-out + audit |
| `pref-dispatch-drops-opted-out` | ntf-pref.1 §5.3, §5.4 | Enforcement + drop |
| `pref-dispatch-security-forced` | ntf-pref.1 §5.6 | Forced-enabled security |
| `pref-neg-invalid-channel` | ntf-pref.1 §5.4 | Error handling |

---

## 9. Test Environment & Setup *(optional)*

```bash
# Local dev
docker compose up -d postgres redis kafka
pnpm migrate:dev

# Run
pnpm test --filter=preferences
pnpm test:integration --filter=preferences
```

---

## 10. Changelog / Revision History

| Version | Date | Author | Summary of Changes |
| :--- | :--- | :--- | :--- |
| 0.1 | 10/20/26 | Alex Rivera | Initial draft |
| 1.0 | 10/22/26 | Alex Rivera | Approved after review |