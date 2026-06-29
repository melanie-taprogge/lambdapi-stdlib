require open Stdlib.Bool;

rule _     or true  ↪ true
with $b    or false ↪ $b;