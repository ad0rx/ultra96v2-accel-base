.. sphinx-rtd-theme_example include code example
   this document content is included in-line in another reStructuredText document

.. toctree::
	:hidden:

This content is located in the file named ``code_example_peekpoke.rst``

H4: C/C++ Code (Whole File)
---------------------------

.. literalinclude:: code_examples/peekpoke/files/peek.c
	:language: c++
	:linenos:

H4: C/C++ Code (Function Only)
------------------------------

Emphasize the opening the file descriptor:

.. literalinclude:: code_examples/peekpoke/files/poke.c
	:caption: Highlight opening the file descriptor
	:language: c++
	:linenos:
	:lines: 45-75
	:emphasize-lines: 8

Show if statements

.. literalinclude:: code_examples/peekpoke/files/poke.c
	:caption: If Statements
	:language: c++
	:linenos:	
	:lines: 53-56,58-61,70-73