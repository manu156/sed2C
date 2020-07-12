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
\[selector\]\[NEG\]\[command\]\[flags\]<br>
\[selector\] - Specifies address(es) of lines on which command should be executed<br>
\[command\] - one of any command<br>
\[flags\] - flags for command<br>

## Grammmar

## Commands Implemented
| Command  |  Function |
|----------|:------|
| = | print current line number |
| a | append text after current line |
| b | branch to label |
| c | change current line |
| d | delete all of pattern space |
| D | delete first line of pattern space |
| g | copy hold space to pattern space |
| G | append hold space to pattern space |
| h | copy pattern space to hold space |
| H | append hold space to pattern space |
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
| y | exhange pattern and hold spaces	|
| z | transliterate text |
