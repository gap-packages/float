function p = abss(p);
%ABSS         Polynomial with absolute values of coefficients
%
%   r = abss(p);
%
% r_i = abss(p_i), i.e. result is real polynomial, also for interval input
% Obsolete, replaced by mag (thanks to Arnold for better naming).
%

% written  08/28/00     S.M. Rump
% modified 04/04/04     S.M. Rump  set round to nearest for safety
% modified 04/06/05     S.M. Rump  rounding unchanged
%

  p.c = abss(p.c);
