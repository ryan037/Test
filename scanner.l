
%{
#define LIST     strcat(buf,yytext)
#define token(t) {LIST;                                \
                 if(yytext[0]>=97 && yytext[0]<=122){  \
                    int i=strlen(yytext)-1;            \
                    while(i>=0){                       \
                      yytext[i]-=32;                   \
                      i-=1;                            \
                    }                                  \
                    printf("<%s>\n", yytext);          \
                 }                                     \
                 else                                  \
                    printf("<%s>\n", #t);              \
                 }                                     
#define tokenChar(t) {LIST; printf("<'%c'>\n", t);}
#define tokenInteger(t,i) {LIST; printf("<%s:%d>\n",#t,atoi(i));}
#define tokenFloat(t,i) {LIST; printf("<%s:%f>\n",#t,atof(i));}
#define tokenString(t,s) {LIST; printf("<%s:%s>\n",#t,s);}

#define MAX_LINE_LENG 256

int linenum = 1;
char buf[MAX_LINE_LENG];
%}

%%
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

bool|break|char|case|class|continue|declare|do|else|exit|float|for|fun|if|int|loop|print|println|return|string|val|var|while  {token(yytext);}

true|false {tokenString(boolean, yytext);}

[a-zA-Z]+[a-zA-Z0-9_]*   {tokenString(id, yytext);}


[1-9][0-9]*\.[0-9]+|[0-9]\.[0-9]+ {tokenFloat(float,yytext);}
[1-9][0-9]*\.[0-9]+[eE][-+][0-9]* {tokenFloat(float,yytext);}
[/+-]?[1-9]?[0-9]*   {tokenInteger(integer, yytext);}


\n      {
        LIST;
        printf("%d: %s", linenum++, buf);
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
   exit(0);
   
}
