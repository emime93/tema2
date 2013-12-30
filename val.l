%{
#include <stdio.h>
#include "y.tab.h"
%}
%%
[0-9]+ {yylval.intval=atoi(yytext); return NR;}
[a-zA-Z]+ {yylval.sir=strdup(yytext); return SIR;}
"==" {return EQUAL;}
[ \t] ;
\n {return 0;}
. {return yytext[0];}
%%