function y = coth(x)
%COTH         Implements  coth(x)  for intervals
%
%   y = coth(x)
%
%interval standard function implementation
%

% written  10/16/98     S.M. Rump
% modified 08/19/99     S.M. Rump  complex allowed, sparse input, tanh used,
%                                  major revision, improved accuracy
% modified 04/04/04     S.M. Rump  set round to nearest for safety
% modified 04/06/05     S.M. Rump  rounding unchanged
%

  e = 1e-30;
  if 1+e==1-e                           % fast check for rounding to nearest
    rndold = 0;
  else
    rndold = getround;
    setround(0)
  end

  y = 1./tanh(x);
  
  if rndold~=0
    setround(rndold)
  end
