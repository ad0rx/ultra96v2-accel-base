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
export G_VITIS_PROJECT_DIR=${G_BUILD_DIR}/vitis-project
export G_PFM_DIR=${G_BUILD_DIR}/pfm
export G_XSA_FILE_NAME=${PROJ}.xsa

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
#declare -f p_delete_existing_dir
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

# End Functions ######################################################

# Aliases
alias pws='cd ${PWS}'
alias cd='pushd'
alias pd='popd'
