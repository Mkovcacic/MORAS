Set Implicit Arguments.
Require Import List.
Import ListNotations.
Require Import Lia.

(* Bit *)

Inductive B : Type :=
  | O : B
  | I : B.

Definition And (x y : B) : B :=
match x with
  | O => O
  | I => y
end.

Definition Or (x y : B) : B :=
match x with
  | O => y
  | I => I
end.

Definition Not (x : B) : B :=
match x with
  | O => I
  | I => O
end.

Definition Add (x y c : B) : B :=
match x, y with
  | O, O => c
  | I, I => c
  | _, _ => Not c
end.

Definition Rem (x y c : B) : B :=
match x, y with
  | O, O => O
  | I, I => I
  | _, _ => c
end.

(* List *)

Fixpoint AndL (x y : list B) : list B :=
match x, y with
| [], _ => []
| _, [] => []
| x :: xs, y :: ys => And x y :: AndL xs ys
end.

Fixpoint OrL (x y : list B) : list B :=
match x, y with
| [], _ => []
| _, [] => []
| x :: xs, y :: ys => Or x y :: OrL xs ys
end.

Fixpoint NotL (x : list B) : list B :=
match x with
  | [] => []
  | x :: xs => Not x :: NotL xs
end.

Fixpoint AddLr (x y : list B) (c : B) : list B :=
match x, y with
| [], _ => []
| _, [] => []
| x :: xs, y :: ys => Add x y c :: AddLr xs ys (Rem x y c)
end.

Definition AddL (x y : list B) : list B := rev (AddLr (rev x) (rev y) O).

Fixpoint IncLr (x : list B) (c : B) : list B :=
match x with
| [] => []
| x :: xs => Add x I c :: IncLr xs (Rem x I c)
end.

Definition IncL (x : list B) : list B := rev (IncLr (rev x) O).

(* ALU *)

Definition flag_zx (f : B) (x : list B) : list B :=
match f with
| I => repeat O (length x)
| O => x
end.

Definition flag_nx (f : B) (x : list B) : list B :=
match f with
| I => NotL x
| O => x
end.

Definition flag_f (f : B) (x y : list B) : list B :=
match f with
| I => AddL x y
| O => AndL x y
end.

Definition ALU (x y : list B) (zx nx zy ny f no : B) : list B := 
  flag_nx no (flag_f f (flag_nx nx (flag_zx zx x)) (flag_nx ny (flag_zx zy y))).

(* Teoremi *)

Lemma ALU_zero (x y : list B) :
  length x = length y -> ALU x y I O I O I O = repeat O (length x).
Proof. Abort.

Lemma ALU_minus_one (x y : list B) : 
  length x = length y -> ALU x y I I I O I O = repeat I (length x).
Proof. Abort.

Lemma ALU_x (x y : list B) : 
  length x = length y -> ALU x y O O I I O O = x.
Proof. Abort.

Lemma ALU_y (x y : list B) : 
  length x = length y -> ALU x y I I O O O O = y.
Proof. Abort.

Lemma ALU_Not_x (x y : list B) : 
  length x = length y -> ALU x y O O I I O I = NotL x.
Proof. Abort.

Lemma ALU_Not_y (x y : list B) : 
  length x = length y -> ALU x y I I O O O I = NotL y.
Proof. Abort.

Lemma ALU_Add (x y : list B) : 
  length x = length y -> ALU x y O O O O I O = AddL x y.
Proof. Abort.

Lemma ALU_And (x y : list B) : 
  length x = length y -> ALU x y O O O O O O = AndL x y.
Proof. Admitted.

Lemma ALU_Or (x y : list B) : 
  length x = length y -> ALU x y O I O I O I = OrL x y.
Proof. Admitted.

(* DZ *)
Lemma D1 : forall n : nat, NotL (repeat O n) = repeat I n.
Proof.
     intros n. induction n.
     - reflexivity.
     - simpl. f_equal. exact IHn.
Qed.

Lemma D2 : forall n : nat, rev (repeat I n) = repeat I n.
Proof.
     intros n. induction n.
     - reflexivity.
     - simpl. rewrite IHn. Search (_ :: _ = _). rewrite repeat_cons. reflexivity.
Qed.
Lemma D3 : forall n : nat, repeat I (S n) = I :: repeat I n.
Proof.
     intros n. induction n.
     - reflexivity.
     - simpl. f_equal.
Qed.
Lemma D4 : forall n : nat, AddLr (repeat I n) (repeat I n) I = repeat I n.
Proof.
    intros n. induction n.
    - reflexivity.
    - simpl. rewrite IHn. reflexivity.
Qed.

Lemma D5 : forall n : nat, NotL (repeat I n ++ [O]) = NotL (repeat I n) ++ [Not O].
Proof.
    intros n. induction n.
    - reflexivity.
    - simpl. rewrite IHn. reflexivity.
Qed.

Lemma D6 : forall n : nat, NotL (repeat I n) = repeat O n.
Proof.
    intros n. induction n.
    - reflexivity.
    - simpl. rewrite IHn. reflexivity.
Qed.

Lemma ALU_One (n : nat) (x y : list B) :
  length x = n /\ length y = n /\ n <> 0 -> ALU x y I I I I I I = repeat O (pred n) ++ [I].
Proof.
    intros [A [B C]]. unfold ALU. simpl. rewrite A, B. rewrite D1. unfold AddL.
    rewrite D2. destruct n.
    - contradiction.
    - rewrite D3. unfold AddLr. simpl. fold AddLr. rewrite D4.
      Search(rev (_ ++ _)). rewrite D2. rewrite D5. simpl.
      rewrite D6. reflexivity.
Qed.