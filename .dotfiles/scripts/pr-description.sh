#!/bin/bash

# Prompt for PR description generation
PR_PROMPT="
Below is a diff of all changes on the current branch, coming from the command:

\`\`\`
git machete diff
\`\`\`

Please generate a concise pull request description for these changes, in markdown.
"

# Function to generate PR description
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

# Main script
printf "Generating AI-powered pull request description...\n\n"
pr_description=$(generate_pr_description)

while true; do
    printf "Proposed pull request description:\n\n"
    printf "%s\n\n" "$pr_description"
    
    read_input "Do you want to (a)ccept, (c)opy, (e)dit, (r)egenerate, or e(x)it? "
    choice=$REPLY

    case "$choice" in
        a|A )
            echo "$pr_description" > .git/info/description
            printf "\nPull request description saved to .git/info/description\n\n"
            break
            ;;
        c|C )
            printf "\nCopying pull request description to clipboard...\n\n"
            echo "$pr_description" | pbcopy
            printf "Pull request description copied to clipboard.\n\n"
            break
            ;;
        e|E )
            printf "\nOpening the description in your default editor...\n\n"
            echo "$pr_description" > .git/info/description
            ${EDITOR} --wait .git/info/description
            printf "Pull request description saved to .git/info/description\n\n"
            break
            ;;
        r|R )
            printf "\nRegenerating pull request description...\n\n"
            pr_description=$(generate_pr_description)
            ;;
        x|X )
            printf "\nOperation cancelled.\n\n"
            exit 1
            ;;
        * )
            printf "\nInvalid choice. Please try again.\n\n"
            ;;
    esac
done

printf "PR description generation complete.\n"
