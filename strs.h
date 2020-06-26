/* main strings */
const char *s_header = "#include<stdio.h>\n#include<stdlib.h>\n#include<string.h>\n";
const char *s_macros = "#define BLEN 1024\n\n";
const char *s_mainS = "int main(int argc, char *argv[]) {\n\tFILE *fin = fopen(argv[1], \"r\");\n\tFILE *fout = fopen(argv[2], \"w\");\n\tchar buffer[BLEN], holdsp[BLEN];\n\tint n=1, read=1;\nholdsp[0]='\\0'\n";
const char *s_mainE = "\t\tprintf(\"%s\", buffer);\n\t\tn++;\n\t}\n\treturn 0;\n}\n";
const char *s_mloop = "\twhile(read==0||fgets(buffer, BLEN, fin)) {\nread=1;\n";

/* function strings */
const char *s_eqcmd = "\t\tprintf(\"%d\\n\", n);\n";
//acmd, bcmd, ccmd, dcmd
const char *s_cdcmd = "\t\tchar *tptr = strchr(buffer, '\\n');\nif(*tptr==buffer[strlen(buffer)-1]) {n++;continue;}\nelse { read=0; strcpy(buffer, (tptr+1));continue;}\n";
//FNCMD, gcmd,cgcmd, hcmd, chcmd, icmd
const char *s_lcmd = "\t\t";//TODO: add formatting
extern const char *s_ncmd="printf(\"%s\", buffer);if(!fgets(buffer, BLEN, fin)){return 0;} n++;\n";
extern const char *s_cncmd="char tmprsp[BLEN];if(!fgets(tmprsp, BLEN, fin)){return 0;} strcat(buffer, tmprsp);n++;\n";
