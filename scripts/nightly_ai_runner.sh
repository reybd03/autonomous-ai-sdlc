#!/usr/bin/env bash
#
# nightly_ai_runner.sh
#
# Runs local Ollama AI models on beads tasks between 12am and 6am.
# Scans ~/dev/devlopment/* and ~/dev/frontEnd/* for project directories that
# have both .beads (beads initialized) and design/ (design directory).
# For each qualifying project, claims ready beads tasks and dispatches them
# to the appropriate AI model based on role assignments in guidelines/users.md.
#
# Usage:
#   Add to crontab (runs every 15 min, script self-restricts to 00:00-06:00):
#     */15 * * * * /home/alpharius/nightly_ai_runner.sh >> /var/log/nightly_ai_runner.log 2>&1
#
set -euo pipefail

###############################################################################
# Configuration
###############################################################################

# Time window: 00:00 (12am) through 05:59 (6am). Hour 0-5 inclusive.
NIGHT_START_HOUR=0
NIGHT_END_HOUR=5   # last hour to start a run (6am = hour 6, excluded)
FORCE_RUN="${FORCE_RUN:-false}"

# Project root directories to scan (immediate children + the roots themselves)
# Can be overridden via PROJECT_ROOTS env variable (colon-separated)
if [[ -n "${PROJECT_ROOTS:-}" && ! "$(declare -p PROJECT_ROOTS 2>/dev/null)" =~ "declare -a" ]]; then
    IFS=':' read -r -a PROJECT_ROOTS <<< "$PROJECT_ROOTS"
elif [[ -z "${PROJECT_ROOTS+x}" ]]; then
    PROJECT_ROOTS=(
        "$HOME/dev/devlopment"
        "$HOME/dev/frontEnd"
        "$HOME/dev"
    )
fi

# Log file
LOG_FILE="${NIGHTLY_AI_LOG_FILE:-$HOME/nightly_ai_runner.log}"

# Ollama host (default local)
OLLAMA_HOST="${OLLAMA_HOST:-http://localhost:11434}"

# Model role mapping (from guidelines/users.md)
# Format: "role_key=model_name"
declare -A MODEL_FOR_ROLE=(
    ["solution_architect"]="qwen3.5:Architect"
    ["lead_qa"]="qwen3.5:Architect"
    ["code_reviewer"]="qwen3.5:Architect"
    ["security_reviewer"]="qwen3.5:Architect"
    ["documentation"]="qwen3.5:Architect"
    ["epic_owner"]="qwen2.5-coder:3b"
    ["feature_designer"]="qwen2.5-coder:3b"
    ["devops"]="qwen2.5-coder:3b"
    ["bugfix_designer"]="qwen2.5-coder:3b"
    ["ui_ux"]="qwen2.5-coder:3b"
    ["senior_qa"]="qwen2.5-coder:3b"
    ["qa_engineer"]="qwen3:0.6b"
    ["feature_implementer"]="qwen3:0.6b"
    ["ui_ux_scoped"]="gemma3:1b"
)

###############################################################################
# Helpers
###############################################################################

log() {
    local ts
    ts="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$ts] $*" | tee -a "$LOG_FILE"
}

err() {
    log "ERROR: $*" >&2
}

# Check if current hour is within the nightly window or if force run is active.
is_time_window_active() {
    if [[ "$FORCE_RUN" == "true" ]]; then
        return 0
    fi
    local now_hour
    now_hour="$(date +%H | sed 's/^0*//')"
    if [[ -z "$now_hour" ]]; then now_hour=0; fi
    if [[ "$now_hour" -ge "$NIGHT_START_HOUR" && "$now_hour" -le "$NIGHT_END_HOUR" ]]; then
        return 0
    fi
    return 1
}

# Check if a directory is a valid beads+design project.
is_valid_project() {
    local dir="$1"
    [[ -d "$dir/.beads" ]] || return 1
    [[ -d "$dir/design" ]] || return 1
    return 0
}

# Discover all project directories to scan.
discover_projects() {
    local found=()
    for root in "${PROJECT_ROOTS[@]}"; do
        # The root itself
        if is_valid_project "$root"; then
            found+=("$root")
        fi
        # Immediate children
        if [[ -d "$root" ]]; then
            while IFS= read -r -d '' child; do
                if is_valid_project "$child"; then
                    found+=("$child")
                fi
            done < <(find "$root" -mindepth 1 -type d -print0 2>/dev/null)
        fi
    done
    # De-duplicate while preserving order
    printf '%s\n' "${found[@]}" | awk '!seen[$0]++'
}

# Map a beads task title/description to a model role.
# Returns the model name.
model_for_task() {
    local title="$1"
    local desc="$2"
    local combined
    combined="$(echo "${title} ${desc}" | tr '[:upper:]' '[:lower:]')"

    if [[ "$combined" =~ (template|example|documentation|changelog|design_system|ui_ux|wireframe|mockup|accessibility) ]]; then
        echo "${MODEL_FOR_ROLE[documentation]}"
        return
    fi
    if [[ "$combined" =~ (security|threat|compliance|privacy|vulnerability) ]]; then
        echo "${MODEL_FOR_ROLE[security_reviewer]}"
        return
    fi
    if [[ "$combined" =~ (test_plan|test_case|qa|test|verification|coverage) ]]; then
        echo "${MODEL_FOR_ROLE[lead_qa]}"
        return
    fi
    if [[ "$combined" =~ (review|code_review|gate|push.back) ]]; then
        echo "${MODEL_FOR_ROLE[code_reviewer]}"
        return
    fi
    if [[ "$combined" =~ (hld|high_level|architecture|architect) ]]; then
        echo "${MODEL_FOR_ROLE[solution_architect]}"
        return
    fi
    if [[ "$combined" =~ (lld|low_level|epic|decomposition) ]]; then
        echo "${MODEL_FOR_ROLE[epic_owner]}"
        return
    fi
    if [[ "$combined" =~ (feature|design_document|implement|code|refactor|build) ]]; then
        echo "${MODEL_FOR_ROLE[feature_designer]}"
        return
    fi
    if [[ "$combined" =~ (bug|fix|defect|issue) ]]; then
        echo "${MODEL_FOR_ROLE[bugfix_designer]}"
        return
    fi
    if [[ "$combined" =~ (deploy|ci/cd|pipeline|release|rollback|ops) ]]; then
        echo "${MODEL_FOR_ROLE[devops]}"
        return
    fi

    # Default fallback
    echo "${MODEL_FOR_ROLE[solution_architect]}"
}

# Build a prompt for the model based on the beads task.
build_prompt() {
    local project_dir="$1"
    local task_id="$2"
    local task_title="$3"
    local task_desc="$4"
    local model="$5"

    cat <<PROMPT
You are acting as an autonomous AI agent working on a beads task at night.

Project directory: $project_dir
Task ID: $task_id
Task title: $task_title
Task description: $task_desc
Assigned model: $model

Instructions:
1. Change into the project directory: cd "$project_dir"
2. Review the beads task details above.
3. If the task is a design document, follow the relevant template in templates/ and fill it in section by section.
4. If the task involves code, make the smallest correct change per layer, following surrounding style.
5. Do not approve your own work; leave review to a human or a different model.
6. When finished, report what was done so the beads task can be closed.

Begin by summarizing your understanding of the task, then proceed with the work.
PROMPT
}

# Invoke an ollama model with a prompt.
invoke_model() {
    local model="$1"
    local prompt="$2"

    local payload
    payload="$(jq -n \
        --arg model "$model" \
        --arg prompt "$prompt" \
        '{model: $model, prompt: $prompt, stream: false, temperature: 0.2, topP: 0.9}')"

    local response
    response="$(curl -s -X POST "${OLLAMA_HOST}/api/generate" \
        -H "Content-Type: application/json" \
        -d "$payload" \
        --max-time 300 || echo '{}')"

    echo "$response"
}

# Extract the response text from ollama JSON.
extract_response() {
    local json="$1"
    echo "$json" | jq -r '.response // empty' 2>/dev/null || echo ""
}

###############################################################################
# Main
###############################################################################

main() {
    # Check CLI arguments
    for arg in "$@"; do
        case "$arg" in
            --force|-f)
                FORCE_RUN="true"
                ;;
            --help|-h)
                echo "Usage: $0 [--force|-f] [--help|-h]"
                echo "  --force, -f   Bypass the 00:00-06:00 window check"
                echo "  --help,  -h   Show this help message"
                exit 0
                ;;
        esac
    done

    if ! is_time_window_active; then
        log "Outside nightly window (00:00-06:00). Current hour: $(date +%H). Pass --force to run immediately. Exiting."
        exit 0
    fi

    log "=== Nightly AI runner starting ==="
    log "Scanning project roots: ${PROJECT_ROOTS[*]}"

    local projects
    projects="$(discover_projects)"

    if [[ -z "$projects" ]]; then
        log "No valid beads+design project directories found. Exiting."
        exit 0
    fi

    log "Found $(echo "$projects" | wc -l) valid project(s):"
    echo "$projects" | while read -r p; do log "  - $p"; done

    while IFS= read -r project_dir; do
        [[ -z "$project_dir" ]] && continue
        log "=== Processing project: $project_dir ==="

        # Ensure we're in the project directory for beads
        (cd "$project_dir" && \
            log "Running: bd ready" && \
            ready_output="$(bd ready 2>&1 || true)" && \
            echo "$ready_output" | while read -r line; do log "  $line"; done)

        # For each ready task, assign a model and generate a prompt
        # (Autonomous execution via ollama is opt-in; uncomment the block below
        #  to enable direct model invocation.)
        #
        # while IFS= read -r task_line; do
        #     task_id="$(echo "$task_line" | awk '{print $1}')"
        #     task_title="$(echo "$task_line" | cut -d' ' -f2-)"
        #     model="$(model_for_task "$task_title" "")"
        #     prompt="$(build_prompt "$project_dir" "$task_id" "$task_title" "" "$model")"
        #     log "Dispatching task $task_id to model $model"
        #     response="$(invoke_model "$model" "$prompt")"
        #     resp_text="$(extract_response "$response")"
        #     log "Model response for $task_id: ${resp_text:0:200}..."
        # done < <(cd "$project_dir" && bd list --status=open --json 2>/dev/null | jq -r '.[] | "\(.id) \(.title)"' 2>/dev/null || true)

        log "=== Finished project: $project_dir ==="
    done <<< "$projects"

    log "=== Nightly AI runner complete ==="
}

main "$@"
