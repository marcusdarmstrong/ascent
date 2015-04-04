// First draft grammar for Ascent

grammar Ascent;

file
	: 'package' Identifier ('.' Identifier)* ('use' Identifier ('.' Identifier)+)* block
	;

block
	: exp*
	;

methodParamList
	: methodParam (',' methodParam)*
	;

methodParam
	: exp
	| Identifier ':' exp
	;

literal
	: NumberLiteral
	| StringLiteral
	| BooleanLiteral
	;

NumberLiteral
    : '-'? INT '.' [0-9]+ EXP? // 1.35, 1.35E-9, 0.3, -4.5
    | '-'? INT EXP             // 1e10 -3e4
    | '-'? INT                 // -3, 45
    ;

StringLiteral 
	: '"' (ESC | ~["\\])* '"' 
	;

BooleanLiteral
	: 'true'
	| 'false'
	;

object
	: '{' objectBody* '}'
	;

objectBody
	: Identifier ':' exp
	| StringLiteral ':' exp
	;

typeDeclaration
	: '{' typeDeclarationBody* '}'
	;

typeDeclarationBody
	: Identifier ':' type
	| StringLiteral ':' type
	| objectBody
	;

list
	: '[' exp* ']'
	;

function
	: '(' functionParamList? ')' ANY_ARROW type? exp
	;

functionParamList
	: functionParam (',' functionParam)*
	;

functionParam
	: Identifier
	| Identifier ':' type
	;

exp
	: type? Identifier '=' exp
	| exp '(' methodParamList? ')'
	| object
	| typeDeclaration
	| list
	| function
	| literal
	| '{' block '}'
	| exp OP exp
	| '(' exp ')'
	| conditional
	| UNARY_OP exp
	| exp '.' Identifier
	;

type
	: Identifier ('.' Identifier)* ('<' type (',' type)* '>')? ('|' type)*
	| '(' functionParamList? ')' ANY_ARROW type
	;

conditional
	: 'if' '(' exp ')' '{' block '}' 
		('elseif' '(' exp ')' '{' block '}')* 
		('else' '{' block '}')?
	;

UNARY_OP
	: '!'
	| '~'
	| '-'
	;

OP
	: Identifier
	| '+'
	| '-'
	| '/'
	| '*'
	| '**'
	| '~'
	| '::'
	| '>'
	| '<'
	| '>='
	| '<='
	| '=='
	| '!='
	| '%'
	| ''
	| '!'
	| '||'
	| '&&'
	| '<<'
	| '>>'
	| '|'
	;

Identifier
	: AscentLetter AscentLetterOrDigit*
	;

fragment AscentLetter
	: [a-zA-Z]
	;

fragment AscentLetterOrDigit
	: [a-zA-Z0-9_]
	;

fragment ESC 
	: '\\' (["\\/bfnrt] | UNICODE) 
	;

fragment UNICODE 
	: 'u' HEX HEX HEX HEX ;

fragment HEX 
	: [0-9a-fA-F]
	;

fragment INT 
	: '0' 
	| [1-9] [0-9]* 
	;

fragment EXP 
	: [Ee] [+\-]? INT 
	; 

ANY_ARROW
	: ARROW
	| FUTURE_ARROW
	;

ARROW
	: '->'
	;

FUTURE_ARROW
	: '~>'
	;

WS 
	: [ \t\r\n]+ -> skip
	;

COMMENT
    :   '/*' .*? '*/' -> skip
    ;

LINE_COMMENT
    :   '//' ~[\r\n]* -> skip
    ;