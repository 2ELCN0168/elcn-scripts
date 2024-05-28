#!/bin/bash

if ! dialog --version &> /dev/null; then
  echo -e "This script needs the package 'dialog' to continue."
  echo -e "Exiting with code 1."
  exit 1
fi


# Function to regenerate SSH key
regenerate_ssh_key() {
    # Prompt for IP address
    IP=$(dialog --inputbox "Enter the host IP address:" 8 40 3>&1 1>&2 2>&3 3>&-)
    # Prompt for SSH port
    PORT=$(dialog --inputbox "Enter the SSH port (default 22):" 8 40 3>&1 1>&2 2>&3 3>&-)
    PORT=${PORT:-22}  # Use 22 if no port is specified

    # Define variables
    SSH_DIR="$HOME/.ssh"
    OLD_KEYS_DIR="$SSH_DIR/old_keys"
    KEY_NAME="id_rsa"

    # Create a directory to save old keys
    mkdir -p $OLD_KEYS_DIR

    # Backup old keys
    if [ -f "$SSH_DIR/$KEY_NAME" ]; then
        mv "$SSH_DIR/$KEY_NAME" "$OLD_KEYS_DIR/$KEY_NAME.$(date +%Y%m%d%H%M%S)"
        mv "$SSH_DIR/$KEY_NAME.pub" "$OLD_KEYS_DIR/$KEY_NAME.pub.$(date +%Y%m%d%H%M%S)"
        dialog --msgbox "Old keys backed up in $OLD_KEYS_DIR" 8 40
    else
        dialog --msgbox "No existing key found, no backup needed" 8 40
    fi

    # Generate new SSH keys
    ssh-keygen -t rsa -b 4096 -f "$SSH_DIR/$KEY_NAME" -N "" <<< y

    # Remove old host entry from known_hosts
    ssh-keygen -R "$IP" -f "$SSH_DIR/known_hosts"
    dialog --msgbox "Host entry $IP removed from known_hosts file" 8 40

    # Copy the new public key to the remote machine
    REMOTE_USER=$(dialog --inputbox "Enter the username for $IP:" 8 40 3>&1 1>&2 2>&3 3>&-)
    ssh-copy-id -i "$SSH_DIR/$KEY_NAME.pub" -p "$PORT" "$REMOTE_USER@$IP"

    # Optional: Verify if the key was correctly added
    ssh -i "$SSH_DIR/$KEY_NAME" -p "$PORT" "$REMOTE_USER@$IP" "echo 'Successful connection with new SSH key'"

    dialog --msgbox "New SSH keys have been successfully generated and deployed." 8 40
}

# Main menu loop
while true; do
    choice=$(dialog --menu "SSH Key Regeneration Menu" 15 50 2 \
        1 "Regenerate SSH Key" \
        2 "Exit" 3>&1 1>&2 2>&3 3>&-)
    
    case $choice in
        1)
            regenerate_ssh_key
            ;;
        2)
            dialog --msgbox "Goodbye!" 8 40
            clear
            exit 0
            ;;
        *)
            dialog --msgbox "Invalid option, please try again." 8 40
            ;;
    esac
done
