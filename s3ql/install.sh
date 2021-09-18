#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo "install compilation tools and dependencies"
echo "Begining..."
apt update -qq
apt install -y git \
   python3 python3-pip fuse psmisc pkg-config \
   libattr1-dev libfuse-dev \
   libsqlite3-dev libjs-sphinxdoc tzdata
pip3 install https://github.com/rogerbinns/apsw/releases/download/3.8.2-r1/apsw-3.8.2-r1.zip
pip3 install cython pycrypto \
    defusedxml requests "llfuse >= 1.0, < 2.0" "dugong >= 3.4, < 4.0" "pytest >= 2.7" 

pip3 install --upgrade google-auth-oauthlib

# Fuse3
apt install -y fuse3 libfuse3-dev
pip3 install pyfuse3 cryptography

echo "download s3ql code"
git clone https://github.com/s3ql/s3ql.git

cd s3ql
echo "compile s3ql"
python3 setup.py build_cython
python3 setup.py build_ext --inplace

echo "install s3ql"
python3 setup.py install

echo "cleanup compilations tools"
apt-get remove --purge -y git
apt autoremove -y && apt autoclean -y && apt clean -y
rm -rf /var/lib/apt/lists/*
