#!/usr/bin/env bash
# 
# Bootstrap script for setting up a new macOS machine.
# This script is idempotent so it can be run multiple times.

# Pretty print
function alreadyInstalled() {
    echo "\033[33mWarning:\033[0m $1 already installed"
}
function installing() {
    echo "\033[32m==>\033[0m \033[1mInstalling\033[1;32m $1\033[0m"
}
function updating() {
    echo "\033[32m==>\033[0m \033[1mUpdating\033[1;32m $1\033[0m"
}
function step() {
    echo "\033[34m==>\033[0m \033[1m$1\033[0m"
}
function action() {
    echo "\033[32m==>\033[0m \033[1m$1\033[0m"
}
function error() {
    echo "\033[31mError:\033[0m $1"
}

# Begin
step "Bootstrapping"

# Software updates
step "Updating software"
xcode-select --install

# zsh shell
if [[ ! $(echo $SHELL) == "/bin/zsh" ]]; then 
    installing "zsh"
    brew install zsh
    chsh -s $(which zsh)
else
    alreadyInstalled "zsh"
fi

# Homebrew

## Install homebrew
if test ! $(which brew); then
    installing "homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
else
    alreadyInstalled "homebrew"
fi

## Update brew + upgrade brew packages/casks
updating "brew"
brew update
updating "brews"
brew upgrade
updating "brew casks"
brew upgrade --cask

## Tap brew repositories
installing "depop brew taps"
TAPS=(
    VirtusLab/git-machete
)
for TAP in ${TAPS[@]} 
do
    brew tap $TAP
done

## Install command line tools
installing "brew packages"
BREWS=(
    ack
    ansible
    aria2
    bat
    delta
    fd
    fzf
    gh
    git-machete
    htop
    httpie
    jq
    llm
    mint
    mise
    ncdu
    tree
    xcbeautify
    xcode-build-server
)
brew install ${BREWS[@]}

## Install graphical applications
installing "brew cask packages"
CASKS=(
    raycast
    proxyman
    sublime-merge
    sublime-text
    visual-studio-code
    warp
)
brew install --cask ${CASKS[@]}

## Add Depop tools homebrew tap
installing "depop brew tap"
gh auth login
export HOMEBREW_GITHUB_API_TOKEN=$(gh auth token)
brew tap depop/tools git@github.com:depop/homebrew-tools.git

## Install Depop brew packages
installing "depop brew packages"
DEPOP_BREWS=(
    depop/tools/depop-cli
    depop/tools/depop-ios-cli
)
brew install ${DEPOP_BREWS[@]}

## Cleanup
brew cleanup

## Install mint packages
MINTS=(
    RobotsAndPencils/xcodes
)
mint install ${MINTS[@]}

# Node.js via nvm
step "Installing Node.js via nvm"

## Check if nvm is already installed
export NVM_VERSION="v0.40.3"
if [ ! -d "$HOME/.nvm" ]; then
    installing "nvm"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
    # Source nvm for the current session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
else
    alreadyInstalled "nvm"
    # Source nvm for the current session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

## Install latest LTS Node.js (includes npm)
if command -v nvm >/dev/null 2>&1; then
    installing "Node.js LTS (includes npm)"
    nvm install --lts
    nvm use --lts
    nvm alias default lts/*
    # Verify installation
    action "Node.js version: $(node --version)"
    action "npm version: $(npm --version)"
else
    error "nvm not found in PATH. Please restart your terminal and run the script again."
fi

## Install Claude Code CLI
if command -v npm >/dev/null 2>&1; then
    installing "Claude Code CLI"
    npm install -g @anthropic-ai/claude-code
    # Verify installation
    if command -v claude-code >/dev/null 2>&1; then
        action "Claude Code CLI installed successfully"
    else
        echo "\033[33mWarning:\033[0m Claude Code CLI may not be in PATH. You may need to restart your terminal."
    fi
else
    error "npm not found. Cannot install Claude Code CLI."
fi

# Create files and directories
step "Creating files and directories"
[[ ! -d ~/Developer ]] && mkdir ~/Developer

# Set macOS defaults
step "Setting macOS defaults"
## Autohide dock
defaults write com.apple.dock "autohide" -bool "true" && killall Dock

# Finish
step "Bootstrapping complete"
