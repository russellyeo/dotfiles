export PATH="/usr/local/bin:$HOME/bin:$PATH"

# Load dotfiles
source $HOME/.profile
source $HOME/.dotfiles/.aliases
source $HOME/.dotfiles/antigen.zsh

# Antigen
antigen use oh-my-zsh
antigen bundle git
antigen bundle pip
antigen bundle command-not-found
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen theme avit
antigen apply