# ────────────────────────────────────────────────────────────────────────────
# Instant prompt (Powerlevel10k)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ────────────────────────────────────────────────────────────────────────────
# Path setup: prepend only once, avoid duplicates
typeset -a EXTRA_PATHS=(
  "$HOME/bin"
  "$HOME/.local"
  "/opt/homebrew/bin"
  "/usr/local/bin"
  "$HOME/.composer/vendor/bin"
  "/usr/local/sbin"
  "$HOME/.cargo/bin"
  "/opt/homebrew/opt/ruby/bin"
  "/Library/Frameworks/Python.framework/Versions/3.11/bin"
)
for p in "${EXTRA_PATHS[@]}"; do
  [[ -d $p && :$PATH: != *":$p:"* ]] && PATH="$p:$PATH"
done
export PATH

# ────────────────────────────────────────────────────────────────────────────
# Oh-My-Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git fast-syntax-highlighting)

source "$ZSH/oh-my-zsh.sh"

# ────────────────────────────────────────────────────────────────────────────
# Terminal tweaks
[[ $TERM_PROGRAM == "ghostty" ]] && export TERM=xterm-256color

# ────────────────────────────────────────────────────────────────────────────
# Editor based on context
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR=vim
else
  export EDITOR=nvim
fi

# ────────────────────────────────────────────────────────────────────────────
# Aliases

# File + system
alias reload='source ~/.zshrc'
alias {c,cl}=clear
alias {q,xit,x}=exit
alias o=open
alias f='open .'
alias tdt='cd ~/Desktop'
alias tdl='cd ~/Downloads'
alias dotfiles='cd ~/.dotfiles'
alias neovim='nvim'
alias {v,vim,nv}='nvim'

# Git
alias g=git
alias gs='git status'
alias gd='git diff'
alias gsh='git show'
alias gap='git add -p'

# Brew & system
alias brewup='brew update && brew upgrade && brew cleanup && brew upgrade --cask && brew doctor'

# Docker & Node
alias dk='docker'
alias dkc='docker-compose'
alias useenv='source venv/bin/activate'
alias python=python3
alias pip=pip3
alias nrb='npm run build'
alias nrs='npm run start'
alias nrd='npm run dev'

# Cargo & Rust
alias cb='cargo build'
alias cr='cargo run'
alias rce='rustc --explain '

# FZF & utils
alias ff=fzf
alias hgrep='history | grep'
alias lorem=lorem-ipsum
alias fib='seq 50 | awk "BEGIN{a=1;b=1}{print a;c=a+b;a=b;b=c}"'

# Photo / image
alias tojpg='mogrify -quality 100 -format jpg'
alias img-resize='magick mogrify'

# ────────────────────────────────────────────────────────────────────────────
# Functions

rfc() {
  [[ $1 =~ ^[0-9]+$ ]] || { echo "Usage: rfc <number>"; return 1; }
  curl -s "https://www.rfc-editor.org/rfc/rfc$1.txt" | less
}

# ────────────────────────────────────────────────────────────────────────────
# Third-party tool integrations

# Bun
[[ -s "$HOME/.bun/bin/bun" ]] && export PATH="$HOME/.bun/bin:$PATH"

# Google Cloud SDK
if [[ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]]; then
  source "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"
  source "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"
fi

# NVM
export NVM_DIR="$HOME/.nvm"
[[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && source "/opt/homebrew/opt/nvm/nvm.sh"
[[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]] && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# PNPM
export PNPM_HOME="$HOME/Library/pnpm"
[[ :$PATH: != *":$PNPM_HOME:"* ]] && export PATH="$PNPM_HOME:$PATH"

# FZF integration & completion
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type=d --hidden --strip-cwd-prefix --exclude .git'

# SGPT (bind Ctrl-L)
_sgpt_zsh() {
  if [[ -n $BUFFER ]]; then
    local cmd=$BUFFER
    BUFFER+="⌛"
    zle redisplay
    BUFFER=$(sgpt --shell <<<"$cmd" --no-interaction)
    zle end-of-line
  fi
}
zle -N _sgpt_zsh
bindkey '^L' _sgpt_zsh

# Powerlevel10k prompt
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Load environment overrides
for envf in ~/.dotfiles/.env ~/.dotfiles/.env.comit ~/.dotfiles/.env.personal; do
  [[ -r $envf ]] && source "$envf"
done

# ────────────────────────────────────────────────────────────────────────────
# Auto-attach tmux on Apiarist.local
 if [[ "$(hostname)" == "Apiarist.local" && -z $TMUX ]]; then
  if command -v tmux >/dev/null 2>&1; then
    exec tmux new-session -A -s main
  fi
fi
