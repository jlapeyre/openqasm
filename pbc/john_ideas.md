## Pauli rotations and product measurements in OpenQASM

Suppose that we want to add support for Pauli rotations and product measurements, but nothing more.
What features do we need to add?
And which circuits can we implement?

It makes sense to have a first-class type representing (phaseless) Pauli strings, rather than carry an unused complex phase. We want to represent phaseless $n$-qubit Pauli strings

$$\\{ P_1 \otimes \ldots \otimes P_n | P_i \in \\{I, X, Y, Z\\} \\}.$$

Let's try to implement a Pauli string as an array of single-qubit factors,
rather than a new array-like type.
It might work like this,
```C
factor[3] p = p"XYZ";
angle a = pi / 8;
gate r = rot(a, p);
qubit[12] q;
r q[3], q[5] q[11];,
```
where `factor` is a new type.

It will probably be useful to support slicing:
```C
factor[3] p = p"XYZ";
qubit[2] q;

angle a = pi / 8;
gate r = rot(a, p({0, 2}); // The Pauli in the exponent is XZ.
r q[0], q[1];
```

### Examples

Here is Bell state preparation as shown in Fig. 2a of GOSC.
```C
qubit[2] q;
factor[2] zprod = p"ZZ";

h q; // Apply h to both qubits.
bit b = measure_pauli(zprod) q;
if (b == 1) {
    x q[0]; // send |01> and |10> to |00> and |11>.
}
```

The following PBC circuit is shown in Fig. 4a of GOSC.
I define a gate via `rcontrol(p"X", p"Z")`.
This gate operates with `Z` on the target
if the control is in the `-1` eigenstate of `X`.
It is assumed that `rcontrol` is implemented in a library.
We may not have (or want to have) semantics to support such a gate construction.
In this case, these gates must be generated at a higher level and hard-coded into an OpenQASM.
```C
qubit[4] q;
gate z8 = rot(p"Z", pi / 8);
gate x4 = rot(p"X", pi / 4);
gate xm4 = rot(p"X", -pi / 4);
gate cxz = rcontrol(p"X", p"Z"); // operate with Z on target, if control is in -1 eigenstate of X.

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

This example uses aliased, concatenated registers, or arrays.
For the moment, I am dodging existing OQ3 semantics.

This circuit is shown in Fig. 7 in GOSC.
The effect is to apply `rot(P, pi / 8)` to the `data` register.
```C
factor[3] P = p"XZY";
qubit[3] data;

qubit[1] ancilla;
factor[1] z = p"Z";

let prod = P ++ z;

let register = data ++ ancilla;

prepare data; // prepare is a gate that prepares the state of data.
t z[0]; // magically generate a magic state.

// A product measurement including data and ancilla qubits.
bit b1 = measure_pauli(prod) register;

if (b1 == 1) {
    rot(P, pi / 4) data;
}

h ancilla; // to measure in the X basis
bit b2 = measure ancilla;

if (b2 == 1) {
    rot(P, pi / 2) data;
}
```

#### Magic state distillation

```C
qubit[4] dirty;
qubit[1] cleaner;

t dirty; // create magic states |m>
h cleaner; // prepare |+>
let register = dirty ++ cleaner;
let a = pi / 8;

rot(p"IIZZZ", a) register;
rot(p"IZIZZ", a) register;
rot(p"IZZIZ", a) register;
rot(p"IZZZI", a) register;
rot(p"ZIIZZ", a) register;
rot(p"ZIZIZ", a) register;
rot(p"ZIZZI", a) register;
rot(p"ZZIIZ", a) register;
rot(p"ZZIZI", a) register;
rot(p"ZZZII", a) register;
rot(p"ZZZZZ", a) register;

h dirty;
measure dirty; // measure out dirty qubits in x-basis
```

Alternatively, we can use a multi-dimension array of `factor`, and use a loop, like this:
```C
qubit[4] dirty;
qubit[1] cleaner;

t dirty; // create magic states |m>
h cleaner; // prepare |+>
let register = dirty ++ cleaner;
let a = pi / 8;

array[factor, 11, 5] prods = {
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
}

for int i in [0:10] {
    rot(prods[i], a) register;
}

h dirty;
measure dirty; // measure out dirty qubits in x-basis
```
