function A = sup(A)
%SUP          Supremum of long (only with error term)
%
%  C = sup(A)
%
%For A being a long scalar or column vector with error term (see long),
%  output C is the long upper bound
%

% written  11/06/99     S.M. Rump
% modified 04/04/04     S.M. Rump  set round to nearest for safety
% modified 09/20/04     S.M. Rump  E.sign fixed
% modified 11/19/04     S.M. Rump  exponent update for error
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 07/25/05     S.M. Rump  result improved, thanks to 
%                                      Nozomu Matsuda and Nobito Yamamoto
%

  e = 1e-30;
  if 1+e==1-e                           % fast check for rounding to nearest
    rndold = 0;
  else
    rndold = getround;
    setround(0)
  end

  global INTLAB_LONG_ERROR

  if ~INTLAB_LONG_ERROR
    error('sup called for long without error term')
  end

  n = length(A.sign);
  E = long(A.error.mant);
  E.exponent = E.exponent + A.error.exp;

  A.error.mant = 0;
  A.error.exp = 0;

  A = A + E;
  index = ( A.error.mant~=0 );
  if any(index)
    %VVVV  A(index) = sup(A(index));
    s.type = '()'; s.subs = {index}; A = subsasgn(A,s,sup(subsref(A,s)));
    %AAAA  Matlab bug fix
  end
  
  if rndold~=0
    setround(rndold)
  end
