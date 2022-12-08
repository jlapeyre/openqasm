OPENQASM 3.0;

int a;
int b;
int c;
int d;

int i;
int j;
int k;

qubit $0;
qubit $1;
qubit $2;

gate H q { }

if (a == 3) {
  b = 9;
  H $0;
  H $0;
  H $0;
} else if (a > 3) {
  U $1;
  U $1;

  if (b == 2) {
    if (c > a) {
      H $2;
      U $2;
      d *= 4;
    } else if (c < a) {
      d = c;
    } else {
      U $0;
      U $0;
      U $0;
      U $0;
    }
  } else {
    i = 1;
    j = 2;
    k = 3;
  }
}

