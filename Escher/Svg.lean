import Escher.Picture

/-!
# Rendering to SVG

The picture is drawn in a square of side `size`, surrounded by a margin because
the fish swim slightly outside their locating boxes. SVG's y axis points down,
so the y coordinate is flipped on output.
-/

namespace Picture

private def num (x : Float) : String :=
  let s := toString ((x * 100).round / 100)
  ((s.dropEndWhile '0').dropEndWhile '.').copy

def toSvg (size : Float) (p : Picture) : String :=
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
