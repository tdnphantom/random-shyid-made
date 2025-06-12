import subprocess
import os
import shutil


def run_command(command):
    """Run a shell command and return its output."""
    try:
        result = subprocess.check_output(command, shell=True)
        return result.strip()
    except subprocess.CalledProcessError as e:
        raise RuntimeError(f"Command failed: {command}\nError: {e.stderr}")


def get_sr_list():
    """Get a list of Storage Repositories."""
    return run_command("xe sr-list")


def get_vdi_list(vm_name):
    """Get a list of VDIs for a given VM."""
    return run_command(f"xe vdi-list name-label={vm_name}")


def find_vhd_file(vdi_uuid):
    """Find the VHD file for a given VDI UUID."""
    print(f"Searching for VHD file with UUID: {vdi_uuid} ...")
    for root, dirs, files in os.walk("/"):
        for file in files:
            if file == f"{vdi_uuid}":
                return os.path.join(root, file)
    raise FileNotFoundError(f"No VHD file found for VDI UUID: {vdi_uuid}")


def copy_vhd_file(vhd_path, destination_path):
    """Copy the VHD file to a destination directory."""
    if not os.path.exists(destination_path):
        os.makedirs(destination_path)
    destination_file = os.path.join(destination_path, os.path.basename(vhd_path))
    shutil.copy(vhd_path, destination_file)
    print(f"VHD file copied to {destination_file}")


def main():
    # Prompt user for inputs
    vm_name = input("Enter the VM name: ").strip()
    destination_path = input("Enter the destination directory for the VHD file: ").strip()

    try:
        print("Fetching list of Storage Repositories...")
        print(get_sr_list())

        print(f"Fetching list of VDIs for VM: {vm_name}")
        print(get_vdi_list(vm_name))

        vdi_uuid = input("Enter the VDI UUID: ").strip()

        print("Locating the VHD file...")
        vhd_path = find_vhd_file(vdi_uuid)
        print(f"VHD file found: {vhd_path}")

        print("Copying the VHD file...")
        copy_vhd_file(vhd_path, destination_path)

    except Exception as e:
        print(f"Error: {e}")


if __name__ == "__main__":
    main()

