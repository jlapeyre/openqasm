### Notes comparing reference parser to qss-qasm parser

* qss-qasm has a big test suite, the majority of which requires extensions. I
  modified the reference parser to implement these extensions.

* The modified reference parser runs the 300 tests almost twice as fast as the
qss-qasm test script. But the latter launches a new process each time, while the former
does not. A better comparison is needed.

* Comparison of single runs of the larger qasm files that require time on the order of seconds.
  qss-qasm is consistently about *three* times faster. The time to serialize the AST to a file is
 included, but this makes only a small contribution to the run time.

* qss-qasm includes some semantic analysis that the reference parser does not. Even accounting
  for this, it appears more complicated to work with than the antlr grammar.

* I spent just a few hours writing regular expressions in the `g4` files to modify the reference parser.
  I suspect that this was far easier than working with flex/bison files.

* The flex/bison input files contain a large amount of C++ code. There is a lot of repetition and
  boiler plate that could be refactored with little trouble. I suspect the repetition is
  a requirement of working with these tools. I don't know. A lot of of other C++ is needed as well,
  for example in header files. Some of this is needed for semantic analysis, but I guess not the majority.

* The reference parser (and the one with IBM modifications) are standard antlr lexer and parser
  spec files. There is nothing language or OS specific in them. It may be easy to generate a C++
  parser for example.

* Qiskit development already depends on Rust. There is a [third party plugin for antlr to target rust](https://github.com/rrevenantt/antlr4rust).
  I find that the this plugin does generate rust code from the reference parser. But, I have
  Not yet compiled it to test it.
  The plugin appears to have one-person development. There is some interested and development.
  But not really strong.


<!--  LocalWords:  qss qasm AST antlr g4
 -->
