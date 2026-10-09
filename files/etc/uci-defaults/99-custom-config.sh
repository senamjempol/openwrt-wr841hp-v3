#!/bin/sh

wlan_name="SEGALA TEKNIK"
wlan_password="takonobojoku"
root_password="enter"
host_name="SAMSUNG"
time_zone="WIB-7"
zone_name="Asia/Jakarta"
lan_ip_address="192.168.100.1"

# 1. Set OpenNDS dalam keadaan OFF (Disabled)
if [ -f /etc/config/opennds ]; then
    uci set opennds.@opennds[0].enabled='0'
    uci commit opennds
fi
/etc/init.d/opennds disable 2>/dev/null || true

# 2. Ganti Password Root
if [ -n "$root_password" ]; then
  (echo "$root_password"; sleep 1; echo "$root_password") | passwd > /dev/null
fi

# 3. Konfigurasi Nama Host & Waktu
if [ -n "$host_name" ] && [ -n "$time_zone" ] && [ -n "$zone_name" ]; then
    uci set system.@system[0].hostname="$host_name"
    uci set system.@system[0].timezone="$time_zone"
    uci set system.@system[0].zonename="$zone_name"
    uci commit system
fi

# 4. Konfigurasi LAN (IP Address)
if [ -n "$lan_ip_address" ]; then
  uci set network.lan.ipaddr="$lan_ip_address"
  uci commit network
fi

# 5. Konfigurasi LED
uci set system.led_power=led
uci set system.led_power.name='Power'
uci set system.led_power.sysfs='green:power'
uci set system.led_power.trigger='timer'
uci set system.led_power.delayon='500'
uci set system.led_power.delayoff='5000'

uci set system.led_wifi=led
uci set system.led_wifi.name='Wifi'
uci set system.led_wifi.sysfs='green:wifi'
uci set system.led_wifi.trigger='none'
uci set system.led_wifi.default='0'
uci commit system

# 6. Konfigurasi WLAN
if [ -n "$wlan_name" -a -n "$wlan_password" -a ${#wlan_password} -ge 8 ]; then
  uci set wireless.@wifi-device[0].disabled='0'
  uci set wireless.@wifi-device[0].country='CA'
  uci set wireless.@wifi-iface[0].disabled='0'
  uci set wireless.@wifi-iface[0].encryption='psk2'
  uci set wireless.@wifi-iface[0].ssid="$wlan_name"
  uci set wireless.@wifi-iface[0].key="$wlan_password"
  uci commit wireless
fi

exit 0
