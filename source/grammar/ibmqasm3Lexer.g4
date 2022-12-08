lexer grammar ibmqasm3Lexer ;
import qasm3Lexer ;

// For decrement operator
DOUBLE_MINUS: '--';

// Allow this as alias for `float[64]`.
DOUBLE: 'double';

// Allow variable number of same type of param in parameter list.
VARARG: '...';

// Another kind of qubit
ModQubit: '%' [0-9]+;
// Broaden set of allowed physical qubit identifiers.
HardwareQubit: '$' (([a-zA-Z_]* [0-9]+) | [a-zA-Z_]+) ;
// Another type.
WAVEFORM: 'waveform';

// switch statment
SWITCH: 'switch';
CASE: 'case';
DEFAULT: 'default';

// Some box-like statements
BOXAS: 'boxas';
BOXTO: 'boxto';

// Allow these as accessors, (can be used in lvals).
// For example: `z.creal`, `z.cimag`.
CREAL: 'creal';
CIMAG: 'cimag';

// Resurrect opaque.
OPAQUE: 'opaque';

// This overlaps with `BitstringLiteral` !
MPintegerstringLiteral: '"' ([0-9])+ '"';
MPdecimalstringLiteral: '"' '-'? ([0-9])+ '.' ([0-9])+ '"';

// Allow this kind of literal
UnsignedIntegerLiteral: DecimalIntegerLiteral 'U';

// For `while`-`do` flow-control statement
DO: 'do';

// Allow old keyword.
CBIT: 'cbit';

// Pragma behavior modified: Allow line continuation.
// I was unable to do this without creating a new mode.
PRAGMA: '#'? 'pragma' -> pushMode(NEW_EAT_TO_LINE_END);

// Add some rules for the defcal mode. There are probably some allowed and useful
// rules that are not tested, so they are not yet here.
mode DEFCAL_PRELUDE;
    DEFCAL_PRELUDE_ModQubit: ModQubit -> type(ModQubit);
    DEFCAL_PRELUDE_StringLiteral: StringLiteral -> type(StringLiteral);

// Replaces `EAT_TO_LINE_END` to allow line continuation with pragma.
mode NEW_EAT_TO_LINE_END;
    NEW_EAT_INITIAL_SPACE: [ \t]+ -> skip;
    NEW_EAT_LINE_END: [\r\n] -> popMode, skip;
    NEW_RemainingLineContent: ([ \t]* ~[ \t\r\n] ~[\r\n]* '\\' [ \t]* [\r\n]+)* [ \t]* ~[ \t\r\n] ~[\r\n]*;

// Trying to override the mode EAT_TO_LINE_END fails.
// mode EAT_TO_LINE_END;
//     EAT_INITIAL_SPACE: [a \t]+ -> skip;
//    EAT_LINE_END: ~[\\] [\t\r\n] -> popMode, skip;
//     RemainingLineContent: ~[ \t\r\n] ~[\r\n]*;
