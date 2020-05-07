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
HOSTSRCS := $(SRCDIR)/vadd.c
HOSTOBJS := $(patsubst $(SRCDIR)/%.c,$(BLDDIR)/%.o,$(HOSTSRCS))

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

# TODO fix cpp and h depends
# \ is used to join lines in the recipe because each line would
# otherwise be a separate shell process and therefore F would
# not be accessible to GPP command.
%.o:
	@echo "Building: $@"
	$(eval F = $(patsubst $(BLDDIR)/%.o,$(SRCDIR)/%.cpp,$@))    \
	$(GPP) -I $(SYSROOT)/usr/include/xrt                          \
	       -I /opt/Xilinx/Vivado/2019.2/include                   \
	       -I ${SYSROOT}/usr/include -c -fmessage-length=0        \
	       -std=c++14 --sysroot=$(SYSROOT) -o $@ $(F)             \

host:  $(HOSTOBJS)
#	@echo "host"
#	@echo "HOSTOBJS: $(HOSTOBJS)"
	cd $(BLDDIR)                                                  \
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
	--link $(BLDDIR)/vadd.hw.xo -o                                \
	$(BLDDIR)/vadd.hw.xclbin --config $(SRCDIR)/design.cfg

hw_emu_kernel:
	@echo "Not yet implemented"

sw_emu_kernel:
	@echo "Not yet implemented"

.PHONY: clean
clean:
	rm -rf $(BLDDIR)
	mkdir -p $(BLDDIR)

#| # Compile sw_emu kernel - more work needed here to get to work - Qemu
#| # ags error during link
#| # ERROR: [v++ 60-929] The specified platform does not support Hardware Emulation (Qemu Arguments missing)
#| v++ -t sw_emu --platform ultra96v2_min2 -c -k krnl_vadd -I src/ -o vadd.sw_emu.xo ../src/krnl_vadd.cpp