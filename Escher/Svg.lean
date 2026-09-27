import Escher.Picture

/-!
# Rendering to SVG

The picture is drawn in a square of side `size`, surrounded by a margin because
the fish swim slightly outside their locating boxes. SVG's y axis points down,
so the y coordinate is flipped on output.
-/

namespace Picture

/-- `x` to two decimal places, without trailing zeros. -/
private def num (x : Rat) : String :=
  let n := ((if x < 0 then -x else x) * 100 + 1 / 2).floor.natAbs
  let sign := if x < 0 ∧ n > 0 then "-" else ""
  let fraction := (s!"{n / 10 % 10}{n % 10}".dropEndWhile '0').copy
  sign ++ toString (n / 100) ++ (if fraction.isEmpty then "" else "." ++ fraction)

#guard num 0 == "0"
#guard num 100 == "100"
#guard num 120 == "120"
#guard num 12.34 == "12.34"
#guard num 12.3 == "12.3"
#guard num 0.05 == "0.05"
#guard num (-7.5) == "-7.5"
#guard num (-0.001) == "0"
#guard num 0.005 == "0.01"
#guard num (-0.005) == "-0.01"

def toSvg (size : Rat) (p : Picture) : String :=
  let margin := size / 20
  let extent := size + 2 * margin
  let pt (v : Vec) := s!"{num v.x} {num (extent - v.y)}"
  let segment (z : Bezier) := s!"M{pt z.p₀}C{pt z.p₁} {pt z.p₂} {pt z.p₃}"
  let curves := p ⟨margin, margin⟩ ⟨size, 0⟩ ⟨0, size⟩
  s!"<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 {num extent} {num extent}\">
<rect width=\"100%\" height=\"100%\" fill=\"white\"/>
<path fill=\"none\" stroke=\"black\" stroke-width=\"{num (size / 800)}\" d=\"{String.join (curves.map segment)}\"/>
</svg>
"

end Picture
