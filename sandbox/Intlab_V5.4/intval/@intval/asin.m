function y = asin(x)
%ASIN         Implements  asin(x)  for intervals
%
%   y = asin(x)
%
%interval standard function implementation
%

% written  12/30/98     S.M. Rump
% modified 08/31/99     S.M. Rump  complex allowed, sparse input,
%                                  pos/neg split, major revision,
%                                  improved accuracy
% modified 09/02/00     S.M. Rump  rounding unchanged after use
% modified 04/04/04     S.M. Rump  set round to nearest for safety
%                                    accelaration for sparse input
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 12/04/05     S.M. Rump  'realstdfctsexcptnignore' added and some
%                                     improvements, tocmplx replaced by cintval
%

  if issparse(x)
    [ix,jx,sx] = find(x);
    [m,n] = size(x);
    y = sparse(ix,jx,asin(full(sx)),m,n);
    return
  end

  e = 1e-30;
  if 1+e==1-e                           % fast check for rounding to nearest
    rndold = 0;
  else
    rndold = getround;
    setround(0)
  end

  if x.complex
    y = -j * log( j*x + sqrt(1-sqr(x)) );
    if rndold~=0
      setround(rndold)
    end
    return
  end
  
  % input x real and full
  % real range of definition:  [-1,1]
  global INTLAB_INTVAL_STDFCTS_EXCPTN
  if INTLAB_INTVAL_STDFCTS_EXCPTN==3    % ignore input out of range
    global INTLAB_INTVAL_STDFCTS_EXCPTN_   
    index = ( x.inf<-1 );               % (partially) exceptional indices
    if any(index(:))
      x.inf(index) = -1;
      INTLAB_INTVAL_STDFCTS_EXCPTN_ = 1;
    end
    index = ( x.sup>1 );                % (partially) exceptional indices
    if any(index(:))
      x.sup(index) = 1;
      INTLAB_INTVAL_STDFCTS_EXCPTN_ = 1;
    end
    index = ( x.sup < -1 ) | ( x.inf > 1 );   % completely exceptional indices
  else
    index = ( x.inf < -1 ) | ( x.sup > 1 );
    if ( INTLAB_INTVAL_STDFCTS_EXCPTN<2 ) & any(index(:))
      if INTLAB_INTVAL_STDFCTS_EXCPTN==1
        warning('ASIN: Real interval input out of range changed to be complex')
      end
      y = x;
      %VVVV  y(index) = asin(cintval(x(index)));
      s.type = '()'; s.subs = {index}; y = subsasgn(y,s,asin(cintval(subsref(x,s))));
      %AAAA  Matlab bug fix
      index = ~index;
      if any(index(:))
        %VVVV  y(index) = asin(x(index));
        s.type = '()'; s.subs = {index}; y = subsasgn(y,s,asin(subsref(x,s)));
        %AAAA  Matlab bug fix
      end
      if rndold~=0
        setround(rndold)
      end
      return
    end
  end

  % input x real and full
  y = x;
  if any(index(:))                       % exceptional arguments
    y.inf(index) = NaN;
    y.sup(index) = NaN;
  end
  index = ~index(:);                     % nonexceptional arguments
  global INTLAB_INTVAL_STDFCTS

  if INTLAB_INTVAL_STDFCTS               % rigorous standard function
    % in this section asin is only executed for non-exceptional cases
  
    xinf = x.inf(:);
    xsup = x.sup(:);

    % switch off warning since exceptional values may occur
    wng = warning;
    warning off

    IndexInfPos = ( xinf>=0 ) & index;
    len1 = sum(IndexInfPos);
    IndexSupNeg = ( xsup<=0 ) & index;

    Y = asin_pos_( [ xinf(IndexInfPos) ; -xsup(IndexSupNeg) ] , -1 , 0 );
    y.inf(IndexInfPos) = Y(1:len1);
    y.sup(IndexSupNeg) = -Y( len1+1 : end );

    IndexInfNeg = ( xinf<0 ) & index;
    len1 = sum(IndexInfNeg);
    IndexSupPos = ( xsup>0 ) & index;

    Y = asin_pos_( [ -xinf(IndexInfNeg) ; xsup(IndexSupPos) ] , 1 , 0 );
    y.inf(IndexInfNeg) = -Y(1:len1);
    y.sup(IndexSupPos) = Y( len1+1 : end );

    % restore warning status
    warning(wng);    

  else                                 % approximate standard function

    global INTLAB_INTVAL_EPSSTDFCTS
    setround(0)
    if any(index(:))
      yinf = asin(x.inf(index));
      y.inf(index) = yinf - INTLAB_INTVAL_EPSSTDFCTS*abs(yinf);
      ysup = asin(x.sup(index));
      y.sup(index) = ysup + INTLAB_INTVAL_EPSSTDFCTS*abs(ysup);
    end
  end

  setround(rndold)
