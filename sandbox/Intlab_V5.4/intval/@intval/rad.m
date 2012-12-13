function c = rad(a)
%RAD          Implements  rad(a)  for intervals
%
%   c = rad(a)
%
% mid(a) and rad(a) computed such that
%    alpha  in  < mid(a) , rad(a) >  for all alpha in a
%
%As has been pointed out by G. Mayer, Rostock, this implies a peculiarity.
%For an interval X with bound differing by one bit, the result of rad(X)
%and diam(X) is the same. For example, 
%
%   x = infsup(1,1+eps), rx = rad(x), dx = diam(x)
%
%yields
% 
% intval x = 
%     1.0000
% rx =
%   2.2204e-016
% dx =
%   2.2204e-016
%
%So for comparing the quality of interval inclusions we recommend
%  to use diam.
%

% written  10/16/98     S.M. Rump
% modified 06/22/99     S.M. Rump  for sparse matrices
% modified 09/02/00     S.M. Rump  rounding unchanged after use
% modified 04/04/04     S.M. Rump  set round to nearest for safety
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 06/29/05     S.M. Rump  comment rad/diam added
% modified 11/20/05     S.M. Rump  fast check for rounding to nearest
%

  if a.complex
    c = a.rad;
  else
    e = 1e-30;
    if 1+e==1-e                         % fast check for rounding to nearest
      rndold = 0;
    else
      rndold = getround;
    end
    setround(1)
    mid = a.inf + 0.5*(a.sup-a.inf);
    c = mid - a.inf;
    setround(rndold)                    % set rounding to previous value
    index = ( isinf(a.inf) | isinf(a.sup) );
    anyindex = any(index);
    if any(anyindex(:))
      c(index) = inf;
      c( find( index & ( a.inf==a.sup ) ) ) = 0;
    end
  end

  index = find( c<0 | isnan(c) );     % be sure radius never complex
  if any(index(:))
    c(index) = NaN;
  end
