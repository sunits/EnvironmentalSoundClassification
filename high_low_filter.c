#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[],
/* Output variables */
int nrhs, const mxArray *prhs[]) /* Input variables */
{
	mexPrintf("Hello, world!\n"); /* Do something interesting */
	return;
}

