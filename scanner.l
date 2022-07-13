
digit       [0-9]
letter      [a-zA-Z]
integer     [+-]?(0|[1-9]){digit}*
real        [+-]?(0|[1-9]){digit}*\.{digit}+([eE][-+]?{digit}+)?
identifier  {letter}+({letter}|{digit}|_)*
string      \"([^\"\n]|\"\")*\"



%{

#include "symtab.h"

#define LIST     strcat(buf,yytext)

#define token(t) {LIST;                                       \
                 int flag=0;                                  \
                 for(int i=0; i<strlen(yytext); i++){         \
                    if(yytext[i] >= 97 && yytext[i] <= 122){  \
                        yytext[i]-=32;                        \
                        flag = 1;                             \
                    }                                         \
                 }                                            \
                 if(flag == 1){                               \
                    printf("<%s>\n", yytext);                 \
                 }                                            \
                 else                                         \
                    printf("<%s>\n", #t);                     \
                 }                                     
#define tokenChar(t) {LIST; printf("<'%c'>\n", t);}
#define tokenInteger(t,i) {LIST; printf("<%s: %d>\n",#t,atoi(i));}
#define tokenFloat(t,i) {LIST; printf("<%s: %f>\n",#t,atof(i));}
#define tokenString(t,s) {LIST; printf("<%s: %s>\n",#t,s);}
#define tokenComment(t)  {LIST; printf("%s\n", t);}

#define MAX_LINE_LENG 256

int linenum = 1;
char buf[MAX_LINE_LENG];
char string_revise[MAX_LINE_LENG];
SymbolTable symtab;
%}

%%


"//".*    {LIST;}

\/\*([^*]|(\*+[^*/]))*\*+\/    {LIST;}


","     {token(',');}
":"     {token(':');}
";"     {token(';');}
"->"    {token(->);}
"("     {token('(');}
")"     {token(')');}
"["     {token('[');}
"]"     {token(']');}
"{"     {token('{');}
"}"     {token('}');}


"+"     {token('+');}
"-"     {token('-');}
"*"     {token('*');}
"/"     {token('/');}
"%"     {token('%');}
"<"     {token('<');}
"<="    {token(<=);}
">="    {token(>=);}
">"     {token('>');}
"=="    {token(==);}
"!="    {token(!=);}
"&"     {token('&');}
"|"     {token('|');}
"!"     {token('!');}
"="     {token('=');}
"+="    {token(+=);}
"-="    {token(-+);}
"*="    {token(*=);}
"/="    {token(/=);}

bool|break|char|case|class|continue|declare|do|else|exit|float|for|fun|if|int|loop|print|println|return|string|val|var|while|as|as\?|in|\!in|interface|is|\!is|null|object|package|super|this|throw|try|typealiat|typeof|when  {token(yytext);}



{real}        {tokenFloat(float,yytext);}
{integer}     {tokenInteger(integer, yytext);}

true|false    {tokenString(boolean, yytext);}

{identifier}  {tokenString(id, yytext); symtab.insert(yytext);}
{string}      {
		int idx = 0;           
		for(int i=1; i<strlen(yytext)-1; i++){
   			if(yytext[i]=='"' && yytext[i+1] == '"'){
     				i+=1;
   			}
   			string_revise[idx++] = yytext[i];
		}
			string_revise[idx] = '\0';
			tokenString(string, string_revise);
                        
              }





\n      {
        LIST;
        int idx = 0;
        for(int i=0; i<strlen(buf); i++){
            if(buf[i] == '\n'){   
               string_revise[idx] = '\0';
               printf("%d: %s\n", linenum++, string_revise);
               idx=0;
            }
            else
               string_revise[idx++] = buf[i];
        
        }

        
        buf[0] = '\0';
        }

[ \t]*  {LIST;}

.       {
        LIST;
        printf("%d:%s\n", linenum+1, buf);
        printf("bad character:'%s'\n",yytext);
        exit(-1);
        }





%%

int main(int argc, char **argv)
{
   yylex();
   printf("--------------------------------SymbolTable Below\n");
   symtab.dump();
   exit(0);
   
}
