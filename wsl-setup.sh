#!/bin/sh
WIN_USERNAME=$1

# Get SSH keys from Windows environment
# Need to make the below block more readable, basically it sets permissions for ssh-keys. 
umask 077
if [ ! -d ~/.ssh ]
then
  cp -r /mnt/d/Users/$WIN_USERNAME/.ssh ~/
  chmod 600 ~/.ssh/config
  chmod 400 ~/.ssh/id*
fi

# Set less annoying permissions, this is just so I don't get annoying green bars when listing directories
# echo "\n#Setting less annoying permissions\numask 077\n" >> ~/.profile

# Set up passwordless sudo
echo "echo \"$USER ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers" | sudo bash

# Setup SSH agent
cat ./ssh-scripts >> ~/.profile

# Set custom aliases to kill ssh-agent quickly
cat ./aliases >> ~/.profile

# Copy .gitconfig
cp gitconfig ~/.gitconfig

## Debian Specific stuff

# Install ansible packages, for Debian like environments
sudo apt update -y
sudo apt upgrade -y
sudo apt install curl ansible vim openssh-client git man-db -y

# Let SSH not bother me everytime I connect to a new host, which happens a lot.
sed -i "s/#   StrictHostKeyChecking ask/    StrictHostKeyChecking no/g"

# Repo clean up
sudo apt autoremove --purge -y
sudo apt clean all

## Debian/Ubuntu specific stuff ends here

# Delete this script
rm -rf ~/wsl-setup

exit 0
