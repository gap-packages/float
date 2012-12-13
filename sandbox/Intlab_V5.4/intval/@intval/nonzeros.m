function x = nonzeros(a)
%NONZEROS     Implements  nonzeros(a)  for sparse interval matrix
%
%   x = nonzeros(a)
%
%Functionality as in Matlab.
%

% written  08/09/02     S.M. Rump 
% modified 04/04/04     S.M. Rump  set round to nearest for safety
% modified 04/06/05     S.M. Rump  rounding unchanged
%

  if a.complex
    I = find(spones(a.mid)+spones(a.rad));
    if isequal(a.rad,0)
      x = intval(full(a.mid(I)),0,'midrad');
    else
      x = intval(full(a.mid(I)),full(a.rad(I)),'midrad');
    end
  else
    I = find(spones(a.inf)+spones(a.sup));
    x = intval(full(a.inf(I)),full(a.sup(I)),'infsup');
  end  
