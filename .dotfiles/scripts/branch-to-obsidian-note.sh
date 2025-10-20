#!/bin/bash

# Helper functions

get_branch_name() {
    git branch --show-current
}

get_ticket_id() {
    # Extract ticket ID from branch name
    # Assumes branch name format like "feature/ABC-123-description"
    local branch=$(get_branch_name)
    echo "$branch" | grep -oE '[A-Z]+-[0-9]+' | head -n1
}

create_note_filename() {
    local ticket_id=$(get_ticket_id)
    echo "${ticket_id}.md"
}

# Directory where the notes are stored
NOTES_DIRECTORY="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/russell/Logs/Tickets"

# Template for the note
TEMPLATE="---
ticket_id: $(get_ticket_id)
date: $(date +"%Y-%m-%d")
tags: ticket
---

## Info
- Branch: \`$(get_branch_name)\`

## Summary
- We needed the thing to be a thing

## Tasks
- [ ] Task 1

## Notes
- Did the thing

## Blockers
- Could not do the thing
"

# Main script
main() {
    # Check if git repository
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Error: Not in a git repository"
        exit 1
    fi

    # Create filename for the note
    filename=$(create_note_filename)
    filepath="$NOTES_DIRECTORY/$filename"

    # Check if file already exists
    if [[ -f "$filepath" ]]; then
        read -p "File $filename already exists. Overwrite? (y/N): " overwrite
        if [[ $overwrite != "y" && $overwrite != "Y" ]]; then
            echo "Aborted."
            exit 0
        fi
    fi

    # Create the note
    echo "$TEMPLATE" > "$filepath"

    echo "Note created: $filepath"

    # Open the note in Obsidian
    open "obsidian://open?path=$(printf '%s' "$filepath" | jq -sRr @uri)"
}

main
