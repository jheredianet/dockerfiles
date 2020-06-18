#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo "install compilation tools and dependencies"
echo "Begining..."
apt update -qq
apt install -y git rsync nano curl \
   python3 python3-pip fuse psmisc pkg-config \
   libattr1-dev libfuse-dev \
   libsqlite3-dev libjs-sphinxdoc tzdata
   #texlive-latex-base texlive-latex-recommended texlive-latex-extra texlive-generic-extra \
   #texlive-fonts-recommended
#pip3 install --upgrade pip
pip3 install https://github.com/rogerbinns/apsw/releases/download/3.8.2-r1/apsw-3.8.2-r1.zip
pip3 install prometheus_client cython pycrypto \
    defusedxml requests "llfuse >= 1.0, < 2.0" "dugong >= 3.4, < 4.0" "pytest >= 2.7" 
    #pytest-catchlog sphinx
    #cython==0.24.1

pip3 install --upgrade google-api-python-client
pip3 install --upgrade oauth2client
pip3 install --upgrade google-auth-oauthlib

# Fuse3
apt install -y fuse3 libfuse3-dev
pip3 install pyfuse3 cryptography

echo "download s3ql code"
git clone https://github.com/segator/s3ql.git -b gdrive
#git clone https://github.com/jheredianet/s3ql.git -b skipfsck

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
