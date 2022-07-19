# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && . "$HOME/.fig/shell/zshrc.pre.zsh"

# Environment
export PATH="/usr/local/bin:$PATH"
export PATH="$PATH:/Users/russell/Library/Application Support/Coursier/bin"
export EDITOR="code --wait"
export SBT_CREDENTIALS="$HOME/.sbt/.depop-credentials"
export COURSER_CREDENTIALS="$HOME/.sbt/.depop-credentials"

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
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && . "$HOME/.fig/shell/zshrc.post.zsh"
