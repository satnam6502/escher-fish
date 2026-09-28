import Escher.Picture

/-!
# Rendering to SVG

The picture is drawn in a square of side `size`, surrounded by a margin because
the fish swim slightly outside their locating boxes. SVG's y axis points down,
so the y coordinate is flipped on output.
-/

namespace Picture.Svg

/-- Round to two decimal places, without trailing zeros. -/
def num (x : Rat) : String :=
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

def point (extent : Rat) (v : Vec) : String :=
  s!"{num v.x} {num (extent - v.y)}"

def segment (extent : Rat) (z : Bezier) : String :=
  s!"M{point extent z.p₀}C{point extent z.p₁} {point extent z.p₂} {point extent z.p₃}"

def path (extent : Rat) (curves : List Bezier) : String :=
  String.join (curves.map (segment extent))

structure Data where
  viewBox : String
  pathData : String
  strokeWidth : String
  curveCount : Nat

/-- Include every control point, with padding, as well as the original viewport.
The convex hull property of Bézier curves makes this a conservative crop. -/
def fittedViewBox (extent padding : Rat) (curves : List Bezier) : String := Id.run do
  let mut lo : Vec := ⟨0, 0⟩
  let mut hi : Vec := ⟨extent, extent⟩
  for z in curves do
    for v in [z.p₀, z.p₁, z.p₂, z.p₃] do
      let y := extent - v.y
      lo := ⟨min lo.x (v.x - padding), min lo.y (y - padding)⟩
      hi := ⟨max hi.x (v.x + padding), max hi.y (y + padding)⟩
  return s!"{num lo.x} {num lo.y} {num (hi.x - lo.x)} {num (hi.y - lo.y)}"

end Picture.Svg

namespace Picture

/-- SVG data in the usual locating box. `fit` expands the viewport for pictures
whose curves extend outside the box; the default preserves the CLI framing. -/
def toSvgData (size : Rat) (p : Picture) (fit : Bool := false) : Svg.Data :=
  let margin := size / 20
  let extent := size + 2 * margin
  let curves := p ⟨margin, margin⟩ ⟨size, 0⟩ ⟨0, size⟩
  let viewBox := if fit then Svg.fittedViewBox extent margin curves
    else s!"0 0 {Svg.num extent} {Svg.num extent}"
  ⟨viewBox, Svg.path extent curves,
    Svg.num (size / 800), curves.length⟩

def toSvg (size : Rat) (p : Picture) : String :=
  let data := toSvgData size p
  s!"<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"{data.viewBox}\">
<rect width=\"100%\" height=\"100%\" fill=\"white\"/>
<path fill=\"none\" stroke=\"black\" stroke-width=\"{data.strokeWidth}\" d=\"{data.pathData}\"/>
</svg>
"

end Picture
