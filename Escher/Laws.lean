import Escher.SquareLimit

/-!
# Laws

The rules of the algebra given in §6 of the paper, checked when the library is built.
Pictures are compared by the curves they draw in a skewed locating box. The test
picture and box use only dyadic coordinates, so every `Float` operation is exact.
-/

namespace Picture

private def f : Picture := ofCurves [⟨⟨0.25, 0.25⟩, ⟨0.25, 0.75⟩, ⟨0.5, 0.75⟩, ⟨0.75, 0.5⟩⟩]
private def g : Picture := ofCurves [⟨⟨0.5, 0.125⟩, ⟨0.875, 0.25⟩, ⟨0.5, 0.5⟩, ⟨0.125, 0.625⟩⟩]

/-- Same curves, in any order. -/
private def same (p q : Picture) : Bool :=
  let draw (r : Picture) := r ⟨1, 2⟩ ⟨8, 2⟩ ⟨-2, 4⟩
  let (ps, qs) := (draw p, draw q)
  ps.length == qs.length && ps.all qs.contains

#guard same (rot (rot (rot (rot f)))) f
#guard same (rot (above f g)) (beside (rot f) (rot g))
#guard same (rot (beside f g)) (above (rot g) (rot f))
#guard same (flip (beside f g)) (beside (flip g) (flip f))
#guard !same (rot45 (rot45 f)) (rot f)
#guard same (above blank (rot45 (rot45 f)))
            (above (quartet blank blank (rot f) blank) blank)

#guard same (beside' 1 1 f g) (beside f g)
#guard same (above' 1 1 f g) (above f g)

end Picture
