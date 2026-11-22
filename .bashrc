#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Starship prompt (if installed and not dumb terminal)
if [[ "$TERM" != "dumb" ]] && command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi

# FZF Integration
if command -v fzf &>/dev/null; then
    [ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
    [ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash
fi

# Zoxide (Smart cd)
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash)"
fi

# Direnv (Per-Project Environment Switching)
if command -v direnv &>/dev/null; then
    eval "$(direnv hook bash)"
fi

# Modern CLI Replacements & Aliases
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

# PATH
export PATH="$HOME/.local/bin:$PATH"

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

# Local Machine Overrides & Secrets (Ignored by Git)
[ -f ~/.bashrc.local ] && source ~/.bashrc.local
