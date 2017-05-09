/****************************************************************************
**
*W  float.c                      GAP source                 Laurent Bartholdi
**
*Y  Copyright (C) 2008-2012 Laurent Bartholdi
**
**  This file contains the main dll of the float package.
**  It defers to mpfr.c, mpfi.c etc. for initialization
*/
#undef TRACE_ALLOC

#include "floatconfig.h"

#undef PACKAGE
#undef PACKAGE_BUGREPORT
#undef PACKAGE_NAME
#undef PACKAGE_STRING
#undef PACKAGE_TARNAME
#undef PACKAGE_URL
#undef PACKAGE_VERSION

#include <string.h>
#include <stdio.h>
#include <gmp.h>

#include "src/compiled.h"
#include "floattypes.h"

Obj FLOAT_INFINITY_STRING, /* pretty strings */
  FLOAT_NINFINITY_STRING,
  FLOAT_EMPTYSET_STRING,
  FLOAT_REAL_STRING,
  FLOAT_I_STRING;

Obj NEW_DATOBJ(size_t size, Obj type)
{
  Obj o = NewBag(T_DATOBJ,sizeof(Obj)+size);
  TYPE_DATOBJ(o) = type;
  return o;
}

/****************************************************************
 * convert long GAP integer to gmp signed integers and back:
 * mpz (malloc'ed) or MPZ (on GAP heap)
 * in the current gmp implementation, we put mpz's as follows:
 * +------------+------------+------------+------------+---
 * | _mp_alloc  |  _mp_size  |  _mp_d  ---+--> limb0   |   limb1
 * +------------+------------+------------+------------+---
 ****************************************************************/
Obj MPZ_LONGINT (Obj obj) {
  Obj f;
  mpz_ptr p;
  int s;

  f = NewBag(T_DATOBJ,SIZE_OBJ(obj)+sizeof(__mpz_struct));
  p = mpz_MPZ(f);
  s = SIZE_INT(obj);
  p->_mp_alloc = s;

  memcpy (p->_mp_d, ADDR_INT(obj), s*sizeof(mp_limb_t));

  while (s > 1 && !p->_mp_d[s-1]) s--; /* trim trailing 0's, gmp wants it */

  if (TNUM_OBJ(obj) == T_INTPOS)
    p->_mp_size = s;
  else if (TNUM_OBJ(obj) == T_INTNEG)
    p->_mp_size = -s;
  else
    ErrorQuit("Internal error: MPZ_LONGINT called with non-LONGINT. Repent.",0L,0L);

  return f;
}

mpz_ptr mpz_MPZ (Obj obj) {
  mpz_ptr p = (mpz_ptr) ADDR_OBJ(obj);

  /* adjust pointer, in case the block moved in a garbage-collect */
  p->_mp_d = (mp_limb_t *) (p+1);

  return p;
}

Obj INT_mpz(mpz_ptr z)
{
  if (mpz_sgn(z) == 0) {
    return INTOBJ_INT(0);
  }

  Obj res;
  if (mpz_sgn(z) > 0)
    res = NewBag(T_INTPOS, mpz_size(z)*sizeof(mp_limb_t));
  else
    res = NewBag(T_INTNEG, mpz_size(z)*sizeof(mp_limb_t));
  memcpy (ADDR_INT(res), z[0]._mp_d, mpz_size(z)*sizeof(mp_limb_t));

  res = GMP_NORMALIZE(res);
  res = GMP_REDUCE(res);

  return res;
}

#if 0
/****************************************************************
 * debug allocation / deallocation
 ****************************************************************/
static void *alloc_func (size_t s)
{
  void *res = malloc(s);
#ifdef TRACE_ALLOC
  printf("#W gmp_default_allocate called for bag of size %d, returned %x\n", s, (int) res);
#endif
  return res;
}

static void *realloc_func (void *p, size_t old, size_t new)
{
  void *res = realloc(p, new);
#ifdef TRACE_ALLOC
  printf("#W gmp_default_reallocate called on bag of size %d->%d at %x, returned %x\n", old, new, (int) p, (int) res);
#endif
  return res;
}

static void free_func (void *p, size_t s)
{
  free (p);
#ifdef TRACE_ALLOC
  printf("#W gmp_default_free called on bag of size %d at %x\n", s, (int) p);
#endif
}
#endif

/****************************************************************
 * initialize package
 ****************************************************************/
static Int InitKernel (StructInitInfo *module)
{
  ImportGVarFromLibrary("FLOAT_INFINITY_STRING", &FLOAT_INFINITY_STRING);
  ImportGVarFromLibrary("FLOAT_NINFINITY_STRING", &FLOAT_NINFINITY_STRING);
  ImportGVarFromLibrary("FLOAT_EMPTYSET_STRING", &FLOAT_EMPTYSET_STRING);
  ImportGVarFromLibrary("FLOAT_REAL_STRING", &FLOAT_REAL_STRING);
  ImportGVarFromLibrary("FLOAT_I_STRING", &FLOAT_I_STRING);

#ifdef USE_MPFR
  InitMPFRKernel();
#endif
#ifdef USE_MPFI
  InitMPFIKernel();
#endif
#ifdef USE_MPC
  InitMPCKernel();
#endif
#ifdef USE_FPLLL
  InitFPLLLKernel();
#endif
#ifdef USE_MPD
  InitMPDKernel();
#endif
#ifdef USE_CXSC
  InitCXSCKernel();
#endif
  return 0;
}

static Int InitLibrary (StructInitInfo *module)
{
#ifdef USE_MPFI
  InitMPFILibrary();
#endif
#ifdef USE_MPFR
  InitMPFRLibrary();
#endif
#ifdef USE_MPC
  InitMPCLibrary();
#endif
#ifdef USE_FPLLL
  InitFPLLLLibrary();
#endif
#ifdef USE_MPD
  InitMPDLibrary();
#endif
#ifdef USE_CXSC
  InitCXSCLibrary();
#endif
#if 0
  mp_set_memory_functions (alloc_func, realloc_func, free_func);
#endif

  return 0;
}

static StructInitInfo module = {
#ifdef FLOATSTATIC
  MODULE_STATIC,                        /* type                           */
#else
  MODULE_DYNAMIC,                       /* type                           */
#endif
    "float",                            /* name                           */
    0,                                  /* revision entry of c file       */
    0,                                  /* revision entry of h file       */
    0,                                  /* version                        */
    0,                                  /* crc                            */
    InitKernel,                         /* initKernel                     */
    InitLibrary,                        /* initLibrary                    */
    0,                                  /* checkInit                      */
    0,                                  /* preSave                        */
    0,                                  /* postSave                       */
    0                                   /* postRestore                    */
};

#ifdef FLOAT_STATIC
StructInitInfo *Init__float (void)
#else
StructInitInfo *Init__Dynamic (void)
#endif
{
  return &module;
}

/****************************************************************************
**
*E  float.c  . . . . . . . . . . . . . . . . . . . . . . . . . . . .ends here
*/
