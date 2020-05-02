%{
#include "y.tab.h"
void yyerror (char *s);
int yylex();
%}

%%
"="	{return EQCMD;}	/* = -- print current line number		*/
"a"	{return ACMD;}	/* a -- append text after current line 	*/
"b"	{return BCMD;}	/* b -- branch to label				*/
"c"	{return CCMD;}	/* c -- change current line 		*/
"d"	{return DCMD;}	/* d -- delete all of pattern space		*/
"D"	{return CDCMD;}	/* D -- delete first line of pattern space	*/
"g"	{return GCMD;}	/* g -- copy hold space to pattern space	*/
"G"	{return CGCMD;}	/* G -- append hold space to pattern space	*/
"h"	{return HCMD;}	/* h -- copy pattern space to hold space	*/
"H"	{return CHCMD;}	/* H -- append hold space to pattern space	*/
"i"	{return ICMD;}	/* i -- insert text before current line 	*/
"l"	{return LCMD;}	/* l -- print pattern space in escaped form	*/
"L"	{return CLCMD;}   /* L -- hexdump					*/
"n"	{return NCMD;}	/* n -- get next line into pattern space	*/
"N"	{return CNCMD;}	/* N -- append next line to pattern space	*/
"p"	{return PCMD;}	/* p -- print pattern space to output		*/
"P"	{return CPCMD;}	/* P -- print first line of pattern space	*/
"q"	{return QCMD;}	/* q -- exit the stream editor			*/
"r"	{return RCMD;}	/* r -- read in a file after current line */
"s"	{return SCMD;}	/* s -- regular-expression substitute		*/
"t"	{return TCMD;}	/* t -- branch on last substitute successful	*/
"T"	{return CTCMD;}	/* T -- branch on last substitute failed	*/
"w"	{return WCMD;}	/* w -- write pattern space to file		*/
"W"	{return CWCMD;}	/* W -- write first line of pattern space	*/
"x"	{return XCMD;}	/* x -- exhange pattern and hold spaces		*/
"y"	{return YCMD;}	/* y -- transliterate text			*/

"!"	{return NEG;}
"*"	{return STAR;}	/* marker for Kleene star */

[0-9]+  {yylval.num = atoi(yytext); return number;}


[ \t\n]                ;
.                      {ECHO; yyerror ("unexpected character");}

%%

int yywrap (void) {return 1;}

