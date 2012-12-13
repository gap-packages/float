#include <mpc.h>

mpc_t coeff[], partial[], x, s, rot94, z;
mpfr_t norm[], bound;

double eta, infin, smalno, base;

static void noshft (const int l1);
static int fxshft (const int l2, mpc_ptr z);
static void scale (mpfr_ptr bound, const int n, mpfr_t norm[], const double eta, const double infin, const double smalno, const double base);
static void cauchy (mpfr_ptr bound, const int n, mpfr_t norm[]);

static void vrshft (const int l3, double *zr, double *zi, int *conv);
static void calct (int *bol);
static void nexth (const int bol);
static void polyev (const int nn, const double sr, const double si, const double pr[], const double pi[], double qr[], double qi[], double *pvr, double *pvi);
static double errev (const int nn, const double qr[], const double qi[], const double ms, const double mp, const double are, const double mre);


int cpoly (mpc_ptr zero[], mpc_srcptr incoeff[], int degree)
{
  int i, cnt1, cnt2, nroots = degree;

  if (mpc_cmp_si (incoeff[0], 0) == 0)
    return -1;

  while (mpc_cmp_si (incoeff[nroots], 0) == 0)
    mpc_set_ui (zero[degree-nroots], 0, MPC_RNDNN), nroots--;

  for (i = 0; i <= nroots; i++) {
    mpc_set (coeff[i], incoeff[i], MPC_RNDNN);
    mpc_abs (norm[i], coeff[i], MPC_RNDNN);
  }

  scale (bound, nroots, norm, eta, infin, smalno, base);
  if (mpfr_cmp_ui (bound, 1) != 0)
    for (i = 0; i <= nroots; i++)
      mpc_mul_fr (coeff[i], coeff[i], bound, MPC_RNDNN);

  mpc_set_si_si (x, 0, -1, MPC_RNDNN); mpc_sqrt (x, x, MPC_RNDNN);
  mpc_set_d_d (rot94, -0.060756474, -0.99756405, MPC_RNDNN);

 search:
  if (nroots <= 1) {
    mpc_div (zero[degree-1], coeff[1], coeff[0], MPC_RNDNN);
    mpc_neg (zero[degree-1], zero[degree-1], MPC_RNDNN);
    goto finish;
  }

  for (i = 0; i <= nroots; i++)
    mpc_abs (norm[i], coeff[i], MPC_RNDNN);

  cauchy (bound, nroots, norm);

  for (cnt1 = 1; cnt1 <= 2; cnt1++) {
    // First stage calculation, no shift
    noshft (5);

    // Inner loop to select a shift
    for (cnt2 = 1; cnt2 <= 9; cnt2++) {
      mpc_mul (x, x, rot94, MPC_RNDNN);
      mpc_mul_fr (s, x, bound, MPC_RNDNN);

      // Second stage calculation, fixed shift
      if (fxshft (10*cnt2, z)) {
	// The second stage jumps directly to the third stage iteration
	// If successful the zero is stored and the polynomial deflated
	mpc_set (zero[degree-nroots], z, MPC_RNDNN);
	nroots--;
	for (i = 0; i <= nroots; i++)
	  mpc_set (coeff[i], partial[i], MPC_RNDNN);
	goto search;
      }
      // If the iteration is unsuccessful another shift is chosen
    }
    // If 9 shifts fail, the outer loop is repeated with another sequence of shifts
  }
  degree -= nroots;

 finish:
  return degree;
}

// COMPUTES  THE DERIVATIVE  POLYNOMIAL AS THE INITIAL H
// POLYNOMIAL AND COMPUTES L1 NO-SHIFT H POLYNOMIALS.
//
static void noshft (const int l1)
{
  int i, j;

  for (i = 0; i < nroots; i++) {
    mpc_mul_ui (h[i], coeff[i], nroots-i, MPC_RNDNN);
    mpc_div_ui (h[i], h[i], nroots);
  }

  for (j = 1; j <= l1; j++) {
    mpc_abs (t, h[nroots-1]);
    mpc_div_d (t, t, eta*10);
    if (mpc_cmp (t, norm[nroots-1]) > 0) {
      mpc_div (t, coeff[nroots], h[nroots-1]);
      mpc_neg (t, t);
      for (i = nroots-1; i > 0; i--) {
	mpc_mul (h[i], h[i+1], t);
	mpc_add (h[i], h[i], coeff[i]);
      }
      mpc_set (h[0], coeff[0]);
    } else {
      // If the constant term is essentially zero, shift H coefficients
      for (i = nroots-1; i > 0; i--) {
	mpc_set (h[i], h[i+1]);
      }
      mpc_set (h[0], coeff[0]);
    }
  }
}

// COMPUTES L2 FIXED-SHIFT H POLYNOMIALS AND TESTS FOR CONVERGENCE.
// INITIATES A VARIABLE-SHIFT ITERATION AND RETURNS WITH THE
// APPROXIMATE ZERO IF SUCCESSFUL.
// L2 - LIMIT OF FIXED SHIFT STEPS
// ZR,ZI - APPROXIMATE ZERO IF CONV IS .TRUE.
// CONV  - LOGICAL INDICATING CONVERGENCE OF STAGE 3 ITERATION
//
static void fxshft( const int l2, double *zr, double *zi, int *conv )
   {
   int i, j, n;
   int test, pasd, bol;
   double otr, oti, svsr, svsi;

   n = nn;
   polyev( nn, sr, si, pr, pi, qpr, qpi, &pvr, &pvi );
   test = 1;
   pasd = 0;

   // Calculate first T = -P(S)/H(S)
   calct( &bol );

   // Main loop for second stage
   for( j = 1; j <= l2; j++ )
      {
      otr = tr;
      oti = ti;

      // Compute the next H Polynomial and new t
      nexth( bol );
      calct( &bol );
      *zr = sr + tr;
      *zi = si + ti;

      // Test for convergence unless stage 3 has failed once or this
      // is the last H Polynomial
      if( !( bol || !test || j == 12 ) )
         if( cmod( tr - otr, ti - oti ) < 0.5 * cmod( *zr, *zi ) )
            {
            if( pasd )
               {
               // The weak convergence test has been passwed twice, start the third stage
               // Iteration, after saving the current H polynomial and shift
               for( i = 0; i < n; i++ )
                  {
                  shr[ i ] = hr[ i ];
                  shi[ i ] = hi[ i ];
                  }
               svsr = sr;
               svsi = si;
               vrshft( 10, zr, zi, conv );
               if( *conv ) return;

               //The iteration failed to converge. Turn off testing and restore h,s,pv and T
               test = 0;
               for( i = 0; i < n; i++ )
                  {
                  hr[ i ] = shr[ i ];
                  hi[ i ] = shi[ i ];
                  }
               sr = svsr;
               si = svsi;
               polyev( nn, sr, si, pr, pi, qpr, qpi, &pvr, &pvi );
               calct( &bol );
               continue;
               }
            pasd = 1;
            }
         else
            pasd = 0;
      }

   // Attempt an iteration with final H polynomial from second stage
   vrshft( 10, zr, zi, conv );
   }
