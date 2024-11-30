if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.local:$PATH
export PATH=/opt/homebrew/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/.composer/vendor/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/Library/Frameworks/Python.framework/Versions/3.11/lib/python3.11/site-packages:$PATH"
export PATH="/Library/Frameworks/Python.framework/Versions/3.11/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="agnoster"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Prevents untracked files from being seen as dirty
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(git fast-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# General File Operations
alias rmr="rm -r"
alias reload="source ~/.zshrc"
alias f="open ./"
alias tdt="cd ~/Desktop"
alias tdl="cd ~/Downloads"

# Brew / System Updates
alias brewup="brew update; brew upgrade; brew cleanup; brew upgrade --cask; brew doctor"

# Session / Terminal Management
alias {q,xit,x}="exit"

# Utilities
alias fib="seq 50 | awk 'BEGIN {a=1; b=1} {print a; c=a+b; a=b; b=c}'"
alias lorem="lorem-ipsum"
alias hgrep="history | grep"
alias pip="pip3"

# Docker and Development
alias dkc="docker-compose"
alias dk="docker"
alias useenv="source venv/bin/activate"
alias python="python3"
alias nrb="npm run build"
alias nrs="npm run start"
alias nrd="npm run dev"

# Project Directories
alias {dev,todev}="cd /Volumes/Development"
alias {comit,tocomit}="cd /Volumes/Development/Comit/"
alias {personal,topersonal}="cd /Volumes/Development/Personal/"
alias tolocal="cd ~/Local\ Sites"

# Neovim / Editors
alias neovim="nvim"
alias {v,vim,nv}=nvim
alias gvim="/usr/bin/vim"
alias sshconfig="nvim ~/.ssh/config"

# Git
alias g="git"
alias gsh="git show"
alias gs="git status"
alias gd="git diff"

# Miscellaneous Tools
alias obs="open -a Obsidian"
alias img-resize="magick mogrify"
alias ff="fzf"
alias cb="cargo build"
alias cr="cargo run"
alias rce="rustc --explain "
alias photoshop="open -a 'Adobe Photoshop 2025'"
alias grep=rg


# Time & Date
alias {timestamp,ts}="date +%s"
alias {tspb,tscp}="date +%s | pbcopy"

# File Management and Conversion
alias tojpg="mogrify -quality 100 -format jpg"
alias dotfiles="cd ~/.dotfiles"
alias rfc=view_rfc
alias h=head
alias {c,cl,clr}=clear

# Nonsense and Fun
alias eggsit="echo \"🥚 bye\"; sleep 1.5s; exit;"
alias nonsense="sgpt --model gpt-4-1106-preview --repl texas_nonsense \"you are a texas nonsense generator, reply with a short sentence or two of texas nonsense\""


view_rfc() {
  local rfc_number="$1"
  if [[ ! "$rfc_number" =~ ^[0-9]+$ ]]; then
    echo "Error: RFC number must be a numeric value."
    return 1
  fi
  local url="https://www.rfc-editor.org/rfc/rfc${rfc_number}.txt"
  echo "Viewing RFC ${rfc_number}..."
  curl -s "$url" | less
}

vv() {
  # Assumes all configs exist in directories named ~/.config/nvim-*
  local config=$(fd --max-depth 1 --glob 'nvi*' ~/.config | fzf --prompt="Neovim Configs > " --height=~50% --layout=reverse --border --exit-0)
 
  # If I exit fzf without selecting a config, don't open Neovim
  [[ -z $config ]] && echo "No config selected" && return
 
  # Open Neovim with the selected config
  NVIM_APPNAME=$(basename $config) nvim $@
}

#function to open a new named session for tmux
# Function to create a named tmux session
tmux_new() {
  if [ -z "$1" ]; then
    echo "Please provide a session name."
    return 1
  fi
  tmux new-session -s "$1"
}

alias {tmn,tmux-new}=tmux_new

# Function to select and attach to a tmux session using fzf
tmux_select() {
  # List tmux sessions, pass through fzf for selection, and extract the session name
  SESSION=$(tmux ls | fzf --height 50% --border --preview 'tmux list-windows -t {1} | head -n 5' | cut -d: -f1)

  # If a session is selected, attach to it
  if [ -n "$SESSION" ]; then
    tmux attach-session -t "$SESSION"
  else
    echo "No session selected."
  fi
}

alias {tms,tmux-select}=tmux_select

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

# bun + bun completions
[ -s "/Users/jarmentor/.bun/_bun" ] && source "/Users/jarmentor/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jarmentor/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jarmentor/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jarmentor/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jarmentor/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/Users/jarmentor/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Shell-GPT integration ZSH v0.2
_sgpt_zsh() {
if [[ -n "$BUFFER" ]]; then
    _sgpt_prev_cmd=$BUFFER
    BUFFER+="⌛"
    zle -I && zle redisplay
    BUFFER=$(sgpt --shell <<< "$_sgpt_prev_cmd" --no-interaction)
    zle end-of-line
fi
}
zle -N _sgpt_zsh
bindkey ^l _sgpt_zsh
# Shell-GPT integration ZSH v0.2

#FZF integration
eval "$(fzf --zsh)"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
    fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
    fd --type=d --hidden --exclude .git . "$1"
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source "/Users/jarmentor/.dotfiles/.env"
source "/Users/jarmentor/.dotfiles/.env.comit"
source "/Users/jarmentor/.dotfiles/.env.personal"

