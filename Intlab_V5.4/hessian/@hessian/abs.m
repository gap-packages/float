function a = abs(a)
%ABS          Hessian absolute value abs(a)
%
%Result is convex hull of left and right derivatives. This allows
%also input containing zero. The expansion
%  f(x) = f(xs) + f'(zeta)*(x-xs)
%for some zeta in ch(x,xs) is still valid
%

% written  04/04/04     S.M. Rump
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 05/23/06     S.M. Rump  complex arguments (thanks to Sébastien Loisel)
%

  if ~isreal(a.x)
    a.x = abs(a.x);
    a.dx = repmat(NaN+NaN*i,size(a.dx));
    a.hx = repmat(NaN+NaN*i,size(a.hx));
    if isa(a.x,'intval')
      a.dx = intval(a.dx);
      a.hx = intval(a.hx);
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

  ax = a.x(:);
  index = ( ax<0 );
  a.x = abs(a.x);
  a.dx(:,index) = -a.dx(:,index);
  a.hx(:,index) = -a.hx(:,index);
  if isa(ax,'intval')
    index = in0(0,ax);
    a.dx(:,index) = infsup(-1,1)*a.dx(:,index);
    a.hx(:,index) = infsup(-1,1)*a.hx(:,index);
  end
    
  if rndold~=0
    setround(rndold)
  end
