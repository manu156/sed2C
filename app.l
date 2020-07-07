
%{
#include "y.tab.h"
void yyerror (char *s);
extern FILE *yyout;
int yylex();

%}

%%

"="	{return EQCMD;}	/* = -- print current line number		*/
"a\\\n".*	{char *s_acp= strdup(yytext+3); yylval.str=s_acp; return ACMD;}	/* a -- append text after current line 	*/
"a ".*	{char *s_acp2= strdup(yytext+2);yylval.str=s_acp2; return ACMD;}
"b"([a-zA-Z])+	{char *s_bc= strdup(yytext+1); yylval.name=s_bc; return BCMD;}	/* b -- branch to label				*/
"c\\\n".*	{char *s_cc= strdup(yytext+3); yylval.str=s_cc; return CCMD;}	/* c -- change current line 		*/
"c ".*	{char *s_cc2= strdup(yytext+2);yylval.str=s_cc2; return CCMD;}
"d"	{return DCMD;}	/* d -- delete all of pattern space		*/
"D"	{return CDCMD;}	/* D -- delete first line of pattern space	*/
"F"	{return FNCMD;} /* F -- Print the file name (current input file)(trailing \n). */
"g"	{return GCMD;}	/* g -- copy hold space to pattern space	*/
"G"	{return CGCMD;}	/* G -- append hold space to pattern space	*/
"h"	{return HCMD;}	/* h -- copy pattern space to hold space	*/
"H"	{return CHCMD;}	/* H -- append pattern space to hold space	*/
"i\\\n".*	{char *s_ic= strdup(yytext+3); yylval.str=s_ic; return ICMD;}	/* i -- insert text before current line 	*/
"i ".*	{char *s_ic2= strdup(yytext+2); yylval.str=s_ic2; return ICMD;}
"l"	{return LCMD;}	/* l -- print pattern space in escaped form	*/
"n"	{return NCMD;}	/* n -- get next line into pattern space	*/
"N"	{return CNCMD;}	/* N -- append next line to pattern space	*/
"p"	{return PCMD;}	/* p -- print pattern space to output		*/
"P"	{return CPCMD;}	/* P -- print first line of pattern space	*/
"q"	{return QCMD;}	/* q -- exit the stream editor			*/
"s"	{return SCMD;}	/* s -- regular-expression substitute		*/
"t"	{return TCMD;}	/* t -- branch on last substitute successful	*/
"T"	{return CTCMD;}	/* T -- branch on last substitute failed	*/
"w"	{return WCMD;}	/* w -- write pattern space to file		*/
"W"	{return CWCMD;}	/* W -- write first line of pattern space	*/
"x"	{return XCMD;}	/* x -- exhange pattern and hold spaces		*/
"y"	{return YCMD;}	/* y -- transliterate text			*/
"z"	{return ZPCMD;} /* z -- clear pattern space			*/

"!"	{return NEG;}

","	{return RSEP;}
"$"	{return EFL;}
"/"(\\.|[^/])*"/"	{char *cp2= strdup(yytext+1);cp2[strlen(cp2)-1]='\0'; yylval.reg=cp2; return regex;}
"~"[0-9]+	{yylval.mnum = atoi(yytext+1); return Mnumber;}
"+"[0-9]+	{yylval.snum = atoi(yytext+1); return Snumber;}
[0-9]+  {yylval.num = atoi(yytext); return number;}


":"([a-zA-Z])+	{char *s_sc1= strdup(yytext+1); yylval.name=s_sc1; return label;}

"{"	{return CROP;}
"}"	{return CRED;}
";"	;//{return SSEP;} //not portable
\n	;//{return NL;}
"#".*\n	;
[ \t]	;
.                      {ECHO; yyerror("unexpected character");}


%%

int yywrap (void) {return 1;}

