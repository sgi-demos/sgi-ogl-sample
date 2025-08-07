#!gmake
#
# License Applicability. Except to the extent portions of this file are
# made subject to an alternative license as permitted in the SGI Free
# Software License B, Version 1.1 (the "License"), the contents of this
# file are subject only to the provisions of the License. You may not use
# this file except in compliance with the License. You may obtain a copy
# of the License at Silicon Graphics, Inc., attn: Legal Services, 1600
# Amphitheatre Parkway, Mountain View, CA 94043-1351, or at:
#
# http://oss.sgi.com/projects/FreeB
#
# Note that, as provided in the License, the Software is distributed on an
# "AS IS" basis, with ALL EXPRESS AND IMPLIED WARRANTIES AND CONDITIONS
# DISCLAIMED, INCLUDING, WITHOUT LIMITATION, ANY IMPLIED WARRANTIES AND
# CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A
# PARTICULAR PURPOSE, AND NON-INFRINGEMENT.
#
# Original Code. The Original Code is: OpenGL ES Reference Manual,
# Version 1.0, released September 2003, developed by Silicon Graphics,
# Inc.	The Original Code is Copyright (c) 2003 Silicon Graphics, Inc.
# Copyright in any portions created by third parties is as indicated
# elsewhere herein.  All Rights Reserved.
#
# $Date: 2003/10/08 06:06:17 $ $Revision: 1.1 $
# $Header: /oss/CVS/cvs/projects/ogl-sample/main/doc/gles/xml/GNUmakefile,v 1.1 2003/10/08 06:06:17 ljp Exp $

XSLT	= xsltproc
TEX	= pdflatex
LN	= ln
TAR	= tar
GZIP	= gzip

SOURCES = \
	$(wildcard gl*.xml) \
	$(wildcard egl*.xml) \
	$(NULL)

MAN_PAGES	= $(SOURCES:.xml=.3G)
HTML_FILES	= $(SOURCES:.xml=.html)
TEX_FILES	= reference.tex
PDF_FILES	= reference.pdf
TAR_FILE	= reference.tar
DIST_FILE	= reference.tar.gz

MAN_LINKS	= \
	glDisable.3G \
	glDisableClientState.3G \
	glPopMatrix.3G \
	$(NULL)

DOCBOOK2MAN	= ../xsl/docbook2man.xsl
DOCBOOK2HTML	= ../xsl/docbook2xhtml.xsl
DOCBOOK2TEX	= ../xsl/docbook2latex.xsl

.SUFFIXES: .xml .html .tex .pdf .3G .tar .tar.gz
.PHONY: man html pdf tex

default: all

all: man html pdf

man: $(MAN_PAGES) $(MAN_LINKS)
html: $(HTML_FILES)
tex: $(TEX_FILES)
pdf: $(PDF_FILES)
dist: $(DIST_FILE)

$(MAN_PAGES): $(DOCBOOK2MAN)
$(HTML_FILES): $(DOCBOOK2HTML)
$(TEX_FILES): $(DOCBOOK2TEX) $(SOURCES)
$(PDF_FILES): $(DOCBOOK2TEX)

glDisable.3G: glEnable.3G
	$(LN) -s glEnable.3G $@

glDisableClientState.3G: glEnableClientState.3G
	$(LN) -s glEnableClientState.3G $@

glPopMatrix.3G: glPushMatrix.3G
	$(LN) -s glPushMatrix.3G $@

reference.tex: legal-notice.xml license-full.xml

.xml.3G:
	$(XSLT) --xinclude -o $@ $(DOCBOOK2MAN) $<

.xml.html: $(DOCBOOK2HTML)
	$(XSLT) --xinclude -o $@ $(DOCBOOK2HTML) $<

.xml.tex:
	$(XSLT) --xinclude -o $@ $(DOCBOOK2TEX) $<

.tex.pdf:
	$(TEX) $<

$(TAR_FILE): all
	$(RM) html
	$(LN) -s . html
	$(TAR) cfv $@ html/*.html html/man.css
	$(TAR) rfv $@ man3/*.3G
	$(TAR) rfv $@ $(PDF_FILES)
	$(TAR) rfv $@ README
	$(RM) html

.tar.tar.gz:
	$(GZIP) $<

clean:
	$(RM) $(TEX_FILES)
	$(RM) *.log *.aux *.toc *.dvi *.out

clobber: clean
	$(RM) $(MAN_PAGES) $(MAN_LINKS)
	$(RM) $(HTML_FILES)
	$(RM) $(PDF_FILES)
	$(RM) $(DIST_FILE)
