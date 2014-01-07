%{
#include <stdio.h>
#include <string.h>
int nuContine;
char *replacestr(char *string, char *sub, char *replace){
              if(!string || !sub || !replace) return NULL;
              char *pos = string; int found = 0;
              while((pos = strstr(pos, sub))){
                        pos += strlen(sub);
                        found++;
              }
              if(found == 0) return NULL;
              int size = ((strlen(string) - (strlen(sub) * found)) + (strlen(replace) * found)) + 1;
              char *result = (char*)malloc(size);
              pos = string; 
             
              char *pos1;
              while((pos1 = strstr(pos, sub))){
                        int len = (pos1 - pos);
                        strncat(result, pos, len);
                        strncat(result, replace, strlen(replace));
                        pos = (pos1 + strlen(sub));
              }
              if(pos != (string + strlen(string)))
                        strncat(result, pos, (string - pos));
              return result;
}
%}
%union {
int intval;
char* sir;
char caracter;
}
%token <intval>NR <sir> SIR EQUAL
%type <sir>str
%nonassoc '=='
%nonassoc '|'	 
%left '+' '-'
%left '#'
%left '*'
%left '`'
%left '?' 


%start s
%%
s     : str 
      ;
 
str   : '|' str '|' {
			char str[2];
			sprintf(str,"%d",strlen($2));
			$$ = str;
			printf("|%s|: %s\n",$2,$$);
		}
	  | '(' str ')' {
	  	$$ = $2;
	  }
      |  str '+' str  { 
         char* s=malloc(sizeof(char)*(strlen($1)+2));
         strcpy(s,$1); strcat(s,$3);
         $$=s;
         printf("%s + %s : %s\n",$1,$3,$$);
        }   
      | SIR {
        char* s = malloc(sizeof(char));
        strcpy(s,$1);
        $$=s;
        printf("Sirul recunoscut:%s\n",$$);
        }
      | '(' SIR ')' {
        char* s = malloc(sizeof(char));
        strcpy(s,$2);
        $$=s;
        printf("Sirul recunoscut:%s\n",$$);
        }
      | str '-' str {
        char* s1 = malloc(sizeof(char));
        strcpy(s1, $1);
        char* s2 = malloc(sizeof(char));
        strcpy(s2, $3);

        char*p = strstr(s1,s2);
        char pos = p-s1;

        if(pos > 0 || (pos == 0 && s1[0] == s2[0])) {
        	$$ = replacestr(s1,s2,""); 
        	printf("%s - %s : %s\n",$1,$3,$$);
        }
        else {
          printf("sirul %s nu este subsir al lui %s\n",$3,$1);
        }

        }
      | str '*' NR {
          char* s = malloc(sizeof(char));
          char* s1 = malloc(sizeof(char));
          strcpy(s1,"");
          strcpy(s,$1);
          int nr = $3;
          int i;
          for (i = 1; i <= nr; ++i)
            strcat(s1,s);
          $$ = s1;
          printf("%s * %d : %s\n",$1,$3,$$);
        }
      | str '*' str {
          char* s = malloc(sizeof(char));
          char* s1 = malloc(sizeof(char));
          strcpy(s1,"");
          strcpy(s,$1);
          int nr = atoi($3);
          int i;
          for (i = 1; i <= nr; ++i)
            strcat(s1,s);
          $$ = s1;
          printf("%s * %s : %s\n",$1,$3,$$);
        } 
      | str '?' str {
          char *pos = $1; int found = 0;
              while((pos = strstr(pos, $3))){
                        pos += strlen($3);
                        found++;
              }
        sprintf($$,"%d",found);
        if(found == 0) printf("Nu s-a gasit nicio aparitie a lui %s in %s\n", $3,$1);
        
        printf("Numar de aparitii ale lui %s: %s\n",$3,$$);
        }
      | str '#' NR {
      		if (strlen($1) < $3) printf("lungimea sirului este mai mica decat numarul de caractere introdus\n");
      		else {
      		char*s = malloc(sizeof(char));
      		strncpy(s,$1+strlen($1)-$3,$3);
      		$$ = s;
      		printf("Ultimele %d caractere ale lui %s: %s\n",$3,$1,$$);
      		}
      	}
      | str '#' str {
      		if (strlen($1) < atoi($3)) printf("lungimea sirului este mai mica decat numarul de caractere introdus\n");
      		else {
      		char*s = malloc(sizeof(char));
      		strncpy(s,$1+strlen($1)-atoi($3),atoi($3));
      		$$ = s;
      		printf("Ultimele %s caractere ale lui %s: %s\n",$3,$1,$$);
      		}
      	}
      | NR '`' str {
      		if (strlen($3) < $1) printf("lungimea sirului este mai mica decat numarul de caractere introdus\n");
      		else {
      		char*s = malloc(sizeof(char));
      		strncpy(s,$3,$1);
      		$$ = s;
      		printf("Primele %d caractere ale lui %s: %s\n",$1,$3,$$);
      		}
      	}
      | str '`' str {
      		int len = atoi($1);
      		if (strlen($3) < len) printf("lungimea sirului este mai mica decat numarul de caractere introdus\n");
      		else {
      		char*s = malloc(sizeof(char));
      		int n = atoi($1);
      		strncpy(s,$3,n);
      		$$ = s;
      		printf("Primele %d caractere ale lui %s: %s\n",n,$3,$$);
      		}
      	}
      | str EQUAL str {
      int state = 0;
      if(strcmp($1,$3) == 0) state = 1;
      	  printf("%s == %s => %d\n",$1,$3,state);
      	}
      ;    

%%
int main(){
 yyparse();
}    