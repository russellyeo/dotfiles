#!/bin/bash

# Set variables
JIRA_TICKET="$1"
OUTPUT_DIR="/Users/russell/Library/Mobile Documents/iCloud~md~obsidian/Documents/Russell/Tickets"

TMP_TICKET="/tmp/ticket.json"
TMP_DESCRIPTION="/tmp/description.html"
TMP_ACCEPTANCE_CRITERIA="/tmp/acceptance_criteria.html"

# Create a Jira link from a ticket ID
create_jira_link() {
  local JIRA_TICKET="$1"
  echo "[$JIRA_TICKET](https://depopmarket.atlassian.net/browse/$JIRA_TICKET)"
}

# Retrieve JIRA ticket details using ACLI
acli depop --action getIssue --issue "$JIRA_TICKET" --outputType json | tail -n +2 > $TMP_TICKET

# Extract relevant fields from the ticket JSON
ticket_summary=$(jq -r '.summary' $TMP_TICKET | tr '\\/[]:|' '-')
ticket_assignee=$(jq -r '.assignee' $TMP_TICKET | sed 's/ *([^()]*)//')
ticket_reporter=$(jq -r '.reporter' $TMP_TICKET | sed 's/ *([^()]*)//')
ticket_created=$(jq -r '.created' $TMP_TICKET)
ticket_updated=$(jq -r '.updated' $TMP_TICKET)
ticket_priority=$(jq -r '.priority' $TMP_TICKET | sed 's/ *([^()]*)//')
ticket_epic_link=$(jq -r '.epicLink' $TMP_TICKET)
ticket_description=$(jq -r '.description' $TMP_TICKET)
ticket_acceptance_criteria=$(jq -r '.acceptanceCriteria' $TMP_TICKET)

# Convert JIRA formatting to Markdown using pandoc
pandoc -f jira -t html <<< "$ticket_description" | pandoc -f html -t markdown --wrap=none -o "$TMP_DESCRIPTION"
pandoc -f jira -t html <<< "$ticket_acceptance_criteria" | pandoc -f html -t markdown --wrap=none -o "$TMP_ACCEPTANCE_CRITERIA"

# Create markdown file
output_file="$OUTPUT_DIR/$JIRA_TICKET - $ticket_summary.md"

touch "$output_file"
{
  echo "---"
  echo "tag: ticket"
  echo "---"
  echo ""
  echo "| Field    | Value                                     |"
  echo "|:--------:|:-----------------------------------------:|"
  echo "| Ticket   | "$(create_jira_link "$JIRA_TICKET")"      |"
  echo "| Assignee | $ticket_assignee                          |"
  echo "| Reporter | $ticket_reporter                          |"
  echo "| Created  | $ticket_created                           |"
  echo "| Updated  | $ticket_updated                           |"
  echo "| Priority | $ticket_priority                          |"
  echo "| Epic     | "$(create_jira_link "$ticket_epic_link")" |"
  echo ""
  echo "## Description"
  cat "$TMP_DESCRIPTION"
  echo ""
  echo "## Acceptance Criteria"
  cat "$TMP_ACCEPTANCE_CRITERIA"
  echo ""
  echo "## Implementation"
  echo "TBD"
  echo ""
} > "$output_file"

rm $TMP_DESCRIPTION
rm $TMP_ACCEPTANCE_CRITERIA
echo "Markdown file created successfully: $output_file"