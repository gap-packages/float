function y = sqrt_rnd(x,rnd)
%SQRT_RND     Rigorous bounds for sqrt(x) according to round
%
%   y = sqrt_rnd(x,rnd)
%
% x may be vector, assumed to be nonnegative, rnd is -1 or +1, rounding unchanged after use.
% Routine necessary because Matlab-sqrt not IEEE 754 but seemingly always round to nearest.
%

% written  01/20/03     S.M. Rump
%

  global INTLAB_INTVAL_ETA
  y = sqrt(x);
  
  switch rnd
    case -1
      setround(1)
      index = ( y.*y>x );
      while any(index(:))
        setround(-1)
        y(index) = y(index) - INTLAB_INTVAL_ETA;
        setround(1)
        index = ( y.*y>x );
      end
    case 1
      setround(-1)
      index = ( y.*y<x );
      while any(index(:))
        setround(1)
        y(index) = y(index) + INTLAB_INTVAL_ETA;
        setround(-1)
        index = ( y.*y<x );
      end
  end
  