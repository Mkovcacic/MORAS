Require Import Bool.
Set Implicit Arguments.

Notation "! x" := (negb x) (at level 20).
(*zad 1*)
(*a*)

Goal forall x y : bool,
  (x && !y) || (!x && !y) || (!x && y) = !(x && y).
Proof.
     intros x y. destruct x, y; try now simpl.
Qed.
(*b*)

Goal forall x y z : bool,
  !(!x && y && z) && !(x && y && !z) && (x && !y && z) = x && !y && z.
Proof.
   intros x y z. destruct x,y,z; simpl; reflexivity.
Qed.