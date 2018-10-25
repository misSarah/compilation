%{
/****************************************************************************
myparser.y
ParserWizard generated YACC file.

Date: mardi 19 décembre 2017
****************************************************************************/
#include "mylexer.h"
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h> 
#include <math.h>
#include <string.h>
#include <conio.h>
#include <windows.h>
#include <ctype.h>
extern FILE *f;
void yyerror(const char * s);
void affichMenu(int choix);
void returnToMenu();
void erre();
double cpt[100] ;
double ecart[100];
double somme[100];
double prod[100];
int err[100];

int ic=0;
int i=0;
int j=0;
int l=0;
int m=0;
%}

/////////////////////////////////////////////////////////////////////////////
// declarations section

// attribute type
%include {
#ifndef YYSTYPE 
#define YYSTYPE double
#endif

}



%token  NOMBRE
%token SOM MOY VAR ECART PROD MIN MAX
%token  PLUS  
%token MOINS FOIS  DIVISE  PUISSANCE
%token  PARENTHESE_GAUCHE PARENTHESE_DROITE
%token  FIN
%token vir



%left PLUS  MOINS
%left FOIS  DIVISE
%left NEG
%right  PUISSANCE
%right SOM
%start Input
%%

Input:
      /* Vide */
    | Input Ligne
    ;

Ligne:
    FIN
  | Expression FIN                { printf("Resultat : %f\n",$1); }
  
  ;

Expression:
    NOMBRE      { $$=$1; }
  | Expression PLUS Expression  { $$=$1+$3; m--; }
  | Expression MOINS Expression { $$=$1-$3; m--; }
  | Expression FOIS Expression  { $$=$1*$3;m--; }
  | Expression DIVISE Expression  {  if ($3==0) {printf("erreur division par zero !!! \n");system("PAUSE"); exit(0);}                  else {$$=$1/$3;} m--;}
  | MOINS Expression %prec NEG  { $$=-$2; m--; }
  | Expression PUISSANCE Expression { $$=pow($1,$3); m--; }
  |SOM PARENTHESE_GAUCHE {i++; m++; err[m]=5;} calcsom PARENTHESE_DROITE  {$$=somme[i];somme[i]=0;i--; m--; m--;}
  |PROD PARENTHESE_GAUCHE {j++; m++; err[m]=5;} calcprod PARENTHESE_DROITE  {$$=prod[j]; prod[j]=1; j--; m--; m--;}
  |VAR PARENTHESE_GAUCHE {ic++; m++; err[m]=5;} CalVar PARENTHESE_DROITE 
				{ double c=(ecart[ic]/(ecart[100-ic]+1));  double i=($4/(ecart[100-ic]+1));
				ecart[ic]=0;ecart[100-ic]=0;ic--;
				 $$=i-c*c; m--; m--;
				}
  |MOY PARENTHESE_GAUCHE {l++; m++; err[m]=5;} CalMoy PARENTHESE_DROITE {$$=$4/cpt[l];cpt[l]=1;l--; m--; m--;}
  |ECART PARENTHESE_GAUCHE {ic++; m++; err[m]=5;} CalVar PARENTHESE_DROITE {
                            double c=(ecart[ic]/(ecart[100-ic]+1));  double i=($4/(ecart[100-ic]+1));
                            ecart[ic]=0;ecart[100-ic]=0;ic--;
				             $$=sqrt(i-c*c); m--; m--;}
  |MIN PARENTHESE_GAUCHE {m++; err[m]=5;} CalMin PARENTHESE_DROITE{$$=$4; m--;m--;}
  |MAX PARENTHESE_GAUCHE {m++; err[m]=5;}CalMax PARENTHESE_DROITE{$$=$4; m--; m--;}
  | PARENTHESE_GAUCHE Expression PARENTHESE_DROITE  { $$=$2; m--; }
  
  ;
calcsom:
Expression vir calcsom { somme[i]=somme[i]+$1; m--;}
|Expression {somme[i]=somme[i]+$1;}
; 
calcprod:
Expression vir calcprod { prod[j]=prod[j]*$1;m--;} 
|Expression {prod[j]=prod[j]*$1;}
;
CalMoy:
  Expression vir CalMoy {$$=$1+$3;cpt[l]++;m--;}
  |Expression {$$=$1;}
;
CalVar:
 Expression vir CalVar {$$ =$1*$1+$3; ecart[ic]=ecart[ic]+$1; ecart[100-ic]++; m--;}
 |Expression {$$ =$1*$1; ecart[ic]=ecart[ic]+$1;}
;

CalMin:
Expression vir CalMin {if ($1<$3) {$$=$1;} else{$$=$3;} m--;}
 |Expression {if ($1<$$) {$$=$1;}}
;
CalMax:
Expression vir CalMax {if ($1>$3) {$$=$1;} else{$$=$3;} m--;}
 |Expression {if ($1>$$) {$$=$1;}}
;

%%

void yyerror(const char * s)
{  
  printf("Ligne :%d: erreur syntaxique ", yylineno-1); erre(); system("PAUSE"); 
} 
void erre(){  if (err[m]==1) printf("operand manquant \n");
              if (err[m]==2) printf("parenthese fermante manquante \n");
              if (err[m]==3) printf("operand manquant apres la virgule  \n");
              if (err[m]==4) printf("parenthese ouvrante attendue apres le nom de la fonction \n");
              if (err[m]==5) printf(" au moins un operand attendu dans une fonction  \n");
               }
       
 
int main(int argc, char *argv[]) {
int menuw=0;
int choix=1;
int i=0;
 for(ic=0;ic<100;ic++) { cpt[ic]=1;ecart[ic]=0; somme[ic]=0; prod[ic]=1;}
 ic=0;
system("mode con LINES=250 COLS=150");
  do
    {
        system("cls");
        printf("         \n");

        printf("       -->  Veuillez faire un choix dans le menu suivant :\n\n") ;
         affichMenu(choix);
         scanf("%d",&choix);
        system("cls");


        switch(choix)
        {
        case 1:
            system("cls");

            printf("\n                                       =============> LIRE D'UN FICHIER <=============   \n\n ");
            printf(" \n\n\n");

       
            printf("\n\n\n");
            yyin = fopen("D\:programme.txt", "r");
                if(!yyparse())
  
 	                  	printf("\nAucune Erreur --> Compilation Reussie\n");
 		
 	             else
 	             printf("\nAttention : Erreur Syntaxique");
 	
 	             fclose(yyin);
 	
            printf("\n\n\n");
            returnToMenu();
            affichMenu(choix);
            printf("\n\n\n");
            break;
        case 2:
            system("cls");

            printf("\n                                      =============> FAIRE ENTREE LES EXPRESSION ARITHMETIQUE<=============   \n\n ");
            printf(" \n\n\n");
            printf(" veuillez entrer l'expression arithmitique a evaluer \n");
            if(!yyparse())
  
 	            	printf("\nAucune Erreur --> Compilation Reussie\n");
 		
 	             else
 	             printf("\nAttention : Erreur Syntaxique");
            returnToMenu();
            printf("\n\n\n");

            affichMenu(choix);
            printf("\n\n\n");
            break;
         case 3:
            affichMenu(choix);
            system("pause");
            break;
        }
            
            
     } while(choix != 3);

    return EXIT_SUCCESS;

    return 0; 
}
void affichMenu(int choix)
{
    printf("\n\n          1/ lire a partir d'un fichier             \n");
      printf("\n \n          2/ lire a partir de la ligne de commande          \n ");
         printf("\n\n          3/ Quitter           \n  ");
         
}

void returnToMenu()
{
    printf("\n\n");

    printf ("          +---------------------------------------------------------------------------------------------------------------------------+\n");
    printf ("          |                                        ");

    printf("[ ");

    printf ("ENTER");

    printf (" ] ");

    printf ("Pour revenir au MENU PRINCIPAL");

    printf("                                           |\n");
    printf ("          +---------------------------------------------------------------------------------------------------------------------------+\n");

    getch();
    system("cls");
}