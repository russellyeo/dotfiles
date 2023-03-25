# Environment
export PATH="/usr/local/bin:$PATH"
export PATH="$PATH:$HOME/Library/Application Support/Coursier/bin"
export PATH="$PATH:$HOME/.mint/bin"
export PATH="$PATH:/Users/russell/.bin"
export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin"
export EDITOR="code --wait"

# Load dotfiles
source $HOME/.dotfiles/.aliases
source $HOME/.dotfiles/.aliases-depop
source $HOME/.dotfiles/.aliases-ios

# Antigen
source $HOME/.dotfiles/antigen.zsh
antigen use oh-my-zsh
antigen bundle command-not-found
antigen bundle git
antigen bundle pip
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen theme candy
antigen apply

# ZSH
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Tokens
export HOMEBREW_GITHUB_API_TOKEN=$(security find-generic-password -s 'Homebrew GitHub Token' -w)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
