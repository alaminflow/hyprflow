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
if [[ "$TERM" != "dumb" ]] && command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

# --- Plugins ---
[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- FZF Integration (Interactive Fuzzy Search & Navigation) ---
if command -v fzf &>/dev/null; then
    [ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
    [ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
fi

# --- Zoxide (Smart cd with habit memory) ---
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# --- Direnv (Per-Project Environment Switching) ---
if command -v direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi

# --- Modern CLI Replacements & Aliases ---
if command -v eza &>/dev/null; then
    alias ls='eza --icons=auto --group-directories-first'
    alias ll='eza -la --icons=auto --git --group-directories-first'
    alias lt='eza --tree --level=2 --icons=auto --group-directories-first'
else
    alias ls='ls --color=auto'
    alias ll='ls -la'
fi

if command -v bat &>/dev/null; then
    alias cat='bat --paging=never --style=plain'
fi

alias grep='grep --color=auto'

# --- PATH & Environment ---
export PATH="$HOME/.local/bin:$PATH"

# --- NVM (Node Version Manager) ---
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --- Local Machine Overrides & Secrets (Ignored by Git) ---
# Use ~/.zshrc.local for work API keys, private tokens, and machine-specific variables
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
