%{
void yyerror (char *s);
int yylex();

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "strs.h"


void addfun(int fu, char *fst);

extern const char *s_header;
extern const char *s_macros;
extern const char *s_mainS;
extern const char *s_mainE;
extern const char *s_eqcmd;
extern const char *s_cdcmd;
extern const char *s_lcmd;
extern const char *s_ncmd;
extern const char *s_cncmd;


%}

%union {
	int num;
	int snum;
	int mnum;
	char *name;
	char *reg;
	char *str;
	char *nlbl;
	}
	
%start file

%token <str> ACMD
%token <nlbl> BCMD
%token <str> CCMD
%token <str> ICMD

%token EQCMD

%token DCMD
%token CDCMD
%token FNCMD
%token GCMD
%token CGCMD
%token HCMD
%token CHCMD
%token LCMD
%token NCMD
%token CNCMD
%token PCMD
%token CPCMD
%token QCMD
%token SCMD
%token TCMD
%token CTCMD
%token WCMD
%token CWCMD
%token XCMD
%token YCMD
%token ZPCMD
%token NEG
%token RSEP
%token EFL

%token FGCMD

%token CROP
%token CRED
%token SSEP

%token <num> number
%token <mnum> Mnumber
%token <snum> Snumber
%token <name> label
%token <reg> regex

%%

file	: lines {printf("\t\t// main \n");}
	;
lines	: lines line {printf("//lines\n");}
	| line {printf("//line\n");}
	;
line    : selector NEG command flags{printf("}\n");}

	| selector command flags{printf("}\n");}
	| selector NEG command{printf("}\n");}
	
	| selector command {printf("}//SC.\n");}
	| command flags{}
	
	| command {}
	
	| label {printf(":%s\n", $1);} //TODO
        ;
selector	: regex RSEP regex {printf("{");}
		| regex RSEP number {printf("{");}
		| number RSEP regex {printf("{");}
		| number RSEP number {printf("while(n>=%d && n<=%d) { //adds\n ", $1, $3);}
		| regex Mnumber {printf("{");}
		| regex Snumber {printf("{");}
		| number Mnumber {printf("{");}
		| number Snumber {printf("{");}
		| regex {printf("{");}
		| number {printf("while(n==%d) { // add:%d\n ", $1, $1);}
		;
	
	//TODO add all comands
command	: EQCMD {addfun(EQCMD, NULL);}
	| ACMD {addfun(ACMD, $1);}
	| BCMD {addfun(BCMD, $1);}
	| CCMD {addfun(CCMD, $1);}
	| DCMD {addfun(DCMD, NULL);}
	| CDCMD {addfun(CDCMD, NULL);}
	| FNCMD {addfun(FNCMD, NULL);}
	| GCMD {addfun(GCMD, NULL);}
	| CGCMD {addfun(CGCMD, NULL);}
	| HCMD {addfun(HCMD, NULL);}
	| CHCMD {addfun(CHCMD, NULL);}
	| ICMD {addfun(ICMD, $1);}
	| LCMD {addfun(LCMD, NULL)}
	| NCMD {addfun(NCMD, NULL)}
	| CNCMD {addfun(CNCMD, NULL)}
	| PCMD {addfun(PCMD, NULL)}
	| CPCMD {addfun(CPCMD, NULL)}
	| QCMD {addfun(QCMD, NULL)}
	| SCMD {} //TODO
	| TCMD {addfun(TCMD, NULL)}
	| CTCMD {addfun(CTCMD, NULL)}
	| WCMD {addfun(WCMD, NULL)}
	| CWCMD {addfun(CWCMD, NULL)}
	| XCMD {addfun(XCMD, NULL)}
	| YCMD {addfun(YCMD, NULL)}//TODO
	| ZPCMD {addfun(ZPCMD, NULL)}
	
	;
flags	: FGCMD {}
	;

%%


int main(int argc, char *argv[]) {
	extern FILE *yyin;
	if ( argc != 2 )
		yyerror("You need 1 args: inputFileName");// outputFileName
	else {
	//preprocess
		printf("%s%s", s_header, s_macros);
	        printf("%s%s", s_mainS, s_mloop);
	        yyin = fopen(argv[1], "r");
		yyparse();
        	fclose(yyin);
		printf("%s", s_mainE);
	}
	return 0;
}


void yyerror (char *s) {
	fprintf (stderr, "%s\n", s);
} 

//TODO: add functiions for each command
void addfun(int fu, char *fst) {
switch(fu) {
	case EQCMD:
	printf("%s", s_eqcmd);
	break;
	case ACMD:
	printf("\t\tstrcat(buffer, \"%s\");\nstrcat(buffer,\"\\n\");\n", fst);
	break;
	case BCMD:
	printf("goto %s;", fst);
	break;
	case CCMD:
	printf("\t\tstrcpy(buffer, \"%s\");\nstrcat(buffer,\"\\n\");\n", fst);
	break;
	case DCMD:
	//printf("buffer[0]='\\0';\n");
	printf("n++;\ncontinue;\n");
	break;
	case CDCMD:
	printf("%s", s_cdcmd);
	break;
	case FNCMD:
	printf("printf(\"%%s\n\", argv[1]);\n");
	break;
	case GCMD:
	printf("strcpy(buffer, holdsp);\n");
	break;
	case CGCMD:
	printf("strcat(buffer, holdsp);\n");
	break;
	case HCMD:
	printf("strcat(holdsp, buffer);\n");
	break;
	case CHCMD:
	printf("strcat(holdsp, buffer);\n");
	break;
	case ICMD:
	printf("printf(\"%s\\n\");\n", fst);
	break;
	case LCMD://TODO: add formatting
	printf("%s", s_lcmd);
	break;
	case NCMD:
	printf("%s", s_ncmd);
	break;
	case CNCMD:
	printf("%s", s_cncmd);
	break;
	case PCMD:
	printf("printf(\"%%s\", buffer);\n");
	break;
	case CPCMD:
	printf("printf(\"%%*s\", strcspn(buffer, \"\\n\")+1, buffer);");
	break;
	case QCMD:
	printf("return 0;");
	break;
	
	//TODO
	case TCMD:
	printf("");
	break;
	case CTCMD:
	printf("");
	break;
	
	//TODO
	case WCMD:
	printf("");
	break;
	case CWCMD:
	printf("");
	break;
	
	case XCMD:
	printf("char tmpbuff[BLEN];strcpy(tmpbuff, buffer);strcpy(buffer, holdsp); strcpy(holdsp, tmpbuff);\n");
	break;
	
	case YCMD://TODO
	printf(" ");
	break;
	
	case ZPCMD:
	printf("buffer[0]='\\0';");
	break;
	
	
	}
}
