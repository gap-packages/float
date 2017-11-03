/****************************************************************************
**
*W  gapfloat.h                    GAP source                Laurent Bartholdi
**
*Y  Copyright (C) 2008-2012 Laurent Bartholdi
**
**  This file declares the functions for the floating point package
*/

#ifndef USE_GMP
#error Float requires a GAP version with built-in GMP support
#endif

Obj MPZ_LONGINT (Obj obj);
Obj INT_mpz(mpz_ptr z);
mpz_ptr mpz_MPZ (Obj obj);

#define VAL_MACFLOAT(obj) (*(Double *)ADDR_OBJ(obj))
#define IS_MACFLOAT(obj) (TNUM_OBJ(obj) == T_MACFLOAT)

#define TEST_IS_INTOBJ(mp_name,obj)					\
  while (!IS_INTOBJ(obj))						\
    obj = ErrorReturnObj(#mp_name ": expected a small integer, not a %s", \
			 (Int)TNAM_OBJ(obj),0,		\
			 "You can return an integer to continue");

#define TEST_IS_STRING(gap_name,obj)				\
  if (!IsStringConv(obj))					\
    ErrorQuit(#gap_name ": expected a string, not a %s",	\
	      (Int)TNAM_OBJ(obj),0)

extern Obj FLOAT_INFINITY_STRING,
  FLOAT_NINFINITY_STRING,
  FLOAT_EMPTYSET_STRING,
  FLOAT_REAL_STRING,
  FLOAT_I_STRING;

Obj NEW_DATOBJ (size_t size, Obj type);

/****************************************************************
 * mpfr
 ****************************************************************/
#ifdef USE_MPFR
#include <mpfr.h>

/****************************************************************
 * mpfr's are stored as follows:
 * +-----------+----------------------------------+-------------+
 * | TYPE_MPFR |           __mpfr_struct          | mp_limb_t[] |
 * |           | precision exponent sign mantissa |             |
 * +-----------+----------------------------------+-------------+
 *                                          \_______^
 ****************************************************************/
#define MPFR_OBJ(obj) ((mpfr_ptr) (ADDR_OBJ(obj)+1))
Obj NEW_MPFR (mp_prec_t prec);
mpfr_ptr GET_MPFR(Obj obj);

int PRINT_MPFR(char *s, mp_exp_t *exp, int digits, mpfr_ptr f, mpfr_rnd_t rnd);

int InitMPFRKernel (void);
int InitMPFRLibrary (void);
#endif

/****************************************************************
 * mpfi
 ****************************************************************/
#ifdef USE_MPFI
#include <mpfi.h>

/****************************************************************
 * mpfi's are stored as follows:
 * +-----------+-----------------------------------------+---------------------+
 * | TYPE_MPFI |             __mpfi_struct               |    __mp_limb_t[]    |
 * |           | __mpfr_struct left         right        | limbl ... limbr ... |
 * |           | prec exp sign mant   prec exp sign mant |                     |
 * +-----------+-----------------------------------------+---------------------+
 *                               \____________________\____^         ^
 *                                                     \____________/
 * it is assumed that the left and right mpfr's are allocated with the
 * same precision
 ****************************************************************/
#define MPFI_OBJ(obj) ((mpfi_ptr) (ADDR_OBJ(obj)+1))

int InitMPFIKernel (void);
int InitMPFILibrary (void);
#endif

/****************************************************************
 * mpc
 ****************************************************************/
#ifdef USE_MPC
#include <mpc.h>

int InitMPCKernel (void);
int InitMPCLibrary (void);
#endif

/****************************************************************
 * fplll
 ****************************************************************/
#ifdef USE_FPLLL
int InitFPLLLKernel (void);
int InitFPLLLLibrary (void);
#endif

/****************************************************************
 * mpd
 ****************************************************************/
#ifdef USE_MPD
int InitMPDKernel (void);
int InitMPDLibrary (void);
#endif

/****************************************************************
 * cxsc
 ****************************************************************/
#ifdef USE_CXSC
#define ERROR_CXSC(gap_name,obj)				      \
  ErrorQuit(#gap_name ": argument must be a CXSC float, not a %s",    \
	    (Int)TNAM_OBJ(obj),0)

#ifdef __cplusplus
static inline bool HAS_FILTER(Obj obj, Obj filter)
{
  return DoFilter(filter,obj) == True;
  return IS_DATOBJ(obj) && DoFilter(filter,obj) == True;
}
#endif
#define IS_RP(obj) HAS_FILTER(obj,IS_CXSC_RP)
#define TEST_IS_RP(gap_name,obj)				\
  if (!IS_RP(obj))						\
    ErrorQuit(#gap_name ": expected a real, not a %s",		\
	       (Int)TNAM_OBJ(obj),0)

#define IS_CP(obj) HAS_FILTER(obj,IS_CXSC_CP)
#define TEST_IS_CP(gap_name,obj)				\
  if (!IS_CP(obj))						\
    ErrorQuit(#gap_name ": expected a complex, not a %s",	\
	       (Int)TNAM_OBJ(obj),0)

#define IS_RI(obj) HAS_FILTER(obj,IS_CXSC_RI)
#define TEST_IS_RI(gap_name,obj)			       	\
  if (!IS_RI(obj))						\
    ErrorQuit(#gap_name ": expected an interval, not a %s",	\
	       (Int)TNAM_OBJ(obj),0)

#define IS_CI(obj) HAS_FILTER(obj,IS_CXSC_CI)
#define TEST_IS_CI(gap_name,obj)			       	\
  if (!IS_CI(obj))					       	\
    ErrorQuit(#gap_name ": expected a complex interval, not a %s",\
	       (Int)TNAM_OBJ(obj),0)

/****************************************************************
 * cxsc data are stored as follows:
 * +--------------------+----------+
 * | TYPE_CXSC_RI       | interval  |
 * +--------------------+----------+
 ****************************************************************/
#define RP_OBJ(obj) (*(cxsc::real *) (ADDR_OBJ(obj)+1))
#define RI_OBJ(obj) (*(cxsc::interval *) (ADDR_OBJ(obj)+1))
#define CP_OBJ(obj) (*(cxsc::complex *) (ADDR_OBJ(obj)+1))
#define CI_OBJ(obj) (*(cxsc::cinterval *) (ADDR_OBJ(obj)+1))

#ifdef _CXSC_COMPLEX_HPP_INCLUDED
int cpoly_CXSC(int degree, cxsc::complex coeffs[], cxsc::complex roots[], int prec);
#endif
int InitCXSCKernel (void);
int InitCXSCLibrary (void);
#endif

/****************************************************************************
**
*E  gapfloat.h  . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
*/
