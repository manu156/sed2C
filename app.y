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

char* RRregxp(char *reg1, char *reg2, int initial, int nloop, char *ts);
char* RNregxp(char *reg, int nloop, char *ts);
char* NRregxp(char *reg, int nloop, char *ts);

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
extern const char *s_regec1;
extern const char *s_regec2;
extern const char *s_regec3;
extern const char *s_regec4;
extern const char *s_regec5;

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

file	: lines {fprintf(yyout, "/*\t--file--\t*/\n");}
	;
lines	: lines line {fprintf(yyout, "/*\t--lines--\t*/\n");}
	| line {fprintf(yyout, "/*\t--line--\t*/\n");}
	;
line    : selector command flags{fprintf(yyout, "}//SCF\n");}

	| selector command {fprintf(yyout, "}//SC\n");}
	| command flags{fprintf(yyout, "//CF\n");}
	
	| command{fprintf(yyout, "//C\n");}
	
	| label {fprintf(yyout, ":%s\n", $1);} //TODO
        ;
selector	: regex RSEP regex NEG {char ts[1024], ts1[1024], ts2[1024];fprintf(yyout, "if(flags[%d]==0){%s}else if(flags[%d]==1){%s} else if(flags[%d]==2){%s}  if(!(flags[%d]==1 || flags[%d]==2)) {", nloop, RRregxp($1, $3, 0, nloop, ts), nloop,RRregxp($1, $3, 1, nloop, ts1), nloop, RRregxp($1, $3, 2, nloop, ts2), nloop, nloop);nloop++;}
		| regex RSEP number NEG {char ts[1024]; fprintf(yyout, "if(flags[%d]==0){%s} else if(flags[%d]==1){if(n>=%d){flags[%d]=2;} } else if(flags[%d]==2){flags[%d]++;} if(!(flags[%d]==1||flags[%d]==2)){", nloop, RNregxp($1, nloop, ts),nloop, $3, nloop, nloop, nloop, nloop, nloop); nloop++;}
		| number RSEP regex NEG {char ts[1024]; fprintf(yyout, "if(flags[%d]==0){if(n>=%d){flags[%d]=1;}} else if(flags[%d]==1){%s} else if(flags[%d]==2){flags[%d]++;} if(!(flags[%d]==1||flags[%d]==2)){", nloop, $1, nloop, nloop, NRregxp($3, nloop, ts), nloop, nloop, nloop, nloop); nloop++;}
		| number RSEP number NEG {fprintf(yyout, "if(!(n>=%d && n<=%d)) { //adds\n ", $1, $3);nloop++;}
		| regex Mnumber NEG {char ts[1024]; fprintf(yyout, "if(flags[%d]==0){%s} else if(flags[%d]==1){if(n%%%d==0){flags[%d]=2;} } else if(flags[%d]==2){flags[%d]++;} if(!(flags[%d]==1||flags[%d]==2)){", nloop, RNregxp($1, nloop, ts),nloop, $2, nloop, nloop, nloop, nloop, nloop); nloop++;}
		| regex Snumber NEG  {char ts[1024]; fprintf(yyout, "if(flags[%d]==0){%s} if(flags[%d]>=1&&((flags[%d]-3)<%d)){flags[%d]++;} if(!(flags[%d]>=1&&((flags[%d]-3)<%d))){", nloop, RNregxp($1, nloop, ts), nloop, nloop, $2, nloop, nloop, nloop, $2); nloop++;}
		| number Mnumber NEG {yyout, fprintf(yyout, "if(!(n>=%d && n<(%d+%d-%d%%%d))){", $1, $1, $1, $1, $2);}
		| number Snumber NEG {yyout, fprintf(yyout, "if(!(n>=%d && (n-1)<(%d+%d))){", $1, $1, $2);} //VERIFY
		| regex NEG {fprintf(yyout, "%s if(!tif){", s_regec5);}
		| number NEG {fprintf(yyout, "if(n!=%d) { // add:%d\n ", $1, $1);}
		
		
		//NORMAL
		| regex RSEP regex {char ts[1024], ts1[1024], ts2[1024];fprintf(yyout, "if(flags[%d]==0){%s}else if(flags[%d]==1){%s} else if(flags[%d]==2){%s}  if(flags[%d]==1 || flags[%d]==2) {", nloop, RRregxp($1, $3, 0, nloop, ts), nloop,RRregxp($1, $3, 1, nloop, ts1), nloop, RRregxp($1, $3, 2, nloop, ts2), nloop, nloop);nloop++;}
		| regex RSEP number {char ts[1024]; fprintf(yyout, "if(flags[%d]==0){%s} else if(flags[%d]==1){if(n>=%d){flags[%d]=2;} } else if(flags[%d]==2){flags[%d]++;} if(flags[%d]==1||flags[%d]==2){", nloop, RNregxp($1, nloop, ts),nloop, $3, nloop, nloop, nloop, nloop, nloop); nloop++;}
		| number RSEP regex {char ts[1024]; fprintf(yyout, "if(flags[%d]==0){if(n>=%d){flags[%d]=1;}} else if(flags[%d]==1){%s} else if(flags[%d]==2){flags[%d]++;} if(flags[%d]==1||flags[%d]==2){", nloop, $1, nloop, nloop, NRregxp($3, nloop, ts), nloop, nloop, nloop, nloop); nloop++;}
		| number RSEP number {fprintf(yyout, "if(n>=%d && n<=%d) { //adds\n ", $1, $3);nloop++;}
		| regex Mnumber  {char ts[1024]; fprintf(yyout, "if(flags[%d]==0){%s} else if(flags[%d]==1){if(n%%%d==0){flags[%d]=2;} } else if(flags[%d]==2){flags[%d]++;} if(flags[%d]==1||flags[%d]==2){", nloop, RNregxp($1, nloop, ts),nloop, $2, nloop, nloop, nloop, nloop, nloop); nloop++;}
		| regex Snumber  {char ts[1024]; fprintf(yyout, "if(flags[%d]==0){%s} if(flags[%d]>=1&&((flags[%d]-3)<%d)){flags[%d]++;", nloop, RNregxp($1, nloop, ts), nloop, nloop, $2, nloop); nloop++;}
		| number Mnumber {yyout, fprintf(yyout, "if(n>=%d && n<(%d+%d-%d%%%d)){", $1, $1, $1, $1, $2);} //GNU ext / ext
		| number Snumber {yyout, fprintf(yyout, "if(n>=%d && (n-1)<(%d+%d)){", $1, $1, $2);} // GNU ext / ext -- TODO: ALSO VERIFY
		| regex {fprintf(yyout, "%s if(tif){", s_regec5);}
		| number {fprintf(yyout, "if(n==%d) { // add:%d\n ", $1, $1);}
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
	| SCMD {} //TODO
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
		yyerror("You need 2 args: inputFileName outputFileName");
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
		sprintf(ts, "int lpn=%d; char regc[]=\"%s\", regc2[]=\"%s\"; %s\n\n", nloop, reg1, reg2, s_regec1);
	}
	else if(initial==1) {
		sprintf(ts, "int lpn=%d; char regc[]=\"%s\"; %s\n\n", nloop, reg2, s_regec2);
	}
	else {
		sprintf(ts, "flags[%d]++;\n\n", nloop);
	}
	//setting intial, final
	
	//print action
	return (ts);
}

char* RNregxp(char *reg, int nloop, char *ts) {
	sprintf(ts, "int lpn=%d; char regc[]=\"%s\"; %s\n\n", nloop, reg, s_regec3);
	return ts;
}
char* NRregxp(char *reg, int nloop, char *ts) {
	sprintf(ts, "int lpn=%d; char regc[]=\"%s\"; %s\n\n", nloop, reg, s_regec4);
	return ts;
}



//TODO: add functiions for each command
void addfun(int fu, char *fst) {
switch(fu) {
	case EQCMD:
	fprintf(yyout, "%s", s_eqcmd);
	break;
	case ACMD:
	fprintf(yyout, "\t\tstrcat(buffer, \"%s\");\nstrcat(buffer,\"\\n\");\n", fst);
	break;
	case BCMD:
	fprintf(yyout, "goto %s;", fst);
	break;
	case CCMD:
	fprintf(yyout, "\t\tstrcpy(buffer, \"%s\");\nstrcat(buffer,\"\\n\");\n", fst);
	break;
	case DCMD:
	//fprintf(yyout, "buffer[0]='\\0';\n");
	fprintf(yyout, "n++;\ncontinue;\n");
	break;
	case CDCMD:
	fprintf(yyout, "%s", s_cdcmd);
	break;
	case FNCMD:
	fprintf(yyout, "printf(\"%%s\\n\", argv[1]);\n");
	break;
	case GCMD:
	fprintf(yyout, "strcpy(buffer, holdsp);\n");
	break;
	case CGCMD:
	fprintf(yyout, "strcat(buffer, holdsp);\n");
	break;
	case HCMD:
	fprintf(yyout, "strcat(holdsp, buffer);\n");
	break;
	case CHCMD:
	fprintf(yyout, "strcat(holdsp, buffer);\n");
	break;
	case ICMD:
	fprintf(yyout, "printf(\"%s\\n\");\n", fst);
	break;
	case LCMD://TODO: add formatting
	fprintf(yyout, "%s", s_lcmd);
	break;
	case NCMD:
	fprintf(yyout, "%s", s_ncmd);
	break;
	case CNCMD:
	fprintf(yyout, "%s", s_cncmd);
	break;
	case PCMD:
	fprintf(yyout, "printf(\"%%s\", buffer);\n");
	break;
	case CPCMD:
	fprintf(yyout, "printf(\"%%*s\", strcspn(buffer, \"\\n\")+1, buffer);");
	break;
	case QCMD:
	fprintf(yyout, "return 0;");
	break;
	
	//TODO
	case TCMD:
	fprintf(yyout, " ");
	break;
	case CTCMD:
	fprintf(yyout, " ");
	break;
	
	//TODO
	case WCMD:
	fprintf(yyout, " ");
	break;
	case CWCMD:
	fprintf(yyout, " ");
	break;
	
	case XCMD:
	fprintf(yyout, "char tmpbuff[BLEN];strcpy(tmpbuff, buffer);strcpy(buffer, holdsp); strcpy(holdsp, tmpbuff);\n");
	break;
	
	case YCMD://TODO
	fprintf(yyout, " ");
	break;
	
	case ZPCMD:
	fprintf(yyout, "buffer[0]='\\0';");
	break;
	
	
	}
}
