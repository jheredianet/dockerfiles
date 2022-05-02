#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo "install compilation tools and dependencies"
echo "Begining..."
apt update -qq && apt upgrade -qq

apt install -y build-essential zlib1g-dev libncurses5-dev \
    libgdbm-dev libnss3-dev libssl-dev libreadline-dev \
    libffi-dev libsqlite3-dev wget curl libbz2-dev git \
    fuse psmisc pkg-config liblzma-dev\
    libattr1-dev libfuse-dev \
    libsqlite3-dev libjs-sphinxdoc tzdata

curl https://www.python.org/ftp/python/3.9.12/Python-3.9.12.tgz -o Python-3.9.12.tgz
tar -xf Python-3.9.12.tgz
cd Python-3.9.12
./configure --enable-optimizations
make -j 12
make altinstall

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3.9 get-pip.py

pip3 install https://github.com/rogerbinns/apsw/releases/download/3.8.2-r1/apsw-3.8.2-r1.zip
pip3 install cython pycrypto \
    defusedxml requests "llfuse >= 1.0, < 2.0" "dugong >= 3.4, < 4.0" "pytest >= 2.7" 
pip3 install --upgrade google-auth-oauthlib

# Fuse3
apt install -y fuse3 libfuse3-dev
pip3 install pyfuse3 cryptography

cd /
rm -rf Python-3.9.12
rm Python-3.9.12.tgz

echo "download s3ql code"
git clone https://github.com/s3ql/s3ql.git

cd s3ql
echo "compile s3ql"
python3.9 setup.py build_cython
python3.9 setup.py build_ext --inplace

echo "install s3ql"
python3.9 setup.py install
cd /
rm -rf s3ql

echo "cleanup compilations tools"
apt-get remove --purge -y git
apt autoremove -y && apt autoclean -y && apt clean -y
rm -rf /var/lib/apt/lists/*
