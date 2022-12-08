# OpenQASM 3.0 Grammar Reference

The file [qasm3.g4](./qasm3.g4) is the reference grammar, written in [ANTLR](https://www.antlr.org/).

This directory also contains a very basic Python parser, which is simply built from the reference grammar and used to test against the examples.

## IBM extensions and modifications

This section describes what is different in this branch. The following sections, beginning with [Requisites](#requisites),
are unchanged from the main branch.

The majority of the [tests](https://github.ibm.com/IBM-Q-Software/qss-qasm/tree/master/tests/src) in
[qss-qasm](https://github.ibm.com/IBM-Q-Software/qss-qasm) require extensions to the grammar implemented by the reference parser.
To compare performance of the parsers, I chose to modify the reference parser modified to include these extensions.

This branch inclues a grammar that tries to reproduce the grammar in the `qss-qasm` flex/bison parser. This parser
has several extensions and modifications relative to the reference parser.
The grammar is specified in files [ibmqasm3Lexer.g4](./ibmqasm3Lexer.g4) and [ibmqasm3Parser.g4](./ibmqasm3Parser.g4).

#### What are the extensions / modifications ?

The extensions are mentioned in comments in the [ibmqasm3Lexer.g4](./ibmqasm3Lexer.g4) and [ibmqasm3Parser.g4](./ibmqasm3Parser.g4).

#### Building

Compile the parser with IBM extensions like this:
```shell
antlr4 -o ibmopenqasm_reference_parser -Dlanguage=Python3 -visitor ibmqasm3Lexer.g4 ibmqasm3Parser.g4
```

#### Running qss-qasm test suite

Call the function `run_tests()` in `qss-qasm-tests.py`. This attempts to parse each qasm file in the
(non-slow) qss-qasm test suite. This will write ASTs to the directory `./qss-test-output_ibm` and errors to the directory 
`./qss-test-err_ibm`.
The qss-qasm test suite has been copied to [./qss-qasm-test](https://github.ibm.com/John-Lapeyre/openqasm/tree/ibmqasm/source/grammar/qss-qasm-test).
Note that `run_tests()` runs not all of the tests in [./qss-qasm-test](https://github.ibm.com/John-Lapeyre/openqasm/tree/ibmqasm/source/grammar/qss-qasm-test),
but rather exactly the same tests that `short_run_tests.sh` in qss-qasm does.
These are the tests that have very small processor and memory requirements.

Calling `run_tests(parse_qasm_reference)` will run the same test suite using the unmodified reference parser. The
majority of the tests will fail. The error messages will be saved to files.

`run_tests` only counts how many qasm files were parsed without error. It does not verify that the ASTs are correct.
There are likley some incorrect ASTs, but I guess very few. Furthermore, I didn't spend much time deliberating the
best way to encode extensions in the AST.

#### Reference version

The reference for this modified reference parser is `qss-qasm` commit 363c6553 Mon Nov 14 2022.

#### [Notes on comparing the parsers](./CompareParsers.md)

## Requisites

Building the grammar only requires ANTLR 4.
You can likely get a copy of ANTLR using your system package manager if you are on Unix, or from `brew` if you are on macOS.
You could also follow [these instructions](https://github.com/antlr/antlr4/blob/master/doc/getting-started.md).

Running the Python version of the parser also requires the ANTLR Python runtime.
You can install this with `pip` by
```bash
pip install antlr4-python3-runtime==<version>
```
where `<version>` should exactly match the version of ANTLR 4 you installed.
If you let `pip` do this automatically when it installs the reference parser, it will likely pull the wrong version, and produce errors during use.


## Building the Python Parser

1. Build the grammar files into the package directory with
    ```bash
    <antlr command> -o openqasm_reference_parser -Dlanguage=Python3 -visitor qasm3Lexer.g4 qasm3Parser.g4
    ```
   `<antlr command>` should be replaced with however you invoke ANTLR on your system.
   If you used a package manager, it is likely `antlr4` or `antlr`.
   If you followed the "Getting Started" instructions, it is likely just the `antlr4` alias, or it might be `java -jar <path/to/antlr.jar>`.
2. Install the Python package with `pip install -e .`.


## Run the Tests

1. Make sure the Python parser is built and available on the Python path.
2. Install the testing requirements with `pip install -e .[tests]` or `pip install -r requirements-dev.txt`.
3. Run `pytest`.
