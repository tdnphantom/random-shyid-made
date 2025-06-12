#!/bin/bash

# Configuration
VM_NAME="Ubuntu Web HC" 
VDI_UUID="846ced5c-2edd-4fca-af6f-5d2b77c1569c" 
DESTINATION="/vm-xcp-backup"
REMOTE_USER="root"
REMOTE_HOST="192.168.220.248"

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

# Function to copy a file to a local or remote destination
copy_file() {
    local file_path="$1"
    local destination="$2"
    # Check if the destination is a remote path (contains ':')
    if [[ "$destination" == *:* ]]; then
        echo "Copying file to remote destination: $destination"
        scp "$file_path" "$REMOTE_USER"@"$REMOTE_HOST":"$DESTINATION"/"$VM_NAME"
        if [ $? -ne 0 ]; then
            echo "Error copying file to remote destination: $destination"
            exit 1
        fi
    else
        echo "Copying file to local directory: $destination"
        mkdir -p "$destination/$VM_NAME"=
        cp "$file_path" "$destination"
        if [ $? -ne 0 ]; then
            echo "Error copying file to local directory: $destination"
            exit 1
        fi
    fi
    echo "File successfully copied to $destination"
}

# Fetch SR UUID for the VDI
echo "Fetching SR UUID for VDI: $VDI_UUID..." 
sr_uuid=$(run_command "xe vdi-list uuid=$VDI_UUID params=sr-uuid --minimal") 
if [ -z "$sr_uuid" ]; then
    echo "No SR found for VDI: $VDI_UUID"
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
    vhd_file=$(find /run/sr-mount/$sr_uuid -type f -name "${VDI_UUID}.vhd" 2>/dev/null)
    if [ -z "$vhd_file" ]; then
        echo "No VHD file found for VDI UUID: $VDI_UUID in SR: $sr_uuid"
        exit 1
    fi
    echo "VHD file found: $vhd_file"
    scp "$vhd_file" "$DESTINATION" 
    
elif [ "$sr_type" = "lvm" ]; then
    echo "The SR is an LVM-based SR. Locating the logical volume..."
    lv_path=$(lvs --noheadings -o lv_path | grep "$VDI_UUID" | xargs)
    
    if [ -z "$lv_path" ]; then
        echo "No logical volume found for VDI UUID: $VDI_UUID"
        exit 1
    fi
    
    echo "Logical volume found: $lv_path"
    
    temp_file="/vm-xcp-backup/tmp/${VDI_UUID}.vhd"
    dd if="$lv_path" of="$temp_file" bs=1M status=progress
    echo "Logical volume successfully exported to temporary file: $temp_file"
    
    scp "$temp_file" "$DESTINATION"
    rm -f "$temp_file" 
fi