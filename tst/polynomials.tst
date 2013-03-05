#############################################################################
##
#W  polynomials.tst              Float Package              Laurent Bartholdi
##
#Y  Copyright (C) 2013,  Laurent Bartholdi
##
#############################################################################
##
##  This file tests polynomials
##
#############################################################################

gap> START_TEST("polynomials");
gap> x := Indeterminate(field,"x");
x
gap> x+1;; x+1.0;; 1+x;; 1-x;; 1*x;; 1.0*x;; x*1.0;; x*x;
x^2
gap> Value(x^2+1,2)=5.0;
true
gap> roots := [0.1,0.1,0.1,0.5,0.6,0.7];;
gap> poly := Product(x-roots);;
gap> newroots := RootsFloat(poly);;
gap> Filtered([1..3],i->AbsoluteValue(roots[i]-newroots[i])>1.e-6);
[  ]
gap> Filtered([4..Length(roots)],i->AbsoluteValue(roots[i]-newroots[i])>1.e-14);
[  ]
gap> STOP_TEST( "polynomials.tst", 3*10^8 );
polynomials

#E polynomials.tst . . . . . . . . . . . . . . . . . . . . . . . . .ends here
