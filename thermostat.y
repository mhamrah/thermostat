%{
package main

import (
    "fmt"
)
%}

%union {
   isOn bool
   temp int
}

%token <isOn> STATE
%token <temp> NUMBER
%token NUMBER TOKHEAT STATE TOKTARGET TOKTEMPERATURE

%%

commands: /* empty */
        | commands command;

command:
        heat_switch
        |
        target_set;

heat_switch:
        TOKHEAT STATE
        {
                fmt.Println("\tHeat turned on: ", $2);
        };

target_set:
        TOKTARGET TOKTEMPERATURE NUMBER
        {
                fmt.Println("\tTemperature set ", $3);
        };