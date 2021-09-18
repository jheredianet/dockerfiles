# ~/.profile: executed by Bourne-compatible login shells.
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true

PATH="/root/scripts:/root/s3ql/bin:$PATH"