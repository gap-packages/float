function c = rdivide(a,b)
%RDIVIDE      Interval elementwise right division a ./ b
%

% written  10/16/98     S.M. Rump
% modified 11/30/98     S.M. Rump  modified for infinity
% modified 06/06/98     S.M. Rump  modified for NaN+Nan*i
% modified 09/02/00     S.M. Rump  rounding unchanged after use
% modified 04/04/04     S.M. Rump  set round to nearest for safety
%                                    remove check for 'double'
%                                    take care of Matlab sparse Inf/NaN bug
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 11/03/05     S.M. Rump  sparse flag corrected
% modified 11/20/05     S.M. Rump  fast check for rounding to nearest
% modified 02/11/06     S.M. Rump  SparseInfNanFlag removed
%                                    improved performance
% modified 05/23/06     S.M. Rump  sparse Inf/NaN bug corrected in Version 7.2+
% modified 12/03/06     S.M. Rump  Sparse Bug global flag (thanks to Arnold)
%

  e = 1e-30;
  if 1+e==1-e                           % fast check for rounding to nearest
    rndold = 0;
  else
    rndold = getround;
  end
  
  global INTLAB_SPARSE_BUG
  if INTLAB_SPARSE_BUG
    % take care of Matlab sparse NaN bug
    if issparse(a)
      index = isnan(b);
      if any(index(:))
        %VVVV Matlab V5.2 bug fix:  a(index) = NaN;
        s.type = '()'; s.subs = {index}; a = subsasgn(a,s,NaN);
        %AAAA Matlab V5.2 bug fix
      end
    end
  end
   
  if isa(a,'intval')
    acomplex = a.complex;
  else
    acomplex = ~isreal(a);
  end
  b = intval(b);                        % make sure b is interval

  ws = warning;
  warning off

  if acomplex | b.complex               % numerator complex
    if ~b.complex                       % denominator is real
      c = a.*(1./b);
      return
    end
    x = real(b.mid);                    % denominator is complex
    y = imag(b.mid);
    setround(-1)
    Ninf = x.*x + y.*y + (-b.rad).*b.rad;
    index = ( Ninf<=0 );
    setround(1)
    Nsup = x.*x + y.*y + (-b.rad).*b.rad;
    x2 = max( x./Ninf , x./Nsup );
    y2 = max( y./Ninf , y./Nsup );
    setround(-1)
    x1 = max( x./Ninf , x./Nsup );
    y1 = max( y./Ninf , y./Nsup );
    c1 = x1 - j*y2;
    setround(1)
    c2 = x2 - j*y1;
    binv.complex = 1;
    binv.inf = [];
    binv.sup = [];
    binv.mid = c1 + 0.5*(c2-c1);
    binv.rad = abs( binv.mid - c1 ) + b.rad./Ninf;
    index = index | ( binv.rad<0 );
    if any(index(:))
      binv.mid(index) = NaN + NaN*j;
      binv.rad(index) = NaN;
    end
    binv = class(binv,'intval');
    c = a.*binv;
  else                                        % both a and b real
    c.complex = 0;
    if ~isa(a,'intval')                       % R ./ IR
      setround(-1)
      c.inf = min( a./b.inf , a./b.sup );
      setround(1)
      c.sup = max( a./b.inf , a./b.sup );
      index = ( b.inf<=0 ) & ( b.sup>=0 );    % 0 in b
      if any(index(:))
        c.inf(index) = -inf;
        c.sup(index) =  inf;
        index = index & ( a==0 );             % 0/0
        if any(index(:))
          c.inf(index) = NaN;
          c.sup(index) = NaN;
        end
      end
    elseif ~isa(b,'intval')                   % IR ./ R
      setround(-1)
      c.inf = min( a.inf./b , a.sup./b );
      setround(1)
      c.sup = max( a.inf./b , a.sup./b );
      index = ( b==0 );
      if any(index(:))                        % 0/0
        c.inf(index) = -inf;
        c.sup(index) =  inf;
        index = index & ( a.inf<=0 ) & ( a.sup>=0 );
        if any(index(:))
          c.inf(index) = NaN;
          c.sup(index) = NaN;
        end
      end
    else                                      % IR ./ IR
      setround(-1)
      c.inf = min( a.inf./b.inf , a.inf./b.sup );
      c.inf = min( c.inf , a.sup./b.inf );
      c.inf = min( c.inf , a.sup./b.sup );
      setround(1)
      c.sup = max( a.inf./b.inf , a.inf./b.sup );
      c.sup = max( c.sup , a.sup./b.inf );
      c.sup = max( c.sup , a.sup./b.sup );
      index = ( b.inf<=0 ) & ( b.sup>=0 );    % 0 in b
      if any(index(:))
        if prod(size(b.inf))==1
          c.inf = -inf*ones(size(c.inf));
          c.sup = -c.inf;
        else
          c.inf(index) = -inf;
          c.sup(index) =  inf;
        end
        index = index & ( a.inf<=0 ) & ( a.sup>=0 );   % 0./0
        if any(index(:))
          c.inf(index) = NaN;
          c.sup(index) = NaN;
        end
      end
    end
    c.mid = [];
    c.rad = [];
    c = class(c,'intval');
  end
  
  if issparse(b) & ( prod(size(c))~=1 )
    c = sparse(c);
  end

  warning(ws)
  setround(rndold)
  