require open Stdlib.Nat;

rule $x + _0 ↪ $x;

rule $x + $y +1 ↪ ($x + $y) +1;

rule ($x + $y) + $z ↪ $x + ($y + $z);

rule $x - _0 ↪ $x;

rule _ * _0 ↪ _0;

rule max $x _0 ↪ $x;

rule max $x $x ↪ $x;

rule min _ _0 ↪ _0;

rule min $x $x ↪ $x;

