A short overview how to use INTLAB (see also file FAQ):
=======================================================


The easiest way to start is create a file startup.m (or to replace the content 
of the existing one) in the Matlab path \toolbox\local by

   cd ... insert the INTLAB path ...
   startintlab

Then the startintlab.m file is started and should do the rest. For
some user-specific options you may adjust the file startintlab.m  .

INTLAB is successfully tested under Matlab versions
   5.3,  6.0.0, 6.5.0, 6.5.1, 7.0, 7.0.1 (SP1), 7.0.4 (SP2), 7.1 (SP3), 
   7.2 (R2006a), 7.3 (R2006b), 7.4 (R2007a).
The Matlab version 7.0.4 (R14) Service Pack 2, however, is not very 
stable, sometimes a segmentation violation may occur.
There are some problems in Matlab version 7.2 (R2006a). For example,
const*sparse for larger dimension can be slow:
>> n=1e4, a=sparse([],[],[],n,n), tic,b=2*a,toc, tic,c=a/2,toc
n =
       10000
a =
   All zero sparse: 10000-by-10000
b =
   All zero sparse: 10000-by-10000
Elapsed time is 3.101008 seconds.
c =
   All zero sparse: 10000-by-10000
Elapsed time is 0.000131 seconds.
>> 
or, still in Matlab version 7.2 (R2006a) under Windows XP, 
>> m=1e6, n=1e4, I=100, J=300, A=sparse(I,J,NaN,m,n), sqrt(-1)*A
the last multiplication produces an infinite loop.

For Matlab Version 5.3 and higher on PCs and Windows, INTLAB is
entirely written in Matlab. There is no system dependency. This is because 
the Mathworks company was so kind to add into the routine "system_dependent"
a possibility to change the rounding mode (my dear thanks to Cleve).

For other platforms or Matlab Version 5.3-, INTLAB is written
entirely in Matlab language except one routine

   setround

for switching rounding mode. A corresponding C-routine together with a
dll-file is in directory \setround. This routine is the only portability
constraint (see also function "setround").

The file setround.dll is put in a separate path "setround". If rounding
does not work properly, this path is removed. So INTLAB should detect automatically
whether a rounding routine is necessary. If not, for some reason, 

===>  and you are using Matlab Version 5.3+ on a PC under Windows, **delete**
===>  the file "setround.dll" .

===>  Prerequisite for INTLAB is the possibility to switch the processor
===>  permanently into a specific rounding mode "downwards", "upwards" and
===>  "to nearest". This is always checked when starting INTLAB under Matlab.
===>  If the check fails, INTLAB will be terminated not to produce incorrect results!

The progress in the different INTLAB versions can be viewed using help, for example

   help Version5_3

Note that '_' is used rather than a dot, otherwise the help function does not work.

INTLAB supports

     - interval scalars, vectors and matrices, real and complex,
     - full and sparse matrices,
     - interval standard functions, real and complex,
     - and a number of toolboxes for intervals, gradients, hessians, slopes,
         polynomials, multi-precision arithmetic and more.

There are some demo-routines to get acquainted with INTLAB such as

   demointlab
   demointval
   demogradient
   demohessian
   demoslope
   demopolynom
   demolong

Call "demos" and access the INTLAB-demos. 

INTLAB results are verified to be correct including I/O and standard
functions. Interval input is rigorous when using string constants, see

   help intval               .

Interval output is always rigorous. For details, try e.g.

   "help intval\display"  and  "demointval".

You may switch your display permanently to infimum/supremum notation,
or midpoint/radius, or display using "_" for uncertainties; see
"help intvalinit" for more information. For example

   format long, x = midrad(pi,1e-14);
   infsup(x)
   midrad(x)
   disp_(x)

produces

   intval x =
   [   3.14159265358978,   3.14159265358981]
   intval x =
   <   3.14159265358979,  0.00000000000002>
   intval x =
      3.1415926535898_

Display with uncertainties represents the interval produces by subtracting
and adding 1 from and to the last displayed digit of the mantissa. Note that
the output is written in a way that "what you see is correct". For example,

   midrad(4.99993,0.0004)

produces

   intval ans = 
   <    4.9999,   0.0005> 

in "format short" and mid-rad representation. Due to non-representable real numbers
this is about the best what can be done with four decimal places after the decimal point.

A possible trap is for example

>> Z=[1,2]+i*[-1,1]
Z =
  1.0000 - 1.0000i   2.0000 + 1.0000i

The brackets in the definition of Z might lead to the conclusion that Z is a 
complex interval (rectangle) with lower left endpoint 1-i and upper right 
endpoint 2+i. This is not the case. The above statement is a standard Matlab
statement defining a (row) vector of length 2. It cannot be an interval:
Otherwise Z would be preceded in the output by "intval".

Standard functions are rigorous. This includes trigonometric functions
with large argument. For example,

   x=2^500; sin(x), sin(intval(x))

produces

   ans =
       3.273390607896142e+150
   intval ans =
      0.42925739234243

the latter being correct to the last digit. For real interval input
causing an exception for a real standard function, one may switch between
changing to complex standard functions with or without warning or, to
stay with real standard functions causing NaN result. For example,

   intvalinit('DisplayMidRad')
   intvalinit('RealStdFctsExcptnAuto'), sqrt(infsup(-3,-2))

produces

   ===> Complex interval stdfct used automatically for real interval input
            out of range (without warning)
   intval ans =
   <   0.0000 +  1.5811i,  0.1670>

whereas

   intvalinit('RealStdFctsExcptnWarn'), sqrt(infsup(-3,-2))

produces

   ===> Complex interval stdfct used automatically for real interval input
            out of range, but with warning

   Warning: SQRT: Real interval input out of range changed to be complex
   > In c:\matlab_v5.1\toolbox\intlab\intval\@intval\sqrt.m at line 81
   intval ans =
   <   0.0000 +  1.5811i,  0.1670>

and

   intvalinit('RealStdFctsExcptnNaN'), sqrt(infsup(-3,-2))

gives

   ===> Result NaN for real interval input out of range
   intval ans =
   <       NaN,      NaN>

All functions support vector and matrix input to minimize interpretation
overhead. Pure floating point standard functions (not rigorous) are still
faster; therefore those are still in INTLAB (for details, see help
intvalinit).

Sometimes it is useful to ignore input data out of range. This is possible
using

   intvalinit('RealStdFctsExcptnIgnore'), sqrt(infsup(-3,4))

which gives

   ===> !!! Caution: Input arguments out of range are ignored !!!
   ===> !!! Use intvalinit('RealStdFctsExcptnOccurred') to check whether this happened !!! 
   ===> !!! Using Brouwer's Fixed Point Theorem may yield erroneous results !!!
   intval ans = 
   [    0.0000,    2.0000] 

Using Brouwer's Fixed Point Theorem by checking f(X) in X is only possible if 
the interval vector X is completely in the range of definition of f. Consider

   f = inline('sqrt(x)-2');  X = infsup(-3,4);  Y = f(X)

which produces

   intval Y = 
   [   -2.0000,    0.0000] 

Obviousy, Y is contained in X, but f has no real fixed point at all. You may
check whether an input out of range occurred by

   NotDefined = intvalinit('RealStdFctsExcptnOccurred')

which gives

   NotDefined =
        1

Checking the flag 'RealStdFctsExcptnOccurred' resets it to zero.

Certain data necessary for rigorous input/output and for rigorous standard
functions are stored in files power10tobinaryVVV.mat and stdfctsdataVVV.mat,
where VVV stands for Matlab version number. Those files must be in the
search path of Matlab. They are generated automatically when starting the
system the first time. Generation of the first is fast, the second file
needs some 10 minutes on a 750 Mhz PC. 

The documentation is included in every routine. INTLAB-code, i.e.
Matlab-code, is (hopefully) self-explaining. INTLAB stays to the
philosophy to implement everything in Matlab.

To start under Windows:
   -  create new directory     c:\matlab\toolbox\intlab
      and copy INTLAB and subdirectories into it;
   -  adapt your STARTINTLAB file according to the included sample;
   -  add a call of startintlab to your startup file.

For other operating systems similar directions apply. Especially,
directory names should be adapted.

For a quick overview of functions, use

   help intval               or
   help gradient             or
   help slope                or   
   help polynom              or
   help long                 or
   help utility              .

For some examples, try the demos.

For specific help try for example

   help verifylss            or
   lookfor reshape           or
   lookfor gradientinit      or
   lookfor 'linear systems'  and alike.

Certain flags like display-mode etc. are stored in global variables.
Therefore

   ===> try to avoid a statement like "clear global" or "clear all" <===

because it clears all global variables and results in subsequent errors
in INTLAB. The statements "clear" or "clear variables" do not do any
harm. Try to clear only specific global variables using, for example,
statements like "clear global v*". Note that all global variables used
in INTLAB start with "INTLAB_". Try "who global" to list them.

If a "clear global" statement is necessary for some reason, let it
be followed by

   startintlab

to restore global variables. In fact, this restores the (your) default options.

Intlab uses infimum-supremum representation for real intervals, and
midpoint-radius representation for complex intervals. However, this is not
visible to the user. For multiplication of two real interval matrices,
both of them being thick, there is a choice between

   - fast midpoint-radius implementation with a little overestimation
       issued by the Matlab command  intvalinit('FastIVmult'),
   - slower infimum-supremum representation
       issued by the Matlab command  intvalinit('SharpIVmult'),

Needless to say that both results are verified to be correct.
There is only a difference between "fast" and "sharp"
   - if both operands being contain intervals of nonzero diameter, and
   - if the inner dimension is greater than one.
Otherwise, all results will be computed sharp and fast. For example,
interval scalar products are always computed in sharp mode (not with
long accumulator, but without overestimation due to midpoint-radius
representation).

Empty interval components are represented by NaN. This is because
Matlab does not accept empty components []. For this, there is some
ambigouity concering the function "isempty". It could mean "mathematically
empty" or "empty in the Matlab sense".

We define "isempty" for all INTLAB data types in the same sense as Matlab
emptyness []. This is to ensure 'upward' compatability, the result of
isempty(x) and isempty(intval(x)), for example, should be the same for
x of type double. The result is one number, 0 or 1.

Emptyness in the mathematical sense is represented by NaN or [], and is 
tested by "isempty_". As for similar Matlab functions like isnan or isinf, 
the result of "isempty" is an array of 0/1 characterizing empty components.
Note that the definition of "isempty" and "isempty_" was interchanged from
INTLAB version 5.1 to 5.2.

For timing use for example

   n=500; A=midrad(rand(n),1e-12); Amid=mid(A); k=10;
   tic; for i=1:k, Amid*Amid; end, toc/k
   tic; for i=1:k, intval(Amid)*Amid; end, toc/k
   tic; for i=1:k, A*Amid; end, toc/k
   intvalinit('FastIVmult'), tic; for i=1:k, A*A; end, toc/k
   intvalinit('SharpIVmult'), tic; A*A; toc

for the multiplication of two 500x500 interval matrices. Results on a
750 Mhz Pentium III are

    0.7 sec  for floating point multiplication,
    1.3 sec  for multiplication of point matrices (both sharp and fast),
    2.4 sec  for multiplication of an thick and a thin matrix (both sharp and fast),
    3.3 sec  for fast multiplication of interval matrices, and
  379   sec  for sharp multiplication of interval matrices.

Default is fast multiplication. This may be changed in the startintlab
file.

To start, try for example the following commands:

   n=10; A=2*rand(n)-1; b=A*ones(n,1); X=verifylss(A,b)

This solves a randomly generated 10x10 linear system with result
verification, matrix entries uniformly distributed in [-1,1]. The
result is a real interval vector. You may display the result in
mid-rad representation by

   midrad(X)                     or
   intvalinit('DisplayMidrad')

For a larger example, try

   n=1000; A=2*rand(n)-1; b=A*ones(n,1);
   tic; A\b; toc
   tic; verifylss(A,b); toc

On a 750 Mhz Pentium III Laptop this takes about

   2.8 seconds   using floating point approximation,
  20.2 seconds   using fast multiplication, and
  20.9 seconds   using sharp multiplication.

The time difference comes from interval matrix by interval vector
multiplication C*X, see verifylss line 189. However, you would barely
see a difference in the results because rather than the solution
itself, the error with respect to an approximate solution is included.

Use the routine "verifylss" to be sure to calculate verified results.
Using "A\b" instead calls the built-in linear system solver, without
verification (if both operands are non-interval).

If the matrix or right hand side is an interval, you may use "\"
safely (it calls verifylss), e.g.

   n=1000; A=midrad(2*rand(n)-1,1e-12); b=A*ones(n,1); tic; A\b; toc   .

This generates a 1000x1000 matrix with entrywise radius 10^(-12) and
solves the linear system with verified bounds. The
timing is

   29.2 seconds .

To change display format of intervals, use the built-in commands
"format long", "format short e", etc.

The linear system solver works for sparse s.p.d. and/or rectangular
matrices as well. To generate a random sparse s.p.d. linear system try

   n=1000; A=sprand(n,n,1/n)+speye(n); A=A*A'; b=A*ones(n,1);

and solve it (with timing) without verification by

   tic; x = A\b; toc

and with verification by

   tic; X = verifylss(A,b); toc

On a 750 Mhz Pentium III the timing is

   0.16 seconds   for built-in floating point, and
   2.4  seconds   with verification.

Much better results are possible with reordering. Try the built-in minimum
degree algorithm by

   p = symmmd(A); tic; X = verifylss(A(p,p),b(p)); toc   .

This computes a verified result in only .18 seconds on the above
computer. The structure of the matrix, the Cholesky factor and the
original matrix and the Cholesky factor of the reordered matrix can be
displayed by

   spy(A), pause, spy(chol(A)), pause, spy(chol(A(p,p)))

Verified solution of linear systems works for complex matrices as well.
Unfortunately, there is a bug in the Cholesky decomposition of Matlab 5.2
for complex sparse matrices such that verification does not work either
in that case.

For nonlinear systems, automatic differentiation is used. For example, look
at the function "intval\test". The code for the first function (omitting
comments) is

   function y = test(x)
     y = x;
     c1 = typeadj( 1 , typeof(x) );
     cpi = typeadj( midrad(3.14159265358979323,1e-16) , typeof(x) );
     y(1) = .5*sin(x(1)*x(2)) - x(2)/(4*cpi) - x(1)/2;
     y(2) = (1-1/(4*cpi))*(exp(2*x(1))-exp(c1)) + ...
            exp(c1)*x(2)/cpi - 2*exp(c1)*x(1);
     return

The call

   x=[-3;7]; y=test(x)

calls "test" with input vector [-3;7] and usual floating point
arithmetic. The call

   x=intval([-3;7]); y=test(x)

uses interval arithmetic, the call

   x=gradientinit([-3;7]); y=test(x)

uses automatic differentiation with access

   y.x    to the function value and
   y.dx   to the Jacobian.

Finally, the call

   x=gradientinit(intval([-3;7])); y=test(x)

evaluates "test" with automatic differentiation and interval artihmetic.
The function "typeadj" is necessary for interval evaluations. It adjusts
the type of constants to the type of the input argument "x". For example,
exp(1) is replaced by "exp(c1)" to ensure correct rounding.

The nonlinear system (Broyden's example) can be solved by

   X = verifynlss('test',[.6;3],'g')   .

The third parameter 'g' indicates function expansion by gradients; the call

   X = verifynlss('test',[.6;3],'s')

does the same using slopes. Use of slopes does not imply uniqueness of
the zero, but allows inclusion of clusters of zeros.

The programs and operators support vector and matrix notation in order to
diminish slow-down by interpretation. The user is encouraged to use matrix
and vector notation whereever possible. See, for example, Brent's example
in the function "test" in directory \intval (copy it from the end to top).
The call

   n=200;  X = verifynlss('test',10*ones(n,1),'g',1)

solves Brent's example with the initial approximation 10*ones(n,1) given in
his paper. The last parameter "1" tells the function "verifynlss" to
display intermediate information. It shows that 10 floating point and 1
interval iteration is used together with information on the residual. The
timing on an 750 Mhz Pentium III is 

                       time for
      n    fl-pt iteration   verification
    -------------------------------------------
     200       1.9 sec          1.3 sec
     500      12.4 sec         21.6 sec

and the sum of the two columns is the total computing time. Without the 
vector notation (see "test") this would not achievable.

For sample programs, consult

   verifylss
   verifynlss       
   verifyeig
   verifypoly

in directories \intval and \polynom.

For the homo ludens in you, try

   intlablogo                .


If you have comments, suggestions, found bugs or similar, contact

    rump(at) tu-harburg.de       .





DISCLAIMER:   Extensive tests have been performed to ensure reliability
===========   of the algorithms. However, neither an error-free processor
              nor an error-free program can be guaranteed.


INTLAB LICENSE INFORMATION
==========================


Copyright (c) 1998 - 2006 Siegfried M. Rump
                          Institute for Scientific Computing
                          Hamburg University of Technology
                          Germany
                                       

All rights reserved.

===> INTLAB is free for private use and for purely academic purposes provided 
proper reference is given acknowledging that the software package INTLAB has 
been developed by Siegfried M. Rump, head of the Institute for Scientific Computing
at the Hamburg University of Technology, Germany. For any other use of INTLAB a 
license is required. 

===> For commercial use of INTLAB as well as its use in any connection with the 
development or distribution of a commercial product a license is required. 
Especially any use of a commercial product which needs INTLAB or parts of INTLAB 
to work properly requires an INTLAB license. This is independent of whether the 
commercial product is used privately or for commercial purposes. To obtain an 
INTLAB license contact Siegfried M. Rump. 

===> Neither the name of the university nor the name of the author may be used 
to endorse or promote products derived with or from this software without specific 
prior written permission. 

THIS SOFTWARE IS PROVIDED AS IS AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, 
INCLUDING, WITHOUT LIMITATIONS, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND 
FITNESS FOR A PARTICULAR PURPOSE. 

