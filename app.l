%{
#include "y.tab.h"
void yyerror (char *s);
int yylex();

%}

%%

"="	{return EQCMD;}	/* = -- print current line number		*/
"a\\\n".*	{yylval.str=(yytext+3); return ACMD;}	/* a -- append text after current line 	*/
"a ".*	{yylval.str=(yytext+2); return ACMD;}
"b"([a-zA-Z])+	{yylval.name=(yytext+1); return BCMD;}	/* b -- branch to label				*/
"c\\\n".*	{yylval.str=(yytext+3); return CCMD;}	/* c -- change current line 		*/
"c ".*	{yylval.str=(yytext+2); return CCMD;}
"d"	{return DCMD;}	/* d -- delete all of pattern space		*/
"D"	{return CDCMD;}	/* D -- delete first line of pattern space	*/
"F"	{return FNCMD;} /* F -- Print the file name (current input file)(trailing \n). */
"g"	{return GCMD;}	/* g -- copy hold space to pattern space	*/
"G"	{return CGCMD;}	/* G -- append hold space to pattern space	*/
"h"	{return HCMD;}	/* h -- copy pattern space to hold space	*/
"H"	{return CHCMD;}	/* H -- append pattern space to hold space	*/
"i\\\n".*	{yylval.str=(yytext+3); return ICMD;}	/* i -- insert text before current line 	*/
"i ".*	{yylval.str=(yytext+2); return ICMD;}
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
"/"(\\.|[^/])*"/"	{yylval.reg=(yytext); return regex;}
"~"[0-9]+	{yylval.mnum = atoi(yytext); return Mnumber;}
"+"[0-9]+	{yylval.snum = atoi(yytext); return Snumber;}
[0-9]+  {yylval.num = atoi(yytext); return number;}


":"([a-zA-Z])+	{yylval.name=(yytext+1); return label;}

"{"	{return CROP;}
"}"	{return CRED;}
";"	{return SSEP;} //not portable

"#".*\n	;
[ \t\n]	;
.                      {ECHO; yyerror("unexpected character");}


%%

int yywrap (void) {return 1;}
