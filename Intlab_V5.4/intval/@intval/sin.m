function y = sin(x)
%SIN          Implements  sin(x)  for intervals
%
%   y = sin(x)
%
%interval standard function implementation
%

% written  12/30/98     S.M. Rump
% modified 08/31/99     S.M. Rump  complex allowed, NaN input, array input,
%                                  sparse input, major revision,
%                                  improved accuracy
% modified 09/02/00     S.M. Rump  rounding unchanged after use
% modified 04/04/04     S.M. Rump  set round to nearest for safety
%                                    accelaration for sparse input
% modified 04/06/05     S.M. Rump  rounding unchanged
%

  if issparse(x)
    [ix,jx,sx] = find(x);
    [m,n] = size(x);
    y = sparse(ix,jx,sin(full(sx)),m,n);
    return
  end

  global INTLAB_INTVAL_STDFCTS

  e = 1e-30;
  if 1+e==1-e                           % fast check for rounding to nearest
    rndold = 0;
  else
    rndold = getround;
    setround(0)
  end

  if x.complex
    y = ( exp(j*x) - exp(-j*x) ) / (2*j);  
    if rndold~=0
      setround(rndold)
    end
    return
  end

  if INTLAB_INTVAL_STDFCTS             % rigorous standard function

    y = x;

    % transform x.inf and x.sup mod pi/2
    [ xinfinf , xinfsup , Sinf ] = modpi2(x.inf(:));
    [ xsupinf , xsupsup , Ssup ] = modpi2(x.sup(:));

    [ yinf , ysup ] = sin_(x.inf(:),xinfinf,xinfsup,Sinf,  ...
                           x.sup(:),xsupinf,xsupsup,Ssup );
    index = ~isfinite(x.inf) | ~isfinite(x.sup);
    if any(index(:))
      yinf(index) = -1;
      ysup(index) = 1;
    end

    y.inf = reshape(yinf,size(x.inf));
    y.sup = reshape(ysup,size(x.inf));

    setround(0)                        % set rounding to nearest

  else                                 % approximate standard function

    global INTLAB_INTVAL_EPSSTDFCTS

    pi2 = 2*pi;
    xmid = mid(x);
    index = ( abs(xmid)>.1 );
    if any(index(:))
      xmid(index) = mod(xmid(index),pi2);
    end
    xrad = rad(x);
    delta = mag(x)*eps;

    xmid = xmid + pi2*(xmid<-.1);
    xmid = xmid - pi2*(xmid>pi2);

    s = xmid>pi;
    xmid = xmid - pi*s;
    s = 1-2*s;

    t = xmid>pi/2;
    xmid = t*pi - (2*t-1).*xmid;

    xx = xmid - xrad - delta;
    yinf = sin(xx);
    t = xx>-pi/2;
    yinf = yinf.*t + (t-1);
    yinf = max(yinf,-1);

    xx = xmid + xrad + delta;
    ysup = sin(xx);
    t = xx<pi/2;
    ysup = ysup.*t + (1-t);
    ysup = min(ysup,1);

    y = s .* infsup(yinf,ysup) * midrad(1,INTLAB_INTVAL_EPSSTDFCTS);

  end

  index = isnan(x.inf);
  if any(index(:))
    y.inf(index) = NaN;
    y.sup(index) = NaN;
  end
  
  if rndold~=0
    setround(rndold)
  end
