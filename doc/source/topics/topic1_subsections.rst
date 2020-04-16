Environment
###########

| edit the bin/setup.sh script to suit
| source the bin/setup.sh script to configure environment
|  psource to source all tool settings
|  pa pop all dirs off directory stack
|  pws cd to project root directory


Vivado Project
##############

| bin/gen-vivado-project.sh
|  uses ultra96v2-accel-base-bd.tcl

| install board files
| VIO LEDs
| JTAG to AXI
| VIO PL Reset

| set_property pfm_name {vendor:boardid:name:rev} [current_project]
| see output of validate_platform -verbose to see fields
| or use list_property_value and list_property commands

| Needed to generate output products in OOC in order to get
| write_hw_platform command to complete sucessfully

| 'name' fields in the xsa appear to be set by the file name given for
| xsa file



PetaLinux Project
#################

| disable 96boards-sensors arduino-tools issue

| build sd card img file for rufus



Vitis Project
#############

| Install board files for u96


.. ****************
.. H2: Subsection 1
.. ****************
..
.. Subsection 1 Paragraph.
..
..
.. H3: Subsection 1.1
.. ==================
..
.. Subsection 1.1 Paragraph.
..
..
.. H4: Subsection 1.1.1
.. --------------------
..
.. Subsection 1.1.1 Paragraph.
..
..
.. H5: Subsection 1.1.1.1
.. ^^^^^^^^^^^^^^^^^^^^^^
..
.. Subsection 1.1.1.1 Paragraph.
..
..
.. H6: Subsection 1.1.1.1.1
.. """"""""""""""""""""""""""
..
.. Subsection 1.1.1.1.1 Paragraph.
..
..
.. ****************
.. H2: Subsection 2
.. ****************
..
.. Subsection 2 Paragraph.
..
..
.. ****************
.. H2: Subsection 3
.. ****************
..
.. Subsection 3 Paragraph.
..
..
.. H3: Subsection 3.1
.. ==================
..
.. Subsection 3.1 Paragraph.
..
..
.. H4: Subsection 3.1.1
.. --------------------
..
.. Subsection 3.1.1 Paragraph.
..
..
.. H5: Subsection 3.1.1.1
.. ^^^^^^^^^^^^^^^^^^^^^^
..
.. Subsection 3.1.1.1 Paragraph.
..
..
.. H6: Subsection 3.1.1.1.1
.. """"""""""""""""""""""""
..
.. Subsection 3.1.1.1.1 Paragraph.
..
..
.. H6: Subsection 3.1.1.1.2
.. """"""""""""""""""""""""
..
.. Subsection 3.1.1.1.2 Paragraph.
