#!/usr/bin/env bash
# ~/lab/diag/jail_audit.sh

PROJECT=${1:-alpha}

if ! podman ps | grep -q "lab-$PROJECT"; then
    echo "No active lab found to audit."
    exit 1
fi

echo ">>> JAIL AUDIT: $PROJECT"

# Check for 'privileged' status or 'root' inside the pod
IS_PRIV=$(podman inspect "lab-$PROJECT" --format '{{.HostConfig.Privileged}}')
USER_ID=$(podman exec "lab-$PROJECT" id -u)

if [ "$IS_PRIV" = "true" ]; then
    echo "❌ CRITICAL: Container is running in Privileged mode!"
else
    echo "✅ Container is unprivileged."
fi

if [ "$USER_ID" = "0" ]; then
    echo "⚠️  WARNING: Agent is running as ROOT inside the pod."
else
    echo "✅ Agent is running as UID $USER_ID (Restricted)."
fi