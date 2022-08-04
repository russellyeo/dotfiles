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
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
else
    alreadyInstalled "homebrew"
fi

## Update homebrew
brew update

## Tap brew repositories
installing "brew taps"
TAPS=(
    depop/tools
    tmspzz/tap
    VirtusLab/git-machete
)
for TAP in ${TAPS[@]} 
do
    brew tap $TAP
done

## Update brew + upgrade brews/casks
updating "brew"
brew update
updating "brews"
brew upgrade
updating "brew casks"
brew upgrade --cask

## Install command line tools
installing "brews"
BREWS=(
    ack
    ansible
    bat
    carthage
    depop/tools/depop-cli
    diff-so-fancy
    fd
    fzf
    gh
    git
    git-machete
    htop
    jq
    mint
    ncdu
    nmap
    pandoc
    rust
    swiftgen
    tmspzz/homebrew-tap/rome
    tree
)
brew install ${BREWS[@]}

## Install graphical applications
installing "cask apps"
CASKS=(
    bitwarden
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

## Install mint packages
MINTS=(
    RobotsAndPencils/xcodes
)
mint install ${MINTS[@]}

# Create files and directories
step "Creating files and directories"
[[ ! -d ~/Developer ]] && mkdir ~/Developer

# Set macOS defaults
step "Setting macOS defaults"

## Autohide dock
defaults write com.apple.dock "autohide" -bool "true" && killall Dock

## Set Xcode counterpart files (VIPER)
defaults write com.apple.dt.Xcode "IDEAdditionalCounterpartSuffixes" -array-add "ViewController" "Interactor" "Presenter" "ViewModel" "Router" "Screen" && killall Xcode

# Finish
step "Bootstrapping complete"
