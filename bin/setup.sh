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

#export PLATFORM_REPO_PATHS=${PWS}/petalinux-project/pfm/wksp2/ultra96v2_min2/export/ultra96v2_min2

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

# Functions

# Clear off the dirs stack
pa () {

    while popd -n &> /dev/null
    do
	popd -n &> /dev/null
    done

}

# Aliases
alias pws='cd ${PWS}'
alias cd='pushd'
alias pd='popd'
