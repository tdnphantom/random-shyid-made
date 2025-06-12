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

# Input variables (set these in your cronjob or pass them as environment variables)
VM_NAME=${VM_NAME:-}
DEST_DIR=${DEST_DIR:-}

if [ -z "$VM_NAME" ]; then
    echo "Error: VM_NAME is not set."
    exit 1
fi

# Fetch list of VDIs for the VM
echo "Fetching list of VDIs for VM: $vm_name..."
VDI_UUID=$(xe vdi-list name-label='$vm_name' params=uuid --minimal)
if [ -z "$vdi_uuid" ]; then    
    echo "No VDIs found for the VM: $vm_name"
    exit 1
fi
echo "$vdi_list"

if [ -z "$VDI_UUID" ]; then
    echo "Error: VDI_UUID is not set."
    exit 1
fi

if [ -z "$DEST_DIR" ]; then
    echo "Error: DEST_DIR is not set."
    exit 1
fi

# Fetch list of VDIs for the VM
echo "Fetching list of VDIs for VM: $VM_NAME..."
vdi_list=$(run_command "xe vdi-list name-label='$VM_NAME'")
if [ -z "$vdi_list" ]; then    
    echo "No VDIs found for the VM: $VM_NAME"
    exit 1
fi
echo "$vdi_list"

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

    # Copy the VHD file to the destination directory
    mkdir -p "$DEST_DIR"
    cp "$vhd_file" "$DEST_DIR"
    echo "VHD file successfully copied to $DEST_DIR"

elif [ "$sr_type" = "lvm" ]; then
    echo "The SR is an LVM-based SR. Locating the logical volume..."
    lv_path=$(lvs --noheadings -o lv_path | grep "$VDI_UUID" | xargs)

    if [ -z "$lv_path" ]; then
        echo "No logical volume found for VDI UUID: $VDI_UUID"
        exit 1
    fi

    echo "Logical volume found: $lv_path"

    # Export the logical volume to a VHD file
    mkdir -p "$DEST_DIR"
    dd if="$lv_path" of="$DEST_DIR/${VDI_UUID}.vhd" bs=1M status=progress
    echo "Logical volume successfully exported to $DEST_DIR/${VDI_UUID}.vhd"
else
    echo "Unsupported SR type: $sr_type"
    exit 1
fi
