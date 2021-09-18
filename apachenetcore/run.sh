#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
httpd-foreground &
/usr/bin/dotnet $NETCOREAPP_PATH