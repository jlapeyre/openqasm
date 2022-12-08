OPENQASM 3.0;

int i = 21;

bit[8] ba = bit(i);

bit[3] bb = 1;

int j = int(bb);

bit[128] bc = 0;

int[64] k = int[64](bc);

float f = 12.15;

bit[32] bf = bit[32](f);

float[64] df = float[64](bf);

j = int(f);

k = int[64](df);

