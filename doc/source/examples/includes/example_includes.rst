.. sphinx-rtd-theme_example include examples
   including external rst files and external code in a rst document

.. toctree::
	:hidden:

##############################
H1: Example Include Directives
##############################

**********************************
H2: Include reStructuredText Files
**********************************
- https://docutils.sourceforge.io/docs/ref/rst/directives.html#including-an-external-document-fragment

Include a complete reStructuredText File that defines additional subsections:

.. include:: rst_files/include_example_subsections.rst

**********************************
H2: Include raw Files
**********************************
- https://docutils.sourceforge.io/docs/ref/rst/directives.html#including-an-external-document-fragment

Include a the same reStructuredText File as above in raw mode to show (instead of interpret) the file contents

.. include:: rst_files/include_example_subsections.rst
	:literal:

**********************************
H2: Include Code
**********************************
- https://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html#code-examples
- https://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html#directive-code-block
- https://pygments.org/languages/

Include and highlight source code from an external file

H3: HTML Code
=============

Show HTML Code included from an external file

H4: HTML Code (Whole File)
--------------------------

.. literalinclude:: code_examples/index.html
	:language: html
	:linenos:
