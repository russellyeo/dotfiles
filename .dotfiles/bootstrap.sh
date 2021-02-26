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
if test ! $(which brew); then
    installing "homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    alreadyInstalled "homebrew"
fi

# RVM 
if test ! $(which rvm); then
    installing "rvm"
    \curl -sSL https://get.rvm.io | bash -s stable 
    source ~/.rvm/scripts/rvm
else
    alreadyInstalled "rvm"
fi

# Update homebrew
brew update

# Tap brew repositories
installing "brew taps"
TAPS=(
	AdoptOpenJDK/openjdk
    tmspzz/tap https://github.com/tmspzz/homebrew-tap.git
    depop/tools
)
brew tap ${TAPS[@]}

# Install command line tools
installing "brews"
BREWS=(
    ack
    bat
    # carthage - latest version (0.36) breaks Xcode 12.2
    diff-so-fancy
    fd
    gh
    htop
    jq
    lastpass-cli
    ncdu
    neofetch
    nmap
    pandoc
    sourcery
    swiftlint
    tldr
    tmspzz/homebrew-tap/rome
    tree
    vault
    z
)
brew install ${BREWS[@]}

# Install graphical applications
installing "cask apps"
CASKS=(
    alfred
    calibre
    dropbox
    gpg-suite
    iterm2
    slack
    spotify
    sublime-text
    sublime-merge
    visual-studio-code
    zeplin
)
brew cask install ${CASKS[@]}

# Cleanup
brew cleanup

# Create files and directories
step "Creating files and directories"
[[ ! -d ~/.profile ]] && touch ~/.profile
[[ ! -d ~/Developer ]] && mkdir ~/Developer

# Finish
step "Bootstrapping complete"