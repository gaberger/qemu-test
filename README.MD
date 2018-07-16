Test Machine

Install Utils
```apt install uml-utilities bridge-utils qemu-system-x86 ipxe-qemu```

Setup Tap interface and bind to docker bridge

``` sudo tunctl -t tap0 -u vagrant```
Add interface to bridge
```sudo brctl addif docker0 tap0```

Enable interface

```sudo ip link set tap0 up```
Create disk
dd if=/dev/zero of=disk1.drive bs=1 count=1 seek=$(( (10 * 1024 * 1024 * 1024) - 1))
qemu-system-x86_64 -k en-us -machine accel=kvm   -m 1024M -netdev tap,id=net0,ifname=tap0,script=no,downscript=no -device e1000,netdev=net0,mac=00:aa:00:60:00:01  -drive file=disk1.drive
