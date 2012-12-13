function r = isempty(a)
%ISEMPTY      Returns 1 if input is empty, i.e.[], in the sense of Matlab
%
%   r = isempty(a)
%
%There two possibilities for a long number to be empty in the mathematical sense:
%  - It is an empty quantity in the sense of Matlab or,
%  - at least component is NaN.
%
%To check emptyness in the mathematical sense, use isempty.
%see intval\@intval\isempty_ and readme
%

% written  09/29/02     S.M. Rump
% modified 04/04/04     S.M. Rump  set round to nearest for safety
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 10/12/05     S.M. Rump  functionality exchanged with @long\isempty_
%

  r = isempty(a.sign) | isempty(a.mantissa) | isempty(a.exponent);
