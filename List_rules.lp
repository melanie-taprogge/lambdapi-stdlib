require open Stdlib.List;

rule $m ++ □ ↪ $m;

rule size ($l ++ $m) ↪ size $l + size $m;

rule ($l ++ $m) ++ $n ↪ $l ++ ($m ++ $n);

rule last _ ($e ⸬ $l) ↪ last $e $l;

rule nth $x □ _ ↪ $x;

rule drop _ □ ↪ □;

rule take _ □ ↪ □;

