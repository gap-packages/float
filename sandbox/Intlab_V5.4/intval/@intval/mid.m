function c = mid(a)
%MID          Implements  mid(a)  for intervals (rounded)
%
%   c = mid(a)
%
% mid(a) and rad(a) computed such that
%    alpha  in  < mid(a) , rad(a) >  for all alpha in a
%

% written  10/16/98     S.M. Rump
% modified 06/22/99     S.M. Rump  for sparse matrices
% modified 09/02/00     S.M. Rump  rounding unchanged after use
% modified 04/04/04     S.M. Rump  set round to nearest for safety
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 11/20/05     S.M. Rump  fast check for rounding to nearest
%

  if a.complex
    c = a.mid;
  else
    e = 1e-30;
    if 1+e==1-e                           % fast check for rounding to nearest
      rndold = 0;
    else
      rndold = getround;
    end
    setround(1)
    c = a.inf + 0.5*(a.sup-a.inf);
    setround(rndold)
    index = find( isinf(a.inf) | isinf(a.sup) );
    if any(index(:))
      c(index) = 0;
      c( find( ( a.inf==-inf ) & ( a.sup==-inf ) ) ) = -inf;
      c( find( ( a.inf==inf ) & ( a.sup==inf ) ) ) = inf;
    end
  end
