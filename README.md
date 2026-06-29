Standard library of [Lambdapi](https://github.com/Deducteam/lambdapi)
=====================================================================

- `Prop`: propositional logic
- `Eq`: equality
- `Set`: set codes for polymorphism
- `FOL`: typed first-order logic
- `Bool`: booleans
- `Nat`: natural numbers
- `List`: polymorphic lists
- `Classic`: classical logic

The libraries on natural numbers and polymorphic lists follow the
corresponding Coq SSReflect libraries:

- [ssrnat.v](https://github.com/math-comp/math-comp/blob/master/mathcomp/ssreflect/ssrnat.v)

- [seq.v](https://github.com/math-comp/math-comp/blob/master/mathcomp/ssreflect/seq.v)

Installation with Opam
----------------------

```
opam repository -a --set-default add lambdapi https://github.com/deducteam/opam-lambdapi-repos
itory.git # once
opam install lambdapi-stdlib
```

Usage in Lambdapi
-----------------

```
require open Stdlib.Prop Stdlib.Set Stdlib.FOL Stdlib.Nat /* ... */;
```

Compilation from the sources
----------------------------

```
opam install --deps-only . # once
make
```

Installation from the sources
-----------------------------

```
opam install .
```

Rocq translation
----------------

The directory `rocq/` contains the support files for exporting this
Rocq-compatible version of the standard library, and
`rocq/partial_stdlib/` contains the generated Rocq files that have been checked
successfully.

To regenerate and check the Rocq files automatically:

```
rocq/scripts/translate_stdlib_to_rocq.sh
```

By default, this writes generated files to `rocq/build/rocq`. The script
translates the configured standard-library modules via Dedukti, applies the
Rocq mappings from `rocq/`, and checks each generated `.v` file with `coqc`.
Files named `*_rules.lp` are ignored during this translation; they are optional
Lambdapi compatibility modules that restore rewrite rules removed from the
Rocq-compatible core.

To overwrite the checked generated files in `rocq/partial_stdlib`, pass that
directory explicitly:

```
rocq/scripts/translate_stdlib_to_rocq.sh . rocq/partial_stdlib
```

To check the committed generated Rocq files:

```
cd rocq/partial_stdlib
make
```
