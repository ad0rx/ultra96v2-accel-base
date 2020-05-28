# View gdbserver in seperate window to see i/o from app

target extended-remote 192.168.0.73:2000
set sysroot /mnt/projects/avnet/2019.2/ultra96v2-accel-base/build/sysroots/aarch64-xilinx-linux
#target extended-remote | ssh -T root@192.168.0.73 gdbserver - build/hello
set remote exec-file /mnt/host
set environment XILINX_XRT /usr
b main
run /mnt/vadd.hw.xclbin