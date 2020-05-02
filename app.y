%{
void yyerror (char *s);
int yylex();

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

void addfun(int fu);
%}

%union {
	int num;
	int snum;
	int mnum;
	char *name;
	char *reg;
	char *str;
	}
	
%start file

%token <str> ACMD
%token <str> CCMD
%token <str> ICMD

%token EQCMD
%token BCMD
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
%token RCMD
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

file	: lines {printf("// main \n");}
	;
lines	: lines line {printf("//lines\n");}
		| line {printf("//line\n");}
		;
line    : selector NEG command flags{printf(" ");}

	| selector command flags{}
	| NEG command flags{printf(" ");}
	| selector NEG command{printf(" ");}
	
	| NEG command {}
	| selector command {}
	| command flags{}
	
	| command {}
	
	| label {printf("lbl:%s..\n", $1);}
        ;
selector	: regex RSEP regex {}
		| regex RSEP number {}
		| number RSEP regex {}
		|number RSEP number {}
		| regex Mnumber {}
		| regex Snumber {}
		| number Mnumber {}
		| number Snumber {}
		| regex {}
		| number {printf("// add:%d\n ", $1);}
	;
	
	//TODO add all comands
command	: EQCMD {addfun(EQCMD);}
	| ACMD {printf(">>%s<<", $1);}
	| BCMD {addfun(BCMD);}
	;
flags	: FGCMD {}
	;

%%


int main(int argc, char *argv[]) {
extern FILE *yyin;
//extern FILE *yyout;
    if ( argc != 2 )
        yyerror("You need 1 args: inputFileName");// outputFileName
    else {
    //preprocess
	printf("#include<stdio.h>\n#include<stdlib.h>\n");
	printf("#define BLEN 1024\n\n");
	printf("int main(int argc, char *argv[]) {\n");
	printf("FILE *fin = fopen(argv[1], \"r\");\nFILE *fout = fopen(argv[2], \"w\");\n");
        printf("char buffer[BLEN];\nint n=1;\n");
        printf("while(fgets(buffer, BLEN, fin)) {\n");
        
        yyin = fopen(argv[1], "r");
//        yyout = fopen(argv[2], "w")
        yyparse();
        fclose(yyin);
//        fclose(yyout);
	printf("n++;\n}\nreturn 0;\n}\n");
    }

    return 0;
}


void yyerror (char *s) {
	fprintf (stderr, "%s\n", s);
} 

//TODO: add functiions for each command
void addfun(int fu) {
switch(fu) {
	case EQCMD:
	printf("printf(\"%%d\", n);\n");
	break;
	case ACMD:
	break;
	case BCMD:
	break;

}
}
