function y = acoth(x)
%ACOTH        Implements  acoth(x)  for intervals
%
%   y = acoth(x)
%
%interval standard function implementation
%

% written  10/16/98     S.M. Rump
% modified 12/30/98     S.M. Rump  improved speed and use atanh
% modified 08/31/99     S.M. Rump  complex allowed, sparse input,
%                                  major revision, improved accuracy near 1
% modified 09/02/00     S.M. Rump  rounding unchanged after use
% modified 04/04/04     S.M. Rump  set round to nearest for safety
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 12/04/05     S.M. Rump  'realstdfctsexcptnignore' added and
%                                     some improvements, extreme values 
%                                     for approximate part

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
          warning('ACOTH: Real interval input out of range changed to be complex')
        end
        iPI2 = intval(j*INTLAB_INTVAL_STDFCTS_PI.PI2MID,INTLAB_INTVAL_STDFCTS_PI.PI2RAD,'midrad');
        y = intval(repmat(iPI2,size(x)));
      end
      index = ~index;
      %VVVV  y(index) = acoth(full(x(index)));
      s.type = '()'; s.subs = {index}; y = subsasgn(y,s,acoth(full(subsref(x,s))));
      %AAAA  Matlab bug fix
    else
      y = acoth(full(x));
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
    y = atanh( 1./x );
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
        warning('ACOTH: Real interval input out of range changed to be complex')
      end
      y = x;
      %VVVV  y(index) = atanh(cintval(1./x(index)));
      s.type = '()'; s.subs = {index}; y = subsasgn(y,s,atanh(cintval(1./subsref(x,s))));
      %AAAA  Matlab bug fix
      index = ~index;
      if any(index(:))
        %VVVV  y(index) = atanh(1./x(index));
        s.type = '()'; s.subs = {index}; y = subsasgn(y,s,atanh(1./subsref(x,s)));
        %AAAA  Matlab bug fix
      end
      index = ( x==0 );
      if any(index(:))
        global INTLAB_INTVAL_STDFCTS_PI
        iPI2 = intval(j*INTLAB_INTVAL_STDFCTS_PI.PI2MID,INTLAB_INTVAL_STDFCTS_PI.PI2RAD,'midrad');
        %VVVV  y(index) = iPI2;
        s.type = '()'; s.subs = {index}; y = subsasgn(y,s,iPI2);
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
  wng = warning;                         % get current warning mode
  warning off
  global INTLAB_INTVAL_STDFCTS
  
  if any(index(:))                       % exceptional arguments
    y.inf(index) = NaN;
    y.sup(index) = NaN;
  end
  index = ~index;                        % nonexceptional arguments
  
  if INTLAB_INTVAL_STDFCTS               % rigorous standard function
    
    % treat positive intervals
    index1 = index & ( x.inf>0 );
    if any(index1(:))
      y.inf(index1) = acoth_pos(x.sup(index1),-1);
      y.sup(index1) = acoth_pos(x.inf(index1),1);
    end
    
    % treat negative intervals
    index1 = index & ( x.sup<0 );
    if any(index1(:))
      y.inf(index1) = - acoth_pos(-x.sup(index1),1);
      y.sup(index1) = - acoth_pos(-x.inf(index1),-1);
    end
    
  else                                   % approximate standard function
    
    global INTLAB_INTVAL_EPSSTDFCTS
    setround(0)
    if any(index(:))
      yinf = acoth(x.sup(index));
      y.inf(index) = yinf - INTLAB_INTVAL_EPSSTDFCTS*min(realmax,abs(yinf));
      ysup = acoth(x.inf(index));
      y.sup(index) = ysup + INTLAB_INTVAL_EPSSTDFCTS*min(realmax,abs(ysup));
    end
    
  end

  warning(wng)                           % restore warning mode
    
  setround(rndold)

  

function y = acoth_pos(x,rnd)
% local acoth for double vector x>=1 with rounding corresponding to rnd
%

  y = x;

  index = ( x<4 );
  if any(index(:))             % 1 <= x <= 4
    setround(rnd)              % acoth(x) = log( 1 + 2/(x-1) )
    e = x(index) - 1;          % e w/o rounding error
    e = 1 + 2./e;
    y(index) = log_rnd( e , rnd ) / 2;
    y(x==1) = inf;
  end

  index = ~index;              % x >= 4, difference x-1 not necessarily exact
  if any(index(:))             % acoth(x) = atanh(1/x)
    setround(rnd)
    e = 1./x(index);
    y(index) = atanh_pos( e , rnd );
  end
