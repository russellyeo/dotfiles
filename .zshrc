# Environment
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="$PATH:$HOME/Library/Application\ Support/Coursier/bin"
export PATH="$PATH:$HOME/.mint/bin"
export PATH="$PATH:/Users/russell/.bin"
export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin"
export PATH="$PATH:/Users/russellyeo/ACLI"

# Shell configuration
export EDITOR="code --wait"
export COLUMNS="120"

# GPG
export GPG_TTY=$(tty)

# Load dotfiles
source $HOME/.dotfiles/.aliases
source $HOME/.dotfiles/.aliases-depop
source $HOME/.dotfiles/.aliases-ios

# Antigen
source $HOME/.dotfiles/antigen.zsh
antigen use oh-my-zsh
antigen bundle command-not-found
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen apply

# ZSH
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Git machete
eval "$(git machete completion zsh)"

# Tokens
export HOMEBREW_GITHUB_API_TOKEN=$(gh auth token)

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Scala
export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home"
# export SBT_CREDENTIALS="$HOME/.sbt/.depop-credentials"
# export COURSER_CREDENTIALS="$HOME/.sbt/.depop-credentials"

# Mise
eval "$(mise activate zsh)"