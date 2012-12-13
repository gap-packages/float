function [res,exact,R,p] = AccSum(p,K,rnd,rho)
%AccSum       Accurate summation with faithful, to nearest or K-fold rounding
%
%   res = accsum(p)
%
%For real or complex input vector, dense or sparse, the result res is
%sum(p) faithfully rounded. Input vector p must not be of type intval.
%
%   res = accsum(p,0)
%
%The result res is equal to sum(p) rounded to the nearest floating-point number.
%
%   res = accsum(p,0,rnd)     
%
%Additionally, for rounding to nearest a rounding parameter can be specified. 
%The result is rounded downwards for rnd=-1, and rounded upwards for rnd=1.
%
%   res = accsum(p,K)
%
%The result res is a vector of length K such that res is a non-overlapping
%sequence, and sum(res) is an approximation of sum(p) of K-fold accuracy. 
%Default is K=1.
%
%   res = accsum(p,inf)
%
%The result res is a vector of necessary length such that res is a non-overlapping
%sequence, and sum(res)=sum(p).
%
%   [res,exact] = accsum(p,K)
%
%The optional output parameter exact is equal to 1 iff sum(res)=sum(p). For K=inf
%always exact=1. That means accsum provides an easy way to check whether the exact
%sum is a floating-point number.
%
%A simple way to compute an interval including sum(p) is
%
%   [res,exact] = accsum(p,K);
%   if exact
%     resinf = res(K);
%     ressup = res(K);
%   else
%     resinf = pred(res(K));
%     ressup = succ(res(K));
%   end
%
%This is for a faithfully rounded result. Note that the interval is represented by
%   sum(res(1:K-1)) + intval(resinf,ressup);
%This interval is generally 2 bits wide unless res=sum(p). For a rounded to nearest 
%result one can use
%
%   [resinf,exact] = accsum(p,0,-1);
%   if exact
%     ressup = resinf;
%   else
%     ressup = succ(resinf);
%   end
%
%The interval infsup(resinf,ressup) is maximally 1 bit wide. Moreover, resinf=ressup
%iff sum(p) is a floating-point number. 
%
%Result is set to NaN if overflow occurs.
%
%Maximum number of nonzero elements per sum is limited to 67108862, which
%seems sufficient for Matlab. More elements can be treated, see our paper (Huge length).
%
%Implements various algorithms in
%  S.M. Rump, T. Ogita, and S. Oishi. Accurate Floating-Point Summation. 
%     41 pages, submitted for publication.
%
%Let x be a vector of floating-point numbers of length n. 
%The following tables display timing in musec
%   t1  for ordinary recursive summation sum(x)
%   t2  for sum_(x), result as if computed in quadruple precision
%   t3  for accsum(x), true result faithfully rounded
%Note that sum_(x) and accsum(x) severely suffer from interpretation
%overhead. We obtain on a 1.2 GHz Pentium IV for cond(sum(x))~1e12
%
%    n      t1    t2    t3   t2/t1  t3/t1 
%-----------------------------------------
%   50       2    95   163    56.2   96.5
%  100       2   100   170    49.4   83.8
%  200       3   110   184    40.3   67.3
%  500       5   142   226    29.1   46.3
% 1000       8   206   310    24.5   36.9
%
%for cond(sum(x))~1e20
%
%    n      t1    t2    t3   t2/t1  t3/t1 
%-----------------------------------------
%   50       2    95   164    55.8   96.6
%  100       2   100   171    49.1   84.0
%  200       3   110   184    40.3   67.3
%  500       5   142   226    29.1   46.3
% 1000       8   205   346    24.3   41.1
%
%and for cond(sum(x))~1e30
%
%    n      t1    t2    t3   t2/t1  t3/t1 
%-----------------------------------------
%   50       2    94   182    56.0  108.1
%  100       2   100   190    49.3   93.4
%  200       3   110   342    40.4   74.4
%  500       5   142   252    29.1   51.4
% 1000       8   205   345    24.4   41.1
%
%Note that for different condition numbers the following number of
%correct digits can be expected:
%
%  cond(sum(x))   sum(x)   sum_(x)   accsum(x)
%----------------------------------------------
%     1e12          4        16         16
%     1e20          -        12         16
%     1e30          -         2         16
%
%CAUTION: !!! THIS IMPLEMENTATION SUFFERS SEVERELY FROM INTERPRETATION OVERHEAD !!!
%!!! IT IS INCLUDED TO SHOW THE PRINCIPLES OF THE NEW METHOD !!!
%!!! DO NOT USE FOR LARGE DIMENSIONS !!!
%

%Extra input and output parameters for use in AccSumK, NearSum
%Internal calls always with 4 parameters
%

% written  12/12/05     S.M. Rump
%

  res = 0;
  exact = 1;
  R = 0;
  if isempty(p)
    return
  end

  if nargin~=4                      % external call: various checks
    
    % check size
    sizep = size(p);
    if length(sizep)>2
      error('accsum not defined for multi-dimensional arrays.')
    end
    if ( sizep(1)~=1 ) & ( sizep(2)~=1 )
      error('accsum only for vector input')
    end
    
    % check interval input
    if isa(p,'intval')
      error('accsum not defined for interval input')
    end

    % default K=1
    if ( nargin<2 ) | isempty(K)
      K = 1;
    end
    
    % default rnd=0
    if ( nargin<3 ) | isempty(rnd)
      rnd = 0;
    end

    % check rnd
    if ( K~=0 ) & ( rnd~=0 )
      error('rounding ~=0 only for K=0')
    end

    % take care of complex input
    if ~isreal(p)
      [resreal,exactreal] = accsum(real(p),K,rnd,0);
      [resimag,exactimag] = accsum(imag(p),K,rnd,0);
      exact = exactreal & exactimag;
      res = resreal + sqrt(-1)*resimag;
      return
    end

    % real vector input
    rho = 0;
  end

  % input real, compute sum(p)
  
  % K-fold accuracy
  if K>1                              % must be rounding to nearest
    if ~isinf(K)
      res = zeros(1,K);
    end
    for k=1:K-1
      [res(k),dummy,rho,p] = accsum(p,1,0,rho);
      if isnan(res(k))
        res = repmat(NaN,size(res));
        return
      end
      if ( abs(res(k))<=realmin ) & isinf(K)
        if res(k)==0
          res = res(1:k-1);
        end
        return
      end
      if k>2                          % eliminate zeros
        p = p(p~=0);
      end
    end
    [res(K),exact] = accsum(p,1,0,rho);
    return
  end
  
  e = 1e-30;
  if 1+e==1-e                           % fast check for rounding to nearest
    rndold = 0;
  else
    rndold = getround;
    setround(0)
  end

  % rounding to nearest
  if K==0                             % rnd maybe -1 or 0 or +1
    % let S:=sum(p)
    [res,dummy,R,p] = accsum(p,1,0,0);   % S = res + R + sum(p)  for new p
    [delta,dummy,R,p] = accsum(p,1,0,R); % delta + R + sum(p) = S - res  for new R,p
                                      % sign(delta) = sign(S-res)
    if delta==0                       % result exact: res=S in any rounding
      if rndold~=0, setround(rndold), end
      return
    end
    exact = 0;                        % result not exact
    
    if rnd~=0                         % rounding downwards or upwards
      if sign(delta)==rnd             % res on wrong side
        if rnd==1
          res = succ(res);
        else
          res = pred(res);
        end
      end
      if rndold~=0, setround(rndold), end
      return
    end
    
    % sign(delta) = sign(S-res)
    % compute nearest neighbor resp in direction sign(delta), rnd=0
    if delta>0
      resp = succ(res);
    else
      resp = pred(res);
    end
    mu = (resp-res)/2;
    if abs(delta)>abs(mu)
      res = resp;
    elseif abs(delta)==abs(mu)
      delta = accsum(p,1,0,R);
      if delta==0
        res = res + mu;
      elseif sign(delta)==sign(mu)
        res = resp;
      end
    end
    if rndold~=0, setround(rndold), end
    return
  end
  
  % the standard case: real vector input, K=1
  if issparse(p)
    n = nnz(p);                         % initialization
  else
    n = length(p);
  end
  tau1 = 0;
  tau2 = 0;  
  mu = full(max(abs(p)));               % abs(p_i) <= mu; full: avoid Matlab bug
  if ( n==0 ) | ( mu==0 )               % no or only zero summands
    res = rho;                          % result exactly zero in any rounding
    if rndold~=0, setround(rndold), end
    return
  end
  Ms = 2^nextpow2(n+2);                 % n+2 <= 2^M
  if Ms^2*eps>1
    error('vector length n too large for accsum; huge n not implemented')
  end
  sigma = Ms*2^nextpow2(mu);            % first extraction unit
  if isinf(sigma) | isnan(sigma)        % overflow, could be avoided with scaling
    res = NaN;
    exact = 0;
    if rndold~=0, setround(rndold), end
    return
  end
  phi = 2^(-53)*Ms;                     % factor to decrease sigma
  factor = 2*phi*Ms;                    % factor for sigma check

  t = rho;
  while 1
    q = ( sigma + p ) - sigma;          % [tau,p] = ExtractVector(sigma,p);
    tau = sum(q);                       % sum of leading terms
    p = p - q;                          % remaining terms
    tau1 = t + tau;                     % new approximation
    if ( abs(tau1)>=factor*sigma ) | ( sigma<=realmin )      
      tau2 = tau - ( tau1 - t );        % [tau1,tau2] = FastTwoSum(t,tau)
      res = tau1 + ( tau2 + sum(p) );   % faithfully rounded final result
      R = tau2 - ( res - tau1 );        % only for K-fold result
      if rndold~=0, setround(rndold), end
      if nargout>=2
        exact = ( R==0 ) & ~any(p);
      end
      return
    end
    t = tau1;                           % sum t+tau exact
    if t==0                             % accelerate case sum(p)=0
      [res,exact,R,p] = accsum(p(p~=0),K,0,0);  % recursive call, zeros eliminated
      if rndold~=0, setround(rndold), end
      return
    end
    sigma = phi*sigma;                  % new extraction unit
  end
    