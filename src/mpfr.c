/****************************************************************************
**
*W  mpfr.c                       GAP source                 Laurent Bartholdi
**
*Y  Copyright (C) 2008-2012 Laurent Bartholdi
**
**  This file contains the functions for the float package.
**  floats are implemented using the MPFR package.
*/

#include "floatconfig.h"

#undef PACKAGE
#undef PACKAGE_BUGREPORT
#undef PACKAGE_NAME
#undef PACKAGE_STRING
#undef PACKAGE_TARNAME
#undef PACKAGE_URL
#undef PACKAGE_VERSION

#include <ctype.h>
#include <string.h>
#include <stdio.h>

#include "floattypes.h"

Obj TYPE_MPFR, IsMPFRFloat, GAP_INFINITY;

#define MANTISSA_MPFR(p) ((mp_limb_t *) ((p)+1))

mpfr_ptr GET_MPFR(Obj obj) {
  if (!IS_DATOBJ(obj) || DoFilter(IsMPFRFloat, obj) != True) {
    ErrorMayQuit("GET_MPFR: object must be an MPFR, not a %s",
		       (Int)TNAM_OBJ(obj),0);
  }
  mpfr_ptr p = MPFR_OBJ(obj);
  mpfr_custom_move (p, MANTISSA_MPFR(p));
  return p;
}

Obj NEW_MPFR (mp_prec_t prec)
{
  Obj f = NEW_DATOBJ(sizeof(__mpfr_struct)+mpfr_custom_get_size(prec), TYPE_MPFR);
  mpfr_ptr p = MPFR_OBJ(f);
  mpfr_custom_init_set(p, MPFR_NAN_KIND, 0, prec, MANTISSA_MPFR(p));
  return f;
}

/****************************************************************
 * 1-argument functions
 ****************************************************************/
#define Func1_MPFR(name,mpfr_name)				\
  static Obj name(Obj self, Obj f)				\
  {								\
    mp_prec_t prec = mpfr_get_prec(GET_MPFR(f));		\
    Obj g = NEW_MPFR(prec);					\
    mpfr_name (MPFR_OBJ(g), GET_MPFR(f), GMP_RNDN);	\
    return g;							\
  }
#define Inc1_MPFR_arg(name,arg)		\
  { #name, 1, arg, (ObjFunc)(void *)(name), "src/mpfr.c:" #name }
#define Inc1_MPFR(name) Inc1_MPFR_arg(name,"float")

Func1_MPFR(COS_MPFR,mpfr_cos);
Func1_MPFR(SIN_MPFR,mpfr_sin);
Func1_MPFR(TAN_MPFR,mpfr_tan);
Func1_MPFR(SEC_MPFR,mpfr_sec);
Func1_MPFR(CSC_MPFR,mpfr_csc);
Func1_MPFR(COT_MPFR,mpfr_cot);
Func1_MPFR(ACOS_MPFR,mpfr_acos);
Func1_MPFR(ASIN_MPFR,mpfr_asin);
Func1_MPFR(ATAN_MPFR,mpfr_atan);

Func1_MPFR(COSH_MPFR,mpfr_cosh);
Func1_MPFR(SINH_MPFR,mpfr_sinh);
Func1_MPFR(TANH_MPFR,mpfr_tanh);
Func1_MPFR(SECH_MPFR,mpfr_sech);
Func1_MPFR(CSCH_MPFR,mpfr_csch);
Func1_MPFR(COTH_MPFR,mpfr_coth);
Func1_MPFR(ACOSH_MPFR,mpfr_acosh);
Func1_MPFR(ASINH_MPFR,mpfr_asinh);
Func1_MPFR(ATANH_MPFR,mpfr_atanh);

Func1_MPFR(LOG_MPFR,mpfr_log);
Func1_MPFR(LOG2_MPFR,mpfr_log2);
Func1_MPFR(LOG10_MPFR,mpfr_log10);
Func1_MPFR(LOG1P_MPFR,mpfr_log1p);
Func1_MPFR(EXP_MPFR,mpfr_exp);
Func1_MPFR(EXP2_MPFR,mpfr_exp2);
Func1_MPFR(EXP10_MPFR,mpfr_exp10);
Func1_MPFR(EXPM1_MPFR,mpfr_expm1);

Func1_MPFR(AINV_MPFR,mpfr_neg);
Func1_MPFR(SQRT_MPFR,mpfr_sqrt);
Func1_MPFR(CBRT_MPFR,mpfr_cbrt);
Func1_MPFR(SQR_MPFR,mpfr_sqr);
Func1_MPFR(ABS_MPFR,mpfr_abs);

Func1_MPFR(CEIL_MPFR,mpfr_rint_ceil);
Func1_MPFR(FLOOR_MPFR,mpfr_rint_floor);
Func1_MPFR(ROUND_MPFR,mpfr_rint_round);
Func1_MPFR(TRUNC_MPFR,mpfr_rint_trunc);
Func1_MPFR(FRAC_MPFR,mpfr_frac);

static Obj SINCOS_MPFR(Obj self, Obj f)
{
  mp_prec_t prec = mpfr_get_prec(GET_MPFR(f));
  Obj g = NEW_MPFR(prec);
  Obj h = NEW_MPFR(prec);
  mpfr_sin_cos(GET_MPFR(g), GET_MPFR(h), GET_MPFR(f), GMP_RNDN);
  Obj l = NEW_PLIST(T_PLIST,2);
  SET_ELM_PLIST(l,1,g);
  SET_ELM_PLIST(l,2,h);
  SET_LEN_PLIST(l,2);
  return l;
}

static Obj INV_MPFR(Obj self, Obj f)
{
  mp_prec_t prec = mpfr_get_prec(GET_MPFR(f));
  Obj g = NEW_MPFR(prec);
  mpfr_ui_div(MPFR_OBJ(g), 1, GET_MPFR(f), GMP_RNDN);
  return g;
}

static Obj ZERO_MPFR(Obj self, Obj f)
{
  mp_prec_t prec = mpfr_get_prec(GET_MPFR(f));
  Obj g = NEW_MPFR(prec);
  mpfr_set_ui(MPFR_OBJ(g), 0, GMP_RNDN);
  return g;
}

static Obj ONE_MPFR(Obj self, Obj f)
{
  mp_prec_t prec = mpfr_get_prec(GET_MPFR(f));
  Obj g = NEW_MPFR(prec);
  mpfr_set_ui (MPFR_OBJ(g), 1, GMP_RNDN);
  return g;
}

static Obj MPFR_MAKENAN(Obj self, Obj prec)
{
  TEST_IS_INTOBJ("MPFR_MAKE_NAN",prec);
  Obj g = NEW_MPFR(INT_INTOBJ(prec));
  mpfr_set_nan (MPFR_OBJ(g));
  return g;
}

static Obj MPFR_MAKEINFINITY(Obj self, Obj prec)
{
  TEST_IS_INTOBJ("MPFR_MAKEINFINITY",prec);

  int p = INT_INTOBJ(prec);
  Obj g = NEW_MPFR(p < 0 ? -p : p);
  mpfr_set_inf (MPFR_OBJ(g), p);
  return g;
}

static Obj MPFR_LOG2(Obj self, Obj prec)
{
  TEST_IS_INTOBJ("MPFR_LOG2",prec);

  Obj g = NEW_MPFR(INT_INTOBJ(prec));
  mpfr_const_log2 (MPFR_OBJ(g), GMP_RNDN);
  return g;
}

static Obj MPFR_PI(Obj self, Obj prec)
{
  TEST_IS_INTOBJ("MPFR_PI",prec);

  Obj g = NEW_MPFR(INT_INTOBJ(prec));
  mpfr_const_pi (MPFR_OBJ(g), GMP_RNDN);
  return g;
}

static Obj MPFR_EULER(Obj self, Obj prec)
{
  TEST_IS_INTOBJ("MPFR_EULER",prec);

  Obj g = NEW_MPFR(INT_INTOBJ(prec));
  mpfr_const_euler (MPFR_OBJ(g), GMP_RNDN);
  return g;
}

static Obj MPFR_CATALAN(Obj self, Obj prec)
{
  TEST_IS_INTOBJ("MPFR_CATALAN",prec);

  Obj g = NEW_MPFR(INT_INTOBJ(prec));
  mpfr_const_catalan (MPFR_OBJ(g), GMP_RNDN);
  return g;
}

static Obj MPFR_INT(Obj self, Obj i)
{
  Obj g;
  if (IS_INTOBJ(i)) {
    g = NEW_MPFR(8*sizeof(long));
    mpfr_set_si(MPFR_OBJ(g), INT_INTOBJ(i), GMP_RNDN);
  } else {
    Obj f = MPZ_LONGINT(i);
    g = NEW_MPFR(8*sizeof(mp_limb_t)*SIZE_INT(i));
    mpfr_set_z(MPFR_OBJ(g), mpz_MPZ(f), GMP_RNDN);
  }
  return g;
}

static Obj MPFR_INTPREC(Obj self, Obj i, Obj prec)
{
  Obj g;
  TEST_IS_INTOBJ("MPFR_INTPREC",prec);
  if (IS_INTOBJ(i)) {
    g = NEW_MPFR(INT_INTOBJ(prec));
    mpfr_set_si(MPFR_OBJ(g), INT_INTOBJ(i), GMP_RNDN);
  } else {
    Obj f = MPZ_LONGINT(i);
    g = NEW_MPFR(INT_INTOBJ(prec));    
    mpfr_set_z(MPFR_OBJ(g), mpz_MPZ(f), GMP_RNDN);
  }
  return g;
}

static Obj INT_MPFR(Obj self, Obj f)
{
  mpz_t z;

  if (mpfr_zero_p(GET_MPFR(f)))
    return INTOBJ_INT(0);
  if (mpfr_inf_p(GET_MPFR(f)))
    return GAP_INFINITY;
  if (!mpfr_number_p(GET_MPFR(f)))
    return Fail;

  long prec = mpfr_get_exp(GET_MPFR(f));

  if (prec < 0) prec = 0;
  mpz_init2 (z, prec+1);
  mpfr_get_z (z, GET_MPFR(f), GMP_RNDZ);
  Obj res = INT_mpz(z);
  mpz_clear(z);

  return res;
}

static Obj PREC_MPFR(Obj self, Obj f)
{
  return INTOBJ_INT(mpfr_get_prec(GET_MPFR(f)));
}

static Obj SIGN_MPFR(Obj self, Obj f)
{
  return INTOBJ_INT(mpfr_sgn(GET_MPFR(f)));
}

static Obj SIGNBIT_MPFR(Obj self, Obj f)
{
  return mpfr_signbit(GET_MPFR(f)) ? True : False;
}

static Obj ISNAN_MPFR(Obj self, Obj f)
{
  return mpfr_nan_p(GET_MPFR(f)) ? True : False;
}

static Obj ISXINF_MPFR(Obj self, Obj f)
{
  return mpfr_inf_p(GET_MPFR(f)) ? True : False;
}

static Obj ISPINF_MPFR(Obj self, Obj f)
{
  if (!mpfr_inf_p(GET_MPFR(f))) return False;
  return mpfr_sgn(MPFR_OBJ(f)) > 0 ? True : False;
}

static Obj ISNINF_MPFR(Obj self, Obj f)
{
  if (!mpfr_inf_p(GET_MPFR(f))) return False;
  return mpfr_sgn(MPFR_OBJ(f)) < 0 ? True : False;
}

static Obj ISZERO_MPFR(Obj self, Obj f)
{
  return mpfr_zero_p(GET_MPFR(f)) ? True : False;
}

static Obj ISNUMBER_MPFR(Obj self, Obj f)
{
  return mpfr_number_p(GET_MPFR(f)) ? True : False;
}

static Obj MPFR_MPFRPREC(Obj self, Obj f, Obj prec)
{
  TEST_IS_INTOBJ("MPFR_MPFRPREC",prec);

  Obj g = NEW_MPFR(INT_INTOBJ(prec));
  mpfr_set (MPFR_OBJ(g), GET_MPFR(f), GMP_RNDN);
  return g;
}

static Obj MPFR_MACFLOAT(Obj self, Obj f)
{
  if (!IS_MACFLOAT(f)) {
    ErrorMayQuit("MPFR_MACFLOAT: object must be a float, not a %s",
		       (Int)TNAM_OBJ(f),0);
  }
  Obj g = NEW_MPFR(64);
  mpfr_set_d (MPFR_OBJ(g), VAL_MACFLOAT(f), GMP_RNDN);
  return g;
}

static Obj MACFLOAT_MPFR(Obj self, Obj f)
{
  return NEW_MACFLOAT(mpfr_get_d(GET_MPFR(f), GMP_RNDN));
}

static Obj FREXP_MPFR(Obj self, Obj f)
{
  mp_prec_t prec = mpfr_get_prec(GET_MPFR(f));
  Obj g = NEW_MPFR(prec);
  mpfr_set (MPFR_OBJ(g), GET_MPFR(f), GMP_RNDN);
  mp_exp_t e = mpfr_get_exp(GET_MPFR(f));
  mpfr_set_exp(MPFR_OBJ(g), 0);
  Obj l = NEW_PLIST(T_PLIST,2);
  SET_ELM_PLIST(l,1,g);
  SET_ELM_PLIST(l,2, ObjInt_Int(e));
  SET_LEN_PLIST(l,2);
  return l;
}

static Obj LDEXP_MPFR(Obj self, Obj f, Obj exp)
{
  mp_exp_t e = Int_ObjInt(exp);
  mp_prec_t prec = mpfr_get_prec(GET_MPFR(f));
  Obj g = NEW_MPFR(prec);
  mpfr_mul_2si (MPFR_OBJ(g), GET_MPFR(f), e, GMP_RNDN);
  return g;
}

static Obj EXTREPOFOBJ_MPFR(Obj self, Obj f)
{
  Obj l = NEW_PLIST(T_PLIST,2);
  SET_LEN_PLIST(l,2);

  mp_prec_t prec = mpfr_get_prec(GET_MPFR(f));
  Obj g = NEW_MPFR(prec);
  mpfr_set (MPFR_OBJ(g), GET_MPFR(f), GMP_RNDN);

  if (mpfr_zero_p(GET_MPFR(f))) {
    SET_ELM_PLIST(l,1, INTOBJ_INT(0));
    mpfr_ui_div(MPFR_OBJ(g), 1, MPFR_OBJ(f), GMP_RNDN);
    SET_ELM_PLIST(l,2, INTOBJ_INT(mpfr_sgn(MPFR_OBJ(g))<0));
    return l;
  }
  if (!mpfr_number_p(MPFR_OBJ(f))) {
    SET_ELM_PLIST(l,1, INTOBJ_INT(0));
    if (mpfr_inf_p(MPFR_OBJ(f)))
      SET_ELM_PLIST(l,2, INTOBJ_INT(2 + (mpfr_sgn(MPFR_OBJ(f))<0)));
    else if (mpfr_nan_p(MPFR_OBJ(f)))
      SET_ELM_PLIST(l,2, INTOBJ_INT(4));
    return l;
  }

  mp_exp_t e = mpfr_get_exp(MPFR_OBJ(f));
  mpfr_set_exp(MPFR_OBJ(g), prec);

  mpz_t z;
  mpz_init2 (z, prec);
  mpfr_get_z (z, MPFR_OBJ(g), GMP_RNDZ);
  g = INT_mpz(z);
  mpz_clear(z);

  SET_ELM_PLIST(l,1, g);
  SET_ELM_PLIST(l,2, ObjInt_Int(e));
  return l;
}

static Obj OBJBYEXTREP_MPFR(Obj self, Obj list)
{
  Obj f, m = ELM_PLIST(list,1), e = ELM_PLIST(list,2);
  if (IS_INTOBJ(m)) {
    f = NEW_MPFR(8*sizeof(long));

    if (m == INTOBJ_INT(0)) /* special cases */
      switch (INT_INTOBJ(e)) {
      case 0: /* 0 */
	mpfr_set_si(MPFR_OBJ(f), 0, GMP_RNDN); return f;
      case 1: /* -0 */
	mpfr_set_inf(MPFR_OBJ(f), -1);
	mpfr_ui_div(MPFR_OBJ(f), 1, MPFR_OBJ(f), GMP_RNDN);
	return f;
      case 2: /* inf */
	mpfr_set_inf (MPFR_OBJ(f), 1); return f;
      case 3: /* -inf */
	mpfr_set_inf (MPFR_OBJ(f), -1); return f;
      case 4: /* nan */
      case 5: /* -nan */
	mpfr_set_nan (MPFR_OBJ(f)); return f;
      default:
	ErrorQuit("OBJBYEXTREP_MPFR: invalid argument [%d,%d]",
			 INT_INTOBJ(m), INT_INTOBJ(e));
      }

    mpfr_set_si(MPFR_OBJ(f), INT_INTOBJ(m), GMP_RNDN);
  } else {
    Obj mantissa = MPZ_LONGINT(m);
    f = NEW_MPFR(8*sizeof(mp_limb_t)*SIZE_INT(m));
    mpfr_set_z(MPFR_OBJ(f), mpz_MPZ(mantissa), GMP_RNDN);
  }

  if (IS_INTOBJ(e)) {
    mpfr_set_exp(MPFR_OBJ(f), INT_INTOBJ(e));
  } else {
    Obj exponent = MPZ_LONGINT(e);
    mpfr_set_exp(MPFR_OBJ(f), mpz_get_si(mpz_MPZ(exponent)));
  }
  return f;
}

/****************************************************************
 * print <mpfr> to string <s> in usual format .xxxeyyy,
 * with at most <digits> digits in mantissa.
 * removes trailing 0's from mantissa.
 ****************************************************************/
int PRINT_MPFR(char *s, mp_exp_t *xexp, int digits, mpfr_ptr f, mpfr_rnd_t rnd)
{
  mp_exp_t exp;

  s++; /* leave room for a '.' */
  mpfr_get_str (s, &exp, 10, digits, f, rnd);
  int slen = strlen(s);
  if (isdigit(s[slen-1])) { /* not an NaN or something */
    if (s[0] == '-') {
      s[-1] = '-'; s[0] = '.';
    } else
      s[-1] = '.';
    while (s[slen-1] == '0' && s[slen-2] != '.')
      slen--;
    s[slen++] = 'e';
    sprintf(s+slen,"%ld",exp);
    slen = strlen(s)+1;
  } else {
    int i;
    for (i = 0; i < slen; i++)
      s[i-1] = s[i];
  }
  if (xexp)
    *xexp = exp;
  return slen;
}

static Obj STRING_MPFR(Obj self, Obj f, Obj digits)
{
  mp_prec_t prec = mpfr_get_prec(GET_MPFR(f));
  Obj str = NEW_STRING(prec*302/1000+20);
  int slen, n;

  TEST_IS_INTOBJ("STRING_MPFR",digits);

  n = INT_INTOBJ(digits);
  if (n == 1) n = 2;

  slen = PRINT_MPFR(CSTR_STRING(str), 0, n, GET_MPFR(f), GMP_RNDN);
  SET_LEN_STRING(str, slen);
  SHRINK_STRING(str);

  return str;
}

static Obj MPFR_STRING(Obj self, Obj s, Obj prec)
{
  TEST_IS_STRING(MPFR_STRING, s);
  TEST_IS_INTOBJ("MPFR_STRING",prec);
  int n = INT_INTOBJ(prec);
  if (n == 0)
    n = GET_LEN_STRING(s)*1000/301;

  Obj g = NEW_MPFR(n);
  mpfr_set_str(MPFR_OBJ(g), CONST_CSTR_STRING(s), 10, GMP_RNDN);
  return g;
}

/****************************************************************
 * 2-argument functions
 ****************************************************************/
#define Func2_MPFR(name,mpfr_name)					\
  static Obj name(Obj self, Obj fl, Obj fr)				\
  {									\
    mp_prec_t precl = mpfr_get_prec(GET_MPFR(fl)),			\
      precr = mpfr_get_prec(GET_MPFR(fr));				\
									\
    Obj g = NEW_MPFR(precl > precr ? precl : precr);			\
    mpfr_name (MPFR_OBJ(g), GET_MPFR(fl), GET_MPFR(fr), GMP_RNDN);	\
    return g;								\
  }
#define Inc2_MPFR_arg(name,arg)			\
  { #name, 2, arg, (ObjFunc)(void *)(name), "src/mpfr.c:" #name }
#define Inc2_MPFR(name) Inc2_MPFR_arg(name,"float, float")

Func2_MPFR(SUM_MPFR,mpfr_add);
Func2_MPFR(DIFF_MPFR,mpfr_sub);
Func2_MPFR(PROD_MPFR,mpfr_mul);
Func2_MPFR(QUO_MPFR,mpfr_div);
Func2_MPFR(POW_MPFR,mpfr_pow);
Func2_MPFR(MOD_MPFR,mpfr_remainder);
Func2_MPFR(ATAN2_MPFR,mpfr_atan2);
Func2_MPFR(HYPOT_MPFR,mpfr_hypot);

static Obj LQUO_MPFR(Obj self, Obj fl, Obj fr)
{
  mp_prec_t precl = mpfr_get_prec(GET_MPFR(fl)),
    precr = mpfr_get_prec(GET_MPFR(fr));
  
  Obj g = NEW_MPFR(precl > precr ? precl : precr);
  mpfr_div (MPFR_OBJ(g), GET_MPFR(fr), GET_MPFR(fl), GMP_RNDN);
  return g;
}

static Obj ROOT_MPFR(Obj self, Obj fl, Obj fr)
{
  Obj g;
  TEST_IS_INTOBJ("ROOT_MPFR",fr);

  g = NEW_MPFR(mpfr_get_prec(GET_MPFR(fl)));
#if MPFR_VERSION_MAJOR >= 4
  mpfr_rootn_ui
#else
    mpfr_root
#endif
    (MPFR_OBJ(g), GET_MPFR(fl), INT_INTOBJ(fr), GMP_RNDN);
  return g;
}

static Obj EQ_MPFR (Obj self, Obj fl, Obj fr)
{
  return mpfr_cmp(GET_MPFR(fr),GET_MPFR(fl)) == 0 ? True : False;
}

static Obj LT_MPFR (Obj self, Obj fl, Obj fr)
{
  return mpfr_cmp(GET_MPFR(fl),GET_MPFR(fr)) < 0 ? True : False;
}

/****************************************************************
 * export functions
 ****************************************************************/
static StructGVarFunc GVarFuncs [] = {  
  Inc1_MPFR(AINV_MPFR),
  Inc1_MPFR(ABS_MPFR),
  Inc1_MPFR(INV_MPFR),

  Inc1_MPFR(COS_MPFR),
  Inc1_MPFR(SIN_MPFR),
  Inc1_MPFR(SINCOS_MPFR),
  Inc1_MPFR(TAN_MPFR),
  Inc1_MPFR(SEC_MPFR),
  Inc1_MPFR(CSC_MPFR),
  Inc1_MPFR(COT_MPFR),
  Inc1_MPFR(ASIN_MPFR),
  Inc1_MPFR(ACOS_MPFR),
  Inc1_MPFR(ATAN_MPFR)
,
  Inc1_MPFR(COSH_MPFR),
  Inc1_MPFR(SINH_MPFR),
  Inc1_MPFR(TANH_MPFR),
  Inc1_MPFR(SECH_MPFR),
  Inc1_MPFR(CSCH_MPFR),
  Inc1_MPFR(COTH_MPFR),
  Inc1_MPFR(ASINH_MPFR),
  Inc1_MPFR(ACOSH_MPFR),
  Inc1_MPFR(ATANH_MPFR),

  Inc1_MPFR(LOG_MPFR),
  Inc1_MPFR(LOG2_MPFR),
  Inc1_MPFR(LOG10_MPFR),
  Inc1_MPFR(LOG1P_MPFR),
  Inc1_MPFR(EXP_MPFR),
  Inc1_MPFR(EXP2_MPFR),
  Inc1_MPFR(EXP10_MPFR),
  Inc1_MPFR(EXPM1_MPFR),
  Inc1_MPFR(SQRT_MPFR),
  Inc1_MPFR(CBRT_MPFR),
  Inc1_MPFR(SQR_MPFR),

  Inc1_MPFR(ZERO_MPFR),
  Inc1_MPFR(ONE_MPFR),
  Inc1_MPFR_arg(MPFR_MAKENAN,"int"),
  Inc1_MPFR_arg(MPFR_MAKEINFINITY,"int"),
  Inc1_MPFR_arg(MPFR_LOG2,"int"),
  Inc1_MPFR_arg(MPFR_PI,"int"),
  Inc1_MPFR_arg(MPFR_EULER,"int"),
  Inc1_MPFR_arg(MPFR_CATALAN,"int"),
  Inc1_MPFR_arg(MPFR_INT,"int"),

  Inc1_MPFR(CEIL_MPFR),
  Inc1_MPFR(FLOOR_MPFR),
  Inc1_MPFR(ROUND_MPFR),
  Inc1_MPFR(TRUNC_MPFR),
  Inc1_MPFR(FRAC_MPFR),

  Inc1_MPFR(INT_MPFR),
  Inc1_MPFR(PREC_MPFR),
  Inc1_MPFR(MPFR_MACFLOAT),
  Inc1_MPFR(MACFLOAT_MPFR),
  Inc1_MPFR(SIGN_MPFR),
  Inc1_MPFR(SIGNBIT_MPFR),
  Inc1_MPFR(ISNAN_MPFR),
  Inc1_MPFR(ISXINF_MPFR),
  Inc1_MPFR(ISPINF_MPFR),
  Inc1_MPFR(ISNINF_MPFR),
  Inc1_MPFR(ISZERO_MPFR),
  Inc1_MPFR(ISNUMBER_MPFR),

  Inc1_MPFR(FREXP_MPFR),
  Inc2_MPFR_arg(LDEXP_MPFR,"float, int"),
  Inc1_MPFR(EXTREPOFOBJ_MPFR),
  Inc1_MPFR_arg(OBJBYEXTREP_MPFR,"list"),

  Inc2_MPFR(SUM_MPFR),
  Inc2_MPFR(DIFF_MPFR),
  Inc2_MPFR(PROD_MPFR),
  Inc2_MPFR(QUO_MPFR),
  Inc2_MPFR(LQUO_MPFR),
  Inc2_MPFR(POW_MPFR),
  Inc2_MPFR(MOD_MPFR),
  Inc2_MPFR(ATAN2_MPFR),
  Inc2_MPFR(HYPOT_MPFR),
  Inc2_MPFR(EQ_MPFR),
  Inc2_MPFR(LT_MPFR),
  Inc2_MPFR_arg(MPFR_STRING,"string, int"),
  Inc2_MPFR_arg(STRING_MPFR,"float, int"),
  Inc2_MPFR_arg(ROOT_MPFR,"float, int"),
  Inc2_MPFR_arg(MPFR_INTPREC,"int, int"),
  Inc2_MPFR_arg(MPFR_MPFRPREC,"float, int"),
  {0}
};

int InitMPFRKernel (void)
{
  InitHdlrFuncsFromTable (GVarFuncs);

  ImportGVarFromLibrary ("TYPE_MPFR", &TYPE_MPFR);
  ImportGVarFromLibrary ("IsMPFRFloat", &IsMPFRFloat);
  ImportGVarFromLibrary ("infinity", &GAP_INFINITY);
  return 0;
}

int InitMPFRLibrary (void)
{
  InitGVarFuncsFromTable (GVarFuncs);
  return 0;
}

/****************************************************************************
**
*E  mpfr.c  . . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
*/
