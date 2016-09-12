package main

import (
        "fmt"
        "strconv"
)

%%{ 
    machine thermostat;
    write data;
    access lex.;
    variable p lex.p;
    variable pe lex.pe;
}%%

type lexer struct {
    data []byte
    p, pe, cs int
    ts, te, act int
}

func newLexer(data []byte) *lexer {
    lex := &lexer{ 
        data: data,
        pe: len(data),
    }
    %% write init;
    return lex
}
/*
[0-9]+                  return NUMBER;
heat                    return TOKHEAT;
on|off                  return STATE;
target                  return TOKTARGET;
temperature             return TOKTEMPERATURE;
\n                     
[ \t]+                 
*/

func (lex *lexer) Lex(out *yySymType) int {
    eof := lex.pe
    tok := 0
    %%{ 
        main := |*
            digit+ => { out.temp, _ = strconv.Atoi(string(lex.data[lex.ts:lex.te])); tok = NUMBER; fbreak;};
            'heat' => { tok = TOKHEAT; fbreak;};
            'on' | 'off' => { out.isOn = (string(lex.data[lex.ts:lex.te]) == "on"); tok = STATE; fbreak;};
            'target' => { tok = TOKTARGET; fbreak;};
            'temperature' => { tok = TOKTEMPERATURE; fbreak; };
            space;
        *|;

         write exec;
    }%%

    return tok;
}

func (lex *lexer) Error(e string) {
    fmt.Println("error:", e)
}
