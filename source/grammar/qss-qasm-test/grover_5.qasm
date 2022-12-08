OPENQASM 2.0;
include "qelib1.inc";

qreg qubits[9];
x qubits[5];
h qubits[0];
h qubits[1];
h qubits[2];
h qubits[3];
h qubits[4];
x qubits[4];
x qubits[0];
x qubits[1];
ccx qubits[0],qubits[1],qubits[6];
ccx qubits[2],qubits[6],qubits[7];
ccx qubits[3],qubits[7],qubits[8];
h qubits[5];
ccx qubits[4],qubits[8],qubits[5];
ccx qubits[3],qubits[7],qubits[8];
ccx qubits[2],qubits[6],qubits[7];
ccx qubits[0],qubits[1],qubits[6];
x qubits[4];
x qubits[0];
x qubits[1];
h qubits[0];
h qubits[1];
h qubits[2];
h qubits[3];
h qubits[4];
x qubits[4];
x qubits[0];
x qubits[1];
x qubits[2];
x qubits[3];
ccx qubits[0],qubits[1],qubits[6];
ccx qubits[2],qubits[6],qubits[7];
ccx qubits[3],qubits[7],qubits[4];
ccx qubits[2],qubits[6],qubits[7];
ccx qubits[0],qubits[1],qubits[6];
x qubits[4];
x qubits[0];
x qubits[1];
x qubits[2];
x qubits[3];
h qubits[0];
h qubits[1];
h qubits[2];
h qubits[3];
h qubits[4];
x qubits[4];
x qubits[0];
x qubits[1];
ccx qubits[0],qubits[1],qubits[6];
ccx qubits[2],qubits[6],qubits[7];
ccx qubits[3],qubits[7],qubits[8];
ccx qubits[4],qubits[8],qubits[5];
ccx qubits[3],qubits[7],qubits[8];
ccx qubits[2],qubits[6],qubits[7];
ccx qubits[0],qubits[1],qubits[6];
x qubits[4];
x qubits[0];
x qubits[1];
h qubits[0];
h qubits[1];
h qubits[2];
h qubits[3];
h qubits[4];
x qubits[4];
x qubits[0];
x qubits[1];
x qubits[2];
x qubits[3];
ccx qubits[0],qubits[1],qubits[6];
ccx qubits[2],qubits[6],qubits[7];
ccx qubits[3],qubits[7],qubits[4];
ccx qubits[2],qubits[6],qubits[7];
ccx qubits[0],qubits[1],qubits[6];
x qubits[4];
x qubits[0];
x qubits[1];
x qubits[2];
x qubits[3];
h qubits[0];
h qubits[1];
h qubits[2];
h qubits[3];
h qubits[4];
x qubits[4];
x qubits[0];
x qubits[1];
ccx qubits[0],qubits[1],qubits[6];
ccx qubits[2],qubits[6],qubits[7];
ccx qubits[3],qubits[7],qubits[8];
ccx qubits[4],qubits[8],qubits[5];
ccx qubits[3],qubits[7],qubits[8];
ccx qubits[2],qubits[6],qubits[7];
ccx qubits[0],qubits[1],qubits[6];
x qubits[4];
x qubits[0];
x qubits[1];
h qubits[0];
h qubits[1];
h qubits[2];
h qubits[3];
h qubits[4];
x qubits[4];
x qubits[0];
x qubits[1];
x qubits[2];
x qubits[3];
ccx qubits[0],qubits[1],qubits[6];
ccx qubits[2],qubits[6],qubits[7];
ccx qubits[3],qubits[7],qubits[4];
ccx qubits[2],qubits[6],qubits[7];
ccx qubits[0],qubits[1],qubits[6];
x qubits[4];
x qubits[0];
x qubits[1];
x qubits[2];
x qubits[3];
h qubits[0];
h qubits[1];
h qubits[2];
h qubits[3];
h qubits[4];
x qubits[4];
x qubits[0];
x qubits[1];
ccx qubits[0],qubits[1],qubits[6];
ccx qubits[2],qubits[6],qubits[7];
ccx qubits[3],qubits[7],qubits[8];
ccx qubits[4],qubits[8],qubits[5];
ccx qubits[3],qubits[7],qubits[8];
ccx qubits[2],qubits[6],qubits[7];
ccx qubits[0],qubits[1],qubits[6];
x qubits[4];
x qubits[0];
x qubits[1];
h qubits[0];
h qubits[1];
h qubits[2];
h qubits[3];
h qubits[4];
x qubits[4];
x qubits[0];
x qubits[1];
x qubits[2];
x qubits[3];
ccx qubits[0],qubits[1],qubits[6];
ccx qubits[2],qubits[6],qubits[7];
ccx qubits[3],qubits[7],qubits[4];
ccx qubits[2],qubits[6],qubits[7];
ccx qubits[0],qubits[1],qubits[6];
x qubits[4];
x qubits[0];
x qubits[1];
x qubits[2];
x qubits[3];
h qubits[0];
h qubits[1];
h qubits[2];
h qubits[3];
h qubits[4];

