#!/bin/sh

# 1. Otomatis aktifkan semua interface Wi-Fi (ON)
if [ -f /etc/config/wireless ]; then
    for radio in $(uci show wireless | grep '=wifi-device' | cut -d'.' -f2); do
        uci set wireless.$radio.disabled='0'
    done
    uci commit wireless
fi

# 2. Set OpenNDS dalam keadaan OFF (Disabled)
if [ -f /etc/config/opennds ]; then
    uci set opennds.@opennds[0].enabled='0'
    uci commit opennds
fi
/etc/init.d/opennds disable 2>/dev/null || true

exit 0
