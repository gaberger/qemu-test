#!/usr/bin/env bash

if (( $# == 1 )); then
  UUID=$1
  echo "Starting VM $UUID"
else
  UUID=$(cat /proc/sys/kernel/random/uuid)
  echo "Creating VM $UUID"
  mkdir machines/$UUID
  dd if=/dev/zero of=machines/${UUID}/${UUID}.drive bs=1 count=1 seek=$(( (10 * 1024 * 1024 * 1024) - 1)) 
  cp /usr/share/OVMF/OVMF_VARS.fd machines/${UUID}/${UUID}_OVMF_VARS.fd
fi

read -r -d '' VAR <<EOF
qemu-system-x86_64 
-k en-us 
-machine pc-i440fx-2.11,accel=kvm,usb=off,vmport=off,dump-guest-core=off \
-cpu Broadwell-noTSX-IBRS 
-m 1024M 
-netdev tap,id=net0,ifname=tap0,script=no,downscript=no 
-global PIIX4_PM.disable_s3=0 
-global isa-debugcon.iobase=0x402 -debugcon file:ovmf.log 
-device piix3-usb-uhci -device usb-tablet
-msg timestamp=on 
-monitor stdio 
-nodefaults 
-device qxl-vga
-realtime mlock=off 
-no-user-config 
-smp 1,sockets=1,cores=1,threads=1 
-device e1000,netdev=net0,mac=00:aa:00:60:00:01  
-drive file=machines/${UUID}/${UUID}.drive,format=raw
-drive file=/usr/share/OVMF/OVMF_CODE.fd,if=pflash,format=raw,unit=0,readonly=on 
-drive if=pflash,format=raw,file=machines/${UUID}/${UUID}_OVMF_VARS.fd
EOF


#-machine pc-i440fx-bionic,accel=kvm,usb=off,vmport=off,dump-guest-core=off \
#-device ipmi-bmc-sim,id=bmc0
#-chardev socket,id=ipmichr0,host=localhost,port=9002,reconnect=10
#-device ipmi-bmc-extern,chardev=ipmichr0,id=bmc0
#-boot menu=off

$VAR

# -k en-us \
# -global PIIX4_PM.disable_s3=0 \
# -global isa-debugcon.iobase=0x402 -debugcon file:ovmf.log \
# -monitor stdio \
# -device piix3-usb-uhci -device usb-tablet \
# -msg timestamp=on \
# -no-user-config \
# -nodefaults \
# -smp 1,sockets=1,cores=1,threads=1 \
# -boot menu=off,strict=on \
# -S format=raw,file=${UUID}.drive 
# -realtime mlock=off 


# -drive file=/usr/share/OVMF/OVMF_CODE.fd,if=pflash,format=raw,unit=0,readonly=on \
# -drive if=pflash,format=raw,file=${UUID}_OVMF_VARS.fd\

#-drive file=disk1.drive


