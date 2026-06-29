// Core primitive/operator mappings for the experimental direct stdlib
// translation. Do not map Lambdapi stdlib theorem names here.

// Prop.lp
builtin "Prop" ≔ Prop;
builtin "True" ≔ {|⊤|};
builtin "I" ≔ {|⊤ᵢ|};
builtin "False" ≔ {|⊥|};
builtin "@False_ind" ≔ {|⊥ₑ|};
builtin "imp" ≔ {|⇒|};
builtin "lp_fold_u21d2" ≔ {|fold_⇒|};
builtin "not" ≔ {|¬|};
builtin "and" ≔ {|∧|};
builtin "@conj" ≔ {|∧ᵢ|};
builtin "@proj1" ≔ {|∧ₑ₁|};
builtin "@proj2" ≔ {|∧ₑ₂|};
builtin "\/" ≔ {|∨|};
builtin "@or_introl" ≔ {|∨ᵢ₁|};
builtin "@or_intror" ≔ {|∨ᵢ₂|};
builtin "or_elim" ≔ {|∨ₑ|};
builtin "@ex_intro" ≔ {|∃ᵢ|};
builtin "ex_elim" ≔ {|∃ₑ|};
builtin "iff" ≔ {|⇔|};

// Set.lp
builtin "Type'" ≔ Set;
builtin "iota_type" ≔ {|ι|};
builtin "el" ≔ el;

// FOL.lp
builtin "@all" ≔ {|∀|};
builtin "ex_" ≔ {|∃|};

// HOL.lp
builtin "arr" ≔ {|⤳|};

// Impred.lp
builtin "o" ≔ o;

// Eq.lp
builtin "@eq" ≔ {|=|};
builtin "@eq_refl" ≔ eq_refl;
builtin "@ind_eq" ≔ ind_eq;
builtin "@neq" ≔ {|≠|};

// Bool.lp
builtin "bool" ≔ {|𝔹|};
builtin "bool_type" ≔ bool;
builtin "true" ≔ true;
builtin "false" ≔ false;
builtin "@bool_rect" ≔ {|ind_𝔹|};
builtin "istrue" ≔ istrue;
builtin "lp_negb" ≔ not;
builtin "lp_orb" ≔ or;
builtin "lp_andb" ≔ and;
builtin "lp_if" ≔ if;

// Nat.lp
builtin "nat" ≔ {|ℕ|};
builtin "O" ≔ _0;
builtin "S" ≔ {|+1|};
builtin "nat_ind" ≔ {|ind_ℕ|};
builtin "nat_type" ≔ nat;
builtin "lp_is0" ≔ is0;
builtin "Nat.pred" ≔ {|∸1|};
builtin "eqn" ≔ eqn;
builtin "lp_add" ≔ {|+|};
builtin "lp_sub" ≔ {|-|};
builtin "lp_mul" ≔ {|*|};
builtin "lp_leq" ≔ {|≤|};
builtin "lp_ltn" ≔ {|<|};
builtin "lp_geq" ≔ {|≥|};
builtin "lp_gtn" ≔ {|>|};
builtin "lp_maxn" ≔ max;
builtin "lp_minn" ≔ min;
builtin "lp_expn" ≔ {|^|};
builtin "lp_factn" ≔ !;

// Pos.lp
builtin "positive" ≔ {|ℙ|};
builtin "xI" ≔ I;
builtin "xO" ≔ O;
builtin "xH" ≔ H;
builtin "positive_rect" ≔ {|ind_ℙ|};
builtin "pos_type" ≔ pos;
builtin "lp_pos_isI" ≔ isI;
builtin "lp_pos_isO" ≔ isO;
builtin "lp_pos_isH" ≔ isH;
builtin "lp_pos_projO" ≔ projO;
builtin "lp_pos_projI" ≔ projI;
builtin "lp_pos_succ" ≔ succ;
builtin "lp_pos_val" ≔ val;
builtin "lp_pos_add" ≔ add;
builtin "lp_pos_add_carry" ≔ add_carry;
builtin "lp_pos_pred_double" ≔ pos_pred_double;
builtin "lp_pos_compare_acc" ≔ compare_acc;
builtin "lp_pos_compare" ≔ compare;
builtin "lp_pos_mul" ≔ mul;

// Z.lp
builtin "Z" ≔ {|ℤ|};
builtin "Z0" ≔ Z0;
builtin "Zpos" ≔ Zpos;
builtin "Zneg" ≔ Zneg;
builtin "Z_rect" ≔ {|ind_ℤ|};
builtin "int_type" ≔ int;
builtin "lp_z_isZ0" ≔ isZ0;
builtin "lp_z_isZpos" ≔ isZpos;
builtin "lp_z_isZneg" ≔ isZneg;
builtin "lp_z_opp" ≔ {|—|};
builtin "lp_z_double" ≔ double;
builtin "lp_z_succ_double" ≔ succ_double;
builtin "lp_z_pred_double" ≔ pred_double;
builtin "lp_z_pos_sub" ≔ sub;
builtin "lp_z_compare" ≔ {|≐|};

// Classic.lp
builtin "em" ≔ em;

// Comp.lp
builtin "comparison" ≔ Comp;
builtin "Eq" ≔ Eq;
builtin "Lt" ≔ Lt;
builtin "Gt" ≔ Gt;
builtin "@comparison_rect" ≔ ind_Comp;
builtin "comparison_type" ≔ comp;
builtin "lp_isEq" ≔ isEq;
builtin "lp_isLt" ≔ isLt;
builtin "lp_isGt" ≔ isGt;
builtin "lp_isLe" ≔ isLe;
builtin "lp_isGe" ≔ isGe;
builtin "lp_opp" ≔ opp;
builtin "case_Comp" ≔ case_Comp;

// Epsilon.lp
builtin "eps" ≔ {|ε|};
builtin "eps_spec" ≔ {|εᵢ|};

// Prod.lp
builtin "lp_prod_type" ≔ {|×|};
builtin "lp_pair" ≔ {|‚|};
builtin "lp_fst" ≔ {|₁|};
builtin "lp_snd" ≔ {|₂|};

// List.lp
builtin "list" ≔ {|𝕃|};
builtin "lp_nil" ≔ {|□|};
builtin "lp_cons" ≔ {|⸬|};
builtin "lp_list_rect" ≔ {|ind_𝕃|};
builtin "lp_list_type" ≔ list;
builtin "lp_is_nil" ≔ {|is□|};
builtin "lp_head" ≔ head;
builtin "lp_behead" ≔ behead;
builtin "lp_eql" ≔ eql;
builtin "lp_size" ≔ size;
builtin "lp_cat" ≔ {|++|};
builtin "lp_nseq" ≔ nseq;
builtin "lp_ncons" ≔ ncons;
builtin "lp_catrev" ≔ catrev;
builtin "lp_rev" ≔ rev;
builtin "lp_rcons" ≔ rcons;
builtin "lp_Arr" ≔ Arr;
builtin "lp_seqn_acc" ≔ seqn_acc;
builtin "lp_seqn" ≔ seqn;
builtin "lp_iota" ≔ iota;
builtin "lp_indexes" ≔ indexes;
builtin "lp_last" ≔ last;
builtin "lp_belast" ≔ belast;
builtin "lp_nth" ≔ nth;
builtin "lp_set_nth" ≔ set_nth;
builtin "lp_incr_nth" ≔ incr_nth;
builtin "lp_zip" ≔ zip;
builtin "lp_unzip1" ≔ unzip1;
builtin "lp_unzip2" ≔ unzip2;
builtin "lp_all2" ≔ all2;
builtin "lp_drop" ≔ drop;
builtin "lp_take" ≔ take;
builtin "lp_rot" ≔ rot;
builtin "lp_rotr" ≔ rotr;
builtin "lp_mem" ≔ {|∈|};
builtin "lp_index" ≔ index;
builtin "lp_has" ≔ has;
builtin "lp_list_all" ≔ all;
builtin "lp_find" ≔ find;
builtin "lp_count" ≔ count;
builtin "lp_count_mem" ≔ count_mem;
builtin "lp_is_constant" ≔ is_constant;
builtin "lp_uniq" ≔ uniq;
builtin "lp_subseq" ≔ subseq;
builtin "lp_subset" ≔ {|⊆|};
builtin "lp_is_prefix" ≔ is_prefix;
builtin "lp_is_suffix" ≔ is_suffix;
builtin "lp_is_infix" ≔ is_infix;
builtin "lp_infix_index" ≔ infix_index;
builtin "lp_perm_eq" ≔ perm_eq;
builtin "lp_filter" ≔ filter;
builtin "lp_rem_nth" ≔ rem_nth;
builtin "lp_undup" ≔ undup;
builtin "lp_undup_first" ≔ undup_first;
builtin "lp_map" ≔ map;
builtin "lp_nths" ≔ nths;
builtin "lp_sumn" ≔ sumn;
builtin "lp_prodn" ≔ prodn;

// Conj.lp
builtin "lp_conj" ≔ conj;

// Disj.lp
builtin "lp_disj" ≔ disj;
builtin "lp_preserves_contents" ≔ preserves_contents;
