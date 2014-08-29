#############################################################################
##
#W init.g                                                   Laurent Bartholdi
##
#Y Copyright (C) 2008-2014, Laurent Bartholdi
##
#############################################################################
##
##  This file reads the declarations of the packages' new objects
##
#############################################################################

#############################################################################
##
#I Create info class to be able to debug loading
##
InfoFloat := NewInfoClass("InfoFloat");
SetInfoLevel(InfoFloat, 1);

#############################################################################
BindGlobal("DOC@FLOAT", function()
    MakeGAPDocDoc(Concatenation(GAPInfo.PackagesLoaded.float[1],"/doc"),"float",
            ["../lib/float.gd","../lib/pslq.gi","../PackageInfo.g"],"float");
    CopyHTMLStyleFiles("doc");
    GAPDocManualLab("Float");
end);

if GAPInfo.TermEncoding = "UTF-8" then
    BindGlobal("FLOAT_INFINITY_STRING","∞"); # UChar(8734)
    BindGlobal("FLOAT_NINFINITY_STRING","-∞"); # UChar(8734)
    BindGlobal("FLOAT_EMPTYSET_STRING","∅"); # UChar(8709)
    BindGlobal("FLOAT_REAL_STRING","ℝ"); # UChar(8477)
    BindGlobal("FLOAT_COMPLEX_STRING","ℂ"); # UChar(8450)
    BindGlobal("FLOAT_I_STRING","ⅈ"); # UChar(8520)
else
    BindGlobal("FLOAT_INFINITY_STRING","inf");
    BindGlobal("FLOAT_NINFINITY_STRING","-inf");
    BindGlobal("FLOAT_EMPTYSET_STRING","empty");
    BindGlobal("FLOAT_REAL_STRING","reals");
    BindGlobal("FLOAT_COMPLEX_STRING","complex");
    BindGlobal("FLOAT_I_STRING","i");
fi;

CallFuncList(function()
    local f;
    f := Filename(DirectoriesPackagePrograms("float"),"float.so");
    if f<>fail then
        LoadDynamicModule(f);
    fi;
end,[]);

#############################################################################
##
#R Read the declaration files.
##
ReadPackage("float", "lib/float.gd");

#############################################################################

#E init.g . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
