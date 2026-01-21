#!/usr/bin/env bash
# ~/lab/tools/init-project.sh

PROJECT=$1
MNT_BR="$HOME/lab/mnt/brain"

if [ -z "$PROJECT" ]; then
    echo "Usage: init-project.sh [project_name]"
    exit 1
fi

echo "🩹 Preparing DNA for new 1GB pair: [$PROJECT]..."

# 1. Ensure it is toggled/mounted
bash ~/lab/tools/forge.sh toggle "$PROJECT"

# 2. Setup the structure
sudo mkdir -p "$MNT_BR/.opencode" "$MNT_BR/.local" "$MNT_BR/.config"
sudo chown -R 1000:1000 "$MNT_BR"

# 3. Seed the files from the Docker Image Template
echo "🌱 Seeding files to the 1GB Brain..."
podman run --rm -v "$MNT_BR:/mnt/brain:z" localhost/opencode-agent \
    cp -rp /home/pilot/brain_template/.opencode/. /mnt/brain/.opencode/

sudo chown -R 1000:1000 "$MNT_BR"
echo "✅ Done. Your 1GB pair is ready."