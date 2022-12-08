OPENQASM 3.0;

include "stdgates.inc"

float fa = 3.14;
float fb = -5.16;
float fc = 47.33;

// 1. Sin.
float fx = sin(fa);

// 2. Cos.
float fy = cos(fx);

// 3. Tan.
float fz = tan(sin(fy));



