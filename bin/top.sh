#!/bin/bash

gen-vivado-project.sh
gen-petalinux-project.sh
gen-vitis-platform.sh
make host
make hw_kernel
