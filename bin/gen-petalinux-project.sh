#!/bin/bash
# Build a useable PetaLinux project which is then used to generate
# sdk.sh for a sysroot for Vitis

ME="gen-petalinux-project.sh"

echo "${ME}: Enter"

# Ensure that project settings have been sourced
if [ -z ${PROJ} ]
then
    echo
    echo "Please source project settings file bin/setup.sh before"
    echo "executing this script"
    echo "Exiting..."
    exit 1
fi

# Defined in setup.sh
p_delete_existing_dir_then_make ${G_PETALINUX_PROJECT_DIR}

# Create output dirs
mkdir -p ${G_PFM_DIR}
mkdir -p ${G_BOOT_DIR}
mkdir -p ${G_SYSROOTS_DIR}

# Generate new vitis project
cd ${G_PETALINUX_PROJECT_DIR}

# Create the base petalinux project based on Ultra96v2 BSP
petalinux-create -t project -n ${PROJ} -s ${G_PETALINUX_BSP_FILE}
cd ${PROJ}

# Pull in custom hardware
petalinux-config --get-hw-description=${G_PFM_DIR} --defconfig

# Disable 96boards-sensors due to build failures from bad dependency URL
p_disable_petalinux_rootfs_packages "packagegroup-petalinux-96boards-sensors"

# Setup PetaLinux to use SSTATE
p_enable_petalinux_sstate
petalinux-config --defconfig

# Fix device tree
cat ${PWS}/support/petalinux/zyxclmm_drm.dts_node >> \
    project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi

time petalinux-build

# Copy collateral to boot dir
p_copy_petalinux_collateral_to_boot_dir

# Copy linux.bif to boot dir
cp ${PWS}/support/petalinux/linux.bif \
   ${G_BOOT_DIR}

# Create the sdk.sh
time petalinux-build --sdk

# Extract the sysroot
petalinux-package --sysroot --dir ${G_BUILD_DIR}

echo "${ME}: Exit"
