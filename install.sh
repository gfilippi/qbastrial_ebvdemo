#!/usr/bin/env bash

set -euo pipefail

# -------------------------------
# CONFIGURATION
# -------------------------------

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"

TARGET_FOLDER="/root/apps"  # destination folder

download_and_verify() {
    local url="$1"
    local output="$2"
    local expected_size="$3"
    local expected_md5="$4"

    echo "Downloading: $url"

    if ! curl -L -k -o "$output" "$url"; then
        echo "ERROR: Download failed"
        exit 1
    fi

    # Get file size (Linux/macOS compatible)
    local actual_size
    if stat --version >/dev/null 2>&1; then
        # Linux
        actual_size=$(stat -c%s "$output")
    else
        # macOS
        actual_size=$(stat -f%z "$output")
    fi

    if [[ "$actual_size" -ne "$expected_size" ]]; then
        echo "ERROR: File size mismatch for $output"
        echo "Expected: $expected_size"
        echo "Actual:   $actual_size"
        exit 1
    fi

    # Get MD5 checksum (Linux/macOS compatible)
    local actual_md5
    if command -v md5sum >/dev/null 2>&1; then
        # Linux
        actual_md5=$(md5sum "$output" | awk '{print $1}')
    else
        # macOS
        actual_md5=$(md5 -q "$output")
    fi

    if [[ "$actual_md5" != "$expected_md5" ]]; then
        echo "ERROR: MD5 checksum mismatch for $output"
        echo "Expected: $expected_md5"
        echo "Actual:   $actual_md5"
        exit 1
    fi

    echo "SUCCESS: $output verified"
}

# -------------------------------
# INSTALL
# -------------------------------

if [[ -d "$TARGET_FOLDER" ]]; then
    echo "Folder $TARGET_FOLDER exists. Removing it completely..."
    rm -rf "$TARGET_FOLDER"
    echo "Folder removed."
    mkdir -p "$TARGET_FOLDER"
    echo "Folder created."
else
    echo "Folder $TARGET_FOLDER does not exist. Creating it..."
    mkdir -p "$TARGET_FOLDER"
    echo "Folder created."
fi




# Downloads APPS:
cd $TARGET_FOLDER
cd /root/
URL="http://www.brainworks.it/astrial/astrial-h8_apps_imx219_20260325_001.tar"
OUTPUT="astrial-h8_apps_imx219_20260325_001.tar"
EXPECTED_SIZE=121446400
EXPECTED_MD5="47e84ec652f66a1a1aecee775494fa10"

download_and_verify \
    $URL \
    $OUTPUT \
    $EXPECTED_SIZE \
    $EXPECTED_MD5

tar -xvf $OUTPUT
rm $OUTPUT


# Downloads TOOLS:
cd /root/
URL="http://www.brainworks.it/astrial/astrial-h8_fil_tools.tar"
OUTPUT="astrial-h8_apps_imx219_20260325_001.tar"
EXPECTED_SIZE=2406400
EXPECTED_MD5="cf6e9839110d68e2cb9b7919b1d4425b"

download_and_verify \
    $URL \
    $OUTPUT \
    $EXPECTED_SIZE \
    $EXPECTED_MD5

tar -xvf $OUTPUT
rm $OUTPUT



# Downloads CONFIG:
cd /root/
URL="http://www.brainworks.it/astrial/astrial-h8_config_ar0234_20260221_001.tar"
OUTPUT="astrial-h8_config_ar0234_20260221_001.tar"
EXPECTED_SIZE=10240
EXPECTED_MD5="bbd930219adf77f3fc04b8cdba6f0015"

download_and_verify \
    $URL \
    $OUTPUT \
    $EXPECTED_SIZE \
    $EXPECTED_MD5

tar -xvf $OUTPUT
rm $OUTPUT



# Downloads libs:
cd /root/
URL="http://www.brainworks.it/astrial/astrial-h8_postproc_imx219_20260325_001.tar"
OUTPUT="astrial-h8_postproc_imx219_20260325_001.tar"
EXPECTED_SIZE=1495040
EXPECTED_MD5="e1b5e942b08903716a984434c6498d41"

download_and_verify \
    $URL \
    $OUTPUT \
    $EXPECTED_SIZE \
    $EXPECTED_MD5

tar -xvf $OUTPUT


# -------------------------------
# POST-INSTALL
# -------------------------------

# post install libs
OUTPUT="astrial-h8_postproc_imx219_20260325_001.tar"
cd /
tar -xvf /root/$OUTPUT
rm /root/$OUTPUT

# copy fan control
cd /root/fil_tools/pwm_fan_lkt.sh $TARGET_FOLDER

# install demo server
cd $TARGET_FOLDER/demo_webserver/setup
chmod 754 ./*.sh
./install.sh

# copy config
cd /root
cp ./rc.local /etc/rc.local

cd /root/etc/systemd/network/
cp ./20-wired.network /etc/etc/systemd/network

# -------------------------------
# 3rd-party-install
# -------------------------------

# t.b.d


# -------------------------------
# DONE
# -------------------------------

echo "######################################"
echo " EBV DEMO install completed, rebooting"
echo "######################################"

#sleep 3
#reboot