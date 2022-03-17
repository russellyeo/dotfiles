#!/usr/bin/swift

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Open Jira Link
// @raycast.mode silent

// Optional parameters:
// @raycast.icon images/jira.png
// @raycast.packageName Developer Utilities
// @raycast.argument1 { "type": "text", "placeholder": "Git branch" }

// Documentation:
// @raycast.description Opens a Jira Link from a feature branch name in clipboard

import AppKit

// MARK: - Main

let input = CommandLine.arguments[1]
openJiraLink(input)

// MARK: - Convenience

func openJiraLink(_ input: String) {
    let url = URL(string: "https://depopmarket.atlassian.net/browse/\(input)")!
    NSWorkspace.shared.open(url)
}