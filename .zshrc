# Environment
export PATH="/usr/local/bin:$PATH"
export PATH="$PATH:$HOME/Library/Application Support/Coursier/bin"
export PATH="$PATH:$HOME/.mint/bin"
export EDITOR="code --wait"
export SBT_CREDENTIALS="$HOME/.sbt/.depop-credentials"
export COURSER_CREDENTIALS="$HOME/.sbt/.depop-credentials"

# Load dotfiles
source $HOME/.dotfiles/.aliases
source $HOME/.dotfiles/.aliases-depop
source $HOME/.dotfiles/.aliases-ios

# Antigen
source $HOME/.dotfiles/antigen.zsh
antigen use oh-my-zsh
antigen bundle command-not-found
antigen bundle git
antigen bundle fig
antigen bundle pip
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen theme candy
antigen apply

# Tokens
export HOMEBREW_GITHUB_API_TOKEN=$(security find-generic-password -s 'Homebrew GitHub Token' -w)
