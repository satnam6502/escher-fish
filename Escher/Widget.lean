import Escher.Svg
import ProofWidgets.Component.HtmlDisplay

/-!
# Pictures in the Lean infoview

Use `#html p` for a clean picture preview, or `pictureHtml p` inside a larger
ProofWidgets HTML layout.
-/

namespace Escher.Widget

open Lean ProofWidgets
open scoped ProofWidgets.Jsx

/-- A responsive preview. Fit out-of-box curves so the primitive fish and
translated pictures are visible in full. Geometry is rendered at size 800;
the SVG scales to the available infoview width. -/
meta def pictureHtml (p : Picture) : Html :=
  let data := Picture.toSvgData 800 p (fit := true);
  <figure style={json% { margin: 0 }}>
    <svg viewBox={toJson data.viewBox}
        xmlns="http://www.w3.org/2000/svg" role="img"
        {... #[ ("aria-label", toJson s!"Picture with {data.curveCount} Bézier curves") ]}
        style={json% { width: "100%", maxWidth: "560px", maxHeight: "60vh",
          display: "block", background: "white" }}>
      <path fill="none" stroke="black"
        strokeWidth={toJson data.strokeWidth} d={toJson data.pathData}/>
    </svg>
    <figcaption style={json% { fontSize: "0.85em", opacity: 0.7 }}>
      {.text s!"{data.curveCount} Bézier curves"}
    </figcaption>
  </figure>

meta instance : HtmlEval Picture where
  eval p := pure (pictureHtml p)

end Escher.Widget
