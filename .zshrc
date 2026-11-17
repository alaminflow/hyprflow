export SHELL=/usr/bin/zsh

# --- History Settings ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory sharehistory

# --- Advanced Completion ---
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select

# --- Launch Starship Prompt ---
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

# --- Plugins ---
[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- PATH & Environment ---
export PATH="$HOME/.local/bin:$PATH"

# --- NVM (Node Version Manager) ---
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
