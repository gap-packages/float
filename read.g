#############################################################################
##
#W read.g                                                   Laurent Bartholdi
##
#Y Copyright (C) 2008, Laurent Bartholdi
##
#############################################################################
##
##  This file reads the implementations, and in principle could be reloaded
##  during a GAP session.
#############################################################################

#############################################################################
##
#R Read the install files.
##
ReadPackage("float", "lib/polynomial.gi");
ReadPackage("float", "lib/pslq.gi");

modules := [];
if IsBound(MPFR_INT) then
    Add(modules,"mpfr");
    ReadPackage("float", "lib/mpfr.gi");
fi;
if IsBound(MPFI_INT) then
    Add(modules,"mpfi");
    ReadPackage("float", "lib/mpfi.gi");
fi;
if IsBound(MPC_INT) then
    Add(modules,"mpc");
    ReadPackage("float", "lib/mpc.gi");
fi;
if IsBound(@FPLLL) then
    Add(modules,"fplll");
    ReadPackage("float", "lib/fplll.gi");
fi;
if IsBound(CXSC_INT) then
    Add(modules,"cxsc");
    ReadPackage("float", "lib/cxsc.gi");
fi;
Print("Loading modules [",JoinStringsWithSeparator(modules,", "),"] for ");

if IsBound(IO_Pickle) then
    ReadPackage("float","lib/pickle.g");
else
    if not IsBound(IO_PkgThingsToRead) then
        IO_PkgThingsToRead := [];
    fi;
    Add(IO_PkgThingsToRead, ["float","lib/pickle.g"]);
fi;
#############################################################################

#E read.g . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
