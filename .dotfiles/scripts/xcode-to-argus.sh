#!/bin/bash

# -----------------------------------------------------------------------------
# xcode-to-argus.sh
#
# This script builds/tests a Xcode scheme and proxies the build trace through Argus.
#
# ## Usage:
#
# Build scheme
# ```sh
# sh $HOME/.dotfiles/scripts/xcode-to-argus.sh build <scheme>
# ```
#
# Test scheme
# ```sh
# sh $HOME/.dotfiles/scripts/xcode-to-argus.sh test <scheme>
# ```
# -----------------------------------------------------------------------------

ACTION="$1"
SCHEME="$2"

# Input validation

if [ -z "$ACTION" ] || [ -z "$SCHEME" ]; then
  echo "Usage: $0 build/test <scheme>"
  exit 1
fi

if [ "$ACTION" != "build" ] && [ "$ACTION" != "test" ]; then
  echo "Error: Action must be either 'build' or 'test'"
  exit 1
fi

# Run xcodebuild with argus proxy

# Ensure argus is available before attempting to use it
if ! command -v argus >/dev/null 2>&1; then
  echo "Error: 'argus' command not found."
  echo "Run: mise use -g github:tuist/argus to install"
  exit 1
fi

BUILD_TRACE_ID=$(uuidgen)

echo "Starting $ACTION for scheme: $SCHEME"
echo "BUILD_TRACE_ID: $BUILD_TRACE_ID"
echo ""
XCBBUILDSERVICE_PATH=$(which argus) BUILD_TRACE_ID=$BUILD_TRACE_ID \
 xcodebuild $ACTION \
  -destination "platform=iOS Simulator,name=iPhone 14 (18.6) (CI),OS=18.6,arch=arm64" \
  -scheme $SCHEME
  