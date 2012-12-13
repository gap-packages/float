function y = cosh(x)
%COSH         Implements  cosh(x)  for intervals
%
%   y = cosh(x)
%
%interval standard function implementation
%

% written  12/30/98     S.M. Rump
% modified 08/31/99     S.M. Rump  complex allowed, array input, sparse input,
%                                  major revision, improved accuracy
% modified 09/02/00     S.M. Rump  rounding unchanged after use
% modified 04/04/04     S.M. Rump  set round to nearest for safety
%                                    accelaration for sparse input
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 12/04/05     S.M. Rump  extreme values for approximate part
%

  if issparse(x)
    index = ( x==0 );
    if any(index(:))                    % treat zero indices
      y = intval(ones(size(x)));
      index = ~index;
      %VVVV  y(index) = cosh(full(x(index)));
      s.type = '()'; s.subs = {index}; y = subsasgn(y,s,cosh(full(subsref(x,s))));
      %AAAA  Matlab bug fix
    else
      y = cosh(full(x));
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

  global INTLAB_INTVAL_STDFCTS

  if x.complex
    y = ( exp(x) + exp(-x) ) / 2;  
    if rndold~=0
      setround(rndold)
    end
    return
  end

  if issparse(x.inf)                   % real case
    x.inf = full(x.inf);
    x.sup = full(x.sup);
  end

  y = x;

  if INTLAB_INTVAL_STDFCTS             % rigorous standard function

    xinf = x.inf(:);
    xsup = x.sup(:);

    IndexInfPos = ( xinf>=0 );
    len1 = sum(IndexInfPos);
    IndexSupNeg = ( xsup<=0 );
    len2 = sum(IndexSupNeg);

    Y = coshpos( [ xinf(IndexInfPos) ; -xsup(IndexSupNeg) ] , -1 );
    y.inf(IndexInfPos) = Y(1:len1);
    y.inf(IndexSupNeg) = Y( len1+1 : end );

    IndexInfNegSupPos = ~( IndexInfPos | IndexSupNeg );
    if any(IndexInfNegSupPos)
      len3 = sum(IndexInfNegSupPos);
      Y = coshpos( [  xsup(IndexInfPos) ; -xinf(IndexSupNeg) ; ...
                     -xinf(IndexInfNegSupPos) ; xsup(IndexInfNegSupPos) ] , 1 );
      y.sup(IndexInfPos) = Y(1:len1);
      y.sup(IndexSupNeg) = Y( len1+1 : len1+len2 );
      y.inf(IndexInfNegSupPos) = 1;
      y.sup(IndexInfNegSupPos) = ...
         max( Y( len1+len2+1 : len1+len2+len3 ) , Y( len1+len2+len3+1 : end ) );
    else
      Y = coshpos( [ xsup(IndexInfPos) ; -xinf(IndexSupNeg) ] , 1 );
      y.sup(IndexInfPos) = Y(1:len1);
      y.sup(IndexSupNeg) = Y( len1+1 : end );
    end

    setround(0)                        % set rounding to nearest

  else                                 % approximate standard function

    global INTLAB_INTVAL_EPSSTDFCTS

    setround(0)

    v = ( x.inf <= 0 & x.sup >= 0 );
    if any(v(:))
      y.inf(v) = 1;
      yv = max( cosh(x.inf(v)) , cosh(x.sup(v)) ) ;
      y.sup(v) = yv + INTLAB_INTVAL_EPSSTDFCTS*min(realmax,abs(yv));
    end

    v = ( x.inf >= 0 );
    if any(v(:))
      yv = cosh(x.inf(v)) ;
      y.inf(v) = yv - INTLAB_INTVAL_EPSSTDFCTS*min(realmax,abs(yv));
      yv = cosh(x.sup(v)) ;
      y.sup(v) = yv + INTLAB_INTVAL_EPSSTDFCTS*min(realmax,abs(yv));
    end

    v = ( x.sup <= 0 );
    if any(v(:))
      yv = cosh(x.sup(v)) ;
      y.inf(v) = yv - INTLAB_INTVAL_EPSSTDFCTS*min(realmax,abs(yv));
      yv = cosh(x.inf(v)) ;
      y.sup(v) = yv + INTLAB_INTVAL_EPSSTDFCTS*min(realmax,abs(yv));
    end

  end
    
  if rndold~=0
    setround(rndold)
  end

  

function y = coshpos(x,rnd)
% Value cosh(x) rounded according to rnd for nonnegative double vector x

  global INTLAB_INTVAL_STDFCTS_SINH

  y = x;

  % medium input
  index = ( x<709 );
  if any(index)
    [ explb , expub ] = exp_rnd(x(index));
    setround(rnd)
    if rnd==-1
      y(index) = 0.5 * ( explb + 1./expub );
    else
      y(index) = 0.5 * ( expub + 1./explb );
    end
  end

  % large input
  index = ( x>=709 );
  if any(index)
    global INTLAB_INTVAL_STDFCTS_E
    expbnd = exp_rnd( x(index)-1 , rnd )/2;
    setround(rnd)
    if rnd==-1
      y(index) = expbnd .* INTLAB_INTVAL_STDFCTS_E.INF;
    else
      y(index) = expbnd .* INTLAB_INTVAL_STDFCTS_E.SUP;
    end
  end
