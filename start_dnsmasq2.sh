sudo pkill dnsmasq
sudo dnsmasq \
 --interface=docker0 \
 --dhcp-range=172.17.0.100,172.17.0.150 \
--log-queries \
 --log-dhcp \
 -d

