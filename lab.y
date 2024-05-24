%{
    #include <iostream>
    #include <stdio.h>
    #include <stdlib.h>
    extern FILE* yyin;  // File with code
    extern int yylineno;
    extern int yylex();
    void yyerror(const char *s) {
      std::cout << "ERROR: " << s << ", line " << yylineno << std::endl;
      exit(1);
    }
    void yysuccess(const char *s) {
      std::cout << s << std::endl;    
    }
    #define YYSTYPE std::string
%}

%token IF ELSE WHILE PRINT RETURN
%token EQ LE GE NE LA LO
%token NUM ID

%%

PROG:    CONSTR
|       PROG CONSTR
;

IFELSE:    '{' PROG '}'
|       EXPR ';'
|       IF '(' EXPR ')' IFELSE ELSE IFELSE
|       WHILE '(' EXPR ')' IFELSE
|       PRINT '(' ID ')' ';'
|       RETURN NUM ';'
|       RETURN ';'
;


IFNO:   IF '(' EXPR ')' CONSTR
|       IF '(' EXPR ')' IFELSE ELSE IFNO
|       WHILE '(' EXPR ')' IFNO
;

CONSTR:     IFELSE | IFNO ;

EXPR:   CALC
|       ID '=' EXPR

CALC:  SUM
|       CALC EQ SUM
|       CALC LE SUM
|       CALC GE SUM
|       CALC NE SUM
|       CALC LA CALC
|       CALC LO CALC
|       CALC '>' SUM
|       CALC '<' SUM
;

SUM: MULT
|       SUM '+' MULT
|       SUM '-' MULT
;

MULT:   VAL
|       MULT '*' VAL
|       MULT '/' VAL
|       MULT '%' VAL
;

VAL:    NUM
|       '-' VAL
|       '!' VAL
|       '(' EXPR ')'
|       ID
;

%%

int main(int argc, char* argv[]) {
 
    if (argc != 2) {
        std::cout << "ERROR: Input data mismatch." << std::endl << "Try: " << argv[0] << " <file.txt>" << std::endl;
        exit(-1);
    }

    yyin = fopen(argv[1], "r");
    
    if (yyin == NULL) {
        std::cout << "ERROR: File was not found." << std::endl;
        exit(-1);
    }

    yyparse();  // Start syntactic analyzer
    
    yysuccess("OK: The program has been successfully completed.");
    
    fclose(yyin);
    
    return 0;
}
