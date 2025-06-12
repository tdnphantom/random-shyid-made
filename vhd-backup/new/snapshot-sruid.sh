#!/bin/bash
VM_NAME=$1
SNAPSHOT_PREFIX="${VM_NAME}-auto-snapshot"
SNAPSHOT_NAME="${SNAPSHOT_PREFIX}-$(date +%Y%m%d)"

# Get VM UUID
VM_UUID=$(xe vm-list name-label="$VM_NAME" --minimal)

if [ -z "$VM_UUID" ]; then
    echo "VM not found: $1"
    exit 1
fi

# Get the primary Storage Repository (SR) UUID
SR_UUID=$(xe vm-disk-list vm="$VM_UUID" --minimal)

if [ -z "$SR_UUID" ]; then
    echo "Failed to find SR for VM: $1"
    exit 1
fi

# Path to snapshots
SNAPSHOT_PATH="/run/sr-mount/$SR_UUID/"

# Delete snapshots older than 30 days
echo "Checking for old snapshots in $SNAPSHOT_PATH..."
find "$SNAPSHOT_PATH" -type f -name "${SNAPSHOT_PREFIX}-*" -mtime +30 -exec rm -v {} \;

# Create a new snapshot
xe vm-snapshot vm="$VM_UUID" new-name-label="$SNAPSHOT_NAME"
echo "Snapshot $SNAPSHOT_NAME created!"
