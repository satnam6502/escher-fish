/-!
# An algebra of pictures

Section 5 of Henderson's *Functional Geometry* (2002): a picture is a function of
three vectors. `a` locates the bottom left-hand corner of the picture's locating box,
and `b` and `c` are its bottom and left-hand edges.
-/

/-- Coordinates are exact rationals, so the laws in `Escher.Laws` can be proved. -/
@[ext] structure Vec where
  x : Rat
  y : Rat

instance : Add Vec := ⟨fun u v => ⟨u.x + v.x, u.y + v.y⟩⟩
instance : Sub Vec := ⟨fun u v => ⟨u.x - v.x, u.y - v.y⟩⟩
instance : Neg Vec := ⟨fun v => ⟨-v.x, -v.y⟩⟩
instance : HMul Rat Vec Vec := ⟨fun k v => ⟨k * v.x, k * v.y⟩⟩
instance : HDiv Vec Nat Vec := ⟨fun v n => ⟨v.x / n, v.y / n⟩⟩

/-- A cubic Bézier curve, the only graphical object we need. -/
structure Bezier where
  (p₀ p₁ p₂ p₃ : Vec)

def Bezier.map (f : Vec → Vec) (z : Bezier) : Bezier :=
  ⟨f z.p₀, f z.p₁, f z.p₂, f z.p₃⟩

abbrev Picture := Vec → Vec → Vec → List Bezier

namespace Picture

/-- Draws curves given in unit-square coordinates within the locating box. -/
def ofCurves (curves : List Bezier) : Picture :=
  fun a b c => curves.map (·.map fun v => a + v.x * b + v.y * c)

def blank : Picture := fun _ _ _ => []

def over (p q : Picture) : Picture :=
  fun a b c => p a b c ++ q a b c

def beside (p q : Picture) : Picture :=
  fun a b c => p a (b / 2) c ++ q (a + b / 2) (b / 2) c

/-- `p` in the upper half, `q` in the lower half. The equation printed in §5 swaps
`p` and `q`; this follows the prose and the general `above(m, n, p, q)`. -/
def above (p q : Picture) : Picture :=
  fun a b c => p (a + c / 2) b (c / 2) ++ q a b (c / 2)

def rot (p : Picture) : Picture :=
  fun a b c => p (a + b) c (-b)

def flip (p : Picture) : Picture :=
  fun a b c => p (a + b) (-b) c

def rot45 (p : Picture) : Picture :=
  fun a b c => p (a + (b + c) / 2) ((b + c) / 2) ((c - b) / 2)

/-- `beside(m, n, p, q)`: `p` and `q` side by side in the ratio `m : n`. -/
def beside' (m n : Nat) (p q : Picture) : Picture :=
  fun a b c =>
    let k : Rat := m / (m + n)
    p a (k * b) c ++ q (a + k * b) ((1 - k) * b) c

/-- `above(m, n, p, q)`: `p` above `q` in the ratio `m : n`. -/
def above' (m n : Nat) (p q : Picture) : Picture :=
  fun a b c =>
    let k : Rat := m / (m + n)
    p (a + (1 - k) * c) b (k * c) ++ q a b ((1 - k) * c)

end Picture
