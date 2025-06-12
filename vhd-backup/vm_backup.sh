#!/bin/bash

# Debug Mode (Uncomment to enable detailed output)
set -x

# Ensure a VM name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <vm-name>"
  exit 1
fi

VM_NAME=$(echo "$1" | xargs)  # Trim whitespace
BACKUP_DIR="/mnt/backup/$VM_NAME"  # Define backup directory
echo "Searching for VM: '$VM_NAME'"

# Get VM UUID(s)
VM_UUIDS=$(xe vm-list name-label="$VM_NAME" --minimal)
if [ -z "$VM_UUIDS" ]; then
  echo "Error: VM with name '$VM_NAME' not found."
  exit 1
fi

# Split the UUIDs into an array
IFS=',' read -r -a UUID_ARRAY <<< "$VM_UUIDS"

# If multiple UUIDs, prompt the user to select one
if [ "${#UUID_ARRAY[@]}" -gt 1 ]; then
  echo "Multiple VMs found with the name '$VM_NAME':"
  for i in "${!UUID_ARRAY[@]}"; do
    echo "$((i + 1)). ${UUID_ARRAY[$i]}"
  done

  read -p "Select the VM to process (1-${#UUID_ARRAY[@]}): " SELECTION
  if [[ "$SELECTION" -lt 1 || "$SELECTION" -gt "${#UUID_ARRAY[@]}" ]]; then
    echo "Invalid selection."
    exit 1
  fi

  VM_UUID=${UUID_ARRAY[$((SELECTION - 1))]}
else
  VM_UUID=${UUID_ARRAY[0]}
fi

echo "Selected VM UUID: $VM_UUID"

# Get all VDI UUIDs for the selected VM
VDI_UUIDS=$(xe vbd-list vm-uuid="$VM_UUID" type=Disk params=vdi-uuid --minimal)
if [ -z "$VDI_UUIDS" ]; then
  echo "No disks found for VM '$VM_NAME'."
  exit 1
fi

echo "Disks for VM: $VM_NAME"

# Create backup directory
mkdir -p "$BACKUP_DIR" || { echo "Failed to create backup directory."; exit 1; }

# Loop through each VDI UUID
for VDI_UUID in $(echo "$VDI_UUIDS" | tr ',' '\n'); do
  echo "Processing VDI UUID: $VDI_UUID"
  # Get SR UUID and location
   SR_UUID=$(xe vdi-list uuid="$VDI_UUID" params=sr-uuid --minimal)
#   SR_UUID=1374642d-e338-cbf1-e835-ddae2ef7b15f
   LOCATION=$(xe vdi-list uuid="$VDI_UUID" params=location --minimal)

  if [ -n "$SR_UUID" ] && [ -n "$LOCATION" ]; then
    VHD_PATH="/var/run/sr-mount/$SR_UUID/$LOCATION"
    echo "Backing up: $VHD_PATH"

    # Backup the VHD
    cp "$VHD_PATH" "$BACKUP_DIR/" || {
      echo "Failed to back up $VHD_PATH."
      continue
    }

    echo "Backup complete: $BACKUP_DIR/$(basename "$VHD_PATH")"
  else
    echo "Failed to retrieve details for VDI UUID: $VDI_UUID"
  fi
done

echo "Backup completed for VM: $VM_NAME"

