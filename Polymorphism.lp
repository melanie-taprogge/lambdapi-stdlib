// Prenex predicative polymorphism from Blanqui et al.,
// A modular construction of type theories, §§3.17–3.18 (arXiv:2111.00543).

require open Stdlib.Set Stdlib.Prop;

constant symbol Scheme : TYPE;

symbol τₛ : Scheme → TYPE;
constant symbol ↑ : Set → Scheme;
rule τₛ (↑ $a) ↪ τ $a;

constant symbol ∀ₛ : (Set → Scheme) → Scheme;
notation ∀ₛ quantifier;
rule τₛ (∀ₛ $s) ↪ Π a : Set, τₛ ($s a);

// A type-quantified proposition has a proof for every monotype.
constant symbol ∀ₚ : (Set → Prop) → Prop;
notation ∀ₚ quantifier;
rule π (∀ₚ $p) ↪ Π a : Set, π ($p a);
