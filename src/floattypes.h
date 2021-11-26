/****************************************************************************
**
*W  floattypes.h                  GAP source                Laurent Bartholdi
**
*Y  Copyright (C) 2008-2012 Laurent Bartholdi
**
**  This file declares the functions for the floating point package
*/

#ifndef FLOATTYPES_H
#define FLOATTYPES_H

#include "gap_all.h"

#include <gmp.h>

#ifdef __cplusplus
extern "C" {
#endif

Obj MPZ_LONGINT (Obj obj);
Obj INT_mpz(mpz_ptr z);
mpz_ptr mpz_MPZ (Obj obj);

#define VAL_MACFLOAT(obj) (*(Double *)ADDR_OBJ(obj))
#define IS_MACFLOAT(obj) (TNUM_OBJ(obj) == T_MACFLOAT)

#define TEST_IS_INTOBJ(mp_name,obj)					\
  if (!IS_INTOBJ(obj))						\
    ErrorMayQuit(#mp_name ": expected a small integer, not a %s", \
			 (Int)TNAM_OBJ(obj),0);

#define TEST_IS_STRING(gap_name,obj)				\
  if (!IsStringConv(obj))					\
    ErrorMayQuit(#gap_name ": expected a string, not a %s",	\
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
int InitMPFIKernel (void);
int InitMPFILibrary (void);
#endif

/****************************************************************
 * mpc
 ****************************************************************/
#ifdef USE_MPC
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
int InitCXSCKernel (void);
int InitCXSCLibrary (void);
#endif


#ifdef __cplusplus
} // extern "C"
#endif

#endif // FLOATTYPES_H
