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
int nloop, spc;

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
extern const char *s_ss;

char* RRregxp(char *reg1, char *reg2, int initial, int nloop, char *ts);
char* RNregxp(char *reg, int nloop, char *ts);
char* NRregxp(char *reg, int nloop, char *ts);
char* rform(char *reg, char *ts);
void addfun(int fu, char *fst);
void ssube(char *strp);

%}

%union {
	int num;
	int snum;
	int mnum;
	char *name;
	char *reg;
	char *str;
	char *nlbl;
	char *regs;
	char *tl;
	char *ctl;
	char *yc;
	}
	
%start file

%token <str> ACMD
%token <nlbl> BCMD
%token <str> CCMD
%token <str> ICMD
%token <regs> SCMD
%token <tl> TCMD
%token <ctl> CTCMD
%token <yc> YCMD
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
%token WCMD
%token CWCMD
%token XCMD
%token ZPCMD
%token NEG
%token RSEP
%token EFL

%token CROP
%token CRED
%error-verbose //DEBUG ONLY
%%

file	: lines {}
	|
	;
lines	: lines line {}
	| line {}
	
	;

line    : selector CROP file CRED {fprintf(yyout, "\t\t}\n");}
	| CROP file CRED {}
	| selector command {fprintf(yyout, "\t\t}\n");}

	| command {fprintf(yyout, "\n");}
	
	| label {fprintf(yyout, "\n\t\t%s:\n", $1);} //TODO
	
        ;
selector: regex RSEP regex NEG {char ts[1024], ts1[1024], ts2[1024];fprintf(yyout, "\t\tif(flags[%d]==0) {\n%s\t\t}\n\t\telse if(flags[%d]==1){\n%s\t\t}\n\t\telse if(flags[%d]==2) {\n%s\t\t}\n\n\t\tif(!(flags[%d]==1 || flags[%d]==2)) {\n\t", nloop, RRregxp($1, $3, 0, nloop, ts), nloop,RRregxp($1, $3, 1, nloop, ts1), nloop, RRregxp($1, $3, 2, nloop, ts2), nloop, nloop);nloop++;}
		| regex RSEP number NEG {char ts[1024]; fprintf(yyout, "\t\tif(flags[%d]==0) {\n%s\t\t}\n\t\telse if(flags[%d]==1) {\n\t\t\tif(n>=%d)\n\t\t\tflags[%d]=2;\n\t\t}\n\t\telse if(flags[%d]==2) {\n\t\t\tflags[%d]++;\n\t\t}\n\t\tif(!(flags[%d]==1||flags[%d]==2)) {\n\t", nloop, RNregxp($1, nloop, ts),nloop, $3, nloop, nloop, nloop, nloop, nloop); nloop++;}
		| number RSEP regex NEG {char ts[1024]; fprintf(yyout, "\t\tif(flags[%d]==0) {\n\t\t\tif(n>=%d)\n\t\t\t\tflags[%d]=1;\n\t\t}\n\t\telse if(flags[%d]==1) {\n%s\t\t}\n\t\telse if(flags[%d]==2) {\n\t\t\tflags[%d]++;\n\t\t}\n\t\tif(!(flags[%d]==1||flags[%d]==2)) {\n\t", nloop, $1, nloop, nloop, NRregxp($3, nloop, ts), nloop, nloop, nloop, nloop); nloop++;}
		| number RSEP number NEG {fprintf(yyout, "\t\tif(!(n>=%d && n<=%d)) {\n\t ", $1, $3);nloop++;}
		| regex Mnumber NEG {char ts[1024]; fprintf(yyout, "\t\tif(flags[%d]==0) {\n%s\t\t}\n\t\telse if(flags[%d]==1) {\n\t\t\tif(n%%%d==0)\n\t\t\t\tflags[%d]=2;\n\t\t}\n\t\telse if(flags[%d]==2) {flags[%d]++;}\n\t\tif(!(flags[%d]==1||flags[%d]==2)) {\n\t", nloop, RNregxp($1, nloop, ts),nloop, $2, nloop, nloop, nloop, nloop, nloop); nloop++;}
		| regex Snumber NEG  {char ts[1024]; fprintf(yyout, "\t\tif(flags[%d]==0) {\n%s\t\t}\n\t\tif(flags[%d]>=1&&((flags[%d]-3)<%d)) {flags[%d]++;}\n\t\tif(!(flags[%d]>=1&&((flags[%d]-3)<%d))) {\n\t", nloop, RNregxp($1, nloop, ts), nloop, nloop, $2, nloop, nloop, nloop, $2); nloop++;}
		| number Mnumber NEG {yyout, fprintf(yyout, "\t\tif(!(n>=%d && n<=(%d+%d-%d%%%d))) {\n\t", $1, $1, $1, $1, $2);}
		| number Snumber NEG {yyout, fprintf(yyout, "\t\tif(!(n>=%d && (n-1)<(%d+%d))) {\n\t", $1, $1, $2);}
		| regex NEG {char rtsn[1024]; fprintf(yyout, "\t\tint tif=0;\n\t\t{\n\t\t\tchar regc[]=\"%s\";\n%s\t\tif(!tif) {\n\t", rform($1, rtsn),  s_regec5);}
		| number NEG {fprintf(yyout, "\t\tif(n!=%d) {\n\t", $1);}
		
		
		//NORMAL
		| regex RSEP regex {char ts[1024], ts1[1024], ts2[1024];fprintf(yyout, "\t\tif(flags[%d]==0) {\n%s\t\t}\n\t\telse if(flags[%d]==1) {\n%s\t\t}\n\t\telse if(flags[%d]==2) {\n%s\t\t}\n\n\t\tif(flags[%d]==1 || flags[%d]==2) {\n", nloop, RRregxp($1, $3, 0, nloop, ts), nloop,RRregxp($1, $3, 1, nloop, ts1), nloop, RRregxp($1, $3, 2, nloop, ts2), nloop, nloop);nloop++;}
		| regex RSEP number {char ts[1024]; fprintf(yyout, "\t\tif(flags[%d]==0) {\n%s\t\t}\n\t\telse if(flags[%d]==1) {\n\t\t\tif(n>=%d)\n\t\t\tflags[%d]=2;\n\t\t}\n\t\telse if(flags[%d]==2) {flags[%d]++;}\n\t\tif(flags[%d]==1||flags[%d]==2) {\n\t", nloop, RNregxp($1, nloop, ts),nloop, $3, nloop, nloop, nloop, nloop, nloop); nloop++;}
		| number RSEP regex {char ts[1024]; fprintf(yyout, "\t\tif(flags[%d]==0) {\n\t\t\tif(n>=%d)\n\t\t\t\tflags[%d]=1;\n\t\t}\n\t\telse if(flags[%d]==1) {\n%s\t\t}\n\t\telse if(flags[%d]==2) {flags[%d]++;}\n\t\tif(flags[%d]==1||flags[%d]==2) {\n\t", nloop, $1, nloop, nloop, NRregxp($3, nloop, ts), nloop, nloop, nloop, nloop); nloop++;}
		| number RSEP number {fprintf(yyout, "\t\tif(n>=%d && n<=%d) {\n", $1, $3);nloop++;}
		| regex Mnumber  {char ts[1024]; fprintf(yyout, "\t\tif(flags[%d]==0) {\n%s\t\t}\n\t\telse if(flags[%d]==1) {\n\t\t\tif(n%%%d==0)\n\t\t\t\tflags[%d]=2;\n\t\t}\n\t\telse if(flags[%d]==2) {flags[%d]++;}\n\t\tif(flags[%d]==1||flags[%d]==2) {\n\t", nloop, RNregxp($1, nloop, ts),nloop, $2, nloop, nloop, nloop, nloop, nloop); nloop++;}
		| regex Snumber  {char ts[1024]; fprintf(yyout, "\t\tif(flags[%d]==0) {\n%s\t\t}\n\t\tif(flags[%d]>=1&&((flags[%d]-3)<%d)) {\n\t\t\tflags[%d]++;\n\t", nloop, RNregxp($1, nloop, ts), nloop, nloop, $2, nloop); nloop++;}
		| number Mnumber {yyout, fprintf(yyout, "\t\tif(n>=%d && n<=(%d+%d-%d%%%d)) {\n\t", $1, $1, $1, $1, $2);}
		| number Snumber {yyout, fprintf(yyout, "\t\tif(n>=%d && (n-1)<(%d+%d)) {\n\t", $1, $1, $2);}
		| regex {char rts[1024];fprintf(yyout, "\t\tint tif=0;\n\t\t{\n\t\t\tchar regc[]=\"%s\";\n%s\t\tif(tif) {\n\t", rform($1, rts),  s_regec5);}
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
	| SCMD {addfun(SCMD, $1);} //TODO
	| TCMD {addfun(TCMD, $1);}
	| CTCMD {addfun(CTCMD, $1);}
	| WCMD {addfun(WCMD, NULL);}
	| CWCMD {addfun(CWCMD, NULL);}
	| XCMD {addfun(XCMD, NULL);}
	| YCMD {addfun(YCMD, $1);}//TODO
	| ZPCMD {addfun(ZPCMD, NULL);}
	
	;
	

%%


int main(int argc, char *argv[]) {
	
	if ( argc != 3 )
		yyerror("You need 2 args: inputFileName outputFileName\n");
	else {
		int tmi=-1;
		nloop=0, spc=0;

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
	char *rc1=strdup(reg1);
	char *rc2=strdup(reg2);
	rform(strdup(rc1), rc1);
	rform(strdup(rc2), rc2);
	
	if(initial==0) {
		sprintf(ts, "\t\t\tint lpn=%d;\n\t\t\tchar regc[]=\"%s\", regc2[]=\"%s\";\n%s", nloop, rc1, rc2, s_regec1);
	}
	else if(initial==1) {
		sprintf(ts, "\t\t\tint lpn=%d;\n\t\t\tchar regc[]=\"%s\";\n%s", nloop, rc2, s_regec2);
	}
	else {
		sprintf(ts, "\t\t\tflags[%d]++;\n", nloop);
	}
	//setting intial, final
	
	//print action
	return (ts);
}

char* RNregxp(char *reg, int nloop, char *ts) {
	char *rc=strdup(reg);
	rform(strdup(rc), rc);
	sprintf(ts, "\t\t\tint lpn=%d;\n\t\t\tchar regc[]=\"%s\";\n%s", nloop, rc, s_regec3);
	return ts;
}
char* NRregxp(char *reg, int nloop, char *ts) {
	char *rc=strdup(reg);
	rform(strdup(rc), rc);
	sprintf(ts, "\t\t\tint lpn=%d;\n\t\t\tchar regc[]=\"%s\";\n%s", nloop, rc, s_regec4);
	return ts;
}



void addfun(int fu, char *fst) {
	int sepl=-1,j =0, k=0, p=0;
	char *mod1, *mod2, *ss1, *ss2;
	// vars for ycmd only
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
	case LCMD:
	fprintf(yyout, "\t\tfor(int i=0;i<strlen(buffer);i++){if(buffer[i]=='\\a')printf(\"\\\\a\");else if(buffer[i]=='\\b')printf(\"\\\\b\");else if(buffer[i]=='\\e')printf(\"\\\\e\");else if(buffer[i]=='\\f')printf(\"\\\\f\");else if(buffer[i]=='\\n')printf(\"$\\n\");else if(buffer[i]=='\\r')printf(\"\\\\r\");else if(buffer[i]=='\\t')printf(\"\\\\t\");else if(buffer[i]=='\\v')printf(\"\\\\v\");else if(buffer[i]>=' '&&buffer[i]<='~')printf(\"%%c\", buffer[i]);else printf(\"\\\\x%%.2x\", buffer[i]);}");
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
	fprintf(yyout, "\t\tprintf(\"%%*.*s\", strcspn(buffer, \"\\n\")+1, strcspn(buffer, \"\\n\")+1, buffer);");
	break;
	case QCMD:
	fprintf(yyout, "\t\treturn 0;");
	break;
	case SCMD:
	ssube(fst);
	break;	
	case TCMD:
	fprintf(yyout, "\t\tif(subf==1) {subf=0; goto %s;}\n", fst);
	break;
	case CTCMD:
	fprintf(yyout, "\t\tif(subf==0) {goto %s;}\n", fst);
	break;
	case WCMD:
	fprintf(yyout, "\t\tFILE *ftpw=fopen(\"%s\", \"a+\"); fprintf(ftpw, \"%%s\", buffer); fclose(ftpw);\n", fst);
	break;
	case CWCMD:
	fprintf(yyout, "\t\tFILE *ftpw=fopen(\"%s\", \"a+\"); fprintf(ftpw, \"%%*.*s\", strcspn(buffer, \"\\n\")+1, buffer); fclose(ftpw);\n", fst);
	break;
	case XCMD:
	fprintf(yyout, "\t\tchar tmpbuff[BLEN];strcpy(tmpbuff, buffer);strcpy(buffer, holdsp); strcpy(holdsp, tmpbuff);\n");
	break;
	case YCMD:
	for(int i=0; i<strlen(fst)-1; i++) {
		if(fst[i]=='\\')
			i++;
		else if(fst[i]=='/')
			sepl=i;
	}
	//printf("!sepl=%d!",sepl);
	if(sepl==-1) {printf("Error, couldn't parse y command strings !\n");exit(1);}
	
	ss1=malloc(4*sizeof(fst));
	ss2=malloc(4*sizeof(fst));
	strncpy(ss1, fst, sepl);
	ss1[sepl+1]='\0';
	strcpy(ss2, fst+sepl+1);
	
	//printf("<SS1:%s||SS2:%s>\n", ss1, ss2);
	
	mod1=malloc(4*sizeof(fst));
	mod2=malloc(4*sizeof(fst));
	
	for(int i=0; i<strlen(ss1)-1; i++) {
		if(ss1[i]=='\\') {
			if(ss1[i+1]=='/') {
				mod1[p]=ss1[i+1];
			}
			else {
				mod1[p]=ss1[i];
				mod1[p+1]=ss1[i+1];
				p++;
			}
			i++;	
		}
		else
			mod1[p]=ss1[i];
		p++;
	}
	mod1[p]=ss1[strlen(ss1)-1];
	mod1[p+1]='\0';
	
	p=0;
	for(int i=0; i<strlen(ss2)-1; i++) {
		if(ss2[i]=='\\') {
			if(ss2[i+1]=='/') {
				mod2[p]=ss2[i+1];
			}
			else {
				mod2[p]=ss2[i];
				mod2[p+1]=ss2[i+1];
				p++;
			}
			i++;	
		}
		else
			mod2[p]=ss2[i];
		p++;
	}
	mod2[p]=ss2[strlen(ss2)-1];
	mod2[p+1]='\0';





	for(int i=0; i<strlen(mod1); i++) {
		if(mod1[i]=='\\') {
			i++;
			j++;
		}
	}
	for(int i=0; i<strlen(mod2); i++) {
		if(mod2[i]=='\\') {
			i++;
			k++;
		}
	}
	//printf("<mod1:%s||mod2:%s><j:%d k:%d>\n", mod1, mod2, j, k);
	if(strlen(mod1)-j!=strlen(mod2)-k) {printf("Error, string lengths do not match!\n");exit(1);}
	fprintf(yyout, "\t\tchar str1[]=\"%s\", str2[]=\"%s\"; for(int i=0; i<strlen(buffer); i++) {for(int j=0;j<%d;j++) {if(buffer[i]==str1[j]){buffer[i]=str2[j];}}}", mod1, mod2, (int)strlen(mod1)-j);	
	break;
	case ZPCMD:
	fprintf(yyout, "\t\tbuffer[0]='\\0';");
	break;
	
	
	}
}


char* rform(char *reg, char *ts) {
	int p=0;
	for(int i=0; i<strlen(reg); i++) {
		if(reg[i]=='\\') {
			ts[p]=reg[i];
			ts[p+1]=reg[i];
			p++;
		}
		else {
			ts[p]=reg[i];
		}
		p++;
	}
	ts[p]='\0';

	strcpy(reg, ts);

	p=0;
	for(int i=0; i<strlen(reg); i++) {
		if(reg[i]=='\\') {
			ts[p]=reg[i];
			ts[p+1]=reg[i+1];
			ts[p+2]=reg[i+2];
			p+=2;
			i+=2;
		}
		else if(reg[i]=='$') {
			ts[p]='\\';
			ts[p+1]='n';
			p++;
		}
		else {
			ts[p]=reg[i];
		}
		p++;
	}
	return ts;
}

void ssube(char *strp) {
	int sep1=-1, sep2=-1, p=0, j=0, k=0;
	char *ss1, *ss2, *mod1, *mod2;
	for(int i=0; i<strlen(strp)-1; i++) {
		if(strp[i]=='\\')
			i++;
		else if(strp[i]=='/')
			sep1=i;
	}
	for(int i=sep1; i<strlen(strp); i++) {
		if(strp[i]=='\\')
			i++;
		else if(strp[i]=='/')
			sep2=i;
	}
	//printf("!sep %d %d!",sep1, sep2);
	if(sep1==-1||sep2==-1) {printf("Error, couldn't parse s command strings !\n");exit(1);}
	
	ss1=malloc(4*sizeof(strp));
	ss2=malloc(4*sizeof(strp));
	strncpy(ss1, strp, sep1);
	ss1[sep1+1]='\0';
	strncpy(ss2, strp+sep1+1, sep2-sep1-1);
	ss2[sep2-sep1]='\0';
	//printf("<SS1:%s||SS2:%s>\n", ss1, ss2);
	mod1=malloc(4*sizeof(strp));
	mod2=malloc(4*sizeof(strp));
	
	for(int i=0; i<strlen(ss1)-1; i++) {
		if(ss1[i]=='\\') {
			if(ss1[i+1]=='/') {
				mod1[p]=ss1[i+1];
			}
			else {
				mod1[p]=ss1[i];
				mod1[p+1]=ss1[i+1];
				p++;
			}
			i++;	
		}
		else
			mod1[p]=ss1[i];
		p++;
	}
	mod1[p]=ss1[strlen(ss1)-1];
	mod1[p+1]='\0';
	
	
	p=0;
	for(int i=0; i<strlen(ss2)-1; i++) {
		if(ss2[i]=='\\') {
			if(ss2[i+1]=='/') {
				mod2[p]=ss2[i+1];
			}
			else {
				mod2[p]=ss2[i];
				mod2[p+1]=ss2[i+1];
				p++;
			}
			i++;	
		}
		else
			mod2[p]=ss2[i];
		p++;
	}
	mod2[p]=ss2[strlen(ss2)-1];
	mod2[p+1]='\0';
	
	if(sep2!=strlen(strp)) {
		fprintf(yyout, "{");
		if(strstr(strp+sep2, "g")) {
			fprintf(yyout, "int limit=strlen(buffer);");
		}
		else {
			fprintf(yyout, "int limit=1;");
		}
		if(strstr(strp+sep2, "p")) {
			fprintf(yyout, "int pr=1;");
		}
		else {
			fprintf(yyout, "int pr=0;");
		}
		if(strstr(strp+sep2, "i")||strstr(strp+sep2, "I")) {
			fprintf(yyout, "int cs=1;");
		}
		else {
			fprintf(yyout, "int cs=0;");
		}
		int tsm=-1;
		for(int i=sep2;i<strlen(strp);i++) {
			if(strp[i]>'0'&&strp[i]<='9') {
				sscanf(strp+i, "%d", &tsm);
				break;
			}
		}
		if(tsm!=-1) {
			fprintf(yyout, "int nth=%d;", tsm);
		}
		else {
			fprintf(yyout, "int nth=0;");
		}
	}
	else {
		fprintf(yyout, "{int limit=1, pr=0, ci=0,nth=0;\n");
	}
	

	rform(strdup(mod1), mod1);
	rform(strdup(mod2), mod2);
	//printf("<mod1:%s||mod2:%s>\n", mod1, mod2);
	
	fprintf(yyout, "char r1[]=\"%s\";char r2[]=\"%s\";\n",mod1,mod2);
	fprintf(yyout, "%s", s_ss);
	
	/*
	
	//flags of s:
	//g - apply replacement to all matches: limit=strlen(buffer);
	//p - if substitution is made print the pattern space :pr=1
	//i/I - case insensitive :cs=1
	//n - replace only nth match :nth=number and limit =n
	
	int p=0;
	char *buffc=malloc(sizeof(buffer));
	memset(buffc, '\0', sizeof(buffc)/sizeof(char));
	int ms=0;
	regex_t regex;
	size_t nmatch=9;
	regmatch_t pm[nmatch];
	int reti;
	if(cs==1) {
		reti = regcomp(&regex, r1, REG_ICASE);
	}
	else {
		reti = regcomp(&regex, r1, 0);
	}
	if(reti) {
		fprintf(stderr, "Could not compile regex\n");
		exit(1);
	}
	
	reti = regexec(&regex, buffer, nmatch, pm, 0);
	int r=0, ni=0;
	while(!reti&&ni<limit) {
		r=1;
		subf=1;
		for(int i=0; i<nmatch; i++) {
			if(pm[i].rm_so==-1) {
				ms=i-1;
				break;
			}
		}
		p=0;
		for(int i=0; i<strlen(r2); i++) {
			if(r2[i]=='\\'&&(r2[i+1]>'9'||r2[i+1]<'1')) {
				buffc[p]=r2[i];
				buffc[p+1]=r2[i+1];
				p+=2;
				i++;
			}
			else if(r2[i]=='\\'&&r2[i+1]<='9'&&r2[i+1]>'0') {
				int q=r2[i+1]-'0';
				sprintf(&buffc[p],"%*.*s", pm[q].rm_eo-pm[q].rm_so, pm[q].rm_eo-pm[q].rm_so, &buffer[pm[q].rm_so]);
				p+= pm[q].rm_eo-pm[q].rm_so;
				i++;
			
			}
			else if(r2[i]=='&') {
				int q=0;
				sprintf(&buffc[p],"%*.*s", pm[q].rm_eo-pm[q].rm_so, pm[q].rm_eo-pm[q].rm_so, &buffer[pm[q].rm_so]);
				p+= pm[q].rm_eo-pm[q].rm_so;
			
			}
			else {
				buffc[p]=r2[i];
				p++;
			}
				
		}
		buffc[p]='\0';
		char *bufd=strdup(buffer);
		if(nth==0||nth==(ni+1)) {
			sprintf(buffer,"%*.*s%s%s", pm[0].rm_so, pm[0].rm_so, bufd, buffc, &bufd[pm[0].rm_eo]);
		}
		ni++;
	reti = regexec(&regex, buffer+pm[0].rm_eo, nmatch, pm, REG_NOTBOL);
	}
	if(r==1&&pr==1) {
		printf("%s\n", buffer);
	}
	if (reti == REG_NOMATCH) {if(r==0){subf=0;}}
	else {
		regerror(reti, &regex, buffer, sizeof(buffer));
		fprintf(stderr, "Regex match failed: %s\n", buffer);
		exit(1);
	}
	regfree(&regex);
	
	
	}
	*/
	
	
	

}
