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
void generer_quad(char c_op[], char s1[], char s2[], char dest[]);
void afficher_quad();
void evaluer();
int taille_quad = 0;
void erre();
double cpt[100] ;
double ecart[100];
double somme[100];
double prod[100];
int err[100];
int tempGenerer=0;

int ic=0;
int i=0;
int j=0;
int l=0;
int m=0;
typedef struct {
                char code_op[10];
                char source1[10];
                char source2[10];
                char dest[10];
                int num;
 }Quad;

Quad tab_quad[1000];
char *var[100];
double val[100];
char c[10];
int v=0;
char * va, *v2;
 
%}

/////////////////////////////////////////////////////////////////////////////
// declarations section
%union {
    int nb; 
    char *val;
} 
%include {
#ifndef YYSTYPE
#define YYSTYPE int
#endif
}


%token <val>  NOMBRE
%token<val> ID
%type <val> Expression
%token SOM MOY VAR ECART PROD 
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
    | Input Ligne
    ;

Ligne:
    FIN
  | Expression FIN                { afficher_quad(); evaluer();taille_quad=0;tempGenerer=0;v=0;}
  
  ;

Expression:
   NOMBRE     { $<val>$=strdup($<val>1); var[v]=strdup($<val>1); v++;}
  |ID {int j=0; $<val>$=strdup($<val>1); 
  
  var[v]=strdup($<val>1); v++; }
  |Expression PLUS Expression {char* src1= strdup($<val>1); tempGenerer++;
   sprintf($<val>$,"t%d",tempGenerer);	
   generer_quad("+",src1,$<val>3,$<val>$); m--;} 
  |Expression MOINS Expression { char* src1= strdup($<val>1); tempGenerer++;
   sprintf($<val>$,"t%d",tempGenerer++);
   generer_quad("-",src1,$<val>3,$<val>$); m--;}
  |Expression FOIS Expression  {char* src1= strdup($<val>1);tempGenerer++; 
  sprintf($<val>$,"t%d",tempGenerer++);
  generer_quad("*",src1,$<val>3,$<val>$); m--;}
  |Expression DIVISE Expression {if ($3==0) {printf("erreur division par zero !!! \n");system("PAUSE"); exit(0);}
  else {char* src1= strdup($<val>1);tempGenerer++; sprintf($<val>$,"t%d",tempGenerer);	
  generer_quad("/",src1,$<val>3,$<val>$);m--;} }
  |MOINS Expression%prec NEG{ {char* src1= strdup($<val>2);char* sr= strdup("t1");$<val>$=sr;
   tempGenerer++;
   generer_quad("NEG",src1,"",sr); m--;
  	}  }
  | SOM PARENTHESE_GAUCHE {i++; m++; err[m]=5;}calcsom PARENTHESE_DROITE  {$<val>$=strdup(va); m--; m--;}
  | PROD PARENTHESE_GAUCHE {j++; m++; err[m]=5;}calcprod PARENTHESE_DROITE {$<val>$=strdup(va); m--; m--;}
  | PARENTHESE_GAUCHE Expression PARENTHESE_DROITE  { $<val>$=strdup($<val>2); }
  | MOY PARENTHESE_GAUCHE {l++; m++; err[m]=5;} CalMoy PARENTHESE_DROITE  {char src1[100]; char src2[100];tempGenerer++; 
         sprintf(src2,"t%d",tempGenerer++);
         sprintf(src1,"%f",cpt[l]);
         generer_quad("/",va,src1,src2); $<val>$=strdup(src2);
         cpt[l]=1;l--;  m--; m--;}
  | VAR PARENTHESE_GAUCHE {ic++; m++; err[m]=5;} CalVar PARENTHESE_DROITE 
				 {char src1[100]; char src2[100];char src3[100];tempGenerer++; 
         sprintf(src2,"t%d",tempGenerer);
         sprintf(src1,"%f",(ecart[100-ic]+1));
         generer_quad("/",va,src1,src2); 
         tempGenerer++;  
         sprintf(src3,"t%d",tempGenerer++);
         generer_quad("/",v2,src1,src3); 
         sprintf(src1,"t%d",tempGenerer++);
         generer_quad("*",src3,src3,src1);
         tempGenerer++; 
         sprintf(src3,"t%d",tempGenerer++);
         generer_quad("-",src2,src1,src3); 
				   ecart[100-ic]=0; ic--;
				   $<val>$=strdup(src3);  m--; m--;
				 }
  | ECART PARENTHESE_GAUCHE {ic++; m++; err[m]=5;} CalVar PARENTHESE_DROITE 
                   { char src1[100]; char src2[100]; int taille;char src3[100];char src4[100];tempGenerer++; 
         sprintf(src2,"t%d",tempGenerer);
         sprintf(src1,"%f",(ecart[100-ic]+1));
         generer_quad("/",va,src1,src2); 
         tempGenerer++;  
         sprintf(src3,"t%d",tempGenerer++);
         generer_quad("/",v2,src1,src3); 
         sprintf(src1,"t%d",tempGenerer++);
         generer_quad("*",src3,src3,src1);
         tempGenerer++; 
         sprintf(src3,"t%d",tempGenerer++);
         generer_quad("-",src2,src1,src3); 
				   ecart[100-ic]=0; ic--;
	    tempGenerer++; 
       /* sprintf(src2,"t%d",tempGenerer);sprintf(src1,"%f",0.5);
 generer_quad("^",src3,src1,src2); */
 tempGenerer++; //src 4= var
    sprintf(src4,src3); sprintf(src2,"t%d",tempGenerer);
   taille=taille_quad;
  
    generer_quad("/",src4,src3,src2); //un/a 
     tempGenerer++; sprintf(src1,"t%d",tempGenerer); //un+a/un 
    generer_quad("+",src3,src2,src1);
    tempGenerer++; sprintf(src2,"t%d",tempGenerer);
    generer_quad("/",src1,"2",src2);
    generer_quad("*",src2,src2,src1);
    generer_quad("-",src1,src4,src3);
     generer_quad("-",src2,"0.01",src3);
     tempGenerer++; sprintf(src1,"t%d",tempGenerer);sprintf(src1,"%d",taille_quad+2);
    generer_quad("JE","",src1,"");
    tempGenerer++; 
    sprintf(src1,"%d",taille);
    generer_quad("Jump","",src1,"");
    
 $<val>$=strdup(src2);
  
  m--; m--;}
  | Expression PUISSANCE Expression { char* src1= strdup($<val>1);tempGenerer++; 
  sprintf($<val>$,"t%d",tempGenerer);  generer_quad("<",src1,$<val>3,$<val>$);
  generer_quad("^",src1,$<val>3,$<val>$);  m--;}
;

calcsom:
Expression vir calcsom {{ char* src1= strdup($<val>1); tempGenerer++;
   sprintf($<val>$,"t%d",tempGenerer);
   generer_quad("+",src1,va,$<val>$); va=$<val>$; m--;
   }
   } 
|Expression {{ va= strdup($<val>1); } }
; 
calcprod:
Expression vir calcprod {  char* src1= strdup($<val>1); tempGenerer++;
   sprintf($<val>$,"t%d",tempGenerer);
   generer_quad("*",src1,va,$<val>$); va=$<val>$; m--;} 
|Expression {va= strdup($<val>1);}
;
CalMoy:
  Expression vir CalMoy {{ char* src1= strdup($<val>1); tempGenerer++;
   sprintf($<val>$,"t%d",tempGenerer);
   generer_quad("+",src1,va,$<val>$); va=$<val>$; 
   cpt[l]++; m--;}}
  |Expression {va= strdup($<val>1);}
;
CalVar:
 Expression vir CalVar {  char* src1= strdup($<val>1);char src2[100]; char som[100];tempGenerer++;
   sprintf(src2,"t%d",tempGenerer);
   generer_quad("*",src1,src1,src2); tempGenerer++;
   sprintf($<val>$,"t%d",tempGenerer);
  generer_quad("+",src2,va,$<val>$);va=$<val>$; 
   tempGenerer++;
   sprintf(som,"t%d",tempGenerer);
   generer_quad("+",src1,v2,som); v2=strdup(som);
   ecart[100-ic]++; m--;
   }
   
 |Expression { char* src1= strdup($<val>1);char src2[100];tempGenerer++;
   sprintf(src2,"t%d",tempGenerer);
   generer_quad("*",src1,src1,src2); va=strdup(src2);
   v2=$<val>1;
 }
;
%%
int main(int argc, char *argv[]) {
int menuw=0;
int choix=1;
int i=0;
 for(ic=0;ic<100;ic++) { cpt[ic]=1;ecart[ic]=0; somme[ic]=0; prod[ic]=1;}
 ic=0; printf("veuillez entrer l'expression a generer ses quadruplet : \n");
yyparse();

    return 0; 
}
void generer_quad(char c_op[], char s1[], char s2[], char dest[])
{
    	 strcpy(tab_quad[taille_quad].code_op, c_op);
    	 strcpy(tab_quad[taille_quad].source1, s1);
    	 strcpy(tab_quad[taille_quad].source2, s2);
    	 strcpy(tab_quad[taille_quad].dest, dest);
    	tab_quad[taille_quad].num = taille_quad;
        taille_quad++;
}
void yyerror(const char * s)
{  
  printf("Ligne :%d: erreur syntaxique ", yylineno-1); erre(); system("PAUSE"); exit(0);
} 
void erre(){  if (err[m]==1) printf("operand manquant \n");
              if (err[m]==2) printf("parenthese fermante manquante \n");
              if (err[m]==3) printf("operand manquant apres la virgule  \n");
              if (err[m]==4) printf("parenthese ouvrante attendue apres le nom de la fonction \n");
              if (err[m]==5) printf(" au moins un operand attendu dans une fonction  \n");
            } 
void afficher_quad()
{
	int i=0;
	 for(i=0;i<taille_quad;i++)
    {
        printf("%2d : %6s | %6s | %6s | %6s\n",tab_quad[i].num,tab_quad[i].code_op,tab_quad[i].source1,tab_quad[i].source2,tab_quad[i].dest);
    } 

	
} 
void evaluer()
{int r=0; double a; double res; 
     printf("etape d'evaluation des variables");
 for(r=0;r<v;r++) 
 { if (isdigit(*var[r])==0)
 {printf("\n la variable %s  = ",var[r]);
  scanf("%lf", &a);
   val[r]=a;
    } 
   else val[r]=atof(var[r]);
   for(i=0;i<taille_quad;i++)
    {
      if(strcmp(tab_quad[i].source1,var[r])==0)   {sprintf(tab_quad[i].source1,"%lf",val[r]);}
      if(strcmp(tab_quad[i].source2,var[r])==0)   {sprintf(tab_quad[i].source2,"%lf",val[r]);}
    } 
   
 }
for(i=0;i<taille_quad;i++)
  {strcpy(c,"+");
      if(strcmp(tab_quad[i].code_op,c)==0)   {
        {strcpy(c,tab_quad[i].dest);
        sprintf(tab_quad[i].dest,"%lf",atof(tab_quad[i].source1)+atof(tab_quad[i].source2));
        }
      for(j=0;j<taille_quad;j++)
    {
      if(strcmp(tab_quad[j].source1,c)==0)   {strcpy(tab_quad[j].source1,tab_quad[i].dest); }
      if(strcmp(tab_quad[j].source2,c)==0)   {strcpy(tab_quad[j].source2,tab_quad[i].dest);}
    } }
     strcpy(c,"-");
     if(strcmp(tab_quad[i].code_op,c)==0)  {
         strcpy(c,tab_quad[i].dest);
        sprintf(tab_quad[i].dest,"%lf",atof(tab_quad[i].source1)-atof(tab_quad[i].source2));
  
      for(j=0;j<taille_quad;j++)
    {
      if(strcmp(tab_quad[j].source1,c)==0)   {strcpy(tab_quad[j].source1,tab_quad[i].dest); }
      if(strcmp(tab_quad[j].source2,c)==0)   {strcpy(tab_quad[j].source2,tab_quad[i].dest);}
    } }
     strcpy(c,"*");
     if(strcmp(tab_quad[i].code_op,c)==0)   {strcpy(c,tab_quad[i].dest);
        sprintf(tab_quad[i].dest,"%lf",atof(tab_quad[i].source1)*atof(tab_quad[i].source2));
        
      for(j=0;j<taille_quad;j++)
    {
      if(strcmp(tab_quad[j].source1,c)==0)   {strcpy(tab_quad[j].source1,tab_quad[i].dest); }
      if(strcmp(tab_quad[j].source2,c)==0)   {strcpy(tab_quad[j].source2,tab_quad[i].dest);}
    } }
     strcpy(c,"/");
     if(strcmp(tab_quad[i].code_op,c)==0)   {strcpy(c,tab_quad[i].dest);
         sprintf(tab_quad[i].dest,"%lf",atof(tab_quad[i].source1)/atof(tab_quad[i].source2));
       
      for(j=0;j<taille_quad;j++)
    {
      if(strcmp(tab_quad[j].source1,c)==0)   {strcpy(tab_quad[j].source1,tab_quad[i].dest); }
      if(strcmp(tab_quad[j].source2,c)==0)   {strcpy(tab_quad[j].source2,tab_quad[i].dest);}
    } }
    strcpy(c,"NEG");
     if(strcmp(tab_quad[i].code_op,c)==0)   {strcpy(c,tab_quad[i].dest);
         sprintf(tab_quad[i].dest,"%lf",atof(tab_quad[i].source1)*(-1));
       
      for(j=0;j<taille_quad;j++)
    {
      if(strcmp(tab_quad[j].source1,c)==0)   {strcpy(tab_quad[j].source1,tab_quad[i].dest); }
      if(strcmp(tab_quad[j].source2,c)==0)   {strcpy(tab_quad[j].source2,tab_quad[i].dest);}
    } }
        strcpy(c,"^");
     if(strcmp(tab_quad[i].code_op,c)==0)   {strcpy(c,tab_quad[i].dest);
         sprintf(tab_quad[i].dest,"%lf",pow(atof(tab_quad[i].source1),atof(tab_quad[i].source2)));
       
      for(j=0;j<taille_quad;j++)
    {
      if(strcmp(tab_quad[j].source1,c)==0)   {strcpy(tab_quad[j].source1,tab_quad[i].dest); }
      if(strcmp(tab_quad[j].source2,c)==0)   {strcpy(tab_quad[j].source2,tab_quad[i].dest);}
    } }
    } 
         printf(" la table contenant les quad apres evaluation\n");
         afficher_quad();
    res= atof(tab_quad[taille_quad-1].dest);
    if(taille_quad==0) res=val[0];
     printf(" le resultat apres evaluation des variables est : %lf  \n",res);
  }