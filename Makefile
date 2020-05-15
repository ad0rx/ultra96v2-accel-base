# Project level
PLATFORM := $(PROJ)

# Tools
VPP := v++
GCC := aarch64-linux-gnu-gcc
GPP := aarch64-linux-gnu-g++

# Paths
SRCDIR  := $(G_SRC_DIR)
BLDDIR  := $(G_BUILD_DIR)/vitis
SYSROOT := $(G_SYSROOTS_DIR)

# Collateral
HOSTSRCS := $(SRCDIR)/vadd.cpp
HOSTOBJS := $(patsubst $(SRCDIR)/%.cpp,$(BLDDIR)/%.o,$(HOSTSRCS))

.PHONY : help
help :
	@clear
	@echo "**********************************************************************"
	@echo "* Targets:                                                            "
	@echo "*   host         : the host application                               "
	@echo "*   hw_kernel    : hardware kernels                                   "
	@echo "*   hw_emu_kernel: hw_emu kernels                                     "
	@echo "*   sw_emu_kernel: sw_emu kernels                                     "
	@echo "*   clean        : you know what this does                            "
	@echo "*                                                                     "
	@echo "**********************************************************************"
	@echo "SRCDIR  : $(SRCDIR)"
	@echo "BLDDIR  : $(BLDDIR)"
	@echo "SYSROOT : $(SYSROOT)"
	@echo "HOSTSRCS: $(HOSTSRCS)"
	@echo "HOSTOBJS: $(HOSTOBJS)"

# TODO fix cpp and h depends
# \ is used to join lines in the recipe because each line would
# otherwise be a separate shell process and therefore F would
# not be accessible to GPP command.
%.o:
	@echo "Building: $@"
	$(eval F = $(patsubst $(BLDDIR)/%.o,$(SRCDIR)/%.cpp,$@))    \
	$(GPP) -I $(SYSROOT)/usr/include/xrt                          \
	       -I /opt/Xilinx/Vivado/2019.2/include                   \
	       -I $(SYSROOT)/usr/include -c -fmessage-length=0        \
	       -std=c++14 --sysroot=$(SYSROOT) -o $@ $(F)             \

#$(BLDDIR)/vadd.o: $(SRCDIR)/vadd.cpp
#	@echo "Building: $@"
#	$(GPP) -I $(SYSROOT)/usr/include/xrt                          \
#	       -I /opt/Xilinx/Vivado/2019.2/include                   \
#	       -I $(SYSROOT)/usr/include -c -fmessage-length=0        \
#	       -std=c++14 --sysroot=$(SYSROOT) -o $@ $(SRCDIR)/vadd.cpp \

host:  $(HOSTOBJS)
	@echo "Linking host"
	cd $(BLDDIR);                                                 \
	$(GPP) -o $(BLDDIR)/$@ $(BLDDIR)/vadd.o -lxilinxopencl        \
	-lpthread -lrt -lstdc++ -lgmp -lxrt_core                      \
	-L $(SYSROOT)/usr/lib --sysroot=$(SYSROOT)

hw_kernel:
	@echo "Building Kernel"
	cd $(BLDDIR);                                                 \
	$(VPP) -t hw --platform $(PLATFORM) -c -k krnl_vadd           \
	-I $(SRCDIR) -o $(BLDDIR)/vadd.hw.xo                          \
	$(SRCDIR)/krnl_vadd.cpp

	@echo "Linking Kernel"
	cd $(BLDDIR);                                                 \
	$(VPP) -t hw --platform $(PLATFORM)                           \
	--link $(BLDDIR)/vadd.hw.xo --save-temps                      \
	-o $(BLDDIR)/vadd.hw.xclbin                                   \
	--config $(SRCDIR)/design.cfg                                 \

# Need to add emconfig step
hw_emu_kernel:
	@echo "Building Kernel"
	cd $(BLDDIR);                                                 \
	$(VPP) -t hw_emu --platform $(PLATFORM) -c -k krnl_vadd       \
	-I $(SRCDIR) -o $(BLDDIR)/vadd.hw_emu.xo                      \
	$(SRCDIR)/krnl_vadd.cpp

	@echo "Linking Kernel"
	cd $(BLDDIR);                                                 \
	$(VPP) -t hw_emu --platform $(PLATFORM)                       \
	--link $(BLDDIR)/vadd.hw_emu.xo --save-temps                  \
	-o $(BLDDIR)/vadd.hw_emu.xclbin                               \
	--config $(SRCDIR)/design.cfg

emconfig:
	@echo "Building emconfig.json"
	cd $(BLDDIR);                                                 \
	emconfigutil --nd 1 --platform $(PLATFORM) --od $(BLDDIR)

# Need to add emconfig step
sw_emu_kernel: emconfig
	@echo "Building Kernel"
	cd $(BLDDIR);                                                 \
	$(VPP) -t sw_emu --platform $(PLATFORM) -c -k krnl_vadd       \
	-I $(SRCDIR) -o $(BLDDIR)/vadd.sw_emu.xo                      \
	$(SRCDIR)/krnl_vadd.cpp

	@echo "Linking Kernel"
	cd $(BLDDIR);                                                 \
	$(VPP) -t sw_emu --platform $(PLATFORM)                       \
	--link $(BLDDIR)/vadd.sw_emu.xo --save-temps                  \
	-o $(BLDDIR)/vadd.sw_emu.xclbin                               \
	--config $(SRCDIR)/design.cfg

# Taken from logs of running qemu on zcu102 edge platform
# Never boots, all CPU cores at 100%. Possibly an issue with image.ub
# and rootfs or just a very large rootfs, not sure
# zcu102 qemu uses ramdisk
#
# using the sd-card-image switch, and pointing to sd_card.img for a
# zcu102 app, it would boot fine. Getting closer.
#
# Changed sd_card.manifest to point to image.ub from zcu102_base
# edge platfrom as downloaded from Xilinx and that also worked
# looks like sd_card.img is dynamically generated when launch_emulator
# is run
#
# commended mmap in the vadd.cpp for led vio and added host to
# sd_card.manifest and was able to run on qemu!
#
# probably need to add xrt.ini to get debug data
#
# how to see xsim waveform?
run:
	cd $(BLDDIR);                                                 \
	launch_emulator -t sw_emu -runtime ocl                        \
	-device-family Ultrascale -pid-file emulation.pid -no-reboot  \
	-forward-port 1440 1534

.PHONY: clean
clean:
	rm -rf $(BLDDIR)
	mkdir -p $(BLDDIR)

#| # Compile sw_emu kernel - more work needed here to get to work - Qemu
#| # ags error during link
#| # ERROR: [v++ 60-929] The specified platform does not support Hardware Emulation (Qemu Arguments missing)
#| v++ -t sw_emu --platform ultra96v2_min2 -c -k krnl_vadd -I src/ -o vadd.sw_emu.xo ../src/krnl_vadd.cpp
