OPENQASM 3.0;

gate H q { }

gate X q { }

bit c0;
bit c1;

qubit $0;
qubit $1;

int i = 3;
int j = 4;

c0 = measure $0;
c1 = measure $1;

if (c0 == i) {
  H $0;
  H $0;
  H $0;
} else if (c0 > i) {
  U $0;
  U $0;
  U $0;
  if (c1 == j) {
    H $1;
    U $1;
    X $1;
  } else if (c1 > j) {
    X $1;
    U $1;
    H $1;
  }
} else {
  X $0;
  X $0;
  X $0;
}

