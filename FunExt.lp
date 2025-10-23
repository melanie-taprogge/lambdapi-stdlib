require open Stdlib.Eq Stdlib.HOL;

symbol funExt [a b] (f g : τ (a ⤳ b)) : (Π x, π(f x = g x)) → π(f = g);

opaque symbol eta_exp [a] [b] (f : τ a → τ b) :  
    π (f = (λ y , f y))≔
begin
    assume a b f; 
    refine funExt f (λ y , f y) _;
    simplify; reflexivity
end;