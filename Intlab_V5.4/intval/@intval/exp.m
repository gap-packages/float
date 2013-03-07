function y = exp(x)
%EXP          Implements  exp(x)  for intervals
%
%   y = exp(x)
%
%interval standard function implementation
%

% written  12/30/98     S.M. Rump
% modified 08/31/99     S.M. Rump  complex allowed, following N.C. Boersken:
%                                  Komplexe Kreis-Standardfunktionen,
%                                  Freiburger Intervallberichte 78/2,
%                                  NaN input, extreme input, sparse input,
%                                  major revision, improved accuracy
% modified 09/02/00     S.M. Rump  rounding unchanged after use
% modified 04/04/04     S.M. Rump  set round to nearest for safety
%                                    accelaration for sparse input
% modified 04/06/05     S.M. Rump  rounding unchanged
% modified 12/04/05     S.M. Rump  extreme values for approximate part
%

  if issparse(x)
    index = ( x==0 );
    if any(index(:))                    % treat zero indices
      y = intval(ones(size(x)));
      index = ~index;
      %VVVV  y(index) = exp(full(x(index)));
      s.type = '()'; s.subs = {index}; y = subsasgn(y,s,exp(full(subsref(x,s))));
      %AAAA  Matlab bug fix
    else
      y = exp(full(x));
    end
    return
  end

  e = 1e-30;
  if 1+e==1-e                           % fast check for rounding to nearest
    rndold = 0;
  else
    rndold = getround;
    setround(0)
  end

  global INTLAB_INTVAL_STDFCTS

  if x.complex
    sizex = size(x.mid);
    if issparse(x.mid)                   % complex case
      x.mid = full(x.mid(:));
      x.rad = full(x.rad(:));
    else
      x.mid = x.mid(:);
      x.rad = x.rad(:);
    end

    y = x;

%   y.mid = exp(x.mid);
%   y.rad = abs(exp(x.mid)) .* ( exp(x.rad) - 1 );

    Xmidre = intval(real(x.mid));
    Xmidim = intval(imag(x.mid));
    R = exp(Xmidre);
    Mre = R.*cos(Xmidim);
    Mim = R.*sin(Xmidim);
    % exp(x.mid)  in  Mre + j*Mim

    expxrad = exp_rnd(x.rad,1);
    setround(1)
    mre = Mre.inf + 0.5*(Mre.sup-Mre.inf);
    mim = Mim.inf + 0.5*(Mim.sup-Mim.inf);
    mrad = abs( mre-Mre.inf + j*(mim-Mim.inf) );
    % Mre + j*Mim  in  mre + j*mim +/- mrad

    y.mid = mre + j*mim;
    y.rad = R.sup .* ( expxrad-1 ) + mrad;
    setround(0)

    index = isnan(x.mid);
    if any(index(:))
      y.mid(index) = NaN + NaN*j;
      y.rad(index) = NaN;
    end

    y.mid = reshape(y.mid,sizex);
    y.rad = reshape(y.rad,sizex);
    
    setround(0)                        % set rounding to nearest
  
    if rndold~=0
      setround(rndold)
    end
    
    return
  end

  if issparse(x.inf)                   % real case
    x.inf = full(x.inf);
    x.sup = full(x.sup);
  end

  y = x;

  % Matlab V5.1 bug fix: x=rand(3); x(1,2)=1000; exp(x)
  global INTLAB_INTVAL_STDFCTS_LOGREALMAX
  indexinf = ( x.inf>INTLAB_INTVAL_STDFCTS_LOGREALMAX );
  if any(indexinf(:))
    x.inf(indexinf) = 0;
  end
  indexsup = ( x.sup>INTLAB_INTVAL_STDFCTS_LOGREALMAX );
  if any(indexsup(:))
    x.sup(indexsup) = 0;
  end

  if INTLAB_INTVAL_STDFCTS             % rigorous standard function

    y.inf = exp_rnd(x.inf(:),-1);
    y.sup = exp_rnd(x.sup(:),1);

    y.inf = reshape(y.inf,size(x.inf));
    y.sup = reshape(y.sup,size(x.sup));

    setround(0)                        % set rounding to nearest

  else                                 % approximate standard function

    global INTLAB_INTVAL_EPSSTDFCTS

    setround(0)

    y.inf = exp(x.inf);
    y.inf = y.inf - INTLAB_INTVAL_EPSSTDFCTS*min(realmax,abs(y.inf));

    y.sup = exp(x.sup);
    y.sup(y.sup==0) = realmin;
    y.sup = y.sup + INTLAB_INTVAL_EPSSTDFCTS*min(realmax,abs(y.sup));

    index = isnan(x.inf);
    if any(index(:))
      y.inf(index) = NaN;
      y.sup(index) = NaN;
    end

  end

  y.inf(indexinf) = realmax;
  y.sup(indexsup) = inf;
  
  if rndold~=0
    setround(rndold)
  end
