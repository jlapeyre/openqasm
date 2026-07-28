## Pauli rotations and product measurements

Suppose that we want to add support for Pauli rotations and product measurements, but nothing more. What features do we need to add?

It makes sense to have a first-class type representing (phaseless) Pauli strings, rather than carry an unused complex phase. We want to represent phaseless $n$-qubit Pauli strings

$$\\{ P_1 \ldots P_n | P_i \in \\{I, X, Y, Z\\} \\}$$

Let's try to implement a Pauli string as an array of single-qubit factors, rather than a new array-like type. It might work like this,
```C
factor[3] p = p"XYZ";
angle a = pi / 8;
gate r = rot(a, p); // or `rot(a) p;`
qubit[12] q;
r q[3], q[5] q[11];,
```
where `factor` is a new type.


The following PBC circuit is shown in figure 4a of GOSC.
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
b = measure q;
```

### Including qubit index in the Pauli string


Here, I include the qubit index in the Pauli string
That is, the Pauli string is specified by giving the phaseless operator and index for each non-identity position.

I will assume that some users will want sparse Pauli strings.
So we want a surface syntax that makes this convenient.

Let's try to implement a Pauli string as an array of single-qubit factors, rather than a new array-like type,
```C
factor[4] p = p"X3 Y12 Z21"; // whitespace is ignored
```
If possible, the elements of an array of type `factor` should be immutable.
By possible, I mean making elements immutable does not introduce too much inefficiency or clumsy code.

Rotatations and product measurements are constructed like this
```C
factor[4] p = p"X3 Y12 Z21"; // whitespace is ignored
bit b;
b = measure p; // `measure` is polymorphic
b = pmeasure p; // Alternatively, product measurement is a new function.

angle a = pi / 8;
gate r = rot(a, p); // or `rot(a) p;`
qubit[22] q;
r q;
```

### Examples

For example, here is Bell state preparation.
```C
qubit[2] q;
factor[2] zprod = p"Z0Z1";
bit b;

h q[0];
h q[1];
b = pmeasure zprod;
if (b == 1) {
    x q[0]; // send |01> and |10> to |00> and |11>.
}
```

We would need to support a Pauli string defined with sparse syntax.
```C
qubit[22] q;
factor[2] zprod = p"Z9 Z21";
bit b;

h q[9];
h q[21];
b = pmeasure zprod;
if (b == 1) {
    x q[9];
}
```

We might want to support slicing.
```C
qubit[2] q;
factor[2] zprod = p"Z9 Z21";
bit b;

h q[0];
h q[1];
b = pmeasure zprod[{9, 21];
if (b == 1) {
    x q[0];
}
```


### Pauli strings in memory

At some lower-level, we will need a dense represention for performance.
We could choose

1. The in memory representation is not specified by the OQ language.
2. The language requires that the in memory representaion be dense (bit-packed symplectic representation)
3. There are two types exposed to the user-- dense and sparse. There is implicit casting, or some kind of automatic conversion, or else manual conversion is required.

At present, I favor option 1. (Actually, I a more complicated design will probably be needed.)

We may also want to support a dense representation with surface syntax. I'll leave that for now.
