function c = abss(a)
%ABSS         Implements  abs(a)  for intervals, result real
%
%   c = abss(a)
%
%On return, abs(alpha) <= c for all alpha in a
%Obsolete, replaced by mag (thanks to Arnold for better naming).
%

% written  10/16/98     S.M. Rump
% modified 09/02/00     S.M. Rump  rounding unchanged after use
% modified 07/08/02     S.M. Rump  changed from abs->abss
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
    setround(1)
    if isequal(a.rad,0)                 % take care of huge arrays
      c = abs(a.mid);
    else
      c = abs(a.mid) + a.rad;
    end
    setround(0)                         % set rounding to nearest
  else
    c = max( abs(a.inf) , abs(a.sup) );
  end
  
  if rndold~=0
    setround(rndold)
  end
