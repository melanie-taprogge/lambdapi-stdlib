Require Import Bool.
Require Import Eq.
Require Import FOL.
Require Import mappings.
Definition lp_Lt_u2260_Eq : @neq comparison_type Lt Eq := fun v3946 : Lt = Eq => @ind_eq comparison_type Lt Eq v3946 (fun v3947 : comparison_type => istrue (lp_isEq v3947)) I.
Definition lp_Gt_u2260_Eq : @neq comparison_type Gt Eq := fun v3948 : Gt = Eq => @ind_eq comparison_type Gt Eq v3948 (fun v3949 : comparison_type => istrue (lp_isEq v3949)) I.
Definition lp_Gt_u2260_Lt : @neq comparison_type Gt Lt := fun v3950 : Gt = Lt => @ind_eq comparison_type Gt Lt v3950 (fun v3951 : comparison_type => istrue (lp_isLt v3951)) I.
Definition opp_idem : forall v3953 : comparison_type, (lp_opp (lp_opp v3953)) = v3953 := @comparison_rect (fun v3954 : comparison => (lp_opp (lp_opp v3954)) = v3954) (@eq_refl comparison_type (lp_opp (lp_opp Eq))) (@eq_refl comparison_type (lp_opp (lp_opp Lt))) (@eq_refl comparison_type (lp_opp (lp_opp Gt))).
