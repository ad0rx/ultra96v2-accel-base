.. sphinx-rtd-theme_example code block and syntax highlighting
   including external rst files and external code in a rst document

.. toctree::
	:hidden:

###################################
H1: Example Code Block Highlighting
###################################

**********************************
H2: Include Code
**********************************
- https://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html#code-examples
- https://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html#directive-code-block
- https://pygments.org/languages/
- https://pygments.org/docs/lexers/

Include and highlight source code from an external file

H3: HTML Code
=============

Show HTML Code

H4: HTML Code (Partial File)
----------------------------
Show part of an HTML file

- Display lines 1-4, 21-25
- Note:  Line numbering doesn't reflect actual line numbers in the file when selectively showing file content

.. literalinclude:: code_examples/index.html
	:language: html
	:linenos:
	:lines: 1-4, 21-25

H4: HTML Code + JINJA Template (Partial File)
---------------------------------------------
Show part of an HTML file with JINJA template syntax

- Display lines 1-27
- Note: Emphasis is relative to the displayed lines from the file

.. literalinclude:: code_examples/layout.html
	:language: html+jinja
	:linenos:
	:emphasize-lines: 9
	:lines: 1-27

H3: C/C++ Code
==============
Show C/C++ syntax highlights from an external reStructuredText document containing C/C++ code file references

- https://docutils.sourceforge.io/docs/ref/rst/directives.html#including-an-external-document-fragment

Include a complete reStructuredText File that defines additional subsections:

.. include:: code_example_peekpoke.rst

H3: TCL Scripts
===============
Show TCL code syntax highlights from an external reStructured text document containing TCL script file references

- https://docutils.sourceforge.io/docs/ref/rst/directives.html#including-an-external-document-fragment

Include a complete reStructuredText File that defines additional subsections:

.. include:: code_example_tcl.rst