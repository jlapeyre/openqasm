OPENQASM 3.0;

bit qc0;

qubit $0;
qubit $1;

qc0 = measure $0;

if (qc0) {
  H $0;
  H $0;
  H $0;
  H $0;
} else {
  U $0;
  U $1;
  U $0;
}

