#!/usr/bin/env bash
# 
# Bootstrap script for setting up a new macOS machine.
# This should be idempotent so it can be run multiple times.

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


step "Bootstrapping"

# Software Updates
step "Updating software"
sudo softwareupdate -iaR --verbose
xcode-select --install

# oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    installing "oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else 
    alreadyInstalled "oh-my-zsh" 
fi 

if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
else
    alreadyInstalled "zsh-syntax-highlighting"
fi 

if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
else
    alreadyInstalled "zsh-autosuggestions"
fi

# zsh shell
if [[ ! $(echo $SHELL) == "/bin/zsh" ]]; then 
    installing "zsh"
    brew install zsh
    chsh -s $(which zsh)
else
    alreadyInstalled "zsh"
fi

# rvm 
if test ! $(which rvm); then
    installing "rvm"
    \curl -sSL https://get.rvm.io | bash -s stable 
    source ~/.rvm/scripts/rvm
else
    alreadyInstalled "rvm"
fi

# homebrew
if test ! $(which brew); then
    installing "homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    alreadyInstalled "homebrew"
fi

# sbt via sdkman
if test ! $(which sbt); then
    installing "homebrew"
    curl -s "https://get.sdkman.io" | sdk i sbt
else
    alreadyInstalled "sbt"
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
	awscli
    bat
    coreutils
    carthage
    chisel
    crowdin
    depop/tools/depop-cli
    depop/tools/dpdb
    diff-so-fancy
    fd
    gh
    git-lfs
    go
    hub
    htop
    jq
    lastpass-cli
    ncdu
    neofetch
    nvm
    nmap
    mitmproxy
    pandoc
    sbt
    sqlite
    sourcery
    swiftlint
    terminal-notifier
    thefuck
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
    adoptopenjdk8
    alfred
    calibre
    charles
    dropbox
    gpg-suite
    iterm2
    macpass
    slack
    spotify
    sublime-text
    sublime-merge
    visual-studio-code
    zeplin
)
brew cask install ${CASKS[@]}
brew cleanup

step "Creating folder structure"
[[ ! -d ~/.profile ]] && touch ~/.profile
[[ ! -d ~/code ]] && mkdir ~/code
[[ ! -d ~/depop ]] && mkdir ~/depop

step "Bootstrapping complete"
