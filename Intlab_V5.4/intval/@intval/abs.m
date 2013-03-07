function c = abs(a)
%ABS          Interval absolute value
%
%  c = abs(a);
%
%Result c is the real interval of { abs(alpha) | alpha in a }
%

% written  12/06/98     S.M. Rump
% modified 09/02/00     S.M. Rump  rounding unchanged after use
% modified 07/08/02     S.M. Rump  changed from iabs-> abs
% modified 04/04/04     S.M. Rump  redesign, set round to nearest for safety
%                                    take care of huge arrays
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 11/20/05     S.M. Rump  fast check for rounding to nearest
% modified 06/26/06     S.M. Rump  zero bound corrected (thanks to Matthew Benedict)
% modified 09/26/06     S.M. Rump  zero bound corrected
%

  e = 1e-30;
  if 1+e==1-e                           % fast check for rounding to nearest
    rndold = 0;
  else
    rndold = getround;
    setround(0)
  end

  c = a;
  c.complex = 0;
  
  if a.complex
    
    setround(-1)
    if isequal(a.rad,0)            % take care of huge arrays
      c.inf = abs(a.mid);
      setround(1)
      c.sup = abs(a.mid);
    else
      c.inf = abs(a.mid) - a.rad;
      c.inf(c.inf<0) = 0;
      setround(1)
      c.sup = abs(a.mid) + a.rad;
    end
    
    index = find(isnan(a.mid));
    if any(index(:))
      if issparse(a.mid)    % take care of huge arrays
        [i,j] = find(isnan(a.mid));
        [m n] = size(a.mid);
        c.inf = c.inf + sparse(i,j,NaN,m,n);
        c.sup = c.sup + sparse(i,j,NaN,m,n);
      else
        c.inf(index) = NaN;
        c.sup(index) = NaN;
      end
    end
    
  else
    
    c.inf = a.inf;
    c.sup = a.sup;
    
    index = find( a.sup<0 );
    if any(index(:))
      c.inf(index) = -a.sup(index);
      c.sup(index) = -a.inf(index);
    end
    
    index = find( a.inf<0 );
    if any(index(:))
      index = index(a.sup(index)>=0);
      if any(index(:))
        c.inf(index) = 0;
        c.sup(index) = max(-a.inf(index),a.sup(index));
      end
    end
    
    index = any(isnan(a.inf));
    if any(index(:))
      c.inf(index) = NaN;
      c.sup(index) = NaN;
    end
    
  end
  
  c.mid = [];
  c.rad = [];
  
  setround(rndold)
