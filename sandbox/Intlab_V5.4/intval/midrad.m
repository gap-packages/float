function c = midrad(a,r)
%MIDRAD       Initialization of interval by midpoint and radius
%  computed such that <a,r> is enclosed in interval  c
%
%   c = midrad(a,r)
%

% written  10/16/98     S.M. Rump
% modified 06/24/99     S.M. Rump  check sparsity, multi-dimensional arrays
% modified 09/02/00     S.M. Rump  rounding unchanged after use
% modified 11/16/02     S.M. Rump  sparse radius
% modified 04/04/04     S.M. Rump  set round to nearest for safety
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 11/20/05     S.M. Rump  fast check for rounding to nearest
%

  index = any( r<0 );                   % take care of huge matrices
  if ~isreal(r) | any(index(:))
    error('invalid radius in call of midrad')
  end

  if ( prod(size(r))~=1) & ( issparse(a)~=issparse(r) )
    error('midpoint and radius must both be or none of them be sparse')
  end

  if isreal(a)                     % real interval (inf/sup representation)
    e = 1e-30;
    if 1+e==1-e                    % fast check for rounding to nearest
      rndold = 0;
    else
      rndold = getround;
      setround(0)
    end
    setround(-1)
    cinf = a - r;
    setround(1)
    csup = a + r;
    setround(rndold)               % set rounding to previous value
    c = intval(cinf,csup,'infsup');
  else                             % complex interval (mid/rad representation)
    c = intval(a,r,'midrad');
  end
