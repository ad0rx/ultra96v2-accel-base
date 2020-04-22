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

time petalinux-build

echo "${ME}: Exit"
