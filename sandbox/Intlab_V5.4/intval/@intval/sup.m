function c = sup(a)
%SUP          Implements  sup(a)  for intervals
%
%   c = sup(a)
%
% On return, alpha <= sup(a) for all alpha in a
%

% written  10/16/98     S.M. Rump
% modified 09/02/00     S.M. Rump  rounding unchanged after use
% modified 10/03/02     S.M. Rump  impovement for sparse input
% modified 04/04/04     S.M. Rump  set round to nearest for safety
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 11/20/05     S.M. Rump  fast check for rounding to nearest
%

  if a.complex
    if isequal(a.rad,0)                  % faster for sparse matrices
      c = a.mid;
    else
      e = 1e-30;
      if 1+e==1-e                           % fast check for rounding to nearest
        rndold = 0;
      else
        rndold = getround;
      end
      setround(1)
      c = a.mid + ( a.rad + a.rad*j );
      setround(rndold)                  % set rounding to previous value
    end
  else
    c = a.sup;
  end
