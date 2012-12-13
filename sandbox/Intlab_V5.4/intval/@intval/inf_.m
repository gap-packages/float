function c = inf_(a)
%INF_         Implements  inf(a)  (cures problems with inf)
%
%   c = inf(a)
%
% On return, inf(a) <= alpha for all entries alpha in a
%
%************************************************************************
%********  due to conflict with internal variable inf (infinity)  *******
%********                    use function inf_                    *******
%************************************************************************
%

% written  10/05/99     S.M. Rump
% modified 09/02/00     S.M. Rump  rounding unchanged after use
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
    if isequal(a.rad,0)
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
