import Escher.SquareLimit

/-!
# Laws

The rules of the algebra given in §6 of the paper, proved for all pictures.

Some rules hold only up to the order in which curves are drawn. For those we write
`p ≈ q`: in every locating box, `p` and `q` draw the same curves.
-/

namespace Picture

instance : HasEquiv Picture := ⟨fun p q => ∀ a b c, (p a b c).Perm (q a b c)⟩

/-! Vector arithmetic, componentwise, for `grind`. -/

attribute [grind ext] Vec.ext

section
variable (u v : Vec) (k : Rat) (n : Nat)
@[grind =] private theorem add_x : (u + v).x = u.x + v.x := rfl
@[grind =] private theorem add_y : (u + v).y = u.y + v.y := rfl
@[grind =] private theorem sub_x : (u - v).x = u.x - v.x := rfl
@[grind =] private theorem sub_y : (u - v).y = u.y - v.y := rfl
@[grind =] private theorem neg_x : (-v).x = -v.x := rfl
@[grind =] private theorem neg_y : (-v).y = -v.y := rfl
@[grind =] private theorem mul_x : (k * v).x = k * v.x := rfl
@[grind =] private theorem mul_y : (k * v).y = k * v.y := rfl
@[grind =] private theorem div_x : (v / n).x = v.x / n := rfl
@[grind =] private theorem div_y : (v / n).y = v.y / n := rfl
end

variable (p q : Picture)

theorem rot_rot_rot_rot : rot (rot (rot (rot p))) = p := by
  funext a b c
  simp only [rot]
  congr 1 <;> grind

theorem rot_above : rot (above p q) = beside (rot p) (rot q) := by
  funext a b c
  simp only [rot, above, beside]
  congr 1 <;> congr 1 <;> grind

theorem rot_beside : rot (beside p q) ≈ above (rot q) (rot p) := by
  intro a b c
  simp only [rot, above, beside]
  refine List.perm_append_comm.trans (List.Perm.of_eq ?_)
  congr 1 <;> congr 1 <;> grind

theorem flip_beside : flip (beside p q) ≈ beside (flip q) (flip p) := by
  intro a b c
  simp only [flip, beside]
  refine List.perm_append_comm.trans (List.Perm.of_eq ?_)
  congr 1 <;> congr 1 <;> grind

/-- Two `rot45`s halve a picture and move it out of its box, into the box above. -/
theorem above_blank_rot45_rot45 :
    above blank (rot45 (rot45 p)) = above (quartet blank blank (rot p) blank) blank := by
  funext a b c
  simp only [above, beside, blank, rot45, rot, quartet, List.nil_append, List.append_nil]
  congr 1 <;> grind

theorem beside'_one_one : beside' 1 1 p q = beside p q := by
  funext a b c
  simp only [beside', beside]
  congr 1 <;> congr 1 <;> grind

theorem above'_one_one : above' 1 1 p q = above p q := by
  funext a b c
  simp only [above', above]
  congr 1 <;> congr 1 <;> grind

end Picture
