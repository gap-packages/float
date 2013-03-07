function r = isempty_(c)
%ISEMPTY_     Returns array of 0's and 1's for empty components in the mathematical sense
%
%   r = isempty_(c)
%
%There two possibilities for an interval to be empty in the mathematical sense:
%  - It is an empty quantity [] in the sense of Matlab or,
%  - at least component is NaN.
%
%see intval\@intval\isempty_ and readme
%

% written  10/16/98     S.M. Rump
% modified 10/15/99     S.M. Rump
% modified 04/04/04     S.M. Rump  set round to nearest for safety
%                                    array input
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 10/12/05     S.M. Rump  functionality exchanged with @gradient\isempty
%

  r = isempty(c.x) | isempty(c.dx) | ...
      isnan(c.x(:)) | any(isnan(c.dx),2);
  r = reshape(r,size(c.x));

  r(isempty(r)) = 1;      % cures  [] | * = []
