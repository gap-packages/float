function infsup(c)
%INFSUP       Display of interval hessians
%
%   infsup(c)
%

% written  04/04/04     S.M. Rump
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 02/11/06     S.M. Rump  SparseInfNanFlag removed
%

  global INTLAB_HESSIAN_NUMVAR

  if nargin<2
    name = inputname(1);
    if isempty(name)                    % happens for display(hessianinit(random))
      name = 'ans';
    end
  end
  
  if isa(c.x,'intval')
    display_gen(c,name,'infsup')
  else
    display_gen(c,name,'display_')
  end

  