# sed2C
A lex-yacc program to convert Sed to C (Practice & educational purpose).  
__Note:__ The code is incomplete and works only for some cases.
## Instructions
compile using makefile:

    $make
    
This will create executable "app" which can be used to compile Sed-scripts to C.<br>
"app" takes two arguments, input sed file(file which is to be converted to C), and output filename.

Example:

    $./app input.sed output.c
    $gcc output.c
    $./a.out inputFile > outputFile
flag -n can be used to suppress output after each cycle. Example:<br>

    $./app tests/dict1.sed out.c
    $gcc output.c
    $./a.out tests/dict1.in -n
    >bob
    >mon
    >non
    >pop
    >sos
    >tot
    >wow
dict.in is a copy of "/usr/share/dict/words"<br>
output produced by sed:<br>

    $sed -n '/^\(.\)o\1$/p' /usr/share/dict/words
    >bob
    >mon
    >non
    >pop
    >sos
    >tot
    >wow
    
## Test Files
test.sh can be used to test all sed scripts in /tests/<br>
(updates filenames in tests/ should also be made in test.sh)<br>
/tests/ contains test files in following format:<br>
file.sed : sed file to be tested<br>
file.in : input file for sed<br>
file.out : expected output(output of sed)<br>
Testing(sample):<br>

    $./test.sh
    >Testing against tests/dict1.in
    >TEST OK!
    >Enter a to abort, anything else to continue:

test.sh converts file.sed to C, compiles it and executes it with file.in as input. Output is compared with expected file.out(sed output) using diff command.<br>
Test result will be printed for each sed file.<br>
(test-files will be removed automatically after tests)<br>

**Note:** See Documentation.md for details about implementation details and commands implemented.
