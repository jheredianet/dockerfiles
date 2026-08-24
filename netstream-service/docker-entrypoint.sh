#!/usr/bin/env bash
set -Eeuo pipefail

WARP_DAEMON=/bin/warp-svc
WARP_CLI=warp-cli
WARP_DATA_DIR=/var/lib/cloudflare-warp
WARP_CHECK_INTERVAL="${WARP_CHECK_INTERVAL:-30}"

# Keep the original image behavior unless WARP is explicitly enabled.
if [[ "${USE_WARP:-no}" != "yes" ]]; then
    exec runuser -u appuser -- /usr/bin/catatonit -- /entrypoint.sh "$@"
fi

mkdir -p /run/dbus /run/cloudflare-warp
dbus-uuidgen --ensure=/etc/machine-id

if [[ ! -S /run/dbus/system_bus_socket ]]; then
    echo "Starting D-Bus system bus..."
    dbus-daemon --system --fork
fi

warp_cli() {
    "${WARP_CLI}" --accept-tos "$@"
}

cleanup() {
    trap - TERM INT EXIT

    if [[ -n "${acestream_pid:-}" ]] && kill -0 "$acestream_pid" 2>/dev/null; then
        kill -TERM "$acestream_pid" 2>/dev/null || true
        wait "$acestream_pid" 2>/dev/null || true
    fi

    if [[ -n "${warp_pid:-}" ]] && kill -0 "$warp_pid" 2>/dev/null; then
        kill -TERM "$warp_pid" 2>/dev/null || true
        wait "$warp_pid" 2>/dev/null || true
    fi
}

trap cleanup TERM INT EXIT

mkdir -p "$WARP_DATA_DIR"

echo "Starting Cloudflare WARP daemon..."
"$WARP_DAEMON" --accept-tos &
warp_pid=$!

echo "Waiting for the WARP daemon..."
for _ in {1..30}; do
    if warp_cli status >/dev/null 2>&1; then
        break
    fi

    if ! kill -0 "$warp_pid" 2>/dev/null; then
        echo "Cloudflare WARP daemon stopped unexpectedly." >&2
        exit 1
    fi

    sleep 1
done

if ! warp_cli status >/dev/null 2>&1; then
    echo "Cloudflare WARP daemon did not become ready." >&2
    exit 1
fi

if [[ ! -f "$WARP_DATA_DIR/reg.json" ]]; then
    echo "Registering this WARP client..."
    warp_cli registration new
fi

echo "Selecting WARP tunnel mode..."
warp_cli mode warp+doh || true

echo "Connecting to WARP..."
warp_cli connect

echo "WARP status:"
warp_cli status || true

echo "Starting AceStream as appuser..."
extra_flags=()
if [[ "${ALLOW_REMOTE_ACCESS:-}" == "yes" ]]; then
    extra_flags+=(--bind-all)
fi

if [[ -n "${EXTRA_FLAGS:-}" ]]; then
    read -r -a configured_flags <<< "${EXTRA_FLAGS}"
    extra_flags+=("${configured_flags[@]}")
fi

# Preserve the original AceStream entrypoint behavior.
runuser -u appuser -- /usr/bin/catatonit -- \
    /app/start-engine \
    --cache-dir /home/appuser/.ACEStream/cache \
    --cache-limit 1 \
    --client-console \
    "${extra_flags[@]}" \
    "$@" &
acestream_pid=$!

while kill -0 "$acestream_pid" 2>/dev/null; do
    if ! kill -0 "$warp_pid" 2>/dev/null; then
        echo "WARP daemon stopped; restarting it..." >&2
        "$WARP_DAEMON" --accept-tos &
        warp_pid=$!
        sleep 3
    fi

    if ! warp_cli status 2>/dev/null | grep -qi 'connected'; then
        echo "WARP is not connected; attempting to reconnect..." >&2
        warp_cli connect || true
    fi

    sleep "$WARP_CHECK_INTERVAL"
done

wait "$acestream_pid"
