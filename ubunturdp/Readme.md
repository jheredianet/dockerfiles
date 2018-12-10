# Ubuntu 18.04 Multi User Remote Desktop Server

Fully implemented Multi User xrdp
with xorgxrdp and pulseaudio
on Ubuntu 18.04.
Copy/Paste and sound is working.
Users can re-login in the same session.
Xfce4, Firefox are pre installed.
Inspired on [ubuntu-xrdp](https://hub.docker.com/r/danielguerra/ubuntu-xrdp/) image.

## Usage

Start the rdp server

```bash
docker run -d --name uxrdp --hostname terminalserver --shm-size 1g -p 3389:3389 -p 2222:22 juanheredia/ubunturdp
```

*note if you already use a rdp server on 3389 change -p \<my-port\>:3389
    -p 2222:22 is for ssh access ( ssh -p 2222 ubuntu@\<docker-ip\> )

Connect with your remote desktop client to the docker server.
Use the Xorg session (leave as it is), user and pass.

## Add new users

No configuration is needed for new users just do

```bash
docker exec -ti uxrdp adduser mynewuser
```

After this the new user can login

## Volumes

This image uses two volumes:

1. `/etc/ssh/` holds the sshd host keys and config
2. `/home/` holds the `mynewuser/` default user home directory

When bind-mounting `/home/`, make sure it contains a folder `mynewuser/` with proper permission, otherwise no login will be possible.

```bash
mkdir -p ubuntu
chown 999:999 ubuntu
```