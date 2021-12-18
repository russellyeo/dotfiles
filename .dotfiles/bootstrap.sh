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
function step() {
    echo "\033[34m==>\033[0m \033[1m$1\033[0m"
}
function action() {
    echo "\033[32m==>\033[0m \033[1m$1\033[0m"
}

# Begin
step "Bootstrapping"

# Software updates
step "Updating software"
sudo softwareupdate -iaR --verbose
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
else
    alreadyInstalled "homebrew"
fi

## Update homebrew
brew update

## Tap brew repositories
installing "brew taps"
TAPS=(
	adoptopenjdk/openjdk
    robotsandpencils/made
)
brew tap ${TAPS[@]}

## Install command line tools
installing "brews"
BREWS=(
    ack
    bat
    diff-so-fancy
    fd
    fzf
    gh
    htop
    jq
    ncdu
    nmap
    pandoc
    tree
    xcodes
)
brew install ${BREWS[@]}

## Install graphical applications
installing "cask apps"
CASKS=(
    adoptopenjdk8
    dropbox
    iterm2
    raycast
    slack
    spotify
    visual-studio-code    
)
brew install --cask ${CASKS[@]}

## Cleanup
brew cleanup

# Create files and directories
step "Creating files and directories"
[[ ! -d ~/.profile ]] && touch ~/.profile
[[ ! -d ~/Developer ]] && mkdir ~/Developer
[[ ! -d ~/Documents/Screenshots ]] && mkdir ~/Documents/Screenshots

# Set macOS defaults
step "Setting macOS defaults"

## Autohide dock
defaults write com.apple.dock "autohide" -bool "true" && killall Dock

## Set screenshots default folder to ~/Documents/Screenshots
defaults write com.apple.screencapture "location" -string "~/Documents/Screenshots" && killall SystemUIServer
defaults write com.apple.iphonesimulator "ScreenShotSaveLocation" -string "~/Documents/Screenshots"

## Set Xcode counterpart files (VIPER)
defaults write com.apple.dt.Xcode "IDEAdditionalCounterpartSuffixes" -array-add "ViewController" "Interactor" "Presenter" "ViewModel" "Router" "Screen" && killall Xcode

# Finish
step "Bootstrapping complete"