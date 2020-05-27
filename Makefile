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
ZCU102_SD_CARD_IMG := $(G_ZCU102_SD_CARD_IMG)

# Collateral
HOSTSRCS := $(SRCDIR)/vadd.cpp
HOSTOBJS := $(patsubst $(SRCDIR)/%.cpp,$(BLDDIR)/%.o,$(HOSTSRCS))

EMULATION_PID_FILE := $(BLDDIR)/emulation.pid
ifneq ("$(wildcard $(EMULATION_PID_FILE))","")
  EMULATION_PID := $(shell cat $(EMULATION_PID_FILE))
else
  EMULATION_PID := "NOTRUNNING"
endif

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
	@echo "*   run          : start sw emulation in qemu                         "
	@echo "*   stop         : stop emulator                                      "
	@echo "*                                                                     "
	@echo "*                                                                     "
	@echo "*                                                                     "
	@echo "**********************************************************************"
	@echo "SRCDIR  : $(SRCDIR)"
	@echo "BLDDIR  : $(BLDDIR)"
	@echo "SYSROOT : $(SYSROOT)"
	@echo "HOSTSRCS: $(HOSTSRCS)"
	@echo "HOSTOBJS: $(HOSTOBJS)"


# Project level targets
.PHONY: $(BLDDIR)
$(BLDDIR):
	mkdir -p $@

# TODO fix cpp and h depends
# \ is used to join lines in the recipe because each line would
# otherwise be a separate shell process and therefore F would
# not be accessible to GPP command.
$(BLDDIR)/vadd.o: $(SRCDIR)/vadd.cpp $(BLDDIR)
	@echo "Building: $@"
	$(eval F = $(patsubst $(BLDDIR)/%.o,$(SRCDIR)/%.cpp,$@))    \
	$(GPP) -I $(SYSROOT)/usr/include/xrt                          \
	       -I /opt/Xilinx/Vivado/2019.2/include                   \
	       -I $(SYSROOT)/usr/include -c -fmessage-length=0        \
	       -std=c++14 --sysroot=$(SYSROOT) -g -o $@ $(F)          \

$(BLDDIR)/vadd_x86.o: $(SRCDIR)/vadd.cpp $(BLDDIR)
	@echo "Building: $@"
	g++ -I $(XILINX_XRT)/include                                  \
	-I $(XILINX_VIVADO)/include                                   \
	-std=c++11 -c -g -o $@                                        \
	$(SRCDIR)/vadd.cpp

host:  $(HOSTOBJS)
	@echo "Linking host"
	cd $(BLDDIR);                                                 \
	$(GPP) -o $(BLDDIR)/$@ $(BLDDIR)/vadd.o -lxilinxopencl        \
	-lpthread -lrt -lstdc++ -lgmp -lxrt_core -g                   \
	-L $(SYSROOT)/usr/lib --sysroot=$(SYSROOT)

host_x86:  $(BLDDIR)/vadd_x86.o
	@echo "Linking host"
	cd $(BLDDIR);                                                 \
	g++ -o $(BLDDIR)/$@ $(BLDDIR)/vadd_x86.o -lOpenCL             \
	-lpthread -lrt -lstdc++ -g                                    \
	-L $(XILINX_XRT)/lib


hw_kernel: $(BLDDIR)
	@echo "Building Kernel"
	cd $(BLDDIR);                                                 \
	$(VPP) -t hw --platform $(PLATFORM) -c -k krnl_vadd           \
	-I $(SRCDIR) -o $(BLDDIR)/vadd.hw.xo                          \
	$(SRCDIR)/krnl_vadd.cpp -g

	@echo "Linking Kernel"
	cd $(BLDDIR);                                                 \
	$(VPP) -t hw --platform $(PLATFORM)                           \
	--link $(BLDDIR)/vadd.hw.xo --save-temps                      \
	-o $(BLDDIR)/vadd.hw.xclbin -g                                \
	--config $(SRCDIR)/design.cfg                                 \

# Currently fails when launching Qemu do to missing symbol
# remoteport_tlm in libdpi.so
# could be LD_LIBRARY_PATH issue
hw_emu_kernel: emconfig $(BLDDIR)
	@echo "Building Kernel"
	cd $(BLDDIR);                                                 \
	$(VPP) -t hw_emu --platform $(PLATFORM) -c -k krnl_vadd       \
	-I $(SRCDIR) -o $(BLDDIR)/vadd.hw_emu.xo                      \
	$(SRCDIR)/krnl_vadd.cpp -g

	@echo "Linking Kernel"
	cd $(BLDDIR);                                                 \
	$(VPP) -t hw_emu --platform $(PLATFORM)                       \
	--link $(BLDDIR)/vadd.hw_emu.xo --save-temps                  \
	-o $(BLDDIR)/vadd.hw_emu.xclbin -g                            \
	--config $(SRCDIR)/design.cfg

emconfig: $(BLDDIR)
	@echo "Building emconfig.json"
	cd $(BLDDIR);                                                 \
	emconfigutil --nd 1 --platform $(PLATFORM) --od $(BLDDIR)

sw_emu_kernel: emconfig $(BLDDIR)
	@echo "Building Kernel"
	cd $(BLDDIR);                                                 \
	$(VPP) -t sw_emu --platform $(PLATFORM) -c -k krnl_vadd       \
	-I $(SRCDIR) -o $(BLDDIR)/vadd.sw_emu.xo -g                   \
	$(SRCDIR)/krnl_vadd.cpp

	@echo "Linking Kernel"
	cd $(BLDDIR);                                                 \
	$(VPP) -t sw_emu --platform $(PLATFORM)                       \
	--link $(BLDDIR)/vadd.sw_emu.xo --save-temps                  \
	-o $(BLDDIR)/vadd.sw_emu.xclbin -g                            \
	--config $(SRCDIR)/design.cfg

# Need to add image.ub from zcu102 edge platform to sd_card.manifest
# launch_emulator -kill $(cat emulation.pid) -t ultrascale
#
# automate the copy of $PWS/support/sd_card.manifest to _vimage/emulation/
# then dynamically generate sd_card.manifest
run:
	cp $(PWS)/support/qemu/sd_card.manifest                       \
	   $(BLDDIR)/_vimage/emulation/
	cp $(PWS)/support/qemu/xrt.ini.sw_emu                         \
	   $(BLDDIR)/xrt.ini
	cd $(BLDDIR);                                                 \
	launch_emulator -t sw_emu -runtime ocl                        \
	-device-family Ultrascale -pid-file $(EMULATION_PID_FILE)     \
	-no-reboot -forward-port 1440 1534

stop:
	cd $(BLDDIR);                                                 \
	launch_emulator -t ultrascale -kill $(EMULATION_PID)
	rm -rf $(EMULATION_PID_FILE)

.PHONY: clean
clean:
	rm -rf $(BLDDIR)
