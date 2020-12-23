#include <R.h>
#include <R_ext/RS.h>
#include <R_ext/Rdynload.h>
#include <Rinternals.h>
#include <stdlib.h>  // for NULL

/* .Fortran calls */
void F77_SUB(hiclimr)(int *n, int *len, int *iopt, int *ia, int *ib,
                      double *crit, double *membr, double *var, double *diss);
void F77_SUB(hcass2)(int *n, int *ia, int *ib, int *iorder, int *iia, int *iib);

static const R_FortranMethodDef FortranEntries[] = {
    {"hiclimr", (DL_FUNC)&F77_NAME(hiclimr), 9},
    {"hcass2", (DL_FUNC)&F77_NAME(hcass2), 6},
    {NULL, NULL, 0}};

void R_init_HiClimR(DllInfo *dll) {
  R_registerRoutines(dll, NULL, NULL, FortranEntries, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
