#!/bin/bash

# Check for required arguments
if [ "$#" -lt 4 ]; then
    echo "Usage: $0 <VM_NAME> <DESTINATION_HOST> <DESTINATION_DIR> <DESTINATION_USER>"
    echo "Example: $0 'Ubuntu VM' 192.168.1.100 /home/user/vhd_backups user"
    exit 1
fi

# Input arguments
vm_name="$1"
destination_host="$2"
destination_dir="$3"
destination_user="$4"

# Fetch VDI UUID
echo "Fetching VDI UUID for VM: $vm_name"
vdi_uuid=$(xe vdi-list name-label="$vm_name" --minimal)

if [ -z "$vdi_uuid" ]; then
    echo "Error: No VDI found for VM $vm_name"
    exit 1
fi

echo "VDI UUID: $vdi_uuid"

# Ensure destination directory exists on the remote host
echo "Ensuring destination directory exists on $destination_host..."
ssh "$destination_user@$destination_host" "mkdir -p $destination_dir"

# Export and transfer the VHD directly to the remote host using SCP
echo "Exporting VDI and transferring to $destination_host:$destination_dir..."
xe vdi-export uuid="$vdi_uuid" filename=/dev/stdout format=vhd | ssh "$destination_user@$destination_host" "cat > $destination_dir/$vdi_uuid.vhd"

if [ $? -eq 0 ]; then
    echo "VHD file successfully transferred to $destination_host:$destination_dir"
else
    echo "Error: Failed to export and transfer VHD file."
    exit 1
fi

echo "Process completed successfully!"

