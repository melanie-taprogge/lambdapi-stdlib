// Z.lp operator overrides.
//
// Z reuses source names such as {|+|}, {|-|}, and {|*|}; the shared mapping
// file maps those names to Nat operators. These overrides are appended only
// when translating Z.dk.
builtin "lp_z_add" ≔ {|+|};
builtin "lp_z_sub" ≔ {|-|};
builtin "lp_z_mul" ≔ {|*|};
builtin "lp_z_leq" ≔ {|≤|};
builtin "lp_z_ltn" ≔ {|<|};
builtin "lp_z_geq" ≔ {|≥|};
builtin "lp_z_gtn" ≔ {|>|};
