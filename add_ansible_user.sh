#!/bin/bash

# Define the username
USERNAME="ansible"

# Define the public key (replace with your actual public key)
PUBLIC_KEY="<YOUR KEY HERE>"

# Create the user if it doesn't already exist
if id "$USERNAME" &>/dev/null; then
  echo "User '$USERNAME' already exists."
else
  echo "Creating user '$USERNAME'..."
  sudo useradd -m "$USERNAME"
fi

# Create the .ssh directory in the user's home directory if it doesn't exist
HOME_DIR="/home/$USERNAME"
SSH_DIR="/home/$USERNAME/.ssh"
if [ ! -d "$SSH_DIR" ]; then
  echo "Creating $SSH_DIR directory..."
  sudo -u "$USERNAME" mkdir -p "$SSH_DIR"
fi

# Paste the public key directly into authorized_keys
echo "$PUBLIC_KEY" | sudo -u "$USERNAME" tee "$SSH_DIR/authorized_keys" > /dev/null

# Set correct permissions
echo "Setting permissions..."
sudo -u "$USERNAME" chmod 755 "$HOME_DIR"
sudo -u "$USERNAME" chmod 700 "$SSH_DIR"
sudo -u "$USERNAME" chmod 644 "$SSH_DIR/authorized_keys"
sudo -u "$USERNAME" chown -R "$USERNAME:$USERNAME" "$SSH_DIR"

# Add the user to the sudoers file with NOPASSWD privileges
echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers > /dev/null

echo "Public key has been added to the '$USERNAME' user's authorized_keys file."
