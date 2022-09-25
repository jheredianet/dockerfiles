#!/bin/bash

echo "install restic & rclone tool and dependencies"
echo "Begining..."
apt-get update -qq
apt-get install -y nano curl fuse restic rclone
#curl https://rclone.org/install.sh | bash

echo "cleanup compilations tools"
#apt autoremove -y && apt autoclean -y && apt clean -y
#rm -rf /var/lib/apt/lists/*