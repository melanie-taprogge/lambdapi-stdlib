require open Stdlib.Z;

rule $x      + Z0      ↪ $x;

rule Zneg $p ≐ Zneg $q ↪ compare $q $p;

