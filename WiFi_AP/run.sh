#!/bin/bash

chown -R www-data:www-data /var/www/html
chown -R www-data:www-data /config/wifiap
mv /var/www/html/installers/enablelog.sh /config/wifiap/hostapd
mv /var/www/html/installers/disablelog.sh /config/wifiap/hostapd
mv /var/www/html/installers/servicestart.sh /config/wifiap/hostapd
mv /var/www/html/installers/debuglog.sh /config/wifiap/system
chown -c root:root /config/wifiap/hostapd/*.sh
chmod 750 /config/wifiap/hostapd/*.sh
chown -c root:root /config/wifiap/system/*.sh
chmod 750 /config/wifiap/system/*.sh
cp /var/www/html/installers/configport.sh /config/wifiap/lighttpd
chown -c root:root /config/wifiap/lighttpd/*.sh
mv /etc/default/hostapd ~/default_hostapd.old
cp /etc/hostapd/hostapd.conf ~/hostapd.conf.old
cp /var/www/html/config/hostapd.conf /config/wifiap/hostapd/hostapd.conf
cp /var/www/html/config/dhcpcd.conf /config/wifiap/dhcpcd/dhcpcd.conf
cp /var/www/html/config/defaults.json /config/wifiap/networking/
cp /var/www/html/config/raspap-bridge-br0.netdev /etc/systemd/network/raspap-bridge-br0.netdev
cp /var/www/html/config/raspap-br0-member-eth0.network /etc/systemd/network/raspap-br0-member-eth0.network


echo "Hello world!"
#python3 -m http.server 8000
lighttpd -f /etc/lighttpd/lighttpd.conf
dhcpcd -f "/config/wifiap/dhcpcd/dhcpcd.conf"
dnsmasq -C "/config/wifiap/dnsmasq/090_raspap.conf"
hostapd -d -B -i wlan0 /config/wifiap/hostapd/hostapd.conf -f /tmp/hostapd.log 1> /dev/null