## Pauli rotations and product measurements in OpenQASM

2026-07-28

Suppose that we want to add support for Pauli rotations and product measurements, but nothing more.
What features do we need to add?
And which circuits can we implement?

It makes sense to have a first-class, phase-free Pauli-string type,
rather than carrying an unused complex phase.
We want to represent phase-free $n$-qubit Pauli strings:

$$\\{ P_1 \otimes \cdots \otimes P_n | P_i \in \\{I, X, Y, Z\\} \\}.$$

In what follows, I do not define any operations on Pauli strings.
We may need to introduce phases and operations on Pauli strings.
But I want to see how much we can do without them.

If we represent Pauli strings as arrays of single‑qubit Pauli values,
then we can reuse existing syntax and semantics.
It might work like this:
```C
pauli[3] p = p"XYZ";
angle a = pi / 8;
gate r = rot(a, p);
qubit[12] q;
r q[3], q[5], q[11];
```
where `pauli` is a new type.

It will likely be useful to support slicing:
```C
pauli[3] p = p"XYZ";
qubit[2] q;

angle a = pi / 8;
gate r = rot(a, p({0, 2})); // The Pauli in the exponent is XZ.
r q[0], q[1];
```

### Examples

Here is Bell-state preparation as shown in Fig. 2a in Game of Surface Codes (GOSC).
```C
qubit[2] q;
pauli[2] zprod = p"ZZ";

h q; // Apply H to both qubits.
bit b = measure_pauli(zprod) q;
if (b == 1) {
    x q[0]; // map |01> and |10> to |00> and |11>.
}
```

The following PBC circuit is shown in Fig. 4a in GOSC.
The gate `rcontrol(p"X", p"Z")`
applies `Z` on the target
if the control qubit is in the `-1` eigenstate of `X`.
A definition of `rcontrol` is given below.
```C
qubit[4] q;
gate z8 = rot(pi / 8, p"Z");
gate z4 = rot(pi / 4, p"Z");
gate x4 = rot(pi / 4, p"X");
gate xm4 = rot(-pi / 4, p"X");
gate cxz = rcontrol(p"X", p"Z"); // Apply Z to target if control is in -1 eigenstate of X.

z8 q[0];
cxz q[1], q[2];
xm4 q[3];

cxz q[0], q[1];
x4 q[2];
z8 q[3];
cxz q[0], q[3];

z8 q[0];
z4 q[1];
z8 q[2];
z4 q[3];

xm4 q[0];
x4 q[1];
x4 q[2];
x4 q[3];

bit[4] b;

// Measure all qubits in the Z basis.
b = measure q;
```

#### Magic state injection

This example uses aliased, concatenated registers and arrays.
For now, I am dodging questions of existing OQ3 semantics.

This circuit is shown in Fig. 7 in GOSC.
The effect is to apply `rot(pi / 8, P)` to the `data` register.
```C
pauli[3] P = p"XZY";
qubit[3] data;

qubit[1] ancilla;
pauli[1] z = p"Z";

let prod = P ++ z;

let register = data ++ ancilla;

prepare data; // The gate `prepare` initializes the state of `data`.
t ancilla[0]; // Magically generate a magic state.

// A product measurement to the data and ancilla qubits.
bit b1 = measure_pauli(prod) register;

if (b1 == 1) {
    rot(pi / 4, P) data;
}

h ancilla; // To measure in the X basis
bit b2 = measure ancilla;

if (b2 == 1) {
    rot(pi / 2, P) data;
}
```

#### Magic state distillation

This circuit is shown in Fig. 15 in GOSC.
```C
qubit[4] dirty;
qubit[1] cleaner;

t dirty; // create magic states |m>
h cleaner; // prepare |+>
let register = dirty ++ cleaner;
angle a = pi / 8;

rot(a, p"IIZZZ") register;
rot(a, p"IZIZZ") register;
rot(a, p"IZZIZ") register;
rot(a, p"IZZZI") register;
rot(a, p"ZIIZZ") register;
rot(a, p"ZIZIZ") register;
rot(a, p"ZIZZI") register;
rot(a, p"ZZIIZ") register;
rot(a, p"ZZIZI") register;
rot(a, p"ZZZII") register;
rot(a, p"ZZZZZ") register;

h dirty;
measure dirty; // Measure dirty qubits in the X basis.
```

Alternatively, we can use a multidimensional array of type `pauli`, and use a loop, like this:
```C
qubit[4] noisy;
qubit[1] cleaner;

t noisy; // create magic states |m>
h cleaner; // prepare |+>
let register = noisy ++ cleaner;
angle a = pi / 8;

array[pauli, 11, 5] prods = {
    p"IIZZZ",
    p"IZIZZ",
    p"IZZIZ",
    p"IZZZI",
    p"ZIIZZ",
    p"ZIZIZ",
    p"ZIZZI",
    p"ZZIIZ",
    p"ZZIZI",
    p"ZZZII",
    p"ZZZZZ"
};

for int i in [0:10] {
    rot(a, prods[i]) register;
}

h noisy;
measure noisy; // measure out noisy qubits in the X basis.
```

### Controlled gates

Implementation of $P_1$ -controlled- $P_2$ gates,
following Fig. 5c in GOSC.
Eigenstates of `p1` control the application of `p2`.
The gate exhibits a symmetry: it also implements
eigenstates of `p2` controlling the application of `p1`.
```C
gate rcontrol(p1, p2) q1, q2
{
    let prod = p1 ++ p2;
    let q = q1 ++ q2;
    rot(pi / 4, prod) q;
    rot(-pi / 4, p1) q1;
    rot(-pi / 4, p2) q2;
}
```
