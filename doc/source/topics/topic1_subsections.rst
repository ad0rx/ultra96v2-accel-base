vadd to test vio access with accelerator
test --save-temps and look at bd to verify VIO is still there
try to toggle leds from app or xsct

sstate build
commit vivado bd - merge with project version
rebuild from vivado all the way through platform

test vadd with new hardware

set_property PFM.CLOCK
{
 clk_out1 { id "1" is_default "false" proc_sys_reset "/proc_sys_reset_0" status "fixed"}
 clk_out2 { id "2" is_default "false" proc_sys_reset "/proc_sys_reset_1" status "fixed"}
 clk_out3 { id "0" is_default "true"  proc_sys_reset "/proc_sys_reset_2" status "fixed"}
 clk_out4 { id "4" is_default "false" proc_sys_reset "/proc_sys_reset_3" status "fixed"}
 clk_out5 { id "5" is_default "false" proc_sys_reset "/proc_sys_reset_4" status "fixed"}
} [get_bd_cells /clk_wiz_0]


set_property PFM.AXI_PORT
{
 M_AXI_HPM0_FPD {memport "M_AXI_GP"  sptag "" memory ""}
 M_AXI_HPM1_FPD {memport "M_AXI_GP"  sptag "" memory ""}
 S_AXI_HPC0_FPD {memport "S_AXI_HPC" sptag "" memory ""}
 S_AXI_HPC1_FPD {memport "S_AXI_HPC" sptag "" memory ""}
 S_AXI_HP0_FPD  {memport "S_AXI_HP"  sptag "" memory ""}
 S_AXI_HP1_FPD  {memport "S_AXI_HP"  sptag "" memory ""}
 S_AXI_HP2_FPD  {memport "S_AXI_HP"  sptag "" memory ""}
 S_AXI_HP3_FPD  {memport "S_AXI_HP"  sptag "" memory ""}
} [get_bd_cells /zynq_ultra_ps_e_0]

qemu boot
qemu dev tree
check that lab4 training document for sd card manifest file mods required

Environment
###########

| edit the bin/setup.sh script to suit
| source the bin/setup.sh script to configure environment
|  psource to source all tool settings
|  pa pop all dirs off directory stack
|  pws cd to project root directory


Vivado Project
##############

| bin/gen-vivado-project.sh
|  uses ultra96v2-accel-base-bd.tcl

| install board files
| VIO LEDs
| JTAG to AXI
| VIO PL Reset

| set_property pfm_name {vendor:boardid:name:rev} [current_project]
| see output of validate_platform -verbose to see fields
| or use list_property_value and list_property commands

| Needed to generate output products in OOC in order to get
| write_hw_platform command to complete sucessfully

| 'name' fields in the xsa appear to be set by the file name given for
| xsa file

| break out pfm interface set_parameters to an external function
| install ultra96v2 board files

| separate bd tcl and platform related commands - then easier to
| change the hardware design

PetaLinux Project
#################

| disable 96boards-sensors arduino-tools issue

| build sd card img file for rufus
| wifi credentials
| wifi autostart
| XILINX_XRT set to /usr
| sstate for faster builds
| remove extra files jffs cpio etc
|  IMAGE_FSTYPES_forcevariable in build/conf/plnxtool.conf for example
| fsck.fat32
|  IMAGE_INSTALL_append = " dosfstools"
| shared downloads dir

Vitis Project
#############

| Install board files for u96
| v++ options
|  debug, profile, interactive, config, save temps,

I want a scripted flow here, but not sure that Makefile makes any
sense. For the host application, it seems reasonable, but for the
kernels not so much. Well, I guess it's not that bad. Could make the
entire project Makefile based or cmake based...


| # Compile Host
| aarch64-linux-gnu-g++ -I ${SYSROOT}/usr/include/xrt -I /opt/Xilinx/Vivado/2019.2/include -I ${SYSROOT}/usr/include -c -fmessage-length=0 -std=c++14 --sysroot=${SYSROOT} -o host.o src/vadd.cpp

| # Link Host
| aarch64-linux-gnu-g++ -o host host.o -lxilinxopencl -lpthread -lrt -lstdc++ -lgmp -lxrt_core -L ${SYSROOT}/usr/lib --sysroot=${SYSROOT}

| # Compile sw_emu kernel - more work needed here to get to work - Qemu
| # ags error during link
| # ERROR: [v++ 60-929] The specified platform does not support Hardware Emulation (Qemu Arguments missing)
| v++ -t sw_emu --platform ultra96v2_min2 -c -k krnl_vadd -I src/ -o vadd.sw_emu.xo ../src/krnl_vadd.cpp

| # Compile hw kernel
| v++ -t hw     --platform ultra96v2_min2 -c -k krnl_vadd -I src/ -o vadd.hw.xo ../src/krnl_vadd.cpp

| # Link hw kernel
| v++ -t hw --platform $PLATFORM --link vadd.hw.xo -o vadd.hw.xclbin --config ../design.cfg



.. ****************
.. H2: Subsection 1
.. ****************
..
.. Subsection 1 Paragraph.
..
..
.. H3: Subsection 1.1
.. ==================
..
.. Subsection 1.1 Paragraph.
..
..
.. H4: Subsection 1.1.1
.. --------------------
..
.. Subsection 1.1.1 Paragraph.
..
..
.. H5: Subsection 1.1.1.1
.. ^^^^^^^^^^^^^^^^^^^^^^
..
.. Subsection 1.1.1.1 Paragraph.
..
..
.. H6: Subsection 1.1.1.1.1
.. """"""""""""""""""""""""""
..
.. Subsection 1.1.1.1.1 Paragraph.
..
..
.. ****************
.. H2: Subsection 2
.. ****************
..
.. Subsection 2 Paragraph.
..
..
.. ****************
.. H2: Subsection 3
.. ****************
..
.. Subsection 3 Paragraph.
..
..
.. H3: Subsection 3.1
.. ==================
..
.. Subsection 3.1 Paragraph.
..
..
.. H4: Subsection 3.1.1
.. --------------------
..
.. Subsection 3.1.1 Paragraph.
..
..
.. H5: Subsection 3.1.1.1
.. ^^^^^^^^^^^^^^^^^^^^^^
..
.. Subsection 3.1.1.1 Paragraph.
..
..
.. H6: Subsection 3.1.1.1.1
.. """"""""""""""""""""""""
..
.. Subsection 3.1.1.1.1 Paragraph.
..
..
.. H6: Subsection 3.1.1.1.2
.. """"""""""""""""""""""""
..
.. Subsection 3.1.1.1.2 Paragraph.
