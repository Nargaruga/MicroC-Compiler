/*
* MicroC Parser specification
*/

%{
     (* Auxiliary definitions *)   

%}

/* Tokens declarations */

// Flow control
%token IF
%token ELSE
%token RETURN
%token FOR
%token WHILE

//Types
%token <int> INT
%token <char> CHAR
%token <bool> BOOL
%token <string> ID
%token VOID
%token NULL

// Operations
%token ADD
%token SUB
%token MUL
%token DIV
%token ASSIGN

// Boolean operations
%token AND
%token OR
%token NOT

// Comparisons
%token EQ
%token NEQ
%token LT
%token GT
%token LTE
%token GTE

// Grouping
%token LPAREN
%token RPAREN
%token LSQUARE
%token RSQUARE
%token LCURLY
%token RCURLY

// Other
%token SEMICOLON
%token EOF

/* Precedence and associativity specification */


/* Starting symbol */
%start program
%type <Ast.program> program    /* the parser returns a Ast.program value */

%%

/* Grammar specification */
program:
  |  EOF                      {Ast.Prog([])}
;
