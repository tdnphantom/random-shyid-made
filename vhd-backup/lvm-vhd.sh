#!/bin/bash

# Function to run a command and handle errors
run_command() {
    local cmd="$1"
    local result
    result=$(eval "$cmd" 2>&1)
    if [ $? -ne 0 ]; then
        echo "Error running command: $cmd"
        echo "$result"
        exit 1
    fi
    echo "$result"
}

# Get VM Name from user
read -rp "Enter the VM name: " vm_name

# Fetch list of VDIs for the VM
echo "Fetching list of VDIs for VM: $vm_name..."
vdi_list=$(run_command "xe vdi-list name-label='$vm_name'")
if [ -z "$vdi_list" ]; then    
    echo "No VDIs found for the VM: $vm_name"
    exit 1
fi
echo "$vdi_list"

# Get the VDI UUID from user
read -rp "Enter the VDI UUID: " vdi_uuid

# Fetch SR UUID for the VDI
echo "Fetching SR UUID for VDI: $vdi_uuid..."
sr_uuid=$(run_command "xe vdi-list uuid=$vdi_uuid params=sr-uuid --minimal")
if [ -z "$sr_uuid" ]; then
    echo "No SR found for VDI: $vdi_uuid"
    exit 1
fi
echo "SR UUID: $sr_uuid"

# Check the SR type
echo "Fetching SR type..."
sr_type=$(run_command "xe sr-list uuid=$sr_uuid params=type --minimal")
echo "SR Type: $sr_type"

# Handle different SR types
if [ "$sr_type" = "nfs" ] || [ "$sr_type" = "ext" ]; then
    echo "Searching for VHD file in /run/sr-mount/$sr_uuid..."
    vhd_file=$(find /run/sr-mount/$sr_uuid -type f -name "${vdi_uuid}.vhd" 2>/dev/null)

    if [ -z "$vhd_file" ]; then
        echo "No VHD file found for VDI UUID: $vdi_uuid in SR: $sr_uuid"
        exit 1
    fi

    echo "VHD file found: $vhd_file"

    # Copy the VHD file to the destination directory
    read -rp "Enter the destination directory for the VHD file: " destination_dir
    mkdir -p "$destination_dir"
    cp "$vhd_file" "$destination_dir"
    echo "VHD file successfully copied to $destination_dir"

elif [ "$sr_type" = "lvm" ]; then
    echo "The SR is an LVM-based SR. Locating the logical volume..."
    lv_path=$(lvs --noheadings -o lv_path | grep "$vdi_uuid" | xargs)

    if [ -z "$lv_path" ]; then
        echo "No logical volume found for VDI UUID: $vdi_uuid"
        exit 1
    fi

    echo "Logical volume found: $lv_path"

    # Export the logical volume to a VHD file
    read -rp "Enter the destination directory for da Exported VHD: " destination_dir
    mkdir -p "$destination_dir"
    dd if="$lv_path" of="$destination_dir/${vdi_uuid}.vhd" bs=1M status=progress
    echo "Logical volume successfully exported to $destination_dir/${vdi_uuid}.vhd"
fi

