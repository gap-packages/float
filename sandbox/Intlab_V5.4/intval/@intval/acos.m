function y = acos(x)
%ACOS         Implements  acos(x)  for intervals
%
%   y = acos(x)
%
%interval standard function implementation
%

% written  12/30/98     S.M. Rump
% modified 08/31/99     S.M. Rump  complex allowed, sparse input,
%                                  pos/neg split, major revision,
%                                  improved accuracy, corrected
%                                  branchcut
% modified 09/02/00     S.M. Rump  rounding unchanged after use
% modified 04/04/04     S.M. Rump  set round to nearest for safety
%                                    accelaration for sparse input
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 12/04/05     S.M. Rump  'realstdfctsexcptnignore' added and
%                                     some improvements
%

  if issparse(x)
    index = ( x==0 );
    if any(index(:))                    % treat zero indices
      global INTLAB_INTVAL_STDFCTS_PI
      PI2 = intval(INTLAB_INTVAL_STDFCTS_PI.PI2INF,INTLAB_INTVAL_STDFCTS_PI.PI2SUP,'infsup');
      y = intval(repmat(PI2,size(x)));
      index = ~index;
      %VVVV  y(index) = acos(full(x(index)));
      s.type = '()'; s.subs = {index}; y = subsasgn(y,s,acos(full(subsref(x,s))));
      %AAAA  Matlab bug fix
    else
      y = acos(full(x));
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
%   y = -i * log( x + sqrt(x.^2-1) );
    y = i * acosh(x);
    index = ( real(y.mid) < 0 );
    y.mid(index) = -y.mid(index);
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
        warning('ACOS: Real interval input out of range changed to be complex')
      end
      y = x;
      %VVVV  y(index) = acos(cintval(x(index)));
      s.type = '()'; s.subs = {index}; y = subsasgn(y,s,acos(cintval(subsref(x,s))));
      %AAAA  Matlab bug fix
      index = ~index;
      if any(index(:))
        %VVVV  y(index) = acos(x(index));
        s.type = '()'; s.subs = {index}; y = subsasgn(y,s,acos(subsref(x,s)));
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
  nonexception = ~index(:);              % nonexceptional arguments
  global INTLAB_INTVAL_STDFCTS

  if INTLAB_INTVAL_STDFCTS               % rigorous standard function
    % in this section acos is only executed for non-exceptional cases

    xinf = x.inf(:);
    xsup = x.sup(:);

    % switch off warning since exceptional values may occur
    wng = warning;
    warning off

    index = ( xsup>=0 ) & nonexception;
    if any(index)
      y.inf(index) = - asin_pos_( xsup(index) , 1 , -1 );
    end

    index = ( xsup<0 ) & nonexception;
    if any(index)
      y.inf(index) = asin_pos_( -xsup(index) , -1 , 1 );
    end

    index = ( xinf>=0 ) & nonexception;
    if any(index)
      y.sup(index) = - asin_pos_( xinf(index) , -1 , -1 );
    end

    index = ( xinf<0 ) & nonexception;
    if any(index)
      y.sup(index) = asin_pos_( -xinf(index) , 1 , 1 );
    end

    % restore warning status
    warning(wng);

    y.inf = reshape(y.inf,size(x.inf));
    y.sup = reshape(y.sup,size(x.sup));
    
  else                                 % approximate standard function

    global INTLAB_INTVAL_EPSSTDFCTS
    setround(0)
    if any(nonexception(:))
      yinf = acos(x.sup(nonexception));
      y.inf(nonexception) = yinf - INTLAB_INTVAL_EPSSTDFCTS*abs(yinf);
      ysup = acos(x.inf(nonexception));
      y.sup(nonexception) = ysup + INTLAB_INTVAL_EPSSTDFCTS*abs(ysup);
    end
  end

  setround(rndold)
