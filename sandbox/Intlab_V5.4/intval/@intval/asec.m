function y = asec(x)
%ASEC         Implements  asec(x)  for intervals
%
%   y = asec(x)
%
%interval standard function implementation
%

% written  10/16/98     S.M. Rump
% modified 12/30/98     S.M. Rump  improved speed and use asin
% modified 09/12/99     S.M. Rump  complex allowed, sparse input,
%                                  major revision, improved accuracy near 1
% modified 09/02/00     S.M. Rump  rounding unchanged after use
% modified 01/20/03     S.M. Rump  Matlab sqrt fixed
% modified 04/04/04     S.M. Rump  set round to nearest for safety
%                                    accelaration for sparse input
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 12/04/05     S.M. Rump  'realstdfctsexcptnignore' added and
%                                     some improvements
%

  if issparse(x)
    index = ( x==0 );
    if any(index(:))                    % treat zero indices
      y = intval(repmat(NaN,size(x)));
      index = ~index;
      %VVVV  y(index) = asec(full(x(index)));
      s.type = '()'; s.subs = {index}; y = subsasgn(y,s,asec(full(subsref(x,s))));
      %AAAA  Matlab bug fix
    else
      y = asec(full(x));
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
    y = acos( 1./x );
    if rndold~=0
      setround(rndold)
    end
    return
  end
  
  % input x real and full
  % real range of definition:  [-inf,-1] and [1,inf]
  % take care for intersection( x , (-1,1) ) nonempty
  global INTLAB_INTVAL_STDFCTS_EXCPTN
  if INTLAB_INTVAL_STDFCTS_EXCPTN==3    % ignore input out of range
    global INTLAB_INTVAL_STDFCTS_EXCPTN_
    index = ( x.inf<=-1 ) & ( abs(x.sup)<1 );   % (partially) exceptional indices
    if any(index(:))
      x.sup(index) = -1;
      INTLAB_INTVAL_STDFCTS_EXCPTN_ = 1;
    end
    index = ( abs(x.inf)<1 ) & ( x.sup>=1 );    % (partially) exceptional indices
    if any(index(:))
      x.inf(index) = 1;
      INTLAB_INTVAL_STDFCTS_EXCPTN_ = 1;
    end
    % indices with -1 and 1 in input
    index = ( x.inf<=-1 ) & ( x.sup>=1 );   
    if any(index(:))
      INTLAB_INTVAL_STDFCTS_EXCPTN_ = 1;
      x.inf(index) = 1;
      x.sup(index) = -1;
    end
    % indices with no intersection with real range of definition
    index = ( abs(x.inf)<1 ) & ( abs(x.sup)<1 );   % completely exceptional indices
    if any(index(:))
      INTLAB_INTVAL_STDFCTS_EXCPTN_ = 1;
    end
  else
    index = ( abs(x.inf)<1 ) | ( abs(x.sup)<1 ) | ( ( x.inf<0 ) & ( x.sup>0 ) );
    if ( INTLAB_INTVAL_STDFCTS_EXCPTN<2 ) & any(index(:))
      if INTLAB_INTVAL_STDFCTS_EXCPTN==1
        warning('ASEC: Real interval input out of range changed to be complex')
      end
      y = x;
      %VVVV  y(index) = acos(cintval(1./x(index)));
      s.type = '()'; s.subs = {index}; y = subsasgn(y,s,acos(cintval(1./subsref(x,s))));
      %AAAA  Matlab bug fix
      index = ~index;
      if any(index(:))
        %VVVV  y(index) = acos(1./x(index));
        s.type = '()'; s.subs = {index}; y = subsasgn(y,s,acos(1./subsref(x,s)));
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

  if any(index(:))                     % exceptional arguments
    y.inf(index) = NaN;
    y.sup(index) = NaN;
  end
  index = ~index;                      % nonexceptional arguments
  global INTLAB_INTVAL_STDFCTS
  
  if INTLAB_INTVAL_STDFCTS             % rigorous standard function

    % treat positive intervals
    index1 = index & ( x.inf>0 );
    if any(index1(:))
      y.inf(index1) = asec_pos(x.inf(index1),-1);
      y.sup(index1) = asec_pos(x.sup(index1),1);
    end

    % treat negative intervals
    index1 = index & ( x.sup<0 );
    if any(index1(:))
      global INTLAB_INTVAL_STDFCTS_PI
      yy = asec_pos(-x.inf(index1),1);
      setround(-1)
      y.inf(index1) = INTLAB_INTVAL_STDFCTS_PI.PIINF - yy;
      yy = asec_pos(-x.sup(index1),-1);
      setround(1)
      y.sup(index1) = INTLAB_INTVAL_STDFCTS_PI.PISUP - yy;
    end

  else                                 % approximate standard function
    
    global INTLAB_INTVAL_EPSSTDFCTS
    setround(0)
    if any(index(:))
      yinf = asec(x.inf(index));
      y.inf(index) = yinf - INTLAB_INTVAL_EPSSTDFCTS*abs(yinf);
      ysup = asec(x.sup(index));
      y.sup(index) = ysup + INTLAB_INTVAL_EPSSTDFCTS*abs(ysup);
    end
  end

  setround(rndold)


function y = asec_pos(x,rnd)
% local asec for double vector x>=1 with rounding corresponding to rnd
%

  y = x;
  setround(rnd)

  index = ( x<1.5 );              % 1 <= x < 1.5
  if any(index(:))
    e = x(index) - 1;             % difference exact because x near 1
    e = sqrt_rnd( e.*(2+e) , rnd );
    y(index) = atan_pos(e(:),rnd);
  end

  index1 = ( x>1e17 );            % x > 1e17
  if any(index1(:))
    e = x(index1) - eps;
    y(index1) = atan_pos(e(:),rnd);
  end

  index = ~( index | index1 );    % 1.5 <= x <= 1e17
  if any(index(:))
    e = x(index);
    e = sqrt_rnd(e.*e-1,rnd);
    y(index) = atan_pos(e(:),rnd);
  end
