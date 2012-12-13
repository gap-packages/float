function c = midradcmplx(a,r)
%MIDRADCMPLX  Initialization of complex interval by midpoint and radius
%  computed such that <a,r> is enclosed in interval  c
%
%   c = midradcmplx(a,r)
%
%***has been replaced by cintval***
%Output interval is complex, i.e.  c = { z in C :  |z-a| <= r }
%For complex a, this is the same as midrad(a,r).
%For real a, midrad(a,r) produces the real interval  { x in R :  |x-a| <= r }
%

% written  11/23/98     S.M. Rump
% modified 06/24/99     S.M. Rump  check sparsity, multi-dimensional arrays
% modified 04/04/04     S.M. Rump  set round to nearest for safety
% modified 04/06/05     S.M. Rump  rounding unchanged
%

  index = ( r<0 );
  if ~isreal(r) | any(index(:))
    error('invalid radius in call of midradcmplx')
  end

  if issparse(a)~=issparse(r)
    error('midpoint and radius must both be or none of them be sparse')
  end

  c = intval(a,r,'midrad');
