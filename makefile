app: lex.yy.c y.tab.c
	gcc -g lex.yy.c y.tab.c -o app

lex.yy.c: y.tab.c app.l
	lex app.l

y.tab.c: app.y strs.h
	yacc -d app.y

clean: 
	rm -rf lex.yy.c y.tab.c y.tab.h app app.dSYM
