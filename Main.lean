import Escher

open Picture in
def main (args : List String) : IO Unit := do
  let path := args.headD "squarelimit.svg"
  IO.FS.writeFile path (toSvg 800 (squarelimit 2))
  IO.println s!"Square Limit to depth 2 written to {path}"
