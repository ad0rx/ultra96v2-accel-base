# To debug Makefile:
# make <target> --debug --just-print

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

XTERM_PID_FILE := $(BLDDIR)/xterm.pid
ifneq ("$(wildcard $(XTERM_PID_FILE))","")
  XTERM_PID := $(shell cat $(XTERM_PID_FILE))
else
  XTERM_PID := "NOTRUNNING"
endif

DEPLOY_TIMESTAMP_FILE := $(BLDDIR)/deploy.timestamp
ifneq ("$(wildcard $(DEPLOY_TIMESTAMP_FILE))","")
  DEPLOY_TIMESTAMP := $(shell cat $(DEPLOY_TIMESTAMP_FILE))
else
  DEPLOY_TIMESTAMP := "UNAVAILABLE"
endif

.PHONY : help
help :
	@clear
	@echo "**********************************************************************"
	@echo "* Targets:                                                            "
	@echo "*   host         : the host application                               "
	@echo "*   hw_kernel    : hardware kernels                                   "
	@echo "*   hw_emu_kernel: hw_emu kernels (not working)                       "
	@echo "*   clean        : you know what this does                            "
	@echo "*   run_sw_emu   : start sw emulation in qemu                         "
	@echo "*   stop_emu     : stop emulator                                      "
	@echo "*   run_hw       : run app on hardware                                "
	@echo "*   deploy       : copy host and xclbin to target                     "
	@echo "*   stop_hw      : kill the xterm session for debugging, gdbserver    "
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
$(BLDDIR)/vadd.o: $(SRCDIR)/vadd.cpp $(SRCDIR)/vadd.h
	@echo "Building: $@"
	mkdir -p $(BLDDIR)
	$(eval F = $(patsubst $(BLDDIR)/%.o,$(SRCDIR)/%.cpp,$@))    \
	$(GPP) -I $(SYSROOT)/usr/include/xrt                          \
	       -I /opt/Xilinx/Vivado/2019.2/include                   \
	       -I $(SYSROOT)/usr/include -c -fmessage-length=0        \
	       -std=c++14 --sysroot=$(SYSROOT) -g -o $@ $(F)          \

$(BLDDIR)/host:  $(HOSTOBJS)
	@echo "Linking host"
	mkdir -p $(BLDDIR)
	cd $(BLDDIR);                                                 \
	$(GPP) -o $@ $(BLDDIR)/vadd.o -lxilinxopencl                  \
	-lpthread -lrt -lstdc++ -lgmp -lxrt_core -g                   \
	-L $(SYSROOT)/usr/lib --sysroot=$(SYSROOT)

hw_kernel:
	@echo "Building Kernel"
	mkdir -p $(BLDDIR)
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
hw_emu_kernel: $(BLDDIR)/emconfig.json
	@echo "Building Kernel"
	mkdir -p $(BLDDIR)
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

$(BLDDIR)/emconfig.json:
	@echo "Building emconfig.json"
	mkdir -p $(BLDDIR)
	cd $(BLDDIR);                                                 \
	emconfigutil --nd 1 --platform $(PLATFORM) --od $(BLDDIR)

$(BLDDIR)/vadd.sw_emu.xclbin: $(BLDDIR)/emconfig.json
	@echo "Building Kernel"
	mkdir -p $(BLDDIR)
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
run_sw_emu: $(BLDDIR)/vadd.sw_emu.xclbin $(BLDDIR)/host
	cp $(PWS)/support/qemu/sd_card.manifest                       \
	   $(BLDDIR)/_vimage/emulation/
	cp $(PWS)/support/qemu/xrt.ini.sw_emu                         \
	   $(BLDDIR)/xrt.ini
	cd $(BLDDIR);                                                 \
	launch_emulator -t sw_emu -runtime ocl                        \
	-device-family Ultrascale -pid-file $(EMULATION_PID_FILE)     \
	-no-reboot -forward-port 1440 1534

stop_emu:
	cd $(BLDDIR);                                                 \
	launch_emulator -t ultrascale -kill $(EMULATION_PID)
	rm -rf $(EMULATION_PID_FILE)

# Download the newest build of host app and xclbin to target
# start gdbserver on target
# start gdb client on dev host and connect to the target
# todo
# xrt.ini
# ssh-keygen
# ssh-copy-id
.PHONY: deploy
deploy: $(DEPLOY_TIMESTAMP_FILE)
$(DEPLOY_TIMESTAMP_FILE): $(BLDDIR)/host $(BLDDIR)/vadd.hw.xclbin
	scp $(BLDDIR)/vadd.hw.xclbin $(BLDDIR)/host root@192.168.0.73:/mnt
	touch $(DEPLOY_TIMESTAMP_FILE)

# Start a xterm session in a separate window and in that window, ssh into the target
# and start the gdbserver
$(XTERM_PID_FILE):
	xterm -e /bin/bash -l -c 'ssh root@192.168.0.73 -t gdbserver --multi :2000' & \
	echo $$! > $(BLDDIR)/xterm.pid

.PHONY: run_hw
run_hw: $(XTERM_PID_FILE) $(DEPLOY_TIMESTAMP_FILE)
	aarch64-linux-gnu-gdb -x $(PWS)/support/gdb/debug-settings.gdb $(BLDDIR)/host

# The '-' means ignore exit status of kill command because
# we want to delete the pid file in every case
.PHONY: stop_hw
stop_hw:
	- kill $(XTERM_PID)
	rm -rf $(XTERM_PID_FILE)

.PHONY: clean
clean:
	rm -rf $(BLDDIR)
