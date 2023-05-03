%option noyywrap

%{
    #include <stdio.h>
    #include <stdlib.h>
    int lineno = 1;
    void print_token(char *token_type);
    void yyerror();
%}
COMMENT     "//".*
AR_OPS      "+"|"-"|"/"|"*"|"^"
ID          [a-zA-Z_][a-zA-Z0-9_]*
INT         [-]?[0-9]+
FLOAT       [-]?[0-9]+"."[0-9]*
STRING      \'(\\.|[^'\\])*\'
FLOOR_CEIL  "floor"|"ceil"
LOG         "log_"("0"|[1-9][0-9]*)
ARRAY       "name("|"A("
BOOL        "true"|"false"

%%
{COMMENT}       { print_token("COMMENT"); }
"go to"         { print_token("GO TO"); }
"exit"          { print_token("EXIT"); }
"if"            { print_token("IF"); }
"then"          { print_token("THEN"); }
"else"          { print_token("ELSE"); }
"case"          { print_token("CASE"); }
"endcase"       { print_token("ENDCASE"); }
"while"         { print_token("WHILE"); }
"do"            { print_token("DO"); }
"endwhile"      { print_token("ENDWHILE"); }
"repeat"        { print_token("REPEAT"); }
"until"         { print_token("UNTIL"); }
"loop"          { print_token("LOOP"); }
"forever"       { print_token("FOREVER"); }
"for"           { print_token("FOR"); }
"to"            { print_token("TO"); }
"by"            { print_token("BY"); }
"endfor"        { print_token("ENDFOR"); }
"end"           { print_token("END"); }
"stop"          { print_token("STOP"); }
"call"          { print_token("CALL"); }
"return("       { print_token("RETURN_EXP"); }
"return"        { print_token("RETURN_DEF"); }
"input"         { print_token("INPUT"); }
"output"        { print_token("OUTPUT"); }
"list"          { print_token("LIST"); }
"array"         { print_token("ARRAY_DEC"); }
{ARRAY}         { print_token("ARRAY"); }
"node()"        { print_token("node"); }
"procname"      { print_token("PROC"); }
"procedure"     { print_token("PROC_DEC"); }
","             { print_token("COMMA"); }
{AR_OPS}        { print_token("ARITHMETIC_OPS"); }
"not"           { print_token("NOT"); }
"and"           { print_token("AND"); }
"or"            { print_token("OR"); }
"<="            { print_token("LEQ"); }
">="            { print_token("GEQ"); }
"=="            { print_token("EQ"); }
"!="            { print_token("NEQ"); }
"<"             { print_token("LT"); }
">"             { print_token("GT"); }
"="             { print_token("ASSIGNMENT"); }
{FLOOR_CEIL}    { print_token("FLOOR_CEIL"); }
"mod"           { print_token("MOD"); }
{LOG}           { print_token("LOG"); }
"("             { print_token("LEFT_PAREN"); }
")"             { print_token("RIGHT_PAREN"); }
"["             { print_token("LEFT_BRACK"); }
"]"             { print_token("RIGHT_BRACK"); }
"{"             { print_token("LEFT_BRACE"); }
"}"             { print_token("RIGHT_BRACE"); }
":"             { print_token("COLON"); }
";"             { print_token("SEMI_COLON"); }
{BOOL}          { print_token("BOOL"); }
{ID}            { print_token("IDENTIFIER"); }
{INT}           { print_token("INT"); }
{FLOAT}         { print_token("FLOAT"); }
{STRING}        { print_token("STRING"); }
"\n"            { lineno++; }
[ \t\r\f]+      /* IGNORE */
.               { yyerror("Unrecognized character"); }
%%

void print_token(char *token_type){
    printf("yytext: %s\ttoken: %s\tlineno: %d\n", yytext, token_type, lineno);
}

void yyerror(char *message){
    printf("Error: \"%s\" in line %d. Token = %s\n", message, lineno, yytext);
    exit(1);
}

int main(int argc, char *argv[]){
    yyin = fopen(argv[1], "r");
    yylex();
    fclose(yyin);
    return 0;
}
