#!/bin/bash

## PROMPTS ##

PR_TITLE_PROMPT="""
You are a helpful assistant that generates clear and concise PR titles.
Given a list of git commit messages, generate a short title (max 60 chars) that summarizes the main changes.
Focus on the WHAT and WHY, not the HOW.
Do not include issue numbers or technical prefixes.
Output only the title, nothing else.
Example good titles:
- Add retry mechanism for failed API requests
- Improve search results relevancy with fuzzy matching
- Fix memory leak in image processing pipeline
"""

## FUNCTIONS ##

# Generate PR title from git commit messages
_generate_pr_title() {
    git machete log -- --oneline | llm "$PR_TITLE_PROMPT"
}

# Generate PR description from git diff
_generate_pr_description() {
    git machete diff | llm "$PR_DESCRIPTION_PROMPT"
}

# Run tooling checks
run_tooling_checks() {
    echo "Running tooling checks..."
    make run_third_party_tooling_checks
}

# Check if there are any git changes after running checks
check_git_changes() {
    if [[ -n $(git status --porcelain) ]]; then
        echo "Error: Uncommitted changes detected after running tooling checks"
        git status
        exit 1
    fi
}

# Run tuist inspect implicit-imports and exit if it fails
run_tuist_inspect_implicit_imports() {
    echo "Running tuist inspect implicit-imports..."
    if ! tuist inspect implicit-imports; then
        echo "Error: tuist inspect failed"
        exit 1
    fi
}

# Generate title file based on branch name pattern and git commit messages
generate_title_file() {
    echo "Prefilling title file based on branch name and git commit messages..."
    # Get the current branch name
    current_branch=$(git branch --show-current)
    # Generate title with branch name pattern and write to .git/info/title
    if [[ $current_branch =~ ^feature/SEARCH-([0-9]+) ]]; then
        suggested_title=$(_generate_pr_title)
        echo "SEARCH-${BASH_REMATCH[1]} | [Draft] $suggested_title" > .git/info/title
    elif [[ $current_branch =~ ^feature/BMX-([0-9]+) ]]; then
        suggested_title=$(_generate_pr_title)
        echo "BMX-${BASH_REMATCH[1]} | [Draft] $suggested_title" > .git/info/title
    elif [[ $current_branch =~ ^technical/ ]]; then
        suggested_title=$(_generate_pr_title)
        echo "TECHNICAL | [Draft] $suggested_title" > .git/info/title
    fi
}

# Clear description file
clear_pr_description_file() {
    echo "Clearing description file..."
    "" > .git/info/description
}

# Prompt user to edit title and description files if needed
prompt_edits() {
    echo "Opening title file for editing..."
    code --wait .git/info/title

    echo "Opening description file for editing..."
    code --wait .git/info/description
}

# Create pull request using git machete
create_draft_pr() {
    echo "Creating pull request using git machete..."
    git machete github create-pr --draft
}

main() {
    run_tooling_checks
    check_git_changes
    run_tuist_inspect_implicit_imports
    generate_title_file
    clear_pr_description_file
    prompt_edits
    create_draft_pr
}

main "$@"
exit_code=$?
if [ $exit_code -ne 0 ]; then
    echo "Error: Script failed with exit code $exit_code"
    exit $exit_code
fi
