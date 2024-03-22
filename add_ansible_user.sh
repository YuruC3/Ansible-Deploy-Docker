#!/bin/bash

# Define variables
USERNAME="<ANSIBLE_USERNAME>"
PUBLIC_KEY="<YOUR_PUBKEY>"
UID_INT="1600"  # 1600 to easilly distinguish ansible_user
not_found=0

# Check if user exists
IFS=$'\n'
for users in $(cat /etc/passwd)
do
    if [[ $(echo "$users" | awk 'BEGIN { FS = ":" } ; { print $1 }') = "$USERNAME" ]]
    then
        ((not_found++))
    fi 
done
unset IFS

# Create user with custom UID and GID
if [[ $not_found = 0 ]]; then
    echo "Creating user '$USERNAME'..."
    sudo useradd -m "$USERNAME" -s "/bin/bash" -u $UID_INT
else
    echo "User '$USERNAME' already exists."
fi

# Create the .ssh directory if it doesn't exists
HOME_DIR="/home/$USERNAME"
SSH_DIR="/home/$USERNAME/.ssh"
if [[ ! -d "$SSH_DIR" ]]; then
    echo "Creating $SSH_DIR directory..."
    sudo -u "$USERNAME" mkdir -p "$SSH_DIR"
fi

# Paste the public key directly into authorized_keys
echo "$PUBLIC_KEY" | sudo -u "$USERNAME" tee -a "$SSH_DIR/authorized_keys" > /dev/null

# Set correct permissions
echo "Setting permissions..."
sudo -u "$USERNAME" chmod 755 "$HOME_DIR"
sudo -u "$USERNAME" chmod 700 "$SSH_DIR"
sudo -u "$USERNAME" chmod 644 "$SSH_DIR/authorized_keys"
sudo -u "$USERNAME" chown -R "$USERNAME:" "$SSH_DIR"

# Add the user to the sudoers file with NOPASSWD privileges
echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers > /dev/null

echo "Public key has been added to the '$USERNAME' user's authorized_keys file."
