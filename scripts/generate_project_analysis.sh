#!/usr/bin/env bash
#
# generate_project_analysis.sh
#
# Generates a Project_Analysis document in the immediate design/ directory
# of the current working directory, using the naming convention:
#   <Project Acronym>_Project_Analysis.md
#
# Reads template from:
#   ~/dev/devlopment/guidelines/Project_Analysis_TEMPLATE.md
#
# Usage:
#   ./generate_project_analysis.sh <PROJECT_ACRONYM>
#
# Example:
#   ./generate_project_analysis.sh ntf
#   # -> design/NTF_Project_Analysis.md
#
set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <PROJECT_ACRONYM>" >&2
    echo "Example: $0 ntf" >&2
    exit 1
fi

PROJECT_ACRONYM="$1"

# Normalize acronym: uppercase, strip non-alphanumeric (keep hyphens)
PROJECT_ACRONYM="$(echo "${PROJECT_ACRONYM}" | tr '[:lower:]' '[:upper:]' | sed 's/[^A-Z0-9-]//g')"

if [[ -z "${PROJECT_ACRONYM}" ]]; then
    echo "Error: project acronym is empty after normalization." >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_GOVERNANCE_TEMPLATES="${SCRIPT_DIR}/../governance/templates/Project_Analysis_TEMPLATE.md"

# Locate template file
TEMPLATE_FILE=""
if [[ -f "${REPO_GOVERNANCE_TEMPLATES}" ]]; then
    TEMPLATE_FILE="${REPO_GOVERNANCE_TEMPLATES}"
elif [[ -f "${HOME}/dev/devlopment/guidelines/templates/Project_Analysis_TEMPLATE.md" ]]; then
    TEMPLATE_FILE="${HOME}/dev/devlopment/guidelines/templates/Project_Analysis_TEMPLATE.md"
elif [[ -f "/run/media/alpharius/Dev/devlopment/guidelines/templates/Project_Analysis_TEMPLATE.md" ]]; then
    TEMPLATE_FILE="/run/media/alpharius/Dev/devlopment/guidelines/templates/Project_Analysis_TEMPLATE.md"
else
    echo "Error: Template file Project_Analysis_TEMPLATE.md not found." >&2
    exit 1
fi

# Target: immediate design/ directory relative to the current working directory
DESIGN_DIR="$(pwd)/design"
OUTPUT_FILE="${DESIGN_DIR}/${PROJECT_ACRONYM}_Project_Analysis.md"

mkdir -p "${DESIGN_DIR}"

TODAY="$(date +%Y-%m-%d)"
DISPLAY_DATE="$(date +%m/%d/%y)"

# Process template with replacements:
# - <Project Acronym> -> ${PROJECT_ACRONYM}
# - <MM/DD/YY> -> ${DISPLAY_DATE}
# - <YYYY-MM-DD> -> ${TODAY}
# - <e.g. v1.0> -> v1.0
# - Draft | In Review | Approved | Superseded -> Draft
sed \
    -e "s#<Project Acronym>#${PROJECT_ACRONYM}#g" \
    -e "s#<MM/DD/YY>#${DISPLAY_DATE}#g" \
    -e "s#<YYYY-MM-DD>#${TODAY}#g" \
    -e "s#<e\.g\. v1\.0>#v1.0#g" \
    -e "s#Draft \\\\| In Review \\\\| Approved \\\\| Superseded#Draft#g" \
    "${TEMPLATE_FILE}" > "${OUTPUT_FILE}"

echo "Created ${OUTPUT_FILE} (from ${TEMPLATE_FILE})"
echo "Next steps:"
echo "  1. Edit ${OUTPUT_FILE} to fill in the <...> placeholders."
echo "  2. Create a beads task and assign it to the document author before editing."
echo "  3. When reviewed by all AI models, generate a review file:"
echo "     <Project Directory>/design/epic/reviews/<epic>_project-analysis_01.md"
