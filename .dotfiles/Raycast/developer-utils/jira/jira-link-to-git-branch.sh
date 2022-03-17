#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Git Branch From Jira Link
# @raycast.mode silent

# Optional parameters:
# @raycast.icon images/jira.png
# @raycast.packageName Developer Utilities

# Documentation:
# @raycast.description Converts a Jira Link to a git feature branch name

branch=`pbpaste | grep -Eo '\d+' | xargs -I {} echo 'feature/PAYMENTS-{}'`
echo $branch | pbcopy
echo "Copied $branch"