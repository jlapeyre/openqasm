## Pauli rotations and product measurements

Suppose that we want to add support for Pauli rotations and product measurements, but nothing more. What features do we need to add?

It makes sense to have a first-class type representing (phaseless) Pauli strings, rather than carry an unused complex phase. We want to represent phaseless $n$-qubit Pauli strings

$$\\{ P_1 \otimes \ldots \otimes P_n | P_i \in \\{I, X, Y, Z\\} \\}$$

Let's try to implement a Pauli string as an array of single-qubit factors, rather than a new array-like type. It might work like this,
```C
factor[3] p = p"XYZ";
angle a = pi / 8;
gate r = rot(a, p); // or `rot(a) p;`
qubit[12] q;
r q[3], q[5] q[11];,
```
where `factor` is a new type.

It will probably be useful to support slicing:
```C
factor[3] p = p"XYZ";
angle a = pi / 8;
gate r = rot(a, p({0, 2}); // The Pauli in the exponent is XZ.
qubit[2] q;
r q[0], q[1];
```

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
