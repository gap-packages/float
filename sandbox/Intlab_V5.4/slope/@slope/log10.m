function u = log10(a)
%LOG10        slope base 10 logarithm  log10(a)
%

% written  12/06/98     S.M. Rump
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

  u = a;

  u.r = log10(a.r);
  u.s = slopeconvexconcave('log10','1./(log(intval(10))*(%))',a,0);
  
  if rndold~=0
    setround(rndold)
  end
