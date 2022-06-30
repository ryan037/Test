
%{
#define LIST     strcat(buf,yytext)
#define token(t) {LIST;                               \
                 if(yytext[0]>=97 && yytext[0]<=122)  \
                    printf("<%s>\n", yytext);         \
                 else                                 \
                    printf("<%s>\n", #t);             \
                 }
#define tokenChar(t) {LIST; printf("<'%c'>\n", t);}
#define tokenInteger(t,i) {LIST; printf("<%s:%d>\n",#t,i);}
#define tokenString(t,s) {LIST; printf("<%s:%s>\n",#t,#s);}

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

bool|break {token(yytext);}

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
