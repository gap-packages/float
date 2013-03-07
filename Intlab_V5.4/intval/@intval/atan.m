function y = atan(x)
%ATAN         Implements  atan(x)  for intervals
%
%   y = atan(x)
%
%interval standard function implementation
%

% written  12/30/98     S.M. Rump
% modified 08/31/99     S.M. Rump  complex allowed, sparse input,
%                                  major revision, improved accuracy
% modified 09/02/00     S.M. Rump  rounding unchanged after use
% modified 04/04/04     S.M. Rump  set round to nearest for safety
%                                    accelaration for sparse input
% modified 04/06/05     S.M. Rump  rounding unchanged
%

  if issparse(x)
    [ix,jx,sx] = find(x);
    [m,n] = size(x);
    y = sparse(ix,jx,atan(full(sx)),m,n);
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
    y = log( 2./(1-j*x) - 1) / (2*j);
    if rndold~=0
      setround(rndold)
    end
    return
  end

  y = x;

  if INTLAB_INTVAL_STDFCTS             % rigorous standard function

    xinf = x.inf(:);
    xsup = x.sup(:);

    IndexInfPos = ( xinf>=0 );
    len1 = sum(IndexInfPos);
    IndexSupNeg = ( xsup<=0 );

    Y = atan_pos( [ xinf(IndexInfPos) ; -xsup(IndexSupNeg) ] , -1 );
    y.inf(IndexInfPos) = Y(1:len1);
    y.sup(IndexSupNeg) = -Y( len1+1 : end );

    IndexInfNeg = ( xinf<0 );
    len1 = sum(IndexInfNeg);
    IndexSupPos = ( xsup>0 );

    Y = atan_pos( [ -xinf(IndexInfNeg) ; xsup(IndexSupPos) ] , 1 );
    y.inf(IndexInfNeg) = -Y(1:len1);
    y.sup(IndexSupPos) = Y( len1+1 : end );

    setround(0)                        % set rounding to nearest
    
  else                                 % approximate standard function

    global INTLAB_INTVAL_EPSSTDFCTS

    setround(0)

    y.inf = atan(x.inf);
    y.inf = y.inf - INTLAB_INTVAL_EPSSTDFCTS*abs(y.inf);

    y.sup = atan(x.sup);
    y.sup = y.sup + INTLAB_INTVAL_EPSSTDFCTS*abs(y.sup);

  end

  if rndold~=0
    setround(rndold)
  end
  