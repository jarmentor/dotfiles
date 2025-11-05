# ─── only run the rest in a real interactive shell ───────────────────────────
# skip EVERYTHING below if this isn't an interactive terminal
[[ $- != *i* ]] && return

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
  "$HOME/.local/bin"
  "/opt/homebrew/bin"
  "/usr/local/bin"
  "$HOME/.composer/vendor/bin"
  "/usr/local/sbin"
  "$HOME/.cargo/bin"
  "/opt/homebrew/opt/ruby/bin"
  "/Library/Frameworks/Python.framework/Versions/3.11/bin",
  "$HOME/.docker/bin"
)
for p in "${EXTRA_PATHS[@]}"; do
  [[ -d $p && :$PATH: != *":$p:"* ]] && PATH="$p:$PATH"
done
export PATH

# ────────────────────────────────────────────────────────────────────────────
# Oh-My-Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git fast-syntax-highlighting zsh-autosuggestions)

source "$ZSH/oh-my-zsh.sh"

# ────────────────────────────────────────────────────────────────────────────
# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY # append to history file rather than replace it
setopt SHARE_HISTORY # share history between sessions
setopt EXTENDED_HISTORY # add timestamps to history
setopt HIST_IGNORE_ALL_DUPS # don't record dupes in history
setopt INC_APPEND_HISTORY # saves commands immediately
setopt HIST_REDUCE_BLANKS # cleans up extra whitespace
setopt HIST_VERIFY # shows command before executing from history

# ────────────────────────────────────────────────────────────────────────────
# Vi mode
bindkey -v
export KEYTIMEOUT=1

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

# File + system (modern replacements)
alias ls='eza --icons --group-directories-first --git -l'
alias ll='eza -l --icons --group-directories-first --git --header'
alias la='eza -la --icons --group-directories-first --git --header'
alias lt='eza --tree --level=2 --icons'

alias reload='source ~/.zshrc'
alias {c,cl,clr,lear}=clear
alias {q,xit,x}=exit
alias o=open
alias sdn=share-daily-note
alias f='open .'
alias tdt='cd ~/Desktop'
alias tdl='cd ~/Downloads'
alias {dots,dotfiles}='cd ~/.dotfiles'
alias neovim='nvim'
alias {v,vim,nv,ivm,bim}='nvim'
alias r='ranger'
alias {dev,todev}='cd /Volumes/Development'

# Daily note function
d() {
  local today_file="/Volumes/Development/Notebook/daily/$(date +%Y-%m-%d).md"
  nvim "$today_file"
}
alias {n,nb,notebook}='cd /Volumes/Development/Notebook/'

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
alias dkc='docker compose'
alias useenv='source venv/bin/activate'
alias python=python3
alias pip=pip3
alias nrb='npm run build'
alias nrs='npm run start'
alias nrd='npm run dev'

# Trafilatura
alias traf='trafilatura'

# Cargo & Rust
alias cb='cargo build'
alias cr='cargo run'
alias rce='rustc --explain '

# FZF & utils
alias ff=fzf
alias hgrep='history | grep'
alias lorem=lorem-ipsum
alias fib='seq 50 | awk "BEGIN{a=1;b=1}{print a;c=a+b;a=b;b=c}"'
alias {ts,now}='date +%s | sed "s/\n//g"'

# Photo / image
alias tojpg='mogrify -quality 100 -format jpg'
alias img-resize='magick mogrify'

# Remote server
alias {h,hipaa}='ssh hipaa'

# ────────────────────────────────────────────────────────────────────────────
# Functions

mkcd() {
  mkdir -p "$1" && cd "$1"
}

fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -${1:-9}
  fi
}

rfc() {
  [[ $1 =~ ^[0-9]+$ ]] || { echo "Usage: rfc <number>"; return 1; }
  curl -s "https://www.rfc-editor.org/rfc/rfc$1.txt" | less
}

sitemap() {
  local url="$1"
  curl -s "$url" \
    | grep '<loc>' \
    | awk -F'[<>]' '{print $3}' \
    | sort
}

# ────────────────────────────────────────────────────────────────────────────
# Third-party tool integrations

# Zoxide
eval "$(zoxide init --cmd cd zsh)"

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
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"

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
# ─── Auto-attach tmux on Apiarist.local (but NOT in VS Code bc aaaa) ────────────────
if [[ "$(hostname)" == "Apiarist.local" && -z $TMUX && $TERM_PROGRAM != "vscode" ]]; then
  if command -v tmux >/dev/null 2>&1; then
    exec tmux new-session -A -s main
  fi
fi


function __set_beam_cursor {
    echo -ne '\e[6 q'
}

function __set_block_cursor {
    echo -ne '\e[2 q'
}

function zle-keymap-select {
  case $KEYMAP in
    vicmd) __set_block_cursor;;
    viins|main) __set_beam_cursor;;
  esac
}
zle -N zle-keymap-select

function zle-line-init {
    __set_beam_cursor
}
zle -N zle-line-init

precmd() {
    __set_beam_cursor  # doesn't have to be in precmd - can put outside a function if you like
}
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/jarmentor/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
