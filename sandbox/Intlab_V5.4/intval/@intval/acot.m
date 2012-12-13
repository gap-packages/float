function y = acot(x)
%ACOT         Implements  acot(x)  for intervals
%
%   y = acot(x)
%
%interval standard function implementation
%

% written  10/16/98     S.M. Rump
% modified 06/24/99     S.M. Rump  complex allowed, sparse input,
%                                  major revision, improved accuracy
% modified 04/04/04     S.M. Rump  set round to nearest for safety
%                                    accelaration for sparse input
% modified 04/06/05     S.M. Rump  rounding unchanged
%

  if issparse(x)
    index = ( x==0 );
    if any(index(:))                    % treat zero indices
      global INTLAB_INTVAL_STDFCTS_PI
      PI2 = intval(INTLAB_INTVAL_STDFCTS_PI.PI2INF,INTLAB_INTVAL_STDFCTS_PI.PI2SUP,'infsup');
      y = intval(repmat(PI2,size(x)));
      index = ~index;
      %VVVV  y(index) = acot(full(x(index)));
      s.type = '()'; s.subs = {index}; y = subsasgn(y,s,acot(full(subsref(x,s))));
      %AAAA  Matlab bug fix
    else
      y = acot(full(x));
    end
    return
  end
      
  e = 1e-30;
  if 1+e==1-e                           % fast check for rounding to nearest
    rndold = 0;
  else
    rndold = getround;
    setround(0)
  end

   y = atan(1./x);
  
  if rndold~=0
    setround(rndold)
  end
