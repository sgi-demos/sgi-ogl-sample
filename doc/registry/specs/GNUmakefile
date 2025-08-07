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
# Original Code. The Original Code is: OpenGL Sample Implementation,
# Version 1.2.1, released January 26, 2000, developed by Silicon Graphics,
# Inc. The Original Code is Copyright (c) 1991-2004 Silicon Graphics, Inc.
# Copyright in any portions created by third parties is as indicated
# elsewhere herein. All Rights Reserved.
#
# Additional Notice Provisions: This software was created using the
# OpenGL(R) version 1.2.1 Sample Implementation published by SGI, but has
# not been independently verified as being compliant with the OpenGL(R)
# version 1.2.1 Specification.
#
# $Date: 2005/01/10 12:52:03 $ $Revision: 1.9 $
# $Header: /oss/CVS/cvs/projects/ogl-sample/main/doc/registry/specs/GNUmakefile,v 1.9 2005/01/10 12:52:03 ljp Exp $

COMMONPREF = standard
include $(ROOT)/usr/include/make/commondefs

# Where to place oss.sgi.com web pages
WEBDIR		= $(ROOT)/web

TARGETS		= glext.h glxext.h wglext.h
LDIRT		= *enums*.tmp *funcs*.tmp *ext.h

default headers: $(TARGETS)

headers_install install: default
	$(INSTALL) -F $(INCLUDE_LOCATION)/GL $(TARGETS)
	$(INSTALL) -F $(WEBDIR)/ogl-sample/ABI $(TARGETS)

libs libs_install apps:

distsi: default
	$(MAKE) $(COMMONPREF)$@

distoss:
	$(MAKE) $(COMMONPREF)$@

include $(ROOT)/usr/include/libspec/libspecdefs

# Override libspecdefs until tools directory entirely converted to Perl
LIBSPEC = $(PERL) -I$(TOPDIR)/tools/libspec

# Generator scripts
GLEXTGEN = glext.pl
TEMPLATEGEN = glexttemplate.pl
# Should collapse together with $(TOPDIR)/gfx/include/gl/template/enum.pl
ENUMGEN  = glextenum.pl

# Flags controlling generation of extension headers
# -protect puts #ifdef/#endif around enums and typedefs (default)
# -prototypes generates C prototypes
# -typedefs generates C function typedefs
PROTECT     = -protect
PROTOTYPES  = -prototypes
TYPEDEFS    = -typedefs
EXTFLAGS    = $(PROTECT) $(PROTOTYPES) $(TYPEDEFS)

# Typemaps for GL, GLX, and WGL (could be collapsed)
# Was $(TYPEMAPSDIR)/$(C_TYPEMAP), but that introduces nasty dependencies
GLTYPEMAP = gl.tm
GLXTYPEMAP = glx.tm
WGLTYPEMAP = wgl.tm

# For testing purposes only
# dropped -protect -typedefs
specfuncs: test.spec $(GLTYPEMAP) $(TEMPLATEGEN)
	$(LIBSPEC) $(TEMPLATEGEN) \
	    -prototypes \
	    -typemap $(GLTYPEMAP) -spec test.spec \
	    -formals -procprefix gl -ptrprefix PFNGL \
	    -protectproto GL_GLEXT_PROTOTYPES \
	    -catprefix GL_ > $@

# -declspec GLAPI -callspec APIENTRY

# GL extension enums/prototypes

glenums.tmp: $(ENUMGEN) enumext.spec
	$(PERL) $(ENUMGEN) $(PROTECT) -enumprefix GL_ -maskprefix GL_ \
	    -defineprefix GL_ enumext.spec > $@

glfuncs.tmp: gl.spec $(GLTYPEMAP) $(TEMPLATEGEN)
	$(LIBSPEC) $(TEMPLATEGEN) $(EXTFLAGS) \
	    -typemap $(GLTYPEMAP) -spec gl.spec -callspec APIENTRY \
	    -callspecptr APIENTRYP \
	    -formals -procprefix gl -ptrprefix PFNGL \
	    -protectproto GL_GLEXT_PROTOTYPES \
	    -declspec GLAPI -catprefix GL_ > $@

glext.h: glenums.tmp glfuncs.tmp $(GLEXTGEN)
	$(PERL) $(GLEXTGEN) -copyright $(OSSCOPYRIGHT) \
	    -protect __glext_h_ \
	    -file1 glenums.tmp -file2 glfuncs.tmp > $@

# GLX extension enums/prototypes

glxenums.tmp: $(ENUMGEN) glxenumext.spec
	$(PERL) $(ENUMGEN) $(PROTECT) -enumprefix GLX_ -maskprefix GLX_ \
	    -defineprefix GLX_ glxenumext.spec > $@

glxfuncs.tmp: glxext.spec $(GLXTYPEMAP) $(TEMPLATEGEN)
	$(LIBSPEC) $(TEMPLATEGEN) $(EXTFLAGS) \
	    -typemap $(GLXTYPEMAP) -spec glxext.spec \
	    -formals -procprefix glX -ptrprefix PFNGLX \
	    -callspecptr " *" \
	    -protectproto GLX_GLXEXT_PROTOTYPES \
	    -declspec extern -catprefix GLX_ > $@

glxext.h: glxenums.tmp glxfuncs.tmp $(GLEXTGEN)
	$(PERL) $(GLEXTGEN) -copyright $(OSSCOPYRIGHT) \
	    -protect __glxext_h_ \
	    -file1 glxenums.tmp -file2 glxfuncs.tmp > $@

# WGL extension enums/prototypes
# No enumprefix/maskprefix/defineprefix is specified, since
#   the WGL prefix is imbedded in the specfiles. A passthru
#   mechanism could be added to the enum specfiles to allow
#   the exceptional cases (ERROR_ codes not prefixed by WGL).
wglenums.tmp: $(ENUMGEN) wglenumext.spec
	$(PERL) $(ENUMGEN) $(PROTECT) wglenumext.spec > $@

wglfuncs.tmp: wglext.spec $(WGLTYPEMAP) $(TEMPLATEGEN)
	$(LIBSPEC) $(TEMPLATEGEN) $(EXTFLAGS) \
	    -typemap $(WGLTYPEMAP) -spec wglext.spec -callspec WINAPI \
	    -callspecptr "WINAPI *" \
	    -formals -procprefix wgl -ptrprefix PFNWGL \
	    -protectproto WGL_WGLEXT_PROTOTYPES \
	    -declspec extern -catprefix WGL_ > $@

wglext.h: wglenums.tmp wglfuncs.tmp $(GLEXTGEN)
	$(PERL) $(GLEXTGEN) -copyright $(OSSCOPYRIGHT) \
	    -protect __wglext_h_ \
	    -file1 wglenums.tmp -file2 wglfuncs.tmp > $@

# EGL enums/prototypes for egl.h (not for eglext.h)

eglenums.tmp: $(ENUMGEN) eglenum.spec
	$(PERL) $(ENUMGEN) -enumprefix EGL_ -maskprefix EGL_ \
	    -defineprefix EGL_ eglenum.spec > $@

eglfuncs.tmp: eglext.spec $(EGLTYPEMAP) $(TEMPLATEGEN)
	$(LIBSPEC) $(TEMPLATEGEN) \
	    -typemap $(EGLTYPEMAP) -spec eglext.spec \
	    -formals -procprefix glX -ptrprefix PFNEGL \
	    -protectproto EGL_EGLEXT_PROTOTYPES \
	    -declspec extern -catprefix EGL_ > $@

eglext.h: eglenums.tmp eglfuncs.tmp $(GLEXTGEN)
	$(PERL) $(GLEXTGEN) -copyright $(OSSCOPYRIGHT) \
	    -protect __eglext_h_ \
	    -file1 eglenums.tmp -file2 eglfuncs.tmp > $@

#

always:

$(COMMONTARGS): % : $(COMMONPREF)%

include $(COMMONRULES)
