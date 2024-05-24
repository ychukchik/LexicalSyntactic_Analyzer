%{
   #include <string>
   #define YYSTYPE std::string
   #include "lab.tab.h"
   void yyerror(const char *s);
   void yysuccess(const char *s);
%}

%option yylineno
%option noyywrap

%%

if              return IF;
else            return ELSE;
while           return WHILE;
print           return PRINT;
return          return RETURN;
==              return EQ;
[<]=            return LE;
>=              return GE;
!=              return NE;
&&              return LA;
[|][|]          return LO;
[0-9]+          { yylval = yytext;
                  return NUM;
                }
[a-zA-Z][a-zA-Z0-9_]* { yylval = yytext;
                  return ID;
                }
[ \t\n]       ; // whitespace
[-{};()=<>+*/%!,] return *yytext;
.               yyerror("Error: Invalid character.");

%%
