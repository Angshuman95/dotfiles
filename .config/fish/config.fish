if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting ""

set -gx EDITOR nvim

# DOTNET
complete -f -c dotnet -a "(dotnet complete)"

if type -q exa
  alias ll "exa --long --git --icons"
  alias lla "ll -a"
end

alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# TMUX splits
function ide3
    tmux split-window -h -p 35 \; \
        split-window -v -p 45 \; \
        send-keys -t 1 "clear" "C-m" \; \
        select-pane -t 1 \;
end

function tde3
    tmux split-window -v -p 40 \; \
        split-window -h -p 45 \; \
        send-keys -t 1 "clear" "C-m" \; \
        select-pane -t 1 \;
end

function ide4
    tmux split-window -v -p 40 \; \
        split-window -h -p 66 \; \
        split-window -h -p 50 \; \
        send-keys -t 1 "clear" "C-m" \; \
        select-pane -t 1 \;
end
