#############################################################################
##
#W  fplll.tst                 Float Package                 Laurent Bartholdi
##
#Y  Copyright (C) 2016,  Laurent Bartholdi
##
#############################################################################
##
##  This file tests the fplll library
##
#############################################################################

gap> START_TEST("fplll");
gap> FPLLLReducedBasis([[100,0,0],[0,100,0],[1,2,3]]);
[ [ 1, 2, 3 ], [ -14, 72, -42 ], [ 93, -14, -21 ] ]
gap> STOP_TEST( "fplll.tst", 3*10^8 );
fplll

#E fplll.tst . . . . . . . . . . . . . . . . . . . . . . . . . . . .ends here
