/****************************************************************************
 *
 * fplll.C                                                  Laurent Bartholdi
 *
 * Copyright (c) 2012-2017, Laurent Bartholdi
 *
 ****************************************************************************
 *
 * driver for fplll
 *
 ****************************************************************************/

#include "floatconfig.h"

#undef PACKAGE
#undef PACKAGE_BUGREPORT
#undef PACKAGE_NAME
#undef PACKAGE_STRING
#undef PACKAGE_TARNAME
#undef PACKAGE_URL
#undef PACKAGE_VERSION

#include "floattypes.h"

#include <fplll.h>
using namespace fplll;


typedef Obj (*ObjFunc)(); // I never could get the () and * right

template <class Z> void SET_INTOBJ(Z_NR<Z> &v, Obj z);
template <class Z> Obj GET_INTOBJ(Z_NR<Z> &v);

template<> void SET_INTOBJ(Z_NR<mpz_t> &v, Obj z) {
  if (IS_INTOBJ(z))
    v = INT_INTOBJ(z);
  else {
    mpz_t zz;
    mpz_init(zz);
    mpz_set(zz, mpz_MPZ(MPZ_LONGINT(z)));
    v = zz;
    mpz_clear(zz);
  }
}

template<> void SET_INTOBJ(Z_NR<long> &v, Obj z) {
  if (IS_INTOBJ(z))
    v = INT_INTOBJ(z);
  else
    v = mpz_get_si(mpz_MPZ(MPZ_LONGINT(z)));
}

template<> void SET_INTOBJ(Z_NR<double> &v, Obj z) {
  if (IS_INTOBJ(z))
    v = INT_INTOBJ(z);
  else
    v = mpz_get_d(mpz_MPZ(MPZ_LONGINT(z)));
}

template<> Obj GET_INTOBJ(Z_NR<mpz_t> &v) {
  mpz_t z;
  mpz_init2 (z, 8*sizeof(long)+1);
  v.get_mpz(z);
  Obj o = INT_mpz(z);
  mpz_clear(z);
  return o;
}

template<> Obj GET_INTOBJ(Z_NR<long> &v) {
  return ObjInt_Int(v.get_si());
}

template<> Obj GET_INTOBJ(Z_NR<double> &v) {
  mpz_t z;
  mpz_init2 (z, 8*sizeof(double)+1);
  mpz_set_d(z,v.get_d());
  Obj o = INT_mpz(z);
  mpz_clear(z);
  return o;
}

inline void set(Z_NR<mpz_t> &a, const Z_NR<long>& b) {
  a = b.get_si();
}

inline void set(Z_NR<mpz_t> &a, const Z_NR<mpz_t>& b) {
  a = b;
}

inline void set(Z_NR<mpz_t> &a, const Z_NR<double> &b) {
  a = b.get_d();
}

template<class Z> Obj dofplll(Obj gapmat, Obj lllargs, Obj svpargs)
{
  if (!IS_PLIST(gapmat)) return INTOBJ_INT(-1);
  Int numrows = LEN_PLIST(gapmat), numcols = -1;

  for (int i = 1; i <= numrows; i++) {
    Obj row = ELM_PLIST(gapmat,i);
    if (numcols == -1)
      numcols = LEN_PLIST(row);
    if (numcols != LEN_PLIST(row))
      return INTOBJ_INT(-1);
  }
  if (numcols <= 0)
    return INTOBJ_INT(-1);

  ZZ_mat<Z> mat(numrows, numcols);
  for (int i = 1; i <= numrows; i++)
    for (int j = 1; j <= numcols; j++)
      SET_INTOBJ(mat[i-1][j-1], ELM_PLIST(ELM_PLIST(gapmat,i),j));

  if (lllargs != Fail) {
    double delta = 0.99;
    double eta = 0.51;
    LLLMethod method = LM_WRAPPER;
    FloatType floatType = FT_DEFAULT;
    int precision = 0;
    int flags = LLL_DEFAULT;

    if (lllargs != True) {
      if (!IS_PLIST(lllargs) || LEN_PLIST(lllargs) != 6) return INTOBJ_INT(-20);

      Obj v = ELM_PLIST(lllargs,1);
      if (IS_MACFLOAT(v)) delta = VAL_MACFLOAT(v);
      else if (v != Fail) return INTOBJ_INT(-21);

      v = ELM_PLIST(lllargs,2);
      if (IS_MACFLOAT(v)) eta = VAL_MACFLOAT(v);
      else if (v != Fail) return INTOBJ_INT(-22);

      v = ELM_PLIST(lllargs,3);
      if (v == INTOBJ_INT(0)) method = LM_WRAPPER;
      else if (v == INTOBJ_INT(1)) method = LM_PROVED;
      else if (v == INTOBJ_INT(2)) method = LM_HEURISTIC;
      else if (v == INTOBJ_INT(3)) method = LM_FAST;
      else if (v != Fail) return INTOBJ_INT(-23);

      v = ELM_PLIST(lllargs,4);
      if (v == INTOBJ_INT(0)) floatType = FT_DEFAULT;
      else if (v == INTOBJ_INT(1)) floatType = FT_DOUBLE;
      else if (v == INTOBJ_INT(2)) floatType = FT_DPE;
      else if (v == INTOBJ_INT(3)) floatType = FT_MPFR;
      else if (v != Fail) return INTOBJ_INT(-24);

      v = ELM_PLIST(lllargs,5);
      if (IS_INTOBJ(v)) precision = INT_INTOBJ(v);
      else if (v != Fail) return INTOBJ_INT(-25);

      v = ELM_PLIST(lllargs,6);
      if (IS_INTOBJ(v)) flags = INT_INTOBJ(v);
      else if (v != Fail) return INTOBJ_INT(-26);
    }
    int result = lll_reduction(mat, delta, eta, method, floatType, precision, flags);

    if (result != RED_SUCCESS)
      return INTOBJ_INT(10*result+1);
  }

  if (svpargs != Fail) {
    SVPMethod method = SVPM_PROVED;
    int flags = SVP_DEFAULT;

    // __asm__ ("int3");
    if (svpargs != True) {
      if (!IS_PLIST(svpargs) || LEN_PLIST(svpargs) != 2) return INTOBJ_INT(-30);

      Obj v = ELM_PLIST(svpargs,1);
      if (v == INTOBJ_INT(0)) method = SVPM_PROVED;
      else if (v == INTOBJ_INT(1)) method = SVPM_FAST;
      else if (v != Fail) return INTOBJ_INT(-31);

      v = ELM_PLIST(svpargs,2);
      if (IS_INTOBJ(v)) flags = INT_INTOBJ(v);
      else if (v != Fail) return INTOBJ_INT(-32);
    }

    vector<Z_NR<mpz_t>> sol(numrows);
    ZZ_mat<mpz_t> svpmat(numrows,numcols);

    for (int i = 0; i < numrows; i++)
      for (int j = 0; j < numcols; j++)
	set(svpmat[i][j], mat[i][j]);

    int result = shortest_vector(svpmat, sol, method, flags);

    if (result != RED_SUCCESS)
      return INTOBJ_INT(10*result+2);

    Obj gapvec;
    if (lllargs == Fail) { // return coordinates of shortest vector in mat
      gapvec = NEW_PLIST(T_PLIST,numrows);
      SET_LEN_PLIST(gapvec,numrows);
      for (int i = 1; i <= numrows; i++) {
	Obj v = GET_INTOBJ(sol[i-1]);
	SET_ELM_PLIST(gapvec,i,v);
      }
    } else { // return shortest vector
      gapvec = NEW_PLIST(T_PLIST,numcols);
      SET_LEN_PLIST(gapvec,numcols);
      for (int i = 1; i <= numcols; i++) {
	Z_NR<mpz_t> s;
	s = 0;
	for (int j = 0; j < numrows; j++)
	  s.addmul(sol[j],svpmat[j][i-1]);
	Obj v = GET_INTOBJ(s);
	SET_ELM_PLIST(gapvec,i,v);
      }
    }
    return gapvec;
  }

  gapmat = NEW_PLIST(T_PLIST,numrows);
  SET_LEN_PLIST(gapmat,numrows);
  for (int i = 1; i <= numrows; i++) {
    Obj gaprow = NEW_PLIST(T_PLIST,numcols);
    SET_LEN_PLIST(gaprow,numcols);
    SET_ELM_PLIST(gapmat,i,gaprow);
    for (int j = 1; j <= numcols; j++) {
      Obj v = GET_INTOBJ(mat[i-1][j-1]);
      SET_ELM_PLIST(gaprow,j,v);
    }
  }
  return gapmat;
}

static Obj FPLLL (Obj self, Obj gapmat, Obj intType, Obj lllargs, Obj svpargs)
{
  if (intType == Fail) intType = INTOBJ_INT(0);
  if (!IS_INTOBJ(intType)) return INTOBJ_INT(-2);
  switch (INT_INTOBJ(intType)) {
  case 0: return dofplll<mpz_t>(gapmat, lllargs, svpargs);
  case 1: return dofplll<long>(gapmat, lllargs, svpargs);
  case 2: return dofplll<double>(gapmat, lllargs, svpargs);
  default: return INTOBJ_INT(-2);
  }
}

static StructGVarFunc GVarFuncs [] = {
  { "@FPLLL", 4, "mat, intType, lllargs, svpargs", (ObjFunc) FPLLL, "fplll.C:FPLLL" },
  { 0 }
};

extern "C" int InitFPLLLKernel(void) {
  InitHdlrFuncsFromTable (GVarFuncs);
  return 0;
}

extern "C" int InitFPLLLLibrary(void) {
  InitGVarFuncsFromTable (GVarFuncs);
  return 0;
}
