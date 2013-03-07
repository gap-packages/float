function res = norm(a,r)
%NORM         Inclusion of norm of a matrix or vector
%
%   res = norm(a,r)
%
%   r in {1,2,inf} for vector a
%   r in {1,inf}   for matrix a
%
% default for r is 2
%

% written  10/16/98     S.M. Rump
% modified 09/02/00     S.M. Rump  rounding unchanged after use
% modified 04/04/04     S.M. Rump  set round to nearest for safety
% modified 04/06/05     S.M. Rump  rounding unchanged, redesign
% modified 01/18/06     S.M. Rump  Matlab bug
%

  [m,n] = size(a);
  if m==1 | n==1       % vector a
    if nargin==1
      r = 2;
    end
  else                 % matrix a
    if nargin==1 | r==2
      error('interval matrix 2-norm not implemented')
    end
  end
  
  if r==1
    suma = sum(abs(a),1);
    res = intval(max(inf(suma)),max(sup(suma)),'infsup');
  elseif r==inf
    suma = sum(abs(a),2);
    res = intval(max(inf(suma)),max(sup(suma)),'infsup');
  else    
    %VVVV x = abs(a(:));
    s.type = '()'; s.subs = {':'}; x = abs(subsref(a,s));
    %AAAA Matlab V5.2 bug fix    
    res = sqrt(abs(sum(x'*x)));
  end
  