#!/usr/bin/env bash

# tmux-sessionizer - unified session switcher and project directory selector

if [[ $# -eq 1 ]]; then
    selected=$1
    is_session=false
else
    # Get current session
    current_session=$(tmux display-message -p '#S' 2>/dev/null || echo "")
    
    # Get all sessions
    all_sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null || echo "")
    existing_sessions=$(echo "$all_sessions" | grep -v "^$current_session$" || echo "")
    
    # Check if main session exists and add create option if not
    has_main=0
    if echo "$all_sessions" | grep -q "^main$" 2>/dev/null; then
        has_main=1
    fi
    
    # Get project directories
    project_dirs=$(find /Volumes/Development -mindepth 1 -maxdepth 2 -type d \
        -not -path '*/\.*' \
        -not -path '*/node_modules' \
        -not -path '*/vendor' \
        -not -path '*/.git' \
        2>/dev/null || echo "")
    
    # Build combined options list
    options=""
    
    # Add current session at top (marked as current)
    if [[ -n "$current_session" ]]; then
        options="$current_session (current)"$'\n'
    fi
    
    # Add create main session if it doesn't exist
    if [[ $has_main -eq 0 ]]; then
        options="${options}Create Main Session"$'\n'
    fi
    
    # Add existing sessions
    if [[ -n "$existing_sessions" ]]; then
        while IFS= read -r session; do
            if [[ -n "$session" ]]; then
                options="${options}$session"$'\n'
            fi
        done <<< "$existing_sessions"
    fi
    
    # Add kill options grouped together
    if [[ -n "$existing_sessions" ]]; then
        while IFS= read -r session; do
            if [[ -n "$session" ]]; then
                options="${options}kill: $session"$'\n'
            fi
        done <<< "$existing_sessions"
    fi
    
    # Add project directories
    if [[ -n "$project_dirs" ]]; then
        options="$options$project_dirs"
    fi
    
    # Show unified picker
    selected=$(printf "%s" "$options" | \
        fzf --reverse \
            --border=none \
            --header="Session Manager" \
            --header-first \
            --height=80% \
            --prompt="❯ " \
            --color=pointer:#f6c177 \
            --color=marker:#ebbcba \
            --preview="$HOME/.dotfiles/tmux/preview-helper.sh {}" \
            --preview-window=right:50%:wrap)
    
    # Determine if selected is an existing session or directory
    if [[ "$selected" == "Create Main Session" ]] || [[ "$selected" == kill:* ]] || [[ "$selected" == *"(current)" ]] || tmux has-session -t "$selected" 2>/dev/null; then
        is_session=true
    else
        is_session=false
    fi
fi

if [[ -z $selected ]]; then
    exit 0
fi

# Handle session switching vs directory-based session creation
if [[ "$selected" == "Create Main Session" ]]; then
    # Create main session
    if ! tmux has-session -t main 2>/dev/null; then
        tmux new-session -d -s main
    fi
    tmux switch-client -t main
elif [[ "$selected" == kill:* ]]; then
    # Kill session
    session_to_kill="${selected#kill: }"
    tmux kill-session -t "$session_to_kill"
    tmux display-message "Killed session: $session_to_kill"
elif [[ "$selected" == *"(current)" ]]; then
    # Current session selected - do nothing
    tmux display-message "Already in current session"
elif [[ $is_session == true ]]; then
    # Switch to existing session
    tmux switch-client -t "$selected"
else
    # Create session from directory
    selected_name=$(basename "$selected" | tr . _)
    tmux_running=$(pgrep tmux)

    # If not in tmux and tmux isn't running, create new session
    if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
        tmux new-session -s $selected_name -c $selected
        exit 0
    fi

    # If session doesn't exist, create it detached
    if ! tmux has-session -t=$selected_name 2> /dev/null; then
        tmux new-session -d -s $selected_name -c $selected
    fi

    # Switch to the session
    if [[ -z $TMUX ]]; then
        # Not in tmux, attach directly
        tmux attach -t $selected_name
    else
        # In tmux, switch client
        tmux switch-client -t $selected_name
    fi
fi