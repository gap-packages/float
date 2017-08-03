LoadPackage("float");
SetInfoLevel(InfoFloat,1);
dirs := DirectoriesPackageLibrary("float","tst");

success := true;

# test machine floats
SetFloats(IEEE754FLOAT);
success := success and Test(Filename(dirs,"arithmetic.tst"));

if IsBound(MPFR_INT) then
    Print("#I  testing MPFR...\n");
    SetFloats(MPFR);
    success := success and Test(Filename(dirs,"arithmetic.tst"));
else
    Print("#I  WARNING: skipping tests for MPFR\n");
fi;

if IsBound(MPFI_INT) then
    Print("#I  testing MPFI...\n");
    SetFloats(MPFI);
    success := success and Test(Filename(dirs,"arithmetic.tst"));
else
    Print("#I  WARNING: skipping tests for MPFI\n");
fi;

if IsBound(MPC_INT) then
    Print("#I  testing MPC...\n");
    SetFloats(MPC);
    success := success and Test(Filename(dirs,"arithmetic.tst"));

    field := MPC_PSEUDOFIELD;
    success := success and Test(Filename(dirs,"polynomials.tst"));
else
    Print("#I  WARNING: skipping tests for MPC\n");
fi;

if IsBound(CXSC_INT) then
    Print("#I  testing CXSC...\n");
    SetFloats(CXSC);
    success := success and Test(Filename(dirs,"arithmetic.tst"));

    field := CXSC_PSEUDOFIELD;
    success := success and Test(Filename(dirs,"polynomials.tst"));
else
    Print("#I  WARNING: skipping tests for CXSC\n");
fi;

if IsBound(@FPLLL) then
    Print("#I  testing FPLLL...\n");
    success := success and Test(Filename(dirs,"fplll.tst"));
else
    Print("#I  WARNING: skipping tests for FPLLL\n");
fi;

# Report test results
if success then
    Print("#I  No errors detected while testing package float\n");
    QUIT_GAP(0);
else
    Print("#I  Errors detected while testing package float\n");
    QUIT_GAP(1);
fi;
