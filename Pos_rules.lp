require open Stdlib.Pos;

rule add $x      H      ↪ succ $x
with add H      $y      ↪ succ $y;

rule add_carry $x      H      ↪ add $x (O H)
with add_carry H      $y      ↪ add (O H) $y;