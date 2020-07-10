/* main strings */

const char *s_header = "#include<stdio.h>\n#include<stdlib.h>\n#include<string.h>\n#include<regex.h>\n";
const char *s_macros = "/*                      */\n#define BLEN 1024\n#ifndef FLL\n#define FLL 256\n#endif\n\n";
const char *s_mainS = "int main(int argc, char *argv[]) {\n\tFILE *fin = fopen(argv[1], \"r\");\n\tchar buffer[BLEN], holdsp[BLEN];\n\tint n=1, read=1, flags[FLL], subf=0;\n\tmemset(flags, 0, 1024);\n\tholdsp[0]='\\0';\n";
const char *s_mainE = "\t\tprintf(\"%s\", buffer);\n\t\tn++;\n\t}\n\treturn 0;\n}\n";
const char *s_mloop = "\n\twhile(read==0||fgets(buffer, BLEN, fin)) {\n\t\tread=1;\n";

/* function strings */
const char *s_eqcmd = "printf(\"%d\\n\", n);\n";
//acmd, bcmd, ccmd, dcmd
const char *s_cdcmd = "char *tptr = strchr(buffer, '\\n'); if(*tptr==buffer[strlen(buffer)-1]) {n++;continue;} else { read=0; strcpy(buffer, (tptr+1));continue;}\n";
//FNCMD, gcmd,cgcmd, hcmd, chcmd, icmd
const char *s_lcmd = "\t\t";//TODO: add formatting
const char *s_ncmd="printf(\"%s\", buffer);if(!fgets(buffer, BLEN, fin)){return 0;} n++;\n";
const char *s_cncmd="char tmprsp[BLEN];if(!fgets(tmprsp, BLEN, fin)){return 0;} strcat(buffer, tmprsp);n++;\n";
const char *s_regec1="\t\t\tregex_t regex;\n\t\t\tint reti;\n\t\t\treti = regcomp(&regex, regc, 0);\n\t\t\tif(reti) {\n\t\t\t\tfprintf(stderr, \"Could not compile regex\\n\");\n\t\t\t\texit(1);\n\t\t\t}\n\t\t\treti = regexec(&regex, buffer, 0, NULL, 0);\n\t\t\tif(!reti) {\n\t\t\t\treti = regcomp(&regex, regc2, 0);\n\t\t\t\tif(reti) {\n\t\t\t\t\tfprintf(stderr, \"Could not compile regex\\n\");\n\t\t\t\t\texit(1);\n\t\t\t\t}\n\t\t\t\treti = regexec(&regex, buffer, 0, NULL, 0);\n\t\t\t\tif(!reti)\n\t\t\t\t\tflags[lpn]=2;\n\t\t\t\telse if(reti == REG_NOMATCH)\n\t\t\t\t\tflags[lpn]=1;\n\t\t\t\telse {\n\t\t\t\t\tregerror(reti, &regex, buffer, sizeof(buffer));\n\t\t\t\t\tfprintf(stderr, \"Regex match failed: %s\\n\", buffer);\n\t\t\t\t\texit(1);\n\t\t\t\t}\n\t\t\t}\n\t\t\telse if (reti == REG_NOMATCH) {} \n\t\t\telse {\n\t\t\t\tregerror(reti, &regex, buffer, sizeof(buffer));\n\t\t\t\tfprintf(stderr, \"Regex match failed: %s\\n\", buffer);\n\t\t\t\texit(1);\n\t\t\t}\n\t\t\tregfree(&regex);\n";
const char *s_regec2="\t\t\tregex_t regex;\n\t\t\tint reti;\n\t\t\treti = regcomp(&regex, regc, 0);\n\t\t\tif(reti){\n\t\t\t\tfprintf(stderr, \"Could not compile regex\\n\");\n\t\t\t\texit(1);\n\t\t\t}\n\t\t\treti = regexec(&regex, buffer, 0, NULL, 0);\n\t\t\tif(!reti)\n\t\t\t\tflags[lpn]=2; \n\t\t\telse if(reti == REG_NOMATCH) {} \n\t\t\telse {\n\t\t\t\tregerror(reti, &regex, buffer, sizeof(buffer));\n\t\t\t\tfprintf(stderr, \"Regex match failed: %s\\n\", buffer);\n\t\t\t\texit(1);\n\t\t\t}\n\t\t\tregfree(&regex);\n";
const char *s_regec3="\t\t\tregex_t regex;\n\t\t\tint reti;\n\t\t\treti = regcomp(&regex, regc, 0);\n\t\t\tif(reti) {\n\t\t\t\tfprintf(stderr, \"Could not compile regex\\n\");\n\t\t\t\texit(1);\n\t\t\t}\n\t\t\treti = regexec(&regex, buffer, 0, NULL, 0);\n\t\t\tif(!reti) {flags[lpn]=1;} \n\t\t\telse if(reti == REG_NOMATCH) {} \n\t\t\telse {\n\t\t\t\tregerror(reti, &regex, buffer, sizeof(buffer));\n\t\t\t\tfprintf(stderr, \"Regex match failed: %s\\n\", buffer);\n\t\t\t\texit(1);\n\t\t\t}\n\t\t\tregfree(&regex);\n";
const char *s_regec4="\t\t\tregex_t regex;\n\t\t\tint reti;\n\t\t\treti = regcomp(&regex, regc, 0);\n\t\t\tif(reti){\n\t\t\t\tfprintf(stderr, \"Could not compile regex\\n\");\n\t\t\t\texit(1);\n\t\t\t}\n\t\t\treti = regexec(&regex, buffer, 0, NULL, 0);\n\t\t\tif(!reti)\n\t\t\t\tflags[lpn]=2; \n\t\t\telse if (reti == REG_NOMATCH) {} \n\t\t\telse {\n\t\t\t\tregerror(reti, &regex, buffer, sizeof(buffer));\n\t\t\t\tfprintf(stderr, \"Regex match failed: %s\\n\", buffer);\n\t\t\t\texit(1);\n\t\t\t}\n\t\t\tregfree(&regex);\n";
const char *s_regec5="\t\t\tregex_t regex;\n\t\t\tint reti;\n\t\t\treti = regcomp(&regex, regc, 0);\n\t\t\tif(reti) {\n\t\t\t\tfprintf(stderr, \"Could not compile regex\\n\");\n\t\t\t\texit(1);\n\t\t\t}\n\t\t\treti = regexec(&regex, buffer, 0, NULL, 0);\n\t\t\tif(!reti)\n\t\t\t\ttif=1;\n\t\t\telse if (reti == REG_NOMATCH) {}\n\t\t\telse {\n\t\t\t\tregerror(reti, &regex, buffer, sizeof(buffer));\n\t\t\t\tfprintf(stderr, \"Regex match failed: %s\\n\", buffer);\n\t\t\t\texit(1);\n\t\t\t}\n\t\t\tregfree(&regex);\n\t\t}\n";



/*
regex1, regex2
0 0 -0
1 0 -1
1 1 -2 exit here make -3

*/
