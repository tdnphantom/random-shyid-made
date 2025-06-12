#!/bin/bash

#Gatau, dari GPT
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

#Destinasi 
dst_addr="/vm-xcp-backup"

#ini buat ambil UUID nya
vm_uuid=$(run_command "xe vm-list name-label='$1' --minimal")
if [ -z "$vm_uuid" ]; then    
    echo "VM UUID not found for the VM: $1"
    exit 1
fi

#Ntar biar dia pause dlu
echo "Suspending VM: $1"
xe vm-suspend vm=$vm_uuid
echo "....."
  echo "Suspended."
  echo ""

# Export VM: Overwrite file or add timestamp // Ni jg dari GPT
timestamp=$(date +"%Y%b%d-%H:%M")
export_file="${dst_addr}/$1-${timestamp}.xva"

#Ni Dari GPT klo mau OverWrite
# Remove old file (Optional: Uncomment to overwrite instead of using timestamps)
# old_file="${dst_addr}/$1.xva"
# if [ -f "$old_file" ]; then
#     echo "Removing old export file: $old_file"
#     rm -f "$old_file"
# fi

echo "Exporting VM: $1 to $export_file"
run_command "xe vm-export vm=$vm_uuid filename=${export_file}"
echo ""

# Resume the VM
echo "Resuming VM: $1"
echo "....."
run_command "xe vm-resume vm=$vm_uuid"
echo "VM: $1 Resumed"