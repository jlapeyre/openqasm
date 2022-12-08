parser grammar ibmqasm3Parser ;

import qasm3Parser ;

options {
    tokenVocab = ibmqasm3Lexer;
}

statement:
    pragma
    // All the actual statements of the language.
    | annotation* (
        aliasDeclarationStatement
        | assignmentStatement
        | barrierStatement
        | boxStatement
        | boxasStatement
        | boxtoStatement
        | breakStatement
        | calStatement
        | calibrationGrammarStatement
        | classicalDeclarationStatement
        | constDeclarationStatement
        | continueStatement
        | defStatement
        | defcalStatement
        | delayStatement
        | ibmdelayStatement
        | endStatement
        | expressionStatement
        | externStatement
        | forStatement
        | gateCallStatement
        | gateStatement
        | opaqueStatement
        | ifStatement
        | includeStatement
        | ioDeclarationStatement
        | measureArrowAssignmentStatement
        | oldStyleDeclarationStatement
        | physicalquantumDeclarationStatement
        | modquantumDeclarationStatement
        | quantumDeclarationStatement
        | resetStatement
        | returnStatement
        | whileStatement
        | switchStatement
        | dowhileStatement
    )
;

// Allow postfix operator `im`.
// Allow pre- and postfix decrement and increment on identifiers.
// Allow postfix increment on expression.
// Allow assignment as expression.
// Allow identifier as parameter to durationof. Represents calibrated gate.
// Allow real and imaginary part expressions.
expression:
    LPAREN expression RPAREN                                  # parenthesisExpression
    | expression indexOperator                                # indexExpression
    | <assoc=right> expression op=DOUBLE_ASTERISK expression  # powerExpression
    | op=(TILDE | EXCLAMATION_POINT | MINUS) expression       # unaryExpression
    | expression op=IMAG                                      # postfixunaryExpression
    | expression '.' CREAL                                    # realpartExpression
    | expression '.' CIMAG                                    # imagpartExpression
    | expression op=(ASTERISK | SLASH | PERCENT) expression   # multiplicativeExpression
    | expression op=(PLUS | MINUS) expression                 # additiveExpression
    | expression op=BitshiftOperator expression               # bitshiftExpression
    | expression op=ComparisonOperator expression             # comparisonExpression
    | expression op=EqualityOperator expression               # equalityExpression
    | expression op=AMPERSAND expression                      # bitwiseAndExpression
    | expression op=CARET expression                          # bitwiseXorExpression
    | expression op=PIPE expression                           # bitwiseOrExpression
    | expression op=DOUBLE_AMPERSAND expression               # logicalAndExpression
    | expression op=DOUBLE_PIPE expression                    # logicalOrExpression
    | (scalarType | arrayType) LPAREN expression RPAREN       # castExpression
    | DURATIONOF LPAREN (scope | Identifier) RPAREN                          # durationofExpression
    | Identifier LPAREN expressionList? RPAREN                # callExpression
    | Identifier DOUBLE_MINUS                                 # postdecrementExpression
    | DOUBLE_MINUS Identifier                                 # predecrementExpression
    | expression DOUBLE_PLUS                                  # postincrementExpression
    | DOUBLE_PLUS Identifier                                  # preincrementExpression
    | indexedIdentifier op=(EQUALS | CompoundAssignmentOperator) (expression | measureExpression) # assignmentExpression
    | (
        Identifier
        | BinaryIntegerLiteral
        | OctalIntegerLiteral
        | DecimalIntegerLiteral
        | UnsignedIntegerLiteral
        | HexIntegerLiteral
        | FloatLiteral
        | ImaginaryLiteral
        | BooleanLiteral
        | BitstringLiteral
        | TimingLiteral
        | HardwareQubit
        | ModQubit
      )                                                       # literalExpression
;

//
// New rules
//

// Allow declaring physical qubit.
physicalquantumDeclarationStatement: qubitType HardwareQubit SEMICOLON;

// Qubit designated by, eg: %0. Don't know what this means.
modquantumDeclarationStatement: QUBIT ModQubit SEMICOLON;

// Allow `delay(expr)` in addition to previous `delay[expr]`.
ibmdelayStatement: DELAY LPAREN expression RPAREN gateOperandList? SEMICOLON;

// Same as `assignmentStatement`, but don't require terminating semicolon.
assignment: indexedIdentifier op=(EQUALS | CompoundAssignmentOperator) (expression | measureExpression);

// Support `switch`-`case`.
switchStatement: SWITCH LPAREN Identifier RPAREN LBRACE (caseStatement breakStatement?)+ defaultStatement? breakStatement? RBRACE;
caseStatement: CASE DecimalIntegerLiteral COLON statementOrScope?;
defaultStatement: DEFAULT COLON statementOrScope;

// What is says.
dowhileStatement: DO statementOrScope WHILE LPAREN expression RPAREN SEMICOLON;

//
// Redefinitions
//

// This makes it look like a C preprocessor macro invocation.
// `SEMICOLON` -> `SEMICOLON?`
includeStatement: INCLUDE StringLiteral SEMICOLON?;

// Don't require declaring type of loop variable.
// `scalarType` -> `scalarType?` 
forStatement: FOR scalarType? Identifier IN (setExpression | LBRACKET rangeExpression RBRACKET | Identifier) body=statementOrScope;

// Allow `ModQubit`, eg. %0. I don't know the semantics of this.
gateOperand: indexedIdentifier | HardwareQubit | ModQubit;

// Allow assignment in `return` statement.
returnStatement: RETURN (expression | measureExpression | assignment)? SEMICOLON;

// Allow qubit type in `extern` declarations.
// Allow named parameters as well as existing type-only signature.
externArgument: (scalarType | qubitType | arrayReferenceType | CREG) designator? Identifier?;

// Allow `complex[64]` in addition to existing `complex[float[64]]`.
// Allow both `bit` and `cbit`.
// Allow `double` floating point type.
// Allow designator on `duration`. Represents a sort-of parametrized type.
// Introduce type `waveform`.
scalarType:
   (BIT | CBIT) designator?
    | INT designator?
    | UINT designator?
    | FLOAT designator?
    | DOUBLE
    | ANGLE designator?
    | WAVEFORM
    | BOOL
    | DURATION designator?
    | STRETCH
    | COMPLEX (LBRACKET (scalarType | DecimalIntegerLiteral) RBRACKET)?
;

// Allow `qubit` in static array declaration.
// Allow `duration[100ns]` etc. as element type.
arrayType: ARRAY LBRACKET (scalarType | qubitType) (designator)? COMMA expressionList RBRACKET;

// Allow statement block (`scope`) after return type. In particular, in `extern` statement.
returnwithstatementsSignature: ARROW scalarType scope?;
externStatement: EXTERN Identifier LPAREN externArgumentList? RPAREN ((returnSignature SEMICOLON) | returnwithstatementsSignature | SEMICOLON)?;

// Allow assignment with declaration.
// Probably is restricted somehow.
quantumDeclarationStatement: qubitType Identifier (EQUALS expression)? SEMICOLON;

// Allow statement like `creg a = 2;`
// Allow statement like `creg[nn] a = 2;`
// Continue supporting `creg a[nn];` as does reference parser.
oldStyleDeclarationStatement: (((CREG | QREG) Identifier designator?) | ((CREG | QREG) designator? Identifier)) (EQUALS expression)? SEMICOLON;

// Allow string of digits as initialization expression.
// Also `BitstringLiteral`. There is no way to distinguish the semantics.
// Perhaps this needs to be redesigned. Require explicitly operating on string to produce value.
declarationExpression: arrayLiteral | expression | measureExpression | MPintegerstringLiteral | MPdecimalstringLiteral | BitstringLiteral;

// Allow named `box` (I think). This is perhaps a declaration.
// Introduce `boxas` and `boxto`.
boxStatement: BOX Identifier? designator? scope;
boxasStatement: BOXAS Identifier? designator? scope;
boxtoStatement: BOXTO TimingLiteral scope;

// Allow accessing real and imagingary parts. May be used as lvals.
// For example: `x = z.creal;` and `z.creal = x;`.
// There is certainly a way to include these expressions once instead of twice
realpartExpressionA: expression '.' CREAL;
imagpartExpressionA: expression '.' CIMAG;

// Allow real and imag parts as lvalues.
assignmentStatement: (indexedIdentifier | realpartExpressionA | imagpartExpressionA) op=(EQUALS | CompoundAssignmentOperator) (expression | measureExpression) SEMICOLON;

// Allow this.
opaqueStatement: OPAQUE Identifier (LPAREN params=angleidentifierList? RPAREN)? qubits=identifierList;

// Use `angleidentifierList` (See below) instead of `identifierList`.
gateStatement: GATE Identifier (LPAREN params=angleidentifierList? RPAREN)? qubits=identifierList scope;


// Allow specifying parametrized angle type in parameter list for gates.
// e.g `gate g (angle[48] t) i, j`.
angleParameter: ((ANGLE designator?)? Identifier);
angleidentifierList: angleParameter (COMMA angleParameter)* COMMA?;

// Allow `...` as last parameter is list, for a kind of vararg.
argumentDefinitionList: argumentDefinition (COMMA argumentDefinition)* (COMMA VARARG)? COMMA?;

// Make parens and parameter list optional in `def` statement.
// This if for a function that takes no arguments.
defStatement: DEF Identifier (LPAREN argumentDefinitionList? RPAREN)? returnSignature? scope;
defStatement: DEF Identifier LPAREN argumentDefinitionList? RPAREN returnSignature? scope;

// Support constructions like `$0[1]`.
// Used for example in defcal, where `$0` represents a sequence of qubits.
indexedHardwareQubit: HardwareQubit indexOperator*;

// Support indexed `HardwareQubit` as `defcal` operand.
defcalOperand: indexedHardwareQubit | Identifier;

// Support specifying grammar as a string. The examples I saw were string literals,
// so this is all that is supported here.
defcalTarget: StringLiteral? (MEASURE | RESET | DELAY | Identifier);

// Make comma separating `defcal` operands optional.
defcalOperandList: defcalOperand (COMMA? defcalOperand)* COMMA?;

// Support line continuation in pragma.
pragma: PRAGMA NEW_RemainingLineContent;
