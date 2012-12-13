% INTLAB  INTerval LABoratory. 
% Version 5.4   31-May-2007
%
%=========================================================================
%*****  Free for private and academic use. Commercial use or use in  *****
%*****  conjunction with a commercial program which requires INTLAB  *****
%*****  or part of INTLAB for proper function is prohibited.         *****
%*****  See the file README.TXT for details of copyright.            *****
%=========================================================================
%
%Directories and toolboxes
%  intval       - Interval package
%  gradient     - Automatic differentiation package
%  hessian      - Automatic Hessian package
%  slope        - Automatic slope package
%  polynom      - Polynomial package (univariate and multivariate)
%  long         - Rudimentary long package
%  utility      - Some useful functions
%
%Auxiliary files
%  intlablogo   - INTLAB logo display
%  startintlab  - Initialization of INTLAB
%  startup      - Calls startintlab: adapt to your local installation
%  intlabsetting   - Current setting of INTLAB control variables
%  Version2     - Additions and changes in version 2
%  Version3     - Additions and changes in version 3
%  Version3.1   - Additions and changes in version 3.1
%  Version4     - Additions and changes in version 4
%  Version4.1   - Additions and changes in version 4.1
%  Version4.1.1 - Additions and changes in version 4.1.1
%  Version4.1.2 - Additions and changes in version 4.1.2
%  Version5     - Additions and changes in version 5
%  Version5.1   - Additions and changes in version 5.1
%  Version5.2   - Additions and changes in version 5.2
%  Version5.3   - Additions and changes in version 5.3
%  Version5.4   - Additions and changes in version 5.4
%  FAQ          - Frequently asked questions
%  Readme       - Installation, a little tutorial and miscellaneous
%
%
%INTLAB based on
%  S.M. Rump: INTLAB - INTerval LABoratory, in "Developments in
%    Reliable Computing", ed. T. Csendes, Kluwer Academic Publishers,
%    77-104 (1999).
%
%INTLAB implementation of interval arithmetic is based on
%  S.M. Rump: Fast and Parallel Interval Arithmetic,
%    BIT 39(3), 539-560 (1999).
%and
%  S. Oishi, S.M. Rump: Fast verification of solutions of matrix equations, 
%    Numerische Mathametik 90, 755-773, 2002.
%
%Real interval standard functions based on
%  S.M. Rump: Rigorous and portable standard functions,
%    BIT 41(3), 540-562 (2001).
%
%Complex interval standard functions based on
%  N.C. Boersken: Komplexe Kreis-Standardfunktionen, Freiburger
%    Intervallberichte 78/2.
%
%Accurate summation and dot product with specified precision
%  T. Ogita, S.M. Rump, and S. Oishi. Accurate Sum and Dot Product, 
%     SIAM Journal on Scientific Computing (SISC), 26(6):1955-1988, 2005.
%
%Accurate summation and dot product with specified accuracy
%  S.M. Rump, T. Ogita, and S. Oishi. Accurate Floating-point Summation I: 
%     Faithful Rounding. submitted for publication in SISC, 2005–2007. 
%  S.M. Rump, T. Ogita, and S. Oishi. Accurate Floating-point Summation II: 
%     Sign, K-fold Faithful and Rounding to Nearest. submitted for publication 
%     in SISC, 2005–2007. 
%
%For references to verification algorithms cf. the corresponding routines.
%
%Slopes based on
%  R. Krawzcyk, A. Neumaier: Interval slopes for rational functions
%    and associated centered forms, SIAM J. Numer. Anal. 22, 604-616
%    (1985)
%with improvements based on
%  S.M. Rump: Expansion and Estimation of the Range of Nonlinear Functions,
%    Math. Comp. 65(216), pp. 1503-1512 (1996).
%
%Gradients based on standard forward differentiation, cf. for example
%  L.B. Rall: Automatic Differentiation: Techniques and Applications,
%    Lecture Notes in Computer Science 120, Springer, 1981.
%
%Long floating point and interval arithmetic based on standard techniques
%  with adaptation and speed up for interpretative systems.
%

% written  12/30/98     S.M. Rump
% modified 03/06/99     S.M. Rump  Version 2
% modified 11/16/99     S.M. Rump  Version 3
% modified 03/07/02     S.M. Rump  Version 3.1
% modified 12/08/02     S.M. Rump  Version 4
% modified 12/27/02     S.M. Rump  Version 4.1
% modified 01/22/03     S.M. Rump  Version 4.1.1
% modified 11/18/03     S.M. Rump  Version 4.1.2
% modified 04/04/04     S.M. Rump  Version 5
% modified 06/04/05     S.M. Rump  Version 5.1
% modified 12/20/05     S.M. Rump  Version 5.2
% modified 05/26/06     S.M. Rump  Version 5.3
% modified 05/31/07     S.M. Rump  Version 5.4

% Copyright (c) Siegfried M. Rump, head of the Institute for Reliable Computing, 
%               Hamburg University of Technology
%
% Free for private and academic use. Any use of a commercial product which needs 
% INTLAB or parts of INTLAB to work properly is prohibited. (for details, see README.TXT).
