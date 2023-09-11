#!/bin/ash

# Abort entire script if any command fails
# S3QL_EXPORTER_ID=""
function disconnect() {
    echo "Stop Success!!"
}

# Get lastest version of dagu
echo "Downloading the latest binary to the current directory..."
test -z "$VERSION" && VERSION="$(curl -sfL -o /dev/null -w %{url_effective} "$RELEASES_URL/latest" |
                rev |
                cut -f1 -d'/'|
                rev)"

test -z "$VERSION" && {
        echo "Unable to get Dagu version." >&2
        exit 1
}

export TARGET_FILE="dagu_${VERSION#v}_${TARGETARCH}.tar.gz" #remove the v
#ping objects.githubusercontent.com # to force resolution, sometimes it's not working
#echo ${RELEASES_URL}/download/v${VERSION}/${TARGET_FILE}
wget -S ${RELEASES_URL}/download/${VERSION}/${TARGET_FILE} && \
tar -xf ${TARGET_FILE} && rm *.tar.gz && \
sudo mv dagu /usr/local/bin/

trap disconnect  SIGINT
trap disconnect  SIGTERM

echo "Startig scheduler..."
dagu scheduler &

# run server
echo "Startig Dagu version: $VERSION"
dagu server

#tail -f "$REDIS_LOGFILE" "$RCLONE_LOGFILE" "$JUICE_LOGFILE" & wait