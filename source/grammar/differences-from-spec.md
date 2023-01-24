## Parser

* Pre- and postfix increment and decrement operators `--` and `++`. (with C semantics ?)
* Postfix increment on expressions
* Allow assignment to be an expression.
* Allow an identifier as parameter to `durationof`. This represents calibrated gate.
* Allow syntax `x.real` and `x.imag` to get real and imaginary parts of complex numbers.
  This can be used as an lvalue as well as rvalue.
* Allow declaring physical qubits
* Qubit identifiers may begin with `%` followed by one or more digits.
* Allow `delay(expr)` in addition to previously supported `delay[expr]`.
* Don't require terminating semicolon on assignment statements.
* Support `switch`-`case` statement. Syntax and semantics very close to C.
* Support `do`-`while` statement.
* Don't require terminating semicolon on `include` statement.
* Don't require declaring type of loop variable. (Implicitly i64 ?)
* Allow qubit identifiers satisfying `'%' [0-9]+`.
* Allow assignment statement as expression in `return` statement in addition to expressions proper.
* Allow quibt type in `extern` declarations.
* Allow named parameters in `extern` declarations. This is in addition to existing declarations
  that include only the type of each parameter.
* Allow `complex[64]` with the same meaning as `complex[float[64]]`.
* Allow `cbit` alias for `bit`.
* Allow `double` as an alias for `float[64]`.
* Allow designator on `duration`. Represents a sort-of parametrized type.
* Allow static array of qubits
* Allow `duration[100ns]` etc. as element type in arrays.
* Allow statement block (`scope`) after return type. In particular, in `extern` statement.
* Allow intial assignment with qubit variable declaration.



## Lexer

* Decrement operator `--`
* Allow `double` as an alias for `float[64]`.
* Vararg: `...` to denote variable number of same type in parameter list
* Allow identifiers matching `'%' [0-9]+` for qubits (with different semantics)
* Larger set of allowed identifiers for physical qubits: `'$' (([a-zA-Z_]* [0-9]+) | [a-zA-Z_]+)`
* Type: `waveform`
* Support `case`-`switch` statement with `case`, `switch`, `default`.
* Introduce `boxas` and `boxto`.
* Introduce `creal` and `cimag`.
* Reintroduce `opaque`.
* Support MP integer literals with `'"' ([0-9])+ '"'`.
* Support MP decimal literal with `'"' '-'? ([0-9])+ '.' ([0-9])+ '"'`.
* Support `U` to denote unsigned integer literal.
* Introduce `do` to support `while`-`do` flow control construct.
* Allow backslash for line continuation in definition of pragma
* More syntax for defcal mode

