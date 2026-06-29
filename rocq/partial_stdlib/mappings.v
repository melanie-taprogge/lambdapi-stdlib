From Stdlib Require Export Classical_Prop.
From Stdlib Require Export ClassicalEpsilon.
From Stdlib Require Export Bool.Bool.
From Stdlib Require Export Arith.PeanoNat.
From Stdlib Require Export Arith.Compare_dec.
From Stdlib Require Export PArith.BinPos.
From Stdlib Require Export ZArith.BinInt.
From Stdlib Require Export Lists.List.

(* Core target encoding for the experimental direct stdlib translation.
   This file maps primitive Lambdapi stdlib symbols to native Rocq symbols.
   It deliberately does not reprove Lambdapi stdlib theorem statements. *)

(* Prop.lp *)
Definition imp (p q : Prop) : Prop := p -> q.

Definition lp_fold_u21d2 (p q : Prop) (pq : p -> q) (hp : p) : q :=
  pq hp.

Definition or_elim (A B P : Prop) (h : A \/ B)
    (ha : A -> P) (hb : B -> P) : P :=
  match h with
  | or_introl a => ha a
  | or_intror b => hb b
  end.

Definition ex_elim (A : Type) (P : A -> Prop) (h : exists x, P x)
    (Q : Prop) (k : forall x : A, P x -> Q) : Q :=
  match h with
  | ex_intro _ x px => k x px
  end.

(* Set.lp *)
Record Type' := { type :> Type; el : type }.

Definition iota_type : Type' := {| type := nat; el := O |}.
Canonical iota_type.

(* FOL.lp *)
Definition all (a : Type') (P : a -> Prop) : Prop := forall x : a, P x.
Definition ex_ (a : Type') (P : a -> Prop) : Prop := exists x : a, P x.

(* HOL.lp *)
Definition arr (a b : Type') : Type' :=
  {| type := a -> b; el := fun _ => el b |}.
Canonical arr.

(* Impred.lp *)
Definition o : Type' := {| type := Prop; el := True |}.
Canonical o.

(* Eq.lp *)
Lemma ind_eq :
  forall {a : Type'} {x y : a}, x = y -> forall p : a -> Prop, p y -> p x.
Proof.
  intros a x y e p py. rewrite e. exact py.
Qed.

Definition neq {a : Type'} (x y : a) : Prop := ~ x = y.

(* Bool.lp *)
Definition bool_type : Type' := {| type := bool; el := true |}.
Canonical bool_type.

Definition istrue : bool -> Prop := Is_true.
Definition lp_negb : bool -> bool := negb.
Definition lp_orb : bool -> bool -> bool := orb.
Definition lp_andb : bool -> bool -> bool := andb.

Definition lp_if (b : bool) (a : Type') (x y : a) : a :=
  if b then x else y.

(* Nat.lp *)
Definition nat_type : Type' := iota_type.
Canonical nat_type.

Definition lp_is0 (n : nat) : bool :=
  match n with
  | O => true
  | S _ => false
  end.

Definition eqn : nat -> nat -> bool := Nat.eqb.
Definition lp_add : nat -> nat -> nat := Nat.add.
Definition lp_sub : nat -> nat -> nat := Nat.sub.
Definition lp_mul : nat -> nat -> nat := Nat.mul.
Definition lp_leq : nat -> nat -> bool := Nat.leb.
Definition lp_ltn (n m : nat) : bool := Nat.leb (S n) m.
Definition lp_geq (n m : nat) : bool := Nat.leb m n.
Definition lp_gtn (n m : nat) : bool := Nat.leb (S m) n.
Definition lp_maxn : nat -> nat -> nat := Nat.max.
Definition lp_minn : nat -> nat -> nat := Nat.min.
Definition lp_expn : nat -> nat -> nat := Nat.pow.

Fixpoint lp_factn (n : nat) : nat :=
  match n with
  | O => S O
  | S p => Nat.mul (S p) (lp_factn p)
  end.

(* Pos.lp *)
Definition pos_type : Type' := {| type := positive; el := xH |}.
Canonical pos_type.

Definition lp_pos_isI (p : positive) : bool :=
  match p with
  | xI _ => true
  | _ => false
  end.

Definition lp_pos_isO (p : positive) : bool :=
  match p with
  | xO _ => true
  | _ => false
  end.

Definition lp_pos_isH (p : positive) : bool :=
  match p with
  | xH => true
  | _ => false
  end.

Definition lp_pos_projO (p : positive) : positive :=
  match p with
  | xO q => q
  | xI q => xI q
  | xH => xH
  end.

Definition lp_pos_projI (p : positive) : positive :=
  match p with
  | xI q => q
  | xO q => xO q
  | xH => xH
  end.

Definition lp_pos_succ : positive -> positive := Pos.succ.

Fixpoint lp_pos_val (p : positive) : nat :=
  match p with
  | xH => S O
  | xO q => lp_mul (S (S O)) (lp_pos_val q)
  | xI q => S (lp_mul (S (S O)) (lp_pos_val q))
  end.

Definition lp_pos_add : positive -> positive -> positive := Pos.add.
Definition lp_pos_add_carry : positive -> positive -> positive := Pos.add_carry.
Definition lp_pos_pred_double : positive -> positive := Pos.pred_double.

Definition lp_pos_compare_acc
    (p : positive) (c : comparison) (q : positive) : comparison :=
  Pos.compare_cont c p q.

Definition lp_pos_compare : positive -> positive -> comparison := Pos.compare.
Definition lp_pos_mul : positive -> positive -> positive := Pos.mul.

(* Z.lp *)
Definition int_type : Type' := {| type := Z; el := Z0 |}.
Canonical int_type.

Definition lp_z_isZ0 (z : Z) : bool :=
  match z with
  | Z0 => true
  | _ => false
  end.

Definition lp_z_isZpos (z : Z) : bool :=
  match z with
  | Zpos _ => true
  | _ => false
  end.

Definition lp_z_isZneg (z : Z) : bool :=
  match z with
  | Zneg _ => true
  | _ => false
  end.

Definition lp_z_opp : Z -> Z := Z.opp.
Definition lp_z_double : Z -> Z := Z.double.
Definition lp_z_succ_double : Z -> Z := Z.succ_double.
Definition lp_z_pred_double : Z -> Z := Z.pred_double.
Definition lp_z_pos_sub : positive -> positive -> Z := Z.pos_sub.
Definition lp_z_add : Z -> Z -> Z := Z.add.
Definition lp_z_sub (x y : Z) : Z := Z.add x (Z.opp y).
Definition lp_z_compare : Z -> Z -> comparison := Z.compare.
Definition lp_z_mul : Z -> Z -> Z := Z.mul.

Definition lp_z_leq (x y : Z) : Prop :=
  ~ istrue (match lp_z_compare x y with Gt => true | _ => false end).

Definition lp_z_ltn (x y : Z) : Prop :=
  istrue (match lp_z_compare x y with Lt => true | _ => false end).

Definition lp_z_geq (x y : Z) : Prop :=
  ~ lp_z_ltn x y.

Definition lp_z_gtn (x y : Z) : Prop :=
  ~ lp_z_leq x y.

(* Classic.lp *)
Definition em : forall p : Prop, p \/ ~ p := classic.

(* Comp.lp *)
Definition comparison_type : Type' := {| type := comparison; el := Eq |}.
Canonical comparison_type.

Definition lp_isEq (c : comparison) : bool :=
  match c with Eq => true | _ => false end.

Definition lp_isLt (c : comparison) : bool :=
  match c with Lt => true | _ => false end.

Definition lp_isGt (c : comparison) : bool :=
  match c with Gt => true | _ => false end.

Definition lp_isLe (c : comparison) : bool :=
  match c with Gt => false | _ => true end.

Definition lp_isGe (c : comparison) : bool :=
  match c with Lt => false | _ => true end.

Definition lp_opp (c : comparison) : comparison :=
  match c with
  | Eq => Eq
  | Lt => Gt
  | Gt => Lt
  end.

Definition case_Comp (A : Type') (c : comparison) (x y z : A) : A :=
  match c with
  | Eq => x
  | Lt => y
  | Gt => z
  end.

(* Epsilon.lp *)
Definition eps {A : Type'} (P : A -> Prop) : A :=
  epsilon (inhabits (el A)) P.

Lemma eps_spec {A : Type'} {P : A -> Prop} : (exists x, P x) -> P (eps P).
Proof.
  intro h. unfold eps. apply epsilon_spec. exact h.
Qed.

(* Prod.lp *)
Definition lp_prod_type (A B : Type') : Type' :=
  {| type := A * B; el := (el A, el B) |}.
Canonical lp_prod_type.

Definition lp_pair (A B : Type') (x : A) (y : B) : lp_prod_type A B :=
  (x, y).

Definition lp_fst (A B : Type') (p : lp_prod_type A B) : A := fst p.
Definition lp_snd (A B : Type') (p : lp_prod_type A B) : B := snd p.

(* List.lp *)
Definition lp_list_type (A : Type') : Type' :=
  {| type := list A; el := nil |}.
Canonical lp_list_type.

Definition lp_nil (A : Type') : list A := nil.
Definition lp_cons (A : Type') (x : A) (xs : list A) : list A :=
  cons x xs.

Definition lp_list_rect (A : Type') (P : list A -> Prop)
    (hnil : P nil)
    (hcons : forall x xs, P xs -> P (cons x xs))
    (xs : list A) : P xs :=
  @list_rect A P hnil hcons xs.

Definition lp_is_nil (A : Type') (xs : list A) : bool :=
  match xs with
  | nil => true
  | cons _ _ => false
  end.

Definition lp_head (A : Type') (default : A) (xs : list A) : A :=
  hd default xs.

Definition lp_behead (A : Type') (xs : list A) : list A :=
  tl xs.

Fixpoint lp_eql (A : Type') (beq : A -> A -> bool)
    (xs ys : list A) : bool :=
  match xs, ys with
  | nil, nil => true
  | cons _ _, nil => false
  | nil, cons _ _ => false
  | cons x xs', cons y ys' => andb (beq x y) (lp_eql A beq xs' ys')
  end.

Definition lp_size (A : Type') (xs : list A) : nat := length xs.
Definition lp_cat (A : Type') (xs ys : list A) : list A := app xs ys.
Definition lp_nseq (A : Type') (n : nat) (x : A) : list A := repeat x n.

Fixpoint lp_ncons (A : Type') (n : nat) (x : A) (xs : list A) : list A :=
  match n with
  | O => xs
  | S p => cons x (lp_ncons A p x xs)
  end.

Definition lp_catrev (A : Type') (xs acc : list A) : list A :=
  rev_append xs acc.

Definition lp_rev (A : Type') (xs : list A) : list A :=
  lp_catrev A xs (lp_nil A).

Definition lp_rcons (A : Type') (xs : list A) (x : A) : list A :=
  xs ++ cons x nil.

Fixpoint lp_Arr (n : nat) (A B : Type') : Type :=
  match n with
  | O => B
  | S p => A -> lp_Arr p A B
  end.

Fixpoint lp_seqn_acc (A : Type') (n : nat)
    : list A -> lp_Arr n A (lp_list_type A) :=
  match n as n0 return list A -> lp_Arr n0 A (lp_list_type A) with
  | O => fun acc => rev acc
  | S p => fun acc x => lp_seqn_acc A p (cons x acc)
  end.

Definition lp_seqn (A : Type') (n : nat) : lp_Arr n A (lp_list_type A) :=
  lp_seqn_acc A n nil.

Fixpoint lp_iota (n k : nat) : list nat :=
  match k with
  | O => nil
  | S p => cons n (lp_iota (S n) p)
  end.

Definition lp_indexes (A : Type') (xs : list A) : list nat :=
  lp_iota O (length xs).

Definition lp_last (A : Type') (default : A) (xs : list A) : A :=
  last xs default.

Definition lp_belast (A : Type') (default : A) (xs : list A) : list A :=
  removelast (cons default xs).

Definition lp_nth (A : Type') (default : A) (xs : list A) (n : nat) : A :=
  nth n xs default.

Fixpoint lp_set_nth (A : Type') (default : A) (xs : list A)
    (n : nat) (y : A) {struct n} : list A :=
  match xs, n with
  | nil, O => cons y nil
  | cons _ xs', O => cons y xs'
  | nil, S p => cons default (lp_set_nth A default nil p y)
  | cons x xs', S p => cons x (lp_set_nth A default xs' p y)
  end.

Fixpoint lp_incr_nth (xs : list nat) (n : nat) {struct n} : list nat :=
  match xs, n with
  | nil, O => cons (S O) nil
  | nil, S p => cons O (lp_incr_nth nil p)
  | cons x xs', O => cons (S x) xs'
  | cons x xs', S p => cons x (lp_incr_nth xs' p)
  end.

Fixpoint lp_zip (A B : Type') (xs : list A) (ys : list B)
    : list (lp_prod_type A B) :=
  match xs, ys with
  | cons x xs', cons y ys' => cons (lp_pair A B x y) (lp_zip A B xs' ys')
  | _, _ => nil
  end.

Definition lp_unzip1 (A B : Type') (xs : list (lp_prod_type A B)) : list A :=
  map (lp_fst A B) xs.

Definition lp_unzip2 (A B : Type') (xs : list (lp_prod_type A B)) : list B :=
  map (lp_snd A B) xs.

Fixpoint lp_all2 (A B : Type') (p : A -> B -> bool)
    (xs : list A) (ys : list B) : bool :=
  match xs, ys with
  | nil, nil => true
  | cons x xs', cons y ys' => andb (p x y) (lp_all2 A B p xs' ys')
  | _, _ => false
  end.

Definition lp_drop (A : Type') (n : nat) (xs : list A) : list A :=
  skipn n xs.

Definition lp_take (A : Type') (n : nat) (xs : list A) : list A :=
  firstn n xs.

Definition lp_rot (A : Type') (n : nat) (xs : list A) : list A :=
  skipn n xs ++ firstn n xs.

Definition lp_rotr (A : Type') (n : nat) (xs : list A) : list A :=
  lp_rot A (Nat.sub (length xs) n) xs.

Fixpoint lp_mem (A : Type') (beq : A -> A -> bool)
    (x : A) (xs : list A) : bool :=
  match xs with
  | nil => false
  | cons y ys => orb (beq x y) (lp_mem A beq x ys)
  end.

Fixpoint lp_index (A : Type') (beq : A -> A -> bool)
    (x : A) (xs : list A) : nat :=
  match xs with
  | nil => O
  | cons y ys => if beq x y then O else S (lp_index A beq x ys)
  end.

Fixpoint lp_has (A : Type') (p : A -> bool) (xs : list A) : bool :=
  match xs with
  | nil => false
  | cons x xs' => if p x then true else lp_has A p xs'
  end.

Fixpoint lp_list_all (A : Type') (p : A -> bool) (xs : list A) : bool :=
  match xs with
  | nil => true
  | cons x xs' => if p x then lp_list_all A p xs' else false
  end.

Fixpoint lp_find (A : Type') (p : A -> bool) (xs : list A) : nat :=
  match xs with
  | nil => O
  | cons x xs' => if p x then O else S (lp_find A p xs')
  end.

Fixpoint lp_count (A : Type') (p : A -> bool) (xs : list A) : nat :=
  match xs with
  | nil => O
  | cons x xs' => if p x then S (lp_count A p xs') else lp_count A p xs'
  end.

Definition lp_count_mem (A : Type') (beq : A -> A -> bool) (x : A)
    (xs : list A) : nat :=
  lp_count A (beq x) xs.

Definition lp_is_constant (A : Type') (beq : A -> A -> bool)
    (xs : list A) : bool :=
  match xs with
  | nil => true
  | cons x xs' => if lp_list_all A (beq x) xs' then true else false
  end.

Fixpoint lp_uniq (A : Type') (beq : A -> A -> bool) (xs : list A) : bool :=
  match xs with
  | nil => true
  | cons x xs' => if negb (lp_mem A beq x xs') then lp_uniq A beq xs' else false
  end.

Fixpoint lp_subseq (A : Type') (beq : A -> A -> bool)
    (xs ys : list A) : bool :=
  match xs, ys with
  | nil, nil => true
  | nil, cons _ _ => false
  | cons _ _, nil => false
  | cons x xs', cons y ys' => if beq x y then lp_subseq A beq xs' ys' else false
  end.

Fixpoint lp_subset (A : Type') (beq : A -> A -> bool)
    (xs ys : list A) : bool :=
  match xs with
  | nil => true
  | cons x xs' => andb (lp_mem A beq x ys) (lp_subset A beq xs' ys)
  end.

Fixpoint lp_is_prefix (A : Type') (beq : A -> A -> bool)
    (xs ys : list A) : bool :=
  match xs, ys with
  | nil, _ => true
  | cons _ _, nil => false
  | cons x xs', cons y ys' => if beq x y then lp_is_prefix A beq xs' ys' else false
  end.

Definition lp_is_suffix (A : Type') (beq : A -> A -> bool)
    (xs ys : list A) : bool :=
  lp_is_prefix A beq (rev xs) (rev ys).

Fixpoint lp_is_infix (A : Type') (beq : A -> A -> bool)
    (xs ys : list A) {struct ys} : bool :=
  match xs, ys with
  | nil, _ => true
  | cons _ _, nil => false
  | cons x xs', cons y ys' =>
      if beq x y then lp_is_prefix A beq xs' ys'
      else lp_is_infix A beq (cons x xs') ys'
  end.

Fixpoint lp_infix_index (A : Type') (beq : A -> A -> bool)
    (xs ys : list A) {struct ys} : nat :=
  match xs, ys with
  | nil, _ => O
  | cons _ _, nil => O
  | cons x xs', cons y ys' =>
      if beq x y then
        if lp_is_prefix A beq xs' ys' then O else S (length ys')
      else S (lp_infix_index A beq (cons x xs') ys')
  end.

Definition lp_perm_eq (A : Type') (beq : A -> A -> bool)
    (xs ys : list A) : bool :=
  lp_list_all A
    (fun x => eqn (lp_count_mem A beq x xs) (lp_count_mem A beq x ys))
    (xs ++ ys).

Definition lp_filter (A : Type') (p : A -> bool) (xs : list A) : list A :=
  filter p xs.

Fixpoint lp_rem_nth (A : Type') (xs : list A) (n : nat) {struct n} : list A :=
  match xs, n with
  | nil, _ => nil
  | cons _ xs', O => xs'
  | cons x xs', S p => cons x (lp_rem_nth A xs' p)
  end.

Fixpoint lp_undup (A : Type') (beq : A -> A -> bool) (xs : list A) : list A :=
  match xs with
  | nil => nil
  | cons x xs' =>
      let ys := lp_undup A beq xs' in
      if lp_mem A beq x ys then ys else cons x ys
  end.

Fixpoint lp_undup_first (A : Type') (beq : A -> A -> bool)
    (xs : list A) : list A :=
  match xs with
  | nil => nil
  | cons x xs' =>
      cons x (filter (fun y => negb (beq x y)) (lp_undup_first A beq xs'))
  end.

Definition lp_map (A B : Type') (f : A -> B) (xs : list A) : list B :=
  map f xs.

Definition lp_nths (A : Type') (default : A) (xs : list A)
    (ns : list nat) : list A :=
  map (fun n => nth n xs default) ns.

Fixpoint lp_sumn (xs : list nat) : nat :=
  match xs with
  | nil => O
  | cons x xs' => Nat.add x (lp_sumn xs')
  end.

Fixpoint lp_prodn (xs : list nat) : nat :=
  match xs with
  | nil => S O
  | cons x xs' => Nat.mul x (lp_prodn xs')
  end.

(* Conj.lp *)
Fixpoint lp_conj (xs : list o) : o :=
  match xs with
  | nil => True
  | cons p nil => p
  | cons p ps => p /\ lp_conj ps
  end.

(* Disj.lp *)
Fixpoint lp_disj (xs : list o) : o :=
  match xs with
  | nil => False
  | cons p nil => p
  | cons p ps => p \/ lp_disj ps
  end.

Definition lp_preserves_contents (sigma : list nat) (xs : list o) : bool :=
  lp_subset nat_type eqn (lp_indexes o xs) sigma.
