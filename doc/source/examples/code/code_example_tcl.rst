.. sphinx-rtd-theme_example include code example
   this document content is included in-line in another reStructuredText document

.. toctree::
	:hidden:

This content is located in the file named ``code_example_tcl.rst``

H4: TCL Script (Part of file)
-----------------------------

Note: Syntax highlighting works with comments ...

doesn't process TCL comments properly

.. literalinclude:: code_examples/tcl_scripts/bd.tcl
	:language: tcl
	:linenos:
	:lines: 1-31

Note: Syntax highlighting ```DOES NOT PROPERLY PROCESS``` variable expansion syntax within Xilinx TCL files
Example: ```${variable}``` causes the syntax highlighter to fail

Failure highlighting TCL syntax included from external file

.. literalinclude:: code_examples/tcl_scripts/bd.tcl
	:language: tcl
	:linenos:
	:lines: 66-73

Failure highlighting TCL syntax in simple code block

.. code-block:: tcl
	:linenos:

	if { ${variable} eq "" } {
	   set errMsg "Please set the variable <design_name> to a non-empty value."
	   set nRet 1
	}

Fixing the variable syntax is highlighted correctly

.. code-block:: tcl
	:linenos:

	if { $variable eq "" } {
	   set errMsg "Please set the variable <design_name> to a non-empty value."
	   set nRet 1
	}

H4: TCL Script (Highlighted Section)
------------------------------------

.. literalinclude:: code_examples/tcl_scripts/bd.tcl
	:caption: Highlight opening the file descriptor
	:language: tcl
	:linenos:
	:lines: 120-149
