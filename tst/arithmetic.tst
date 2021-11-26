#############################################################################
##
#W  arithmetic.tst              Float Package               Laurent Bartholdi
##
#Y  Copyright (C) 2011,  Laurent Bartholdi
##
#############################################################################
##
##  This file tests basic arithmetic
##
#############################################################################

gap> START_TEST("arithmetic");
gap> 
gap> x := 1.0;;
gap> IsFloat(x);
true
gap> IsOne(x);
true
gap> IsZero(x);
false
gap> y := 4*Atan(x);;
gap> IsFloat(y);
true
gap> y > 3.14 and y < 3.15;
true
gap> x+x = 2.0;
true
gap> x-x = 0.0;
true
gap> Sqrt(x) = 1.0;
true
gap> AbsoluteValue(Sin(y)) < 1.e-10;
true
gap> STOP_TEST( "arithmetic.tst", 3*10^8 );
