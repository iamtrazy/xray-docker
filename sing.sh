#!/bin/sh

mkdir -p /var/log/sing-box /var/lib/sing-box

if [[ "$(uname)" == 'Linux' ]]; then
    case "$(uname -m)" in
        'amd64' | 'x86_64')
            supports_v2='awk "/cx16/&&/lahf/&&/popcnt/&&/sse4_1/&&/sse4_2/&&/ssse3/ {found=1} END {exit !found}"'
            supports_v3='awk "/avx/&&/avx2/&&/bmi1/&&/bmi2/&&/f16c/&&/fma/&&/abm/&&/movbe/&&/xsave/ {found=1} END {exit !found}"'
            echo "$flags" | eval $supports_v2 || ARCH="amd64";ARCH_CF="amd64"
            echo "$flags" | eval $supports_v3 || ARCH="amd64v3"
        ;;
        'armv8' | 'aarch64')
            ARCH='arm64';ARCH_CF="amd64"
        ;;
        *)
            ARCH="";ARCH_CF="amd64"
        ;;
        
    esac
fi

[ -z "${ARCH}" ] && echo "Error: Not supported OS Architecture" && exit 1
# Download binary file
SING_FILE="sing-box-1.8.5-linux-${ARCH}.tar.gz"
CFD_FILE="cloudflared-linux-${ARCH_CF}"


echo "Downloading binary file: ${SING_FILE}"
wget -O /tmp/sing.tar.gz https://github.com/SagerNet/sing-box/releases/download/v1.8.5/${SING_FILE} > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Failed to download binary file: ${SING_FILE}" && exit 1
fi
echo "Download binary file: ${SING_FILE} completed"

tar xvf /tmp/sing.tar.gz sing-box-1.8.5-linux-${ARCH}/sing-box -C /tmp --strip-components=1
mv /tmp/sing-box /usr/local/bin/sing-box
rm -f /tmp/sing.tar.gz

echo "Downloading Geodata"
wget -O /var/lib/sing-box/geosite.db https://github.com/SagerNet/sing-geosite/releases/latest/download/geosite.db > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Failed to download geodata" && exit 1
fi
echo "Download geodata completed"

chmod +x /usr/local/bin/sing-box
sing-box version

echo "Downloading binary file: ${CFD_FILE}"
wget -O /tmp/cloudflared https://github.com/cloudflare/cloudflared/releases/download/2024.2.0/${CFD_FILE} > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Failed to download binary file: ${CFD_FILE}" && exit 1
fi
echo "Download binary file: ${CFD_FILE} completed"

mv /tmp/cloudflared /usr/local/bin/cloudflared
chmod +x /usr/local/bin/cloudflared
cloudflared version