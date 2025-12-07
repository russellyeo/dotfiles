#!/bin/bash

# -----------------------------------------------------------------------------
# branch-to-pr-title-template.sh
#
# This script generates a title line based on the current git branch name.
# It extracts the ticket ID from certain branch naming patterns and
# formats it with a placeholder title.
#
# Supported branch patterns:
#   - feature/SEARCH-<number>
#   - feature/BMX-<number>
#   - technical/*
#
# Usage:
# ```sh
# sh ~/.dotfiles/scripts/branch-to-title.sh
# ```
#
# Example outputs:
#   SEARCH-123 | [PLACEHOLDER TITLE]
#   BMX-456 | [PLACEHOLDER TITLE]
#   TECHNICAL | [PLACEHOLDER TITLE]
# -----------------------------------------------------------------------------

# Get the current git branch name
current_branch=$(git branch --show-current)

# Check branch pattern and output formatted title
if [[ $current_branch =~ ^feature/SEARCH-([0-9]+) ]]; then
    # For branches like feature/SEARCH-123
    echo "SEARCH-${BASH_REMATCH[1]} | [PLACEHOLDER TITLE]"
elif [[ $current_branch =~ ^feature/BMX-([0-9]+) ]]; then
    # For branches like feature/BMX-456
    echo "BMX-${BASH_REMATCH[1]} | [PLACEHOLDER TITLE]"
elif [[ $current_branch =~ ^technical/ ]]; then
    # For branches like technical/some-task
    echo "TECHNICAL | [PLACEHOLDER TITLE]"
fi
