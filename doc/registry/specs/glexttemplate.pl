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
# $Date: 2005/01/10 12:52:03 $ $Revision: 1.8 $
# $Header: /oss/CVS/cvs/projects/ogl-sample/main/doc/registry/specs/glexttemplate.pl,v 1.8 2005/01/10 12:52:03 ljp Exp $

@options = (
	"procprefix=s",
	"ptrprefix=s",
	"catprefix=s",
	"callspec=s",
	"callspecptr=s",
	"declspec=s",
	"output=s",
	"protectproto=s",
	"formals",
	"future",
	"protect",
	"prototypes",
	"typedefs"
	);
require libspec;

##########################################################################

sub initialize {
    # these should be defined on the command line that invokes libspec
    $proc_prefix = $optionvars{"procprefix"};
    $ptr_prefix = $optionvars{"ptrprefix"};
    $cat_prefix = $optionvars{"catprefix"};
    $protect_proto = $optionvars{"protectproto"};
    $output = $optionvars{"output"};
    $formals = $optionvars{"formals"};
    $future = $optionvars{"future"};
    $protect = $optionvars{"protect"};
    $prototypes = $optionvars{"prototypes"};
    $typedefs = $optionvars{"typedefs"};
    $decl_spec = $optionvars{"declspec"};
    $call_spec = $optionvars{"callspec"};
    # This could (should) default to "$call_spec *" if not specified
    $call_spec_ptr = $optionvars{"callspecptr"};

    # Initialization for sanitizing function names:
    $MaxIDLen = 60;

    # Always print passthru lines; might be controlled by option later
    $passthru = 1;

    # Not inside any category initially
    $last_category = "";
}

# Called to start a new category.
# After flushing the previous category (if any), clears
#   the accumulators holding "passthru", "passend", prototype,
#   and typedef declarations.
sub newcategory {
    my($category) = @_;

    if ($last_category ne $category) {
	endcategory();

	$passthru_decls = "";
	$passend_decls = "";
	$prototype_decls = "";
	$typedef_decls = "";

	$last_category = $category;
    }
}

# Called to end a category.
# Prints out prototypes and typedefs.
sub endcategory {
    if ($last_category ne "") {
	if ($protect == 1) {
	    print "#ifndef " . $cat_prefix . $last_category . "\n";
	    print "#define " . $cat_prefix . $last_category . " 1\n";
	}

	if ($passthru && $passthru_decls ne "") {
	    print $passthru_decls;
	}
	if ($prototypes && $prototype_decls ne "" && $protect_proto ne "") {
	    print "#ifdef " . $protect_proto . "\n";
	    print $prototype_decls;
	    print "#endif /* " . $protect_proto . " */\n";
	}
	if ($typedefs) {
	    print $typedef_decls;
	}
	if ($passthru && $passend_decls ne "") {
	    print $passend_decls;
	}

	if ($protect == 1) {
	    print "#endif\n\n";
	}
    }
    $last_category = "";
}

# Accumulate "passthru:" lines if they're associated with a category,
# otherwise just print them.
sub passthru {
    my($data) = @_;

    if ($last_category ne "") {
	$passthru_decls .= $data . "\n";
    } else {
	print $data . "\n";
    }
}

# Accumulate "passend:" lines if they're associated with a category,
# otherwise just print them.
sub passend {
    my($data) = @_;

    if ($last_category ne "") {
	$passend_decls .= $data . "\n";
    } else {
	print $data . "\n";
    }
}

sub main {
    # Only include the following functions in glext.h: anything with
    # version 1.2, and anything whose category starts with a capital
    # letter (heuristic for identifying an extension). Later, we'll
    # add a new field to gl.spec.

    $category = substr($propList{"category"}, 1,
	length($propList{"category"})-1);

    if (defined $propList{"passthru"}) {
	$passthru = substr($propList{"passthru"}, 1,
	    length($propList{"passthru"})-1);
	print $passthru . "\n";
    }

    if (! defined $propListValues{"version","1.2"} &&
	! ($category =~ /^[A-Z]/) ) {
	return;
    }

    # Is the name distinguishable in its first MaxIDLen characters?
    $TruncatedName = substr($functionName, 0,
		$MaxIDLen - length($proc_prefix));
    if (defined $OriginalNames{$TruncatedName}) {
	if ($functionName ne $OriginalNames{$TruncatedName}) {
	    error( sprintf("the name %s is indistinguishable from %s",
			$functionName, $OriginalNames{$TruncatedName}) );
	}
    } else {
	$OriginalNames{$TruncatedName} = $functionName;
    }

    # Switch extension categories if needed
    if ($last_category ne $category) {
	newcategory($category);
    }

    # Generate function prototypes
    if ($prototypes) {
	# Lifted heavily from template.pl.
	# Print the function declaration.
	$func_decl = "";
	if ($decl_spec) {
	    $func_decl .= $decl_spec . " ";
	}
	$func_decl .= $returnType . " ";
	if ($call_spec) {
	    $func_decl .= $call_spec . " ";
	}
	$func_decl .= $proc_prefix . $functionName;
	$func_decl .= " (";

	if ($formals eq "yes") {
	    $func_decl .= makeCArglist();
	} else {
	    $func_decl .= makeCPrototype();
	}
	$func_decl .= ");\n";

	$prototype_decls .= $func_decl;
    }

    # Generate function pointer typedefs
    if ($typedefs) {
	$fnUpper = $functionName;
	$fnUpper =~ tr/[a-z]/[A-Z]/;
	$typedefname = $ptr_prefix . $fnUpper . "PROC";
	$type_decl = "typedef " . $returnType .
	    " (" . $call_spec_ptr . " " . $typedefname . ") ";

	if ($formals) {
	    $type_decl .= "(" . makeCArglist() . ");\n";
	} else {
	    $type_decl .= "(" . makeCPrototype() . ");\n";
	}

	$typedef_decls .= $type_decl;
    }
}

sub finalize {
    endcategory();
}
