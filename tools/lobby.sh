#!/usr/bin/env bash
# ~/lab/lobby.sh

# 1. Discovery (Fuzzy select prefix)
PREFIX=$(ls *.img 2>/dev/null | sed 's/_[^_]*\.img//' | sort -u | fzf --header="Select Lab Project")

if [[ -z "$PREFIX" ]]; then echo "No project selected."; exit 1; fi

WS_IMG="${PREFIX}_WS.img"
BRAIN_IMG="${PREFIX}_Brain.img"

# 2. Scientific Permissions
# Ensure the host user (1000) owns the block images
podman unshare chown 1000:1000 "$WS_IMG" "$BRAIN_IMG"

# 3. Entry
echo "🛸 Docking into $PREFIX..."
podman run -it --rm \
  --name "${PREFIX}_pod" \
  --userns keep-id \
  --security-opt label=disable \
  -v "$(pwd)/$WS_IMG":/home/pilot/workspace:z \
  -v "$(pwd)/$BRAIN_IMG":/home/pilot/brain:Z \
  -v "$(pwd)/tools":/usr/local/bin:ro \
  opencode-chassis
