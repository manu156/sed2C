/* main strings */

// FIX STRING POINTERS / COPYING like yylval.snum = atoi(yytext); IN app.l
// VERIFY printf("%*s",siz, str); 

const char *s_header = "#include<stdio.h>\n#include<stdlib.h>\n#include<string.h>\n#include<regex.h>\n";
const char *s_macros = "/*                      */\n#define BLEN 1024\n#ifndef FLL\n#define FLL 256\n#endif\n\n";
const char *s_mainS = "int main(int argc, char *argv[]) {\n\tFILE *fin = fopen(argv[1], \"r\");\n\tchar buffer[BLEN], holdsp[BLEN];\n\tint n=1, read=1, flags[FLL];\nmemset(flags, 0, 1024);\nholdsp[0]='\\0';\n";
const char *s_mainE = "\t\tprintf(\"%s\", buffer);\n\t\tn++;\n\t}\n\treturn 0;\n}\n";
const char *s_mloop = "\twhile(read==0||fgets(buffer, BLEN, fin)) {\nread=1;\n";

/* function strings */
const char *s_eqcmd = "\t\tprintf(\"%d\\n\", n);\n";
//acmd, bcmd, ccmd, dcmd
const char *s_cdcmd = "\t\tchar *tptr = strchr(buffer, '\\n');\nif(*tptr==buffer[strlen(buffer)-1]) {n++;continue;}\nelse { read=0; strcpy(buffer, (tptr+1));continue;}\n";
//FNCMD, gcmd,cgcmd, hcmd, chcmd, icmd
const char *s_lcmd = "\t\t";//TODO: add formatting
const char *s_ncmd="printf(\"%s\", buffer);if(!fgets(buffer, BLEN, fin)){return 0;} n++;\n";
const char *s_cncmd="char tmprsp[BLEN];if(!fgets(tmprsp, BLEN, fin)){return 0;} strcat(buffer, tmprsp);n++;\n";
const char *s_regec1="regex_t regex;int reti;\nreti = regcomp(&regex, regc, 0);\nif(reti){fprintf(stderr, \"Could not compile regex\\n\");exit(1);}\nreti = regexec(&regex, buffer, 0, NULL, 0);\nif (!reti) {puts(\"Match\"); {reti = regcomp(&regex, regc2, 0);\nif(reti){fprintf(stderr, \"Could not compile regex\\n\");exit(1);}\nreti = regexec(&regex, buffer, 0, NULL, 0);} if(!reti){flags[lpn]=2;} else if(reti == REG_NOMATCH){flags[lpn]=1;} else{{regerror(reti, &regex, buffer, sizeof(buffer));\nfprintf(stderr, \"Regex match failed: %s\\n\", buffer); exit(1);}} } \nelse if (reti == REG_NOMATCH) {puts(\"No match\");} \nelse {regerror(reti, &regex, buffer, sizeof(buffer));\nfprintf(stderr, \"Regex match failed: %s\\n\", buffer); exit(1);}\nregfree(&regex);";
const char *s_regec2="regex_t regex;int reti;\nreti = regcomp(&regex, regc, 0);\nif(reti){fprintf(stderr, \"Could not compile regex\\n\");exit(1);}\nreti = regexec(&regex, buffer, 0, NULL, 0);\nif (!reti) {puts(\"Match\");{flags[lpn]=2;} } \nelse if (reti == REG_NOMATCH) {puts(\"No match\"); } \nelse {regerror(reti, &regex, buffer, sizeof(buffer));\nfprintf(stderr, \"Regex match failed: %s\\n\", buffer); exit(1);}\nregfree(&regex);";
const char *s_regec3="regex_t regex;int reti;\nreti = regcomp(&regex, regc, 0);\nif(reti){fprintf(stderr, \"Could not compile regex\\n\");exit(1);}\nreti = regexec(&regex, buffer, 0, NULL, 0);\nif (!reti) {puts(\"Match\");{flags[lpn]=1;} } \nelse if (reti == REG_NOMATCH) {puts(\"No match\"); } \nelse {regerror(reti, &regex, buffer, sizeof(buffer));\nfprintf(stderr, \"Regex match failed: %s\\n\", buffer); exit(1);}\nregfree(&regex);";
const char *s_regec4="regex_t regex;int reti;\nreti = regcomp(&regex, regc, 0);\nif(reti){fprintf(stderr, \"Could not compile regex\\n\");exit(1);}\nreti = regexec(&regex, buffer, 0, NULL, 0);\nif (!reti) {puts(\"Match\");{flags[lpn]=2;} } \nelse if (reti == REG_NOMATCH) {puts(\"No match\"); } \nelse {regerror(reti, &regex, buffer, sizeof(buffer));\nfprintf(stderr, \"Regex match failed: %s\\n\", buffer); exit(1);}\nregfree(&regex);";
const char *s_regec5="int tif=0; { regex_t regex;int reti;\nreti = regcomp(&regex, regc, 0);\nif(reti){fprintf(stderr, \"Could not compile regex\\n\");exit(1);}\nreti = regexec(&regex, buffer, 0, NULL, 0);\nif (!reti) {puts(\"Match\");{tif=1;} } \nelse if (reti == REG_NOMATCH) {puts(\"No match\"); } \nelse {regerror(reti, &regex, buffer, sizeof(buffer));\nfprintf(stderr, \"Regex match failed: %s\\n\", buffer); exit(1);}\nregfree(&regex);}";
