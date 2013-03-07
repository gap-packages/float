function r = isempty_(a)
%ISEMPTY_     Returns array of 1's for empty components in the mathematical sense
%
%   r = isempty_(a)
%
%There two possibilities for an interval to be empty in the mathematical sense:
%  - It is an empty quantity [] in the sense of Matlab or,
%  - at least component is NaN.
%
%see intval\@intval\isempty_ and readme
%

% written  10/15/99     S.M. Rump
% modified 04/04/04     S.M. Rump  set round to nearest for safety
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 10/12/05     S.M. Rump  functionality exchanged with @intval\isempty
%

  if a.complex
    r = isempty_(a.mid) | isempty_(a.rad) | ...
        isnan(a.mid) | isnan(a.rad);
  else
    r = isempty_(a.inf) | isempty_(a.sup) | ...
        isnan(a.inf) | isnan(a.sup);
  end

  r(isempty(r)) = 1;      % cures  [] | * = []
