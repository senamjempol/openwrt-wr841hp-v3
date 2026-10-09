#!/bin/sh

# 1. Set OpenNDS dalam keadaan OFF (Disabled)
if [ -f /etc/config/opennds ]; then
    uci set opennds.@opennds[0].enabled='0'
    uci commit opennds
fi
/etc/init.d/opennds disable 2>/dev/null || true

exit 0
