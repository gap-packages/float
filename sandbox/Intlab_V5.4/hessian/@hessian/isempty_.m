function r = isempty_(c)
%ISEMPTY_     Returns array of 1's for empty components in the mathematical sense
%
%   r = isempty_(c)
%
%There two possibilities for an interval to be empty in the mathematical sense:
%  - It is an empty quantity [] in the sense of Matlab or,
%  - at least component is NaN.
%
%see intval\@intval\isempty_ and readme
%

% written  04/04/04     S.M. Rump
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 10/12/05     S.M. Rump  functionality exchanged with @hessian\isempty
%

  r = isempty(c.x) | isempty(c.dx) | isempty(c.hx) | ...
      isnan(c.x(:)') | any(isnan(c.dx),1)| any(isnan(c.hx),1);
  r = reshape(r,size(c.x));

  r(isempty(r)) = 1;      % cures  [] | * = []
