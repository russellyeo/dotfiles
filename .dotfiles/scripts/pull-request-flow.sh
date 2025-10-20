#!/bin/bash

# Prompt for PR description generation
PR_PROMPT="
Below is a diff of all changes on the current branch, coming from the command:

\`\`\`
git machete diff
\`\`\`

Please generate a comprehensive pull request description for these changes. Include:
1. A brief summary of the changes
2. The main features or fixes implemented
3. Any important technical details
"

# Function to generate a PR description
generate_pr_description() {
    git machete diff | llm "$PR_PROMPT"
}

# Function to read user input compatibly with both Bash and Zsh
read_input() {
    if [ -n "$ZSH_VERSION" ]; then
        echo -n "$1"
        read -r REPLY
    else
        read -p "$1" -r REPLY
    fi
}

# Function to read the current PR description
get_current_pr_description() {
    cat .git/info/description
}

# Function to get the current branch name
get_current_branch() {
    git machete show current
}

# Function to get the parent branch name
get_parent_branch() {
    git machete show up
}

# Main script
echo -e "\nStarting a pull request for branch $(get_current_branch) against base $(get_parent_branch).\n"
current_pr_description=$(get_current_pr_description)

while true; do
    echo -e "\nThe current pull request description is:"
    echo -e "$(get_current_pr_description)\n"
    
    read_input "For the PR description, do you want to (k)eep the current description, (e)dit it, (g)enerate a new description using AI, or (c)ancel? "
    choice=$REPLY

    case "$choice" in
        k|K )
            echo "\nKeeping the current pull request description."
            break
            ;;
        e|E )
            echo "Opening the pull request description in your default editor..."
            ${EDITOR} --wait .git/info/description
            echo -e "\nPull request description saved to .git/info/description"
            break
            ;;
        g|G )
            echo -e "\Generating a pull request description..."
            new_pr_description=$(generate_pr_description)
            echo "$pr_description" > .git/info/description
            ;;
        c|C )
            echo -e "\nOperation cancelled."
            exit 1
            ;;
        * )
            echo -e "\nInvalid choice. Please try again."
            ;;
    esac
done