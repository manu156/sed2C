%{
void yyerror (char *s);
int yylex();
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <regex.h> // VERIFY usage
#include "strs.h"

extern FILE *yyin;
extern FILE *yyout;
int nloop;

extern const char *s_header;
extern const char *s_macros;
extern const char *s_mainS;
extern const char *s_mainE;
extern const char *s_eqcmd;
extern const char *s_cdcmd;
extern const char *s_lcmd;
extern const char *s_ncmd;
extern const char *s_cncmd;
extern const char *s_regec1;
extern const char *s_regec2;
extern const char *s_regec3;
extern const char *s_regec4;
extern const char *s_regec5;

char* RRregxp(char *reg1, char *reg2, int initial, int nloop, char *ts);
char* RNregxp(char *reg, int nloop, char *ts);
char* NRregxp(char *reg, int nloop, char *ts);

void addfun(int fu, char *fst);

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
%token <num> number
%token <mnum> Mnumber
%token <snum> Snumber
%token <name> label
%token <reg> regex

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

%token FGCMD //VERIFY

%token CROP //TO ADD
%token CRED
%token SSEP //NOT portable - VERIFY
%token NL // VERIFY
%error-verbose //DEBUG ONLY
%%

file	: lines {}
	|
	;
lines	: lines line {}
	| line {}
	
	;

line    : selector CROP file CRED {fprintf(yyout, "\t\t}\n");}
	| CROP file CRED
	| selector command {fprintf(yyout, "\t\t}\n");}

	| command {fprintf(yyout, "\n");}
	
	| label {fprintf(yyout, "\n:%s\n", $1);} //TODO
	
        ;
selector: regex RSEP regex NEG {char ts[1024], ts1[1024], ts2[1024];fprintf(yyout, "\t\tif(flags[%d]==0) {\n%s\t\t}\n\t\telse if(flags[%d]==1){\n%s\t\t}\n\t\telse if(flags[%d]==2) {\n%s\t\t}\n\n\t\tif(!(flags[%d]==1 || flags[%d]==2)) {\n\t", nloop, RRregxp($1, $3, 0, nloop, ts), nloop,RRregxp($1, $3, 1, nloop, ts1), nloop, RRregxp($1, $3, 2, nloop, ts2), nloop, nloop);nloop++;}
		| regex RSEP number NEG {char ts[1024]; fprintf(yyout, "\t\tif(flags[%d]==0) {\n%s\t\t}\n\t\telse if(flags[%d]==1) {\n\t\t\tif(n>=%d)\n\t\t\tflags[%d]=2;\n\t\t}\n\t\telse if(flags[%d]==2) {\n\t\t\tflags[%d]++;\n\t\t}\n\t\tif(!(flags[%d]==1||flags[%d]==2)) {\n\t", nloop, RNregxp($1, nloop, ts),nloop, $3, nloop, nloop, nloop, nloop, nloop); nloop++;}
		| number RSEP regex NEG {char ts[1024]; fprintf(yyout, "\t\tif(flags[%d]==0) {\n\t\t\tif(n>=%d)\n\t\t\t\tflags[%d]=1;\n\t\t}\n\t\telse if(flags[%d]==1) {\n%s\t\t}\n\t\telse if(flags[%d]==2) {\n\t\t\tflags[%d]++;\n\t\t}\n\t\tif(!(flags[%d]==1||flags[%d]==2)) {\n\t", nloop, $1, nloop, nloop, NRregxp($3, nloop, ts), nloop, nloop, nloop, nloop); nloop++;}
		| number RSEP number NEG {fprintf(yyout, "\t\tif(!(n>=%d && n<=%d)) {\n\t ", $1, $3);nloop++;}
		| regex Mnumber NEG {char ts[1024]; fprintf(yyout, "\t\tif(flags[%d]==0) {\n%s\t\t}\n\t\telse if(flags[%d]==1) {\n\t\t\tif(n%%%d==0)\n\t\t\t\tflags[%d]=2;\n\t\t}\n\t\telse if(flags[%d]==2) {flags[%d]++;}\n\t\tif(!(flags[%d]==1||flags[%d]==2)) {\n\t", nloop, RNregxp($1, nloop, ts),nloop, $2, nloop, nloop, nloop, nloop, nloop); nloop++;}
		| regex Snumber NEG  {char ts[1024]; fprintf(yyout, "\t\tif(flags[%d]==0) {\n%s\t\t}\n\t\tif(flags[%d]>=1&&((flags[%d]-3)<%d)) {flags[%d]++;}\n\t\tif(!(flags[%d]>=1&&((flags[%d]-3)<%d))) {\n\t", nloop, RNregxp($1, nloop, ts), nloop, nloop, $2, nloop, nloop, nloop, $2); nloop++;}
		| number Mnumber NEG {yyout, fprintf(yyout, "\t\tif(!(n>=%d && n<=(%d+%d-%d%%%d))) {\n\t", $1, $1, $1, $1, $2);}
		| number Snumber NEG {yyout, fprintf(yyout, "\t\tif(!(n>=%d && (n-1)<(%d+%d))) {\n\t", $1, $1, $2);} //VERIFY
		| regex NEG {fprintf(yyout, "\t\tint tif=0;\n\t\t{\n\t\t\tchar regc[]=\"%s\";\n%s\t\tif(!tif) {\n\t", $1,  s_regec5);}
		| number NEG {fprintf(yyout, "\t\tif(n!=%d) {\n\t", $1);}
		
		
		//NORMAL
		| regex RSEP regex {char ts[1024], ts1[1024], ts2[1024];fprintf(yyout, "\t\tif(flags[%d]==0) {\n%s\t\t}\n\t\telse if(flags[%d]==1) {\n%s\t\t}\n\t\telse if(flags[%d]==2) {\n%s\t\t}\n\n\t\tif(flags[%d]==1 || flags[%d]==2) {\n", nloop, RRregxp($1, $3, 0, nloop, ts), nloop,RRregxp($1, $3, 1, nloop, ts1), nloop, RRregxp($1, $3, 2, nloop, ts2), nloop, nloop);nloop++;}
		| regex RSEP number {char ts[1024]; fprintf(yyout, "\t\tif(flags[%d]==0) {\n%s\t\t}\n\t\telse if(flags[%d]==1) {\n\t\t\tif(n>=%d)\n\t\t\tflags[%d]=2;\n\t\t}\n\t\telse if(flags[%d]==2) {flags[%d]++;}\n\t\tif(flags[%d]==1||flags[%d]==2) {\n\t", nloop, RNregxp($1, nloop, ts),nloop, $3, nloop, nloop, nloop, nloop, nloop); nloop++;}
		| number RSEP regex {char ts[1024]; fprintf(yyout, "\t\tif(flags[%d]==0) {\n\t\t\tif(n>=%d)\n\t\t\t\tflags[%d]=1;\n\t\t}\n\t\telse if(flags[%d]==1) {\n%s\t\t}\n\t\telse if(flags[%d]==2) {flags[%d]++;}\n\t\tif(flags[%d]==1||flags[%d]==2) {\n\t", nloop, $1, nloop, nloop, NRregxp($3, nloop, ts), nloop, nloop, nloop, nloop); nloop++;}
		| number RSEP number {fprintf(yyout, "\t\tif(n>=%d && n<=%d) {\n", $1, $3);nloop++;}
		| regex Mnumber  {char ts[1024]; fprintf(yyout, "\t\tif(flags[%d]==0) {\n%s\t\t}\n\t\telse if(flags[%d]==1) {\n\t\t\tif(n%%%d==0)\n\t\t\t\tflags[%d]=2;\n\t\t}\n\t\telse if(flags[%d]==2) {flags[%d]++;}\n\t\tif(flags[%d]==1||flags[%d]==2) {\n\t", nloop, RNregxp($1, nloop, ts),nloop, $2, nloop, nloop, nloop, nloop, nloop); nloop++;}
		| regex Snumber  {char ts[1024]; fprintf(yyout, "\t\tif(flags[%d]==0) {\n%s\t\t}\n\t\tif(flags[%d]>=1&&((flags[%d]-3)<%d)) {\n\t\t\tflags[%d]++;\n\t", nloop, RNregxp($1, nloop, ts), nloop, nloop, $2, nloop); nloop++;}
		| number Mnumber {yyout, fprintf(yyout, "\t\tif(n>=%d && n<=(%d+%d-%d%%%d)) {\n\t", $1, $1, $1, $1, $2);} //GNU ext / ext
		| number Snumber {yyout, fprintf(yyout, "\t\tif(n>=%d && (n-1)<(%d+%d)) {\n\t", $1, $1, $2);} // GNU ext / ext -- TODO: ALSO VERIFY
		| regex {fprintf(yyout, "\t\tint tif=0;\n\t\t{\n\t\t\tchar regc[]=\"%s\";\n%s\t\tif(tif) {\n\t", $1,  s_regec5);}
		| number {fprintf(yyout, "\t\tif(n==%d) {\n\t", $1);}
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
	| LCMD {addfun(LCMD, NULL);}
	| NCMD {addfun(NCMD, NULL);}
	| CNCMD {addfun(CNCMD, NULL);}
	| PCMD {addfun(PCMD, NULL);}
	| CPCMD {addfun(CPCMD, NULL);}
	| QCMD {addfun(QCMD, NULL);}
	| SCMD flags {} //TODO
	| TCMD {addfun(TCMD, NULL);}
	| CTCMD {addfun(CTCMD, NULL);}
	| WCMD {addfun(WCMD, NULL);}
	| CWCMD {addfun(CWCMD, NULL);}
	| XCMD {addfun(XCMD, NULL);}
	| YCMD {addfun(YCMD, NULL);}//TODO
	| ZPCMD {addfun(ZPCMD, NULL);}
	
	;
	

flags	: FGCMD {}
	;

%%


int main(int argc, char *argv[]) {
	
	if ( argc != 3 )
		yyerror("You need 2 args: inputFileName outputFileName\n");
	else {
		int tmi=-1;
		nloop=0;

	//preprocess
	

	        yyout=fopen(argv[2],"w+");
		fprintf(yyout, "%s%s", s_header, s_macros);
	        fprintf(yyout, "%s%s", s_mainS, s_mloop);
	        yyin = fopen(argv[1], "r");

		yyparse();
		

		fprintf(yyout, "%s", s_mainE);
		
		// POST PROCESSING

		fseek(yyout, strlen(s_header), SEEK_SET);
		fprintf(yyout, "#define FLL %d /*", nloop);
        	fclose(yyin);
		fclose(yyout);
	}
	return 0;
}


void yyerror (char *s) {
	fprintf (stderr, "%s\n", s);
}


char* RRregxp(char *reg1, char *reg2, int initial, int nloop, char *ts) {
	//preprocess
	
	//process
	
	if(initial==0) {
		sprintf(ts, "\t\t\tint lpn=%d;\n\t\t\tchar regc[]=\"%s\", regc2[]=\"%s\";\n%s", nloop, reg1, reg2, s_regec1);
	}
	else if(initial==1) {
		sprintf(ts, "\t\t\tint lpn=%d;\n\t\t\tchar regc[]=\"%s\";\n%s", nloop, reg2, s_regec2);
	}
	else {
		sprintf(ts, "\t\t\tflags[%d]++;\n", nloop);
	}
	//setting intial, final
	
	//print action
	return (ts);
}

char* RNregxp(char *reg, int nloop, char *ts) {
	sprintf(ts, "\t\t\tint lpn=%d;\n\t\t\tchar regc[]=\"%s\";\n%s", nloop, reg, s_regec3);
	return ts;
}
char* NRregxp(char *reg, int nloop, char *ts) {
	sprintf(ts, "\t\t\tint lpn=%d;\n\t\t\tchar regc[]=\"%s\";\n%s", nloop, reg, s_regec4);
	return ts;
}



//TODO: add functiions for each command
void addfun(int fu, char *fst) {
switch(fu) {
	case EQCMD:
	fprintf(yyout, "\t\t%s", s_eqcmd);
	break;
	case ACMD:
	fprintf(yyout, "\t\tstrcat(buffer, \"%s\"); strcat(buffer,\"\\n\");\n", fst);
	break;
	case BCMD:
	fprintf(yyout, "\t\tgoto %s;", fst);
	break;
	case CCMD:
	fprintf(yyout, "\t\tstrcpy(buffer, \"%s\"); strcat(buffer,\"\\n\");\n", fst);
	break;
	case DCMD:
	//fprintf(yyout, "buffer[0]='\\0';\n");
	fprintf(yyout, "\t\tn++; continue;\n");
	break;
	case CDCMD:
	fprintf(yyout, "\t\t%s", s_cdcmd);
	break;
	case FNCMD:
	fprintf(yyout, "\t\tprintf(\"%%s\\n\", argv[1]);\n");
	break;
	case GCMD:
	fprintf(yyout, "\t\tstrcpy(buffer, holdsp);\n");
	break;
	case CGCMD:
	fprintf(yyout, "\t\tstrcat(buffer, holdsp);\n");
	break;
	case HCMD:
	fprintf(yyout, "\t\tstrcat(holdsp, buffer);\n");
	break;
	case CHCMD:
	fprintf(yyout, "\t\tstrcat(holdsp, buffer);\n");
	break;
	case ICMD:
	fprintf(yyout, "\t\tprintf(\"%s\\n\");\n", fst);
	break;
	case LCMD://TODO: add formatting
	fprintf(yyout, "\t\t%s", s_lcmd);
	break;
	case NCMD:
	fprintf(yyout, "\t\t%s", s_ncmd);
	break;
	case CNCMD:
	fprintf(yyout, "\t\t%s", s_cncmd);
	break;
	case PCMD:
	fprintf(yyout, "\t\tprintf(\"%%s\", buffer);\n");
	break;
	case CPCMD:
	fprintf(yyout, "\t\tprintf(\"%%*s\", strcspn(buffer, \"\\n\")+1, buffer);");
	break;
	case QCMD:
	fprintf(yyout, "\t\treturn 0;");
	break;
	
	//TODO
	case TCMD:
	fprintf(yyout, "\t\t");
	break;
	case CTCMD:
	fprintf(yyout, "\t\t");
	break;
	
	//TODO
	case WCMD:
	fprintf(yyout, "\t\t");
	break;
	case CWCMD:
	fprintf(yyout, "\t\t");
	break;
	
	case XCMD:
	fprintf(yyout, "\t\tchar tmpbuff[BLEN];strcpy(tmpbuff, buffer);strcpy(buffer, holdsp); strcpy(holdsp, tmpbuff);\n");
	break;
	
	case YCMD://TODO
	fprintf(yyout, "\t\t");
	break;
	
	case ZPCMD:
	fprintf(yyout, "\t\tbuffer[0]='\\0';");
	break;
	
	
	}
}
