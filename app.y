%{
void yyerror (char *s);
int yylex();


#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
void addfun(int fu);
%}
%union {int num;}
%start file

%token EQCMD
%token ACMD
%token BCMD
%token CCMD
%token DCMD
%token CDCMD
%token GCMD
%token CGCMD
%token HCMD
%token CHCMD
%token ICMD
%token LCMD
%token CLCMD
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

%token STAR
%token NEG

%token <num> number


%%

file	: lines {printf("// main \n");}
	;
lines	: lines line {printf("//lines\n");}
		| line {printf("//line\n");}
		;
line    : address NEG command {printf(" ");}
	| address command {}
	| NEG command {}
	| command {}
        ;
command	: EQCMD {addfun(EQCMD);}
	| ACMD {addfun(ACMD);}
	| BCMD {addfun(BCMD);}
	| STAR {addfun(STAR);}
	;
address	: number {printf("// add:%d\n ", $1);}
	;

%%


int main(int argc, char *argv[]) {
extern FILE *yyin;
//extern FILE *yyout;
    if ( argc != 2 )
        yyerror("You need 1 args: inputFileName");// outputFileName
    else {
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

void addfun(int fu) {
switch(fu) {
	case EQCMD:
	printf("printf(\"%%d\", n);\n");
	break;
	case ACMD:
	break;
	case BCMD:
	break;
	case STAR:
	break;
}
}
