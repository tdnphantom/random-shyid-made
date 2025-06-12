#!/bin/bash
VM_NAME=$1
SNAPSHOT_NAME="${VM_NAME}-auto-snapshot"

# Get VM UUID
VM_UUID=$(xe vm-list name-label="$VM_NAME" --minimal)

if [ -z "$VM_UUID" ]; then
    echo "‚ùå VM not found: $1"
    exit 1
fi

# Find existing snapshots with the same name
OLD_SNAPSHOT_UUIDS=$(xe snapshot-list name-label="$SNAPSHOT_NAME" --minimal)

# If any snapshots exist, delete them all
if [ -n "$OLD_SNAPSHOT_UUIDS" ]; then
    echo "Ì†ΩÌ∑ë Deleting old snapshots for $SNAPSHOT_NAME..."
    for SNAPSHOT_UUID in $(echo "$OLD_SNAPSHOT_UUIDS" | tr ',' ' '); do
        echo "   ‚û§ Removing snapshot: $SNAPSHOT_UUID"
        xe snapshot-destroy uuid="$SNAPSHOT_UUID"
    done
    echo "‚úÖ Old snapshots deleted."
fi

# Create a new snapshot
echo "Ì†ΩÌ≥∏ Creating new snapshot: $SNAPSHOT_NAME..."
SNAPSHOT_UUID=$(xe vm-snapshot vm="$VM_UUID" new-name-label="$SNAPSHOT_NAME" 2>&1)

if [[ $? -ne 0 ]]; then
    echo "‚ùå Snapshot creation failed! Error: $SNAPSHOT_UUID"
    exit 1
fi

echo "‚úÖ Snapshot $SNAPSHOT_NAME created!"
