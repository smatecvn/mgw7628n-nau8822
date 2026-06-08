#!/bin/sh

BASE_URL="http://repo.smatec.com.vn/a7600"
VERSION="$2"

usage() {
    echo "Firmware Upgrade Tool"
    echo
    echo "Usage:"
    echo "  $0 -v <FW_VERSION>"
    echo
    echo "Options:"
    echo "  -v <FW_VERSION>    Firmware version to be upgraded"
    echo "  -h                 Show this help message"
    echo
    echo "Example:"
    echo "  $0 -v A50C4B14A7600M7"
    echo
    echo "Description:"
    echo "  This script upgrades the modem firmware to the specified version."
    echo "  Before upgrading, related services and processes will be stopped"
    echo "  to prevent the 4G module from restarting during the upgrade."
    echo
    exit 1
}

# Parse arguments
while [ $# -gt 0 ]; do
    case "$1" in
        -v)
            VERSION="$2"
            shift 2
            ;;
        *)
            usage
            ;;
    esac
done

[ -z "$VERSION" ] && usage

BINFILE="BinFile_${VERSION}.bin"
DOWNLOADER="fbfdownloader_cross"
WD="/tmp"

echo "======================================="
echo "A7600 FW Update"
echo "Version : $VERSION"
echo "======================================="

echo "[0/5] Stopping services..."

/etc/init.d/cron stop 2>/dev/null

for pid in $(pgrep -f "/usr/bin/mgwp_app"); do
    kill -9 "$pid"
done

for pid in $(pgrep -f "python /usr/lib/python3.9/site-packages/mgw3/mgwp.pyc"); do
    kill -9 "$pid"
done

sleep 2
cd $WD

# Download downloader
if [ ! -f "$DOWNLOADER" ]; then
    echo "[1/5] Downloading $DOWNLOADER ..."
    wget -O "$DOWNLOADER" "$BASE_URL/$DOWNLOADER" || {
        echo "ERROR: Download $DOWNLOADER failed"
        exit 1
    }
    chmod +x "$DOWNLOADER"
fi

# Download firmware
echo "[2/5] Downloading $BINFILE ..."
wget -O "$BINFILE" "$BASE_URL/$BINFILE" || {
    echo "ERROR: Download $BINFILE failed"
    exit 1
}

# Run upgrade
echo "[3/5] Upgrading firmware ..."
LOGFILE="/tmp/a7600_upgrade.log"

./"$DOWNLOADER" -b "$BINFILE" 2>&1 | tee "$LOGFILE"

#echo "Waiting for modem flash completion..."
#for i in 5 4 3 2 1; do
#    echo "$i..."
#    sleep 1
#done

# Check result
echo "[4/5] Checking result ..."

if grep -q "Burn Successfully" "$LOGFILE"; then
    echo "Firmware upgrade SUCCESS"

    echo "Restarting A7600 module..."

    mraa-gpio set 37 0
    sleep 3
    mraa-gpio set 37 1

    echo "A7600 rebooted"
    #exit 0
else
    echo "Firmware upgrade FAILED"
    exit 1
fi

echo "[5/5] Start cron and mgw8788 again..."
/etc/init.d/cron start 2>/dev/null
/etc/init.d/mgw8788 start 2>/dev/null
rm $BINFILE
rm $DOWNLOADER
rm $LOGFILE
exit 0