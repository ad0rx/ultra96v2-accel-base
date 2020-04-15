# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
# import os
# import sys
# sys.path.insert(0, os.path.abspath('.'))


# -- Project information -----------------------------------------------------

project = 'ultra96v2-accel-base'
copyright = '2020, Avnet'
author = 'Avnet'

# -- General configuration ---------------------------------------------------

# Add any Sphinx extenison module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
]

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = []


# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'sphinx_rtd_theme'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

# -- HTML Custom Style Sheets
html_css_files = [
        'css/avnet.css',
]

# -- HTML Theme Options ------------------------------------------------------
# -- https://sphinx-rtd-theme.readthedocs.io/en/stable/configuring.html#theme-options
# Note: Sphinx RTD Theme Only supports rendering up to 4 TOC levels
# - The spacing is off for levels 5, 6 and beyond.
# The following PR was submitted to add up to 10 level spacing:
# - https://github.com/readthedocs/sphinx_rtd_theme/pull/852
#
html_theme_options = {
    'logo_only': False,
    # Table of Contents Options
    'collapse_navigation': False,
    'sticky_navigation': True,
    'navigation_depth': 4,
    'includehidden': True,
    'titles_only': False
}

# -- Set Custom Logo for html_theme
html_logo = "_static/Avnet_logo_rgb.png"

# -- Turn off the Sphinx footer
html_show_sphinx = True

# -- Set Custom Extended Template Variables
html_context = {
        'second_logo': True,
        'second_logo_filename': "320px-Xilinx_logo_2008.svg.png",
        'footer_logo' : True,
        'footer_logo_filename': "Avnet_logo_tagline_rgb_300.png",
}
