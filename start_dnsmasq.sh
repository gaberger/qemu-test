sudo pkill dnsmasq
sudo dnsmasq \
 --interface=docker0 \
 --dhcp-range=172.17.0.100,172.17.0.150 \
 --dhcp-match=set:http,60,HTTPClient:Arch:00016 \
 --dhcp-boot=tag:http,http://172.17.0.1:8000/ipxe.efi\
 --dhcp-userclass=set:ipxe,iPXE \
 --dhcp-boot=tag:ipxe,"http://172.17.0.1:8000/boot.ipxe"  \
--log-queries \
 --log-dhcp \
 -d

