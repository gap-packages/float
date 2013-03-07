function y = acosh(x)
%ACOSH        Implements  acosh(x)  for intervals
%
%   y = acosh(x)
%
%interval standard function implementation
%

% written  12/30/98     S.M. Rump
% modified 08/31/99     S.M. Rump  complex allowed, array input, sparse input
%                                  major revision, improved accuracy
% modified 09/02/00     S.M. Rump  rounding unchanged after use
% modified 01/20/03     S.M. Rump  Matlab sqrt fixed
% modified 04/04/04     S.M. Rump  set round to nearest for safety
%                                    accelaration for sparse input
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 12/04/05     S.M. Rump  'realstdfctsexcptnignore' added and
%                                     some improvements, extreme values for 
%                                     approximate part

%

  if issparse(x)
    index = ( x==0 );
    if any(index(:))                    % treat zero indices
      global INTLAB_INTVAL_STDFCTS_PI
      global INTLAB_INTVAL_STDFCTS_EXCPTN
      if INTLAB_INTVAL_STDFCTS_EXCPTN==3   % ignore input out of range
        y = intval(repmat(NaN,size(x)));
        global INTLAB_INTVAL_STDFCTS_EXCPTN_
        INTLAB_INTVAL_STDFCTS_EXCPTN_ = 1;
      elseif INTLAB_INTVAL_STDFCTS_EXCPTN==2   % result NaN for input out of range
        y = intval(repmat(NaN,size(x)));
      else
        if INTLAB_INTVAL_STDFCTS_EXCPTN==1     % result complex for input out of range
          warning('ACOSH: Real interval input out of range changed to be complex')
        end
        iPI2 = intval(j*INTLAB_INTVAL_STDFCTS_PI.PI2MID,INTLAB_INTVAL_STDFCTS_PI.PI2RAD,'midrad');
        y = intval(repmat(iPI2,size(x)));
      end
      index = ~index;
      %VVVV  y(index) = acosh(full(x(index)));
      s.type = '()'; s.subs = {index}; y = subsasgn(y,s,acosh(full(subsref(x,s))));
      %AAAA  Matlab bug fix
    else
      y = acosh(full(x));
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

  if x.complex
    if rndold~=0
      setround(rndold)
    end
    y = 2 * log( sqrt((x+1)/2) + sqrt((x-1)/2) );  
    return
  end

  % input x real and full
  % real range of definition:  [1,inf]
  global INTLAB_INTVAL_STDFCTS_EXCPTN
  index = ( x.inf < 1 );                % (partially) exceptional indices
  if INTLAB_INTVAL_STDFCTS_EXCPTN==3    % ignore input out of range
    if any(index(:))
      x.inf(index) = 1;
      global INTLAB_INTVAL_STDFCTS_EXCPTN_   
      INTLAB_INTVAL_STDFCTS_EXCPTN_ = 1;
    end
    index = index & ( x.sup<1);         % completely exceptional indices
  else
    if ( INTLAB_INTVAL_STDFCTS_EXCPTN<2 ) & any(index(:))
      if INTLAB_INTVAL_STDFCTS_EXCPTN==1
        warning('ACOSH: Real interval input out of range changed to be complex')
      end
      y = x;
      %VVVV  y(index) = acosh(cintval(x(index)));
      s.type = '()'; s.subs = {index}; y = subsasgn(y,s,acosh(cintval(subsref(x,s))));
      %AAAA  Matlab bug fix
      index = ~index;
      if any(index(:))
        %VVVV  y(index) = acosh(x(index));
        s.type = '()'; s.subs = {index}; y = subsasgn(y,s,acosh(subsref(x,s)));
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
  global INTLAB_INTVAL_STDFCTS

  if any(index(:))                      % exceptional arguments
    y.inf(index) = NaN;
    y.sup(index) = NaN;
    index = ~index;                     % nonexceptional arguments
    if any(index(:))
      if INTLAB_INTVAL_STDFCTS          % rigorous standard function
        y.inf(index) = acoshrnd(x.inf(index),-1);
        y.sup(index) = acoshrnd(x.sup(index),1);
      else                              % approximate standard function
        global INTLAB_INTVAL_EPSSTDFCTS
        setround(0)
        yinf = acosh(x.inf(index));
        y.inf(index) = yinf - INTLAB_INTVAL_EPSSTDFCTS*min(realmax,abs(yinf));
        ysup = acosh(x.sup(index));
        y.sup(index) = ysup + INTLAB_INTVAL_EPSSTDFCTS*min(realmax,abs(ysup));
      end
    end
  else                                  % no exceptional arguments
    if INTLAB_INTVAL_STDFCTS            % rigorous standard function
      y.inf = acoshrnd(x.inf,-1);
      y.sup = acoshrnd(x.sup,1);
    else                                % approximate standard function
      global INTLAB_INTVAL_EPSSTDFCTS
      setround(0)
      y.inf = acosh(x.inf);
      y.inf = y.inf - INTLAB_INTVAL_EPSSTDFCTS*min(realmax,abs(y.inf));
      y.sup = acosh(x.sup);
      y.sup = y.sup + INTLAB_INTVAL_EPSSTDFCTS*min(realmax,abs(y.sup));
    end
  end

  setround(rndold)

  

function y = acoshrnd(x,rnd)
% rigorous acosh for nonnegative x with rounding corresponding to rnd

  y = x;

  % huge arguments: use proper scaling
  index = ( x>1e10 );
  if any(index(:))
    setround(rnd)
    y(index) = log_rnd( 2*x(index) + eps*(rnd-1) , rnd );
  end
  Index = ~index;

  % large arguments: use acosh(x) = log( x + sqrt(x^2-1) )
  index = Index & ( x>1.25 );
  if any(index(:))
    X = x(index);
    setround(rnd)
    y(index) = log_rnd( X + sqrt_rnd(sqr(X)-1,rnd) , rnd );
  end
  Index = Index & ( ~index );

  % small arguments: use acosh(x) = log( x + sqrt(E*(2+E)) )  for  x = 1+E
  index = Index & ( ~index );          % 1 <= x <= 1.25
  if any(index(:))
    X = x(index);
    E = X-1;              % exactly representable because X close to 1
    setround(rnd)
    E = E + sqrt_rnd( E.*(2+E) , rnd );
    y(index) = log_1(E,rnd);     % 0 <= E <= 1
  end
