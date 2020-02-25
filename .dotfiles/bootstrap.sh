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
    git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
else
    alreadyInstalled "oh-my-zsh"
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

# Update homebrew
brew update

# Install command line tools
installing "brews"
BREWS=(
	ack
	awscli
    bat
    carthage
    chisel
    crowdin
    diff-so-fancy
    fd
    gh
    go
    hub
    htop
    jq
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
    tree
)
brew install ${BREWS[@]}
brew cleanup

# Install graphical applications
installing "cask apps"
CASKS=(
    alfred
    calibre
    charles
    dropbox
    fastlane
    gpg-suite
    iterm2
    macpass
    slack
    spotify
    sublime-text
    sublime-merge
    visual-studio-code
)
brew cask install ${CASKS[@]}

step "Creating folder structure"
[[ ! -d ~/code ]] && mkdir ~/code
[[ ! -d ~/depop ]] && mkdir ~/depop

step "Bootstrapping complete"

