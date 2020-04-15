.. sphinx-rtd-theme_example table formatting examples

###########################
H1: Example Table Syntax
###########################

Table Format Options:
- https://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html#table-directives

****************
H2: Simple Table
****************
- https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html#simple-tables

========  ========  ========
Column 1  Column 2  Column 3
========  ========  ========
Item 1,1  Item 1,2  Item 1,3  
Item 2,1  Item 2,2  Item 2,3  
Item 3,1  Item 3,2  Item 3,3  
Item 4,1  Item 4,2  Item 4,3  
Item 5,1  Item 5,2  Item 5,3  
========  ========  ========

****************
H2: Grid Table
****************
- https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html#grid-tables

+----------+----------+----------+
| Column 1 | Column 2 | Column 3 |
+==========+==========+==========+
| Item 1,1 | Item 1,2 | Item 1,3 |
+----------+----------+----------+
| Item 2,1 | Item 2,2 | Item 2,3 |
+----------+----------+----------+
| Item 3,1 | Item 3,2 | Item 3,3 |
+----------+----------+----------+
| Item 4,1 | Item 4,2 | Item 4,3 |
+----------+----------+----------+
| Item 5,1 | Item 5,2 | Item 5,3 |
+----------+----------+----------+

****************
H2: CSV Table
****************

H3: CSV Table
==============

Subsection 1.1 Paragraph.
- https://docutils.sourceforge.io/docs/ref/rst/directives.html#csv-table

.. csv-table:: CSV Table Title
	:header: "Column 1", "Column 2", "Column 3"
	:widths: auto

	"Item 1,1", "Item 1,2", "Item 1,3"
	"Item 2,1", "Item 2,2", "Item 2,3"
	"Item 3,1", "Item 3,2", "Item 3,3"
	"Item 4,1", "Item 4,2", "Item 4,3"
	"Item 5,1", "Item 5,2", "Item 5,3"

H3: CSV Table (from File)
=========================
- https://docutils.sourceforge.io/docs/ref/rst/directives.html#csv-table

.. csv-table:: CSV Table Title
	:file: example_table.csv
	:header-rows: 1
	:widths: auto


****************
H2: List Table
****************
- https://docutils.sourceforge.io/docs/ref/rst/directives.html#list-table

.. list-table:: List Table Title
	:header-rows: 1
	:widths: auto

	* - Column 1
	  - Column 2
	  - Column 3
	* - Item 1,1
	  - Item 1,2
	  - Item 1,3
	* - Item 2,1
	  - Item 2,2
	  - Item 3,2
	* - Item 3,1
	  - Item 3,2
	  - Item 3,3
	* - Item 4,1
	  - Item 4,2
	  - Item 4,3
	* - Item 5,1
	  - Item 5,2
	  - Item 5,3
