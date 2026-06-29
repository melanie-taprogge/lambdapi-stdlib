/* Reduction rules 
The rules given here all correspond to proved equalities in their corresponding file.
They were removed to increase the compatibility with native Rocq encodings. 
*/

// Rules from Bool.lp

require Stdlib.Bool as B;
require Stdlib.Nat as N;
require Stdlib.List as L;
require Stdlib.Pos as P;
require Stdlib.Z as Z;

rule _ B.or B.true  ↪ B.true
with $b B.or B.false ↪ $b;

// Rules for Nat.lp

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

rule $m L.++ L.□ ↪ $m;

rule L.size ($l L.++ $m) ↪ L.size $l N.+ L.size $m;

rule ($l L.++ $m) L.++ $n ↪ $l L.++ ($m L.++ $n);

rule L.last _ ($e L.⸬ $l) ↪ L.last $e $l;

rule L.nth $x L.□ _ ↪ $x;

rule L.drop _ L.□ ↪ L.□;

rule L.take _ L.□ ↪ L.□;


// Rules for Pos.lp

rule P.add $x P.H ↪ P.succ $x
with P.add P.H $y ↪ P.succ $y;

rule P.add_carry $x P.H ↪ P.add $x (P.O P.H)
with P.add_carry P.H $y ↪ P.add (P.O P.H) $y;


// Rules for Z.lp

rule $x Z.+ Z.Z0 ↪ $x;
