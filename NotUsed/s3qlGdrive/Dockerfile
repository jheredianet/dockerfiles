FROM ubuntu:16.04
LABEL maintainer="@jheredianet"

# Update package cache and install dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install openssh-server nfs-kernel-server htop nload wget software-properties-common git -y && \
    add-apt-repository ppa:nikratio/s3ql -y && \
    apt-get install python3 python3-pip -y && \
    pip3 install --upgrade pip && apt-get update && apt-get install python3-llfuse -y && \
    pip3 install --upgrade google-api-python-client && \
    pip3 install llfuse && \
    apt-get install s3ql sqlite3 libsqlite3-dev cython nfs-common -y && \
    cd root && git clone https://github.com/jheredianet/s3ql.git -b gdrive && cd s3ql && \
    python3 setup.py build_cython && \
    python3 setup.py build_ext --inplace && \
    python3 setup.py install

# Add sample credentials
ADD authinfo2 /root/.s3ql/authinfo2 
RUN chmod 600 /root/.s3ql/authinfo2

# Add config files for NFS
ADD configure-exports.bash /root/configure-exports.bash
ADD start-container.bash /root/start-container.bash
RUN chmod 755 /root/*.bash

# Config SSH
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

# Default Profile
ADD .bashrc /root/.bashrc
ADD .profile /root/.profile

WORKDIR /root
EXPOSE 22/tcp 111/tcp 111/udp 2049/tcp 2049/udp 32765/tcp 32765/udp 32766/tcp 32766/udp 32767/tcp 32767/udp

ENTRYPOINT ["/root/start-container.bash"]
