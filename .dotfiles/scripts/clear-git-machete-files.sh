#!/bin/bash

# -----------------------------------------------------------------------------
# clear-git-machete-files.sh
#
# This script safely removes git machete github info files from the current
# repository. Git machete uses .git/info/title and .git/info/description files
# to stage title and description for pull requests. This script cleans up
# these files in preparation for a new pull request.
#
# Usage:
# ```sh
# sh ~/.dotfiles/scripts/clear-git-machete-files.sh
# ```
#
# Example outputs:
#   Removed .git/info/title
#   Removed .git/info/description
#   Done. Removed 2 file(s).
#
#   Or if no files exist:
#   No git machete files found to remove.
# -----------------------------------------------------------------------------

files_removed=0

if [ -f ".git/info/title" ]; then
    rm .git/info/title
    echo "Removed .git/info/title"
    ((files_removed++))
fi

if [ -f ".git/info/description" ]; then
    rm .git/info/description
    echo "Removed .git/info/description"
    ((files_removed++))
fi

if [ $files_removed -eq 0 ]; then
    echo "No git machete files found to remove."
else
    echo "Done. Removed $files_removed file(s)."
fi