# Fig pre block. Keep at the top of this file.
export PATH="${PATH}:${HOME}/.local/bin"
eval "$(fig init zsh pre)"

# Environment
export PATH="/usr/local/bin:$PATH"
export EDITOR="code --wait"

# Load dotfiles
source $HOME/.profile
source $HOME/.dotfiles/.aliases
source $HOME/.dotfiles/.aliases-depop
source $HOME/.dotfiles/.aliases-ios
source $HOME/.dotfiles/antigen.zsh

# Antigen
antigen use oh-my-zsh
antigen bundle command-not-found
antigen bundle git
antigen bundle fig
antigen bundle pip
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
# antigen bundle zsh-users/zsh-completions (replaced by Fig)
antigen bundle zsh-users/zsh-history-substring-search
antigen theme candy
antigen apply

# Fig post block. Keep at the bottom of this file.
eval "$(fig init zsh post)"

