function r = isempty_(a)
%ISEMPTY_     Returns array of 0's and 1's for empty components in the mathematical sense
%
%   r = isempty_(a)
%
%There two possibilities for a long number to be empty in the mathematical sense:
%  - It is an empty quantity [] in the sense of Matlab or,
%  - at least component is NaN.
%
%see intval\@intval\isempty_ and readme
%

% written  09/29/02     S.M. Rump
% modified 04/04/04     S.M. Rump  set round to nearest for safety
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 10/12/05     S.M. Rump  functionality exchanged with @long\isempty
%

  r = isempty_(a.sign) | any(isempty_(a.mantissa),2) | isempty_(a.exponent) | ...
      isnan(a.sign) | isnan(a.exponent);
  r(isempty(r)) = 1;      % cures  [] | * = []
