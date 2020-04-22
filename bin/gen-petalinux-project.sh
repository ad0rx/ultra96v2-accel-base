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
#p_delete_existing_dir_then_make ${G_VITIS_PLATFORM_PROJECT_DIR}

# Create output dirs
#mkdir -p ${G_PFM_DIR}
#mkdir -p ${G_BOOT_DIR}
#mkdir -p ${G_SYSROOTS_DIR}

# Generate new vitis project
#cd ${G_VITIS_PLATFORM_PROJECT_DIR}

# See bin/ultra96v2-accel-base-bd.tcl for details
#xsct ${PWS}/bin/vitis-platform.tcl
#xsct -interactive ${PWS}/bin/vitis-platform.tcl

echo "${ME}: Exit"
