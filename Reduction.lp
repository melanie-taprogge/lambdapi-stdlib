/* Reduction rules 
The rules given here all correspond to proved equalities in their corresponding file.
They were removed to increase the compatibility with native Rocq encodings. 
*/

// Rules for Nat.lp

require Stdlib.Nat as N;

rule $x N.+ N._0 ↪ $x;

rule $x N.+ $y N.+1 ↪ ($x N.+ $y) N.+1;

rule ($x N.+ $y) N.+ $z ↪ $x N.+ ($y N.+ $z);

rule $x N.- N._0 ↪ $x;

rule _ N.* N._0 ↪ N._0;

rule N.max $x N._0 ↪ $x;

rule N.max $x $x ↪ $x;

rule N.min _ N._0 ↪ N._0;

rule N.min $x $x ↪ $x;


// Rules for List.lp

require Stdlib.List as L;

rule $m L.++ L.□ ↪ $m;

rule L.size ($l L.++ $m) ↪ L.size $l N.+ L.size $m;

rule ($l L.++ $m) L.++ $n ↪ $l L.++ ($m L.++ $n);

rule L.last _ ($e L.⸬ $l) ↪ L.last $e $l;

rule L.nth $x L.□ _ ↪ $x;

rule L.drop _ L.□ ↪ L.□;

rule L.take _ L.□ ↪ L.□;


// Rules for Z.lp

require Stdlib.Z as Z;

rule $x Z.+ Z.0 ↪ $x;

