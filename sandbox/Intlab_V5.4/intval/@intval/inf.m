function c = inf(a)
%INF          Implements  inf(a)  for intervals
%
%   c = inf(a)
%
% On return, inf(a) <= alpha for all alpha in a
%

% written  10/16/98     S.M. Rump
% modified 09/02/00     S.M. Rump  rounding unchanged after use
% modified 10/03/02     S.M. Rump  impovement for sparse input
% modified 04/04/04     S.M. Rump  set round to nearest for safety
%                                    take care of huge arrays
% modified 04/06/05     S.M. Rump  rounding unchanged
%

  e = 1e-30;
  if 1+e==1-e                           % fast check for rounding to nearest
    rndold = 0;
  else
    rndold = getround;
    setround(0)
  end

  if a.complex
    if isequal(a.rad,0)                  % faster for sparse matrices
      c = a.mid;
    else
      setround(-1)
      c = a.mid - ( a.rad + a.rad*j );
      setround(0)                       % set rounding to nearest
    end
  else
    c = a.inf;
  end
  
  if rndold~=0
    setround(rndold)
  end
