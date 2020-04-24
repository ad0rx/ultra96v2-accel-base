# Source this file to setup the environment
# Need to be in the docker container before sourcing
# Container: xilinx-vitis:v2019.2
# docker exec da xterm&
# docker exec -it /bin/bash
# source /mnt/projects/avnet/2019.2/ultra96v2-accel-base/bin/setup.sh

# These are paths within the container
VITIS_SETTINGS=/opt/Xilinx/Vitis/2019.2/settings64.sh
PETALINUX_SETTINGS=/opt/Xilinx/petalinux/v2019.2/settings.sh
XRT=/opt/xilinx/xrt/setup.sh

# Set project level variables
export PROJ=ultra96v2-accel-base
export PWS=/mnt/projects/avnet/2019.2/${PROJ}
cd ${PWS}

# Globals used in project scripts
export G_BUILD_DIR=${PWS}/build
export G_VIVADO_PROJECT_DIR=${G_BUILD_DIR}/vivado-project
export G_PETALINUX_PROJECT_DIR=${G_BUILD_DIR}/petalinux-project
export G_VITIS_PLATFORM_PROJECT_DIR=${G_BUILD_DIR}/vitis-platform-project
export G_BOOT_DIR=${G_BUILD_DIR}/boot
export G_LINUX_BIF=${G_BUILD_DIR}/boot/linux.bif
export G_SYSROOTS_DIR=${G_BUILD_DIR}/sysroots/aarch64-xilinx-linux
export G_PETALINUX_BSP_FILE=/mnt/projects/no_bkup/avnet/bsps/ultra96v2_oob_2019_2.bsp
export G_VITIS_PROJECT_DIR=${G_BUILD_DIR}/vitis-project
export G_SSTATE_AARCH64_DIR=/mnt/projects/no_bkup/xilinx/downloads/sstate/sstate_aarch64_2019.2/aarch64
export G_PFM_DIR=${G_BUILD_DIR}/pfm
export G_XSA_FILE_NAME=${PROJ}.xsa

G_NUM_CPU_CORES=$(grep -m 1 'cpu cores' /proc/cpuinfo | awk '{print $4}')
export G_NUM_CPU_CORES

# Add project scripts to PATH
export PATH=${PWS}/bin:${PATH}

#export PLATFORM_REPO_PATHS=${PWS}/petalinux-project/pfm/wksp2/ultra96v2_min2/export/ultra96v2_min2

# Functions
function psource () {

    # If this is sourced within a docker container, then add tool
    # settings. Otherwise, skip
    if [ $(hostname) != "bubba" ]
    then

	# Source Vitis Settings, which include Vidado Settings
	source ${VITIS_SETTINGS}

	# Source PetaLinux Settings
	source ${PETALINUX_SETTINGS}

	# Source XRT Settings
	source ${XRT}

    fi
}


# Clear off the dirs stack
pa () {

    while popd -n &> /dev/null
    do
	popd -n &> /dev/null
    done

}

# Test if a directory exists, delete
p_delete_existing_dir_then_make () {

    # If the project directory exists, delete it
    if [ -d $1 ]
    then
	echo "${ME}: Deleting existing $1"
	rm -rf "$1"
    fi

    # Ensure the dir was deleted. Sometimes rm fails because a handle
    # is active on the dir
    if [ -d $1 ]
    then
	echo "${ME}: Unable to remove $1"
	echo "${ME}: Please manually delete"
	exit 1
    fi

    mkdir -p $1
}
export -f  p_delete_existing_dir_then_make

# Disable a package so that it is not built in PetaLinux project
# Disable multiple packages by calling with a space delimited string
# "pack pack1" for example
p_disable_petalinux_rootfs_packages () {

    cfg=${G_PETALINUX_PROJECT_DIR}/${PROJ}/project-spec/configs/rootfs_config

    for p in "${1}"
    do
	echo "${ME}: Disabling Rootfs Package: $p"
	sed -i "s/CONFIG_$p=y/# CONFIG_$p is not set/g" "${cfg}"
    done

}
export -f p_disable_petalinux_rootfs_packages

p_copy_petalinux_collateral_to_boot_dir () {

    files=(image.ub zynqmp_fsbl.elf pmufw.elf bl31.elf u-boot.elf)
    for f in ${files[@]}
    do
	#echo "f: $f"
	cp ${G_PETALINUX_PROJECT_DIR}/${PROJ}/images/linux/${f} \
	   ${G_BOOT_DIR}/
    done

}
export -f p_copy_petalinux_collateral_to_boot_dir

# End Functions ######################################################

# Aliases
alias pws='cd ${PWS}'
alias cd='pushd'
alias pd='popd'
