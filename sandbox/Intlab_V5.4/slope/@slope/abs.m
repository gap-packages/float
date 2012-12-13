function u = abs(a)
%ABS          Slope absolute value abs(a)
%

% written  12/06/98     S.M. Rump
% modified 07/08/02     S.M. Rump  adapted to intval\abs
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

  u.r = abs(a.r);
  u.s = slopeconvexconcave('abs','isign(%)',a,1);
  
  if rndold~=0
    setround(rndold)
  end
