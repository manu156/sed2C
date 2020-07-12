# Documentation
## About Sed
sed ("stream editor") is a Unix utility that parses and transforms text, using a simple, compact programming language.<br>
Several version/implementations of Sed exist.GNU Sed is widely used, Super-sed is an extended version of sed that includes regular expressions compatible with Perl.<br>
Another variant of sed is minised. minised was used by the GNU Project until the GNU Project wrote a new version of sed based on the new GNU regular expression library.<br>
The current minised contains some extensions to BSD sed but is not as feature-rich as GNU sed.<br><br>

GNU Sed, BSD Sed, MiniSed, Super Sed, all have different syntax, different extensions.<br>
GNU Sed is considered as base for this implementation. Features that are obsolete or non-portable are not implemented.<br><br>

## Structure of Sed-script
each sed-script line is of this format:<br>
> \[selector\]\[NEG\]\[command\]\[flags\]<br>

\[selector\] - Specifies address(es) of lines on which command should be executed<br>
\[command\] - one of any command<br>
\[flags\] - flags for command<br>

## Grammmar
Sed-script fits into the following grammar:<br>
\[file\] &rarr; \[lines\]<br>
where each line has a command with optional parameters except commands a, c, and i(these commands can span multiple lines)<br>
lines can be seperated by a newline or semicolon.<br>
\[lines\] &rarr; \[lines\] SEP \[line\] \| \[line\]<br>
\[line\] &rarr; \[selector\]\[NEG\]\[command\]\[flags\] \| \[label\]<br>
selector, NEG(!), flags are optional.<br>
Several commands can be combined using "\{" and "\}", with ";" seperating each line(commands)<br>
lines/commands can also be grouped using "\{" and "\}", with ";" seperating each line(commands)<br>
Also sed accepts "\{\}", ""(empty file), which creates ambiguous grammar.<br>
For example:<br>
Following sed commands are accepted by sed:<br>

    $sed ''
    $sed '{}'
    $sed '{p}'
    $sed '{{}}'
    $sed '{{p}}'
However, following commands are not accepted:<br>

    $sed '{p{}}'
    $sed '{{}p}'
    $sed '{{p}p}'
    $sed '{p{p}}'
These conflicts are because of optional end of command ";" and optional selector<br>
Also, several semicolons/newlines can be used to seperate commands/lines.<br>
Following sed commands are accepted by sed:<br>

    $sed ';'
    $sed '{;;};;;'
    $sed 'p;;;p'

This implementation includes above abnormal positives and to cover all posible parse trees with no ambiguity.<br>
We also added grammar rules (whenever possible, without ambiguity) to correct syntax error where two commands are not seperated by ; or newline but have atleast one space between them.<br>

## Commands Implemented
| Command  |  Function |
|----------|:------|
| = | print current line number |
| a | append text after current line |
| b | branch to label |
| c | change current line |
| d | delete all of pattern space |
| D | delete first line of pattern space |
| F | print the filename(current input filename) with trailing newline character |
| g | copy hold space to pattern space |
| G | append hold space to pattern space |
| h | copy pattern space to hold space |
| H | append pattern space to hold space |
| i | insert text before current line |
| l | print pattern space in escaped form |
| n | get next line into pattern space |
| N | append next line to pattern space |
| p | print pattern space to output |
| P | print first line of pattern space |
| q | exit the stream editor |
| s | regular-expression substitute	 |
| t | branch on last substitute successful |
| T | branch on last substitute failed |
| w | write pattern space to file |
| W | write first line of pattern space |
| x | exhange pattern and hold spaces |
| y | transliterate text |
| z | clear pattern space |
