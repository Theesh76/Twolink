#include <stdio.h>
#include <math.h>
#include "mex.h"
signed int sign(double v) 
{
  if (v < 0) return -1;
  if (v > 0) return 1;
  return 0;
}
void Reg(const double* q, const double* dq, const double* ddq ,double* H, mwSize n)
{
  double x0 = ((dq[0])*(dq[0]));
  double x1 = ddq[0] + ddq[1];
  double x2 = sin(q[1]);
  double x3 = dq[0]*x2;
  double x4 = dq[0] + dq[1];
  double x5 = cos(q[1]);
  double x6 = ddq[0]*x5 - dq[1]*x3 + x3*x4;
  double x7 = -((x4)*(x4));
  double x8 = dq[0]*x5;
  double x9 = ddq[0]*x2 + dq[1]*x8;
  double x10 = x4*x8;
  double x11 = x10 - x9;
//
  H[0] = 0;
  H[1] = 0;
  H[2] = 0;
  H[3] = 0;
  H[4] = 0;
  H[5] = ddq[0];
  H[6] = 2*ddq[0];
  H[7] = 0;
  H[8] = 0;
  H[9] = ddq[0];
  H[10] = 0;
  H[11] = 0;
  H[12] = 0;
  H[13] = 0;
  H[14] = 0;
  H[15] = x1;
  H[16] = x1*x5 + x2*x7 + x6;
  H[17] = -x1*x2 + x11 + x5*x7;
  H[18] = 0;
  H[19] = x2*(-x10 + x9) + x5*x6;
  H[20] = 0;
  H[21] = 0;
  H[22] = 0;
  H[23] = 0;
  H[24] = 0;
  H[25] = 0;
  H[26] = 0;
  H[27] = 0;
  H[28] = 0;
  H[29] = 0;
  H[30] = 0;
  H[31] = 0;
  H[32] = 0;
  H[33] = 0;
  H[34] = 0;
  H[35] = x1;
  H[36] = x6;
  H[37] = x11;
  H[38] = 0;
  H[39] = 0;
  return;
}
// {
//   double x0 = ((dq[0])*(dq[0]));
//   double x1 = ddq[0] + ddq[1];
//   double x2 = sin(q[1]);
//   double x3 = dq[0]*x2;
//   double x4 = dq[0] + dq[1];
//   double x5 = -dq[1];
//   double x6 = cos(q[1]);
//   double x7 = ((x2)*(x2)) + ((x6)*(x6));
//   double x8 = ddq[0]*x6 + ddq[0]*x7 + ddq[1] + x3*x4 + x3*x5;
//   double x9 = -((x4)*(x4));
//   double x10 = dq[0]*x6 + dq[0]*x7;
//   double x11 = x4*(dq[1] + x10);
//   double x12 = ddq[0]*x2 + dq[0]*x5 + dq[1]*x10;
//   double x13 = x11 - x12;
//   H[0] = 0;
//   H[1] = 0;
//   H[2] = 0;
//   H[3] = 0;
//   H[4] = 0;
//   H[5] = ddq[0];
//   H[6] = 2*ddq[0];
//   H[7] = 0;
//   H[8] = 0;
//   H[9] = ddq[0];
//   H[10] = dq[0];
//   H[11] = sign(dq[0]);
//   H[12] = 0;
//   H[13] = 0;
//   H[14] = 0;
//   H[15] = 0;
//   H[16] = 0;
//   H[17] = x1;
//   H[18] = x1*x6 + x1*x7 + x2*x9 + x8;
//   H[19] = -x1*x2 + x13 + x6*x9 + x7*x9;
//   H[20] = 0;
//   H[21] = x2*(-x11 + x12) + x6*x8 + x7*x8;
//   H[22] = 0;
//   H[23] = 0;
//   H[24] = 0;
//   H[25] = 0;
//   H[26] = 0;
//   H[27] = 0;
//   H[28] = 0;
//   H[29] = 0;
//   H[30] = 0;
//   H[31] = 0;
//   H[32] = 0;
//   H[33] = 0;
//   H[34] = 0;
//   H[35] = 0;
//   H[36] = 0;
//   H[37] = 0;
//   H[38] = 0;
//   H[39] = 0;
//   H[40] = 0;
//   H[41] = x1;
//   H[42] = x1 + x8;
//   H[43] = x13 + x9;
//   H[44] = 0;
//   H[45] = x8;
//   H[46] = dq[1];
//   H[47] = sign(dq[1]);   
//     return;
// }

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    double multiplier;              /* input scalar */
    double *inMatrix;               /* 1xN input matrix */
    double *inMatrix1; 
    double *inMatrix2; 
    mwSize ncols;                  /* size of matrix */
    double *outMatrix;              /* output matrix */

    /* check for proper number of arguments */
    if(nrhs!=3) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs","Two inputs required.");
    }
    if(nlhs!=1) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nlhs","One output required.");
    }
    
    /* make sure the second input argument is type double */
    if( !mxIsDouble(prhs[0]) || 
         mxIsComplex(prhs[0])) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:notDouble","Input matrix must be type double.");
    }
    
    if( !mxIsDouble(prhs[1]) || 
         mxIsComplex(prhs[1])) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:notDouble","Input matrix must be type double.");
    }
    
    if( !mxIsDouble(prhs[2]) || 
         mxIsComplex(prhs[2])) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:notDouble","Input matrix must be type double.");
    }
    if(mxGetM(prhs[0])!=1) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:notRowVector","Input must be a row vector.");
    }
    
    /* check that number of rows in second input argument is 1 */
    if(mxGetM(prhs[1])!=1) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:notRowVector","Input must be a row vector.");
    }
    
    if(mxGetM(prhs[2])!=1) {
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:notRowVector","Input must be a row vector.");
    }
    
    /* create a pointer to the real data in the input matrix  */
    inMatrix = mxGetPr(prhs[0]);
    inMatrix1 = mxGetPr(prhs[1]);
    inMatrix2 = mxGetPr(prhs[2]);
    /* create the output matrix */
    plhs[0] = mxCreateDoubleMatrix(1,40,mxREAL);

    /* get a pointer to the real data in the output matrix */
    outMatrix = mxGetPr(plhs[0]);

    /* call the computational routine */
    Reg(inMatrix,inMatrix1,inMatrix2,outMatrix,ncols);
}
