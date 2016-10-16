LoadPackage("float");
SetInfoLevel(InfoFloat,1);
dirs := DirectoriesPackageLibrary("float","tst");

SetFloats(IEEE754FLOAT);
Test(Filename(dirs,"arithmetic.tst"),rec(compareFunction:="uptowhitespace"));
SetFloats(MPFR);
Test(Filename(dirs,"arithmetic.tst"),rec(compareFunction:="uptowhitespace"));
SetFloats(MPFI);
Test(Filename(dirs,"arithmetic.tst"),rec(compareFunction:="uptowhitespace"));
SetFloats(MPC);
Test(Filename(dirs,"arithmetic.tst"),rec(compareFunction:="uptowhitespace"));
field := MPC_PSEUDOFIELD;
Test(Filename(dirs,"polynomials.tst"),rec(compareFunction:="uptowhitespace"));
SetFloats(CXSC);
Test(Filename(dirs,"arithmetic.tst"),rec(compareFunction:="uptowhitespace"));
field := CXSC_PSEUDOFIELD;
Test(Filename(dirs,"polynomials.tst"),rec(compareFunction:="uptowhitespace"));

Test(Filename(dirs,"fplll.tst"),rec(compareFunction:="uptowhitespace"));
