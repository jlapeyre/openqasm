OPENQASM 3.0;

gate H a { U(π/2, 0, π) a; }

bit qc0;
qubit $0;

int i = 3;

int j = 4;

qc0 = measure $0;

if (qc0 == i) {
  H $0;
  H $0;
  H $0;
  H $0;
  H $0;
  H $0;
} else if (qc0 == j) {
  U $0;
  U $0;
  U $0;
} else {
  H $0;
  U $0;
  H $0;
  U $0;
}

