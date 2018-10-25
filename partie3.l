%{
/****************************************************************************
mylexer.l
ParserWizard generated Lex file.

Date: mardi 19 décembre 2017
****************************************************************************/

#include "myparser.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

extern int m;
extern int err[100];
%}
alpha [a-zA-Z]
blancs    [ \t]+

chiffre   [0-9]
entier    {chiffre}+
reel    {entier}"."{entier}
exposant ({entier}|{reel})[eE][+-]?{entier}
%%

{blancs}  { /* On ignore */ }

{reel}    {
        yylval.val = strdup(yytext);
      return(NOMBRE);
    }
{chiffre} {
      yylval.val = strdup(yytext);
      return(NOMBRE);
    }
{entier} {
       yylval.val = strdup(yytext);
      return(NOMBRE);
    }
variance { m++; err[m]=4; return(VAR);}
somme { m++; err[m]=4;return(SOM);}
produit  {m++; err[m]=4; return(PROD);}
moyenne  { m++; err[m]=4;return(MOY);}
ecart    { m++; err[m]=4; return(ECART);}
{alpha}({alpha}|{chiffre})* { yylval.val = strdup(yytext); return ID; }
[+]   {m++; err[m]=1; return (PLUS);}
[-]   {m++; err[m]=1; return(MOINS);}
[*]   {m++; err[m]=1; return(FOIS); }
[/]  { m++; err[m]=1; return(DIVISE); }
[(]   {m++; err[m]=2;return(PARENTHESE_GAUCHE);}
[)]   {return(PARENTHESE_DROITE);}
"^" {m++; err[m]=1; return(PUISSANCE);}
","        {return (vir);}
[\n]  {return(FIN);}
.  {printf("erreur lexical veuilez verifier votre expression \n ");system("PAUSE"); exit(0);}