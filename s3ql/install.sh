#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo "install compilation tools and dependencies"
echo "Begining..."
apt update -qq
apt install -yy s3ql rsync nano curl wget
apt upgrade -yy