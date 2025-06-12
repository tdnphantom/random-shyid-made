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

# Fetch all VDI UUIDs for the given VM
echo "Fetching VDI UUIDs for VM: $vm_name"
vdi_uuids=$(xe vdi-list name-label="$vm_name" --minimal)

if [ -z "$vdi_uuids" ]; then
    echo "Error: No VDIs found for VM $vm_name"
    exit 1
fi

echo "VDI UUIDs: $vdi_uuids"

# Fetch SR UUID for the VDI
echo "Fetching SR UUID for VDI: $vdi_uuids..."
sr_uuid=$(xe vdi-list uuid=$vdi_uuids params=sr-uuid --minimal)
if [ -z "$sr_uuid" ]; then
    echo "No SR found for VDI: $vdi_uuid"
    exit 1
fi
echo "SR UUID: $sr_uuid"

# Check the SR type
echo "Fetching SR type..."
sr_type=$(xe sr-list uuid=$sr_uuid params=type --minimal)
echo "SR Type: $sr_type"

# Ensure destination directory exists on the remote host
echo "Ensuring destination directory exists on $destination_host..."
ssh "$destination_user@$destination_host" "mkdir -p $destination_dir"

# Handle different SR types
if [ "$sr_type" = "nfs" ] || [ "$sr_type" = "ext" ]; then
    echo "Searching for VHD file in /run/sr-mount/$sr_uuid..."
    vhd_file=$(find /run/sr-mount/$sr_uuid -type f -name "${vdi_uuids}.vhd" 2>/dev/null)

    if [ -z "$vhd_file" ]; then
        echo "No VHD file found for VDI UUID: $vdi_uuid in SR: $sr_uuid"
        exit 1
    fi

    echo "VHD file found: $vhd_file"
    
# Loop through each VDI UUID
IFS=',' read -ra uuid_array <<< "$vdi_uuids"
index=1
for vdi_uuid in "${uuid_array[@]}"; do
    echo "Processing VDI UUID: $vdi_uuids"

    # Define the export file name based on VM name
    export_file_name="$destination_dir/$vm_name-${index}.vhd"

    # Export and transfer the VHD directly to the remote host
    echo "Exporting and transferring VDI $vdi_uuids to $destination_host:$export_file_name..."
    # xe vdi-export uuid="$vdi_uuid" filename=/dev/stdout format=vhd | ssh "$destination_user@$destination_host" "cat > $export_file_name"
    cp "$vhd_file" "$destination_dir"
    echo "VHD file successfully copied to $destination_dir"

    if [ $? -eq 0 ]; then
        echo "VDI $vdi_uuids successfully transferred as $export_file_name"
    else
        echo "Error: Failed to export and transfer VDI $vdi_uuids"
    fi

    ((index++))
done

echo "All VDIs processed successfully!"
fi