package main

import "fmt"

//go:generate ragel -Z -G2 -o lex.go lex.rl
//go:generate go tool yacc thermostat.y

func main() {
	lex := newLexer([]byte(`target temperature 5 heat on
	target temperature 10
	`))
	e := yyParse(lex)
	fmt.Println(e)
}
