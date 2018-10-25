%{
/****************************************************************************
mylexer.l
ParserWizard generated Lex file.

Date: mardi 19 décembre 2017
****************************************************************************/

#include "myparser.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
extern YYSTYPE yylval;
extern int m;
extern int err[100];
%}



blancs    [ \t]+

chiffre   [0-9]
entier    {chiffre}+
exposant  [eE][+-]?{entier}


reel    {entier}"."{entier}

%%

{blancs}  { /* On ignore */ }

{reel}    {
      yylval=atof(yytext);
      return(NOMBRE);
    }
{chiffre} {
      yylval=atof(yytext);
      return(NOMBRE);
    }
{entier} {
      yylval=atof(yytext);
      return(NOMBRE);
    } 
{exposant} {
      yylval=atof(yytext);
      return(NOMBRE);
    } 
"+"   {m++; err[m]=1; return(PLUS); }
"-"   {m++; err[m]=1;return(MOINS);}

"*"   {m++; err[m]=1;return(FOIS); }
"/"   {m++; err[m]=1;return(DIVISE); }

"^"   {m++; err[m]=1; return(PUISSANCE);}

"("   {m++; err[m]=2;return(PARENTHESE_GAUCHE); }
")"   {return(PARENTHESE_DROITE); }

"\n"  return(FIN);
somme { m++; err[m]=4; return(SOM);}
produit { m++; err[m]=4; return(PROD);}
moyenne { m++; err[m]=4; return(MOY);}
variance { m++; err[m]=4; return(VAR);}
ecart  { m++; err[m]=4; return(ECART);}
min { m++; err[m]=4; return(MIN);}
max { m++; err[m]=4; return(MAX);}
, { m++; err[m]=3; return (vir);}
.  {printf("erreur lexical veuilez verifier votre expression \n ");system("PAUSE"); exit(0);}