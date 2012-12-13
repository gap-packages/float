function r = isempty(c)
%ISEMPTY      Returns 1 if input is empty, i.e. [], in the sense of Matlab
%
%   r = isempty(a)
%
%There two possibilities for an interval to be empty in the mathematical sense:
%  - It is an empty quantity in the sense of Matlab or,
%  - at least component is NaN.
%
%To check emptyness in the mathematical sense, use isempty.
%see intval\@intval\isempty_ and readme
%

% written  10/15/99     S.M. Rump
% modified 04/04/04     S.M. Rump  set round to nearest for safety
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 10/12/05     S.M. Rump  functionality exchanged with @gradient\isempty_
%

  r = isempty(c.x) | isempty(c.dx);
