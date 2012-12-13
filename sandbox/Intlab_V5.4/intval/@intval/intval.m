function [c,err] = intval(x,y,type)
%INTVAL       Intval class constructor
%
%  c = intval(x)        type cast for x double or intval
%  c = intval(s)        verified conversion for string s
%
%For verified conversion, string s may be one- or two-dimensional
%  containing one or more input numbers. Input may be real or complex,
%  scalars or intervals in
%     infsup representation  [ ... , ... ]  or
%     midrad representation  < ... , ... >  or
%     numbers with uncertainty  3.14_+2.71_i
%Output c is always interval column vector
%
%  Examples:  c = intval('0.1');    ==>  rad(c) = 1.3878e-017
%
%             c = intval('0.1e1');  ==>  rad(c) = 0
%
%             c = intval('3.14_');  ==>  rad(c) = 1e-2
%
%             input   » s = [ '-3.4_e2 0 ' ; '.02 +123  ' ], intval(s)
%             output  s =
%                     -3.4_e2 0
%                     .02 +123
%                     intval ans =
%                      -34_.____
%                         0.0000
%                         0.0200
%                       123.0000
%
%             input   » intval(' [1.993,2] <3+2i,1e-3> -4.33_i ')
%             output  intval ans =
%                         2.00__ +  0.00__i
%                         3.0000 +  2.00__i
%                         0.0___ -  4.3___i
%
%The last interval has thick real part because complex intervals are always
%  midpoint/radius intervals, i.e. the uncertainty in the imaginary part
%  -4.33_i is interpreted as a radius in the complex plane.
%
%To avoid error messages use, for example, 
%
%  [x,err] = intval('[3,2]')
%
%where  err =  0   normal end, no error detected
%              1   improper interval (lower bound greater than upper)
%              2   other errors
%
%If one of the operands of a unary or binary arithmetic operation or a
%  standard function is of type intval, the operation is executed with
%  interval arithmetic producing rigorous bounds for the result.
%The Matlab system parses - as every compiler - expressions following the
%  priority rules of the operation. For example,
%
%  x = intval(0.125) + 1/10
%
%does not contain the decimal number 0.225 because 1/10 is executed in
%  floating-point with round to nearest (in fact, x is a point interval,
%  try x.sup-x.inf). A correct answer is produced by
%
%  x = 0.125 + intval(1)/10 .
%
%The easiest way always to produce correct answers is that all quantities
%  occuring in an expression are of type intval.
%
%The result of standard functions with interval arguments is also correct,
%  even for extreme examples like
%
%  sin(intval(2^1000)) .
%
%For more information try demointval. For information of system variables,
%  default output format, settings for standard functions and others try
%
%  help intvalinit .
%


%
%Internal representation of real intervals by infimum and supremum:
%  [ inf , sup ]  represents the set  { x in R | inf <= x <= sup }
%
%Internal representation of complex intervals by midpoint and radius:
%  < mid , rad >  represents the set  { x in C | abs(x-mid) <= rad }
%
%  inf/sup   may be a real number, vector, matrix, or sparse matrix
%  mid       may be a complex number, vector, matrix, or sparse matrix
%  rad       may be a nonnegative real number, vector, matrix, or sparse matrix
%
%For an array x=1:6, for example, the assignment x(3)=[] results in a
%  vector [1 2 4 5 6] with 5 components. Therefore, empty intervals or
%  empty components of an interval vector/matrix are represented by NaN.
%Accordingly, isempty_ produces a logical 0/1 array with 1 for mathematically
%  empty components, i.e. NaN components, whereas isempty produces a single 1
%  for intval([]) (see also intval\isempty).
%

%If .complex = 0   real interval by inf/sup, mid=rad=[]
%   .complex = 1   complex interval by mid/rad, inf=sup=[]
%

%Function intval with more than one argument only for internal use.
%To produce a non-point interval use ***only*** functions infsup, midrad or
%  intval with input string
%

% written  10/16/98     S.M. Rump
% modified 12/30/98     S.M. Rump  slopes and bug fix for save/load
% modified 10/24/99     S.M. Rump  sparse matrices, comment empty intervals
% modified 08/29/00     S.M. Rump  multivariate polynom handling
% modified 12/18/02     S.M. Rump  hessians added
% modified 04/04/04     S.M. Rump  set round to nearest for safety
%                                    error message for invalid application of 'infsup'
%                                    Matlab sparse bug
% modified 01/01/05     S.M. Rump  error parameter added to intval('..') (thanks to Arnold)
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 11/20/05     S.M. Rump  fast check for rounding to nearest
%

  e = 1e-30;
  if 1+e==1-e                           % fast check for rounding to nearest
    rndold = 0;
  else
    rndold = getround;
    setround(0)
  end

  if nargin==1
    if isa(x,'double')          % 1 parameter, point interval
      if isreal(x)
        c.complex = 0;
        c.inf = x;
        c.sup = x;
        c.mid = [];
        c.rad = [];
      else
        c.complex = 1;
        c.inf = [];
        c.sup = [];
        c.mid = x;
        % careful: just 0 is not sparse and may cause tremendous memory need
        if issparse(x)
          c.rad = sparse(size(x,1),size(x,2),0);
        else
          c.rad = 0;
        end
      end

      c = class(c,'intval');

    elseif isa(x,'intval')      % 1 parameter, interval
      c = x;

    elseif isa(x,'char')        % 1 parameter input string, verified conversion
      if nargout==2
        [c,err] = str2intval(x);
      else
        c = str2intval(x);
      end

    elseif isa(x,'polynom')     % 1 parameter, polynom
      c = polynom(intval(vector(x)));

    elseif isa(x,'gradient')    % 1 parameter, gradient
      if isa(x.x,'intval')
        c = x;
      else
        c = gradient(x,'gradientintval');
      end

    elseif isa(x,'hessian')    % 1 parameter, Hessian
      if isa(x.x,'intval')
        c = x;
      else
        c = hessian(x,'hessianintval');
      end
      
    elseif isa(x,'slope')       % 1 parameter, slope
      c = x;                    % slopes are always of type intval

    else
      error('invalid call of intval constructor')
    end

  elseif nargin==3                  % internal type cast
    if isequal(type,'midrad')       % internal use only
      % input real or complex, rad is real nonnegative
      c.complex = 1;
      c.inf = [];
      c.sup = [];
      if prod(size(x))==1
        c.mid = x*ones(size(y));
      else
        c.mid = x;
      end
      % careful: just 0 is not sparse and may cause tremendous memory need
      if isequal(y,0)
        c.rad = 0;
      else
        if prod(size(y))==1
          if issparse(x)
            c.rad = y*spones(x);
          else
            c.rad = y*ones(size(x));
          end
        else
          if ~isequal(size(c.mid),size(y))
            error('invalid call of intval constructor')
          else
            c.rad = y;
          end
        end
      end
    elseif isequal(type,'infsup')   % internal use only
      % input is real and inf<=sup
      if ~isreal(x) | ~isreal(y)
        disp('*************************************************************')
        disp('*************************************************************')
        disp('*************************************************************')
        disp('This should *never* happen!')
        disp('Please report circumstances to the author, rump@tu-harburg.de')
        disp('Thanks for your cooperation.')
        disp('*************************************************************')
        disp('*************************************************************')
        disp('*************************************************************')
        error('invalid use of intval(x,y,''infsup'')')
      end
      c.complex = 0;
      if issparse(x) | issparse(y)
        if prod(size(x))==1
          x = x*spones(y);
        elseif prod(size(y))==1
          y = y*spones(x);
        end
      else
        if prod(size(x))==1
          x = x*ones(size(y));
        elseif prod(size(y))==1
          y = y*ones(size(x));
        end
      end
      c.inf = x;
      c.sup = y;
      c.mid = [];
      c.rad = [];
    else
      error('invalid call of intval constructor')
    end
    c = class(c,'intval');
  elseif nargin==0                % for save/load
    c.complex = 0;
    c.inf = [];
    c.sup = [];
    c.mid = [];
    c.rad = [];
    c = class(c,'intval');
  else
    error('invalid call of intval constructor')
  end

  % avoid Matlab 6.5f bug: 
  % a = sparse([],[],[],1,1); a = reshape(a,1,1); abs(a)
  % produces  9.6721e-317  or similar number in underflow range
  if isa(c,'intval')
    if c.complex
      if prod(size(c.mid))==1
        c.mid = full(c.mid);
        c.rad = full(c.rad);
      end
    else
      if prod(size(c.inf))==1
        c.inf = full(c.inf);
        c.sup = full(c.sup);
      end
    end
  end
    
  setround(rndold)
