OPENQASM 2.0;
include "qelib1.inc";

qreg qubits[5];
x qubits[4];
ccx qubits[0],qubits[3],qubits[4];
ccx qubits[2],qubits[3],qubits[4];
cx qubits[3],qubits[4];
ccx qubits[1],qubits[2],qubits[4];
cx qubits[2],qubits[4];
ccx qubits[0],qubits[1],qubits[4];
cx qubits[1],qubits[4];
cx qubits[0],qubits[4];

