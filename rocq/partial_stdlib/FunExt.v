Require Import Eq.
Require Import HOL.
Require Import mappings.
Axiom funExt : forall v1396 : Type', forall v1397 : Type', forall v1398 : v1396 -> v1397, forall v1399 : v1396 -> v1397, (forall v1401 : v1396, (v1398 v1401) = (v1399 v1401)) -> v1398 = v1399.
