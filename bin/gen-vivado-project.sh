#!/bin/bash
# Execute Vivado in batch mode to build the hardware project

ME="gen-vivado-project.sh"

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
p_delete_existing_dir_then_make ${G_VIVADO_PROJECT_DIR}

# Create output dirs needed by vivado project
mkdir -p ${G_PFM_DIR}

# Generate new vivado project
cd ${G_VIVADO_PROJECT_DIR}

# See bin/ultra96v2-accel-base-bd.tcl for details
#vivado -source ${PWS}/bin/ultra96v2-accel-base-bd.tcl
vivado -mode batch -source ${PWS}/bin/ultra96v2-accel-base-bd.tcl
#vivado -mode tcl -source ${PWS}/bin/ultra96v2-accel-base-bd.tcl

# Primitive attempt to determine whether design was sucessfully
# implemented. Look for the timing summary and grep for string
# "All user specified timing constraints are met."
RETVAL=0
RPT=$(find ${G_VIVADO_PROJECT_DIR} -name "*timing_summary_routed.rpt")
#echo "RPT: ${RPT}"
if [ -z "${RPT}" ]
then
    RETVAL=-2
    echo "${ME}: Vivado Implementation Failed"
else
    RETVAL=$(grep -c --max-count=1                                 \
		  "All user specified timing constraints are met." \
		  ${RPT})
fi

#echo "RETVAL: $RETVAL"
case ${RETVAL} in
    "1")
	echo "${ME}: Exit"
	exit 0
	;;

    "")
	exit 3
	;;

    *)
	exit 4
	;;

esac
