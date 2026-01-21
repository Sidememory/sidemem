#!/usr/bin/env bash
# ~/lab/labs/ignition-tmux.sh

PROJECT=${1:-alpha}

# 1. Mount the Cartridges on the Host
bash ~/lab/labs/opencode.sh "$PROJECT" --mount-only 

# 2. Create Tmux Session
tmux new-session -d -s "lab-$PROJECT" -n "Pilot"

# Pane 1: The Pilot (Entry into Podman)
tmux send-keys -t "lab-$PROJECT:0" "bash ~/lab/labs/opencode.sh $PROJECT" C-m

# Pane 2: The Overseer (Host Side Tools)
tmux split-window -v -p 30 -t "lab-$PROJECT:0"
tmux send-keys -t "lab-$PROJECT:0.1" "cd ~/lab && ./lab-menu.sh" C-m

# Pane 3: The Monitor
tmux split-window -h -t "lab-$PROJECT:0.1"
tmux send-keys -t "lab-$PROJECT:0.2" "bash ~/lab/diag/perms.sh" C-m

tmux attach-session -t "lab-$PROJECT"