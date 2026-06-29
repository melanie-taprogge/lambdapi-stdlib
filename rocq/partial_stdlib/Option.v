Require Import mappings.
Axiom option : Type' -> Type'.
Axiom none : forall v24 : Type', option v24.
Axiom some : forall v25 : Type', v25 -> option v25.
