function r = isempty_(u)
%ISEMPTY_     Returns array of 0's and 1's for empty components in the mathematical sense
%
%   r = isempty_(u)
%
%There two possibilities for an interval to be empty in the mathematical sense:
%  - It is an empty quantity [] in the sense of Matlab or,
%  - at least component is NaN.
%
%see intval\@intval\isempty_ and readme
%

% written  12/06/98     S.M. Rump
% modified 10/15/99     S.M. Rump
% modified 04/04/04     S.M. Rump  set round to nearest for safety
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 10/12/05     S.M. Rump  functionality exchanged with @slope\isempty
%

  r = any(isempty_(u.r),2) | any(isempty_(u.s),2) | ...
      any(isnan(u.r),2) | any(isnan(u.s),2);

  r(isempty(r)) = 1;      % cures  [] | * = []
