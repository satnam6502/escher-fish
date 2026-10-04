import Escher.Fish
import Escher.SquareLimit
import Escher.Widget

/-!
# Picture previews

Place the cursor on a `#html` command to see its picture in the infoview.
Edit the expression to explore the picture combinators.
-/

open Picture

#html fish
#html rot45 fish

-- Try `beside` instead of `above`, or change the rotations.
def twoFish (p : Picture) : Picture := above p (rot (rot p))

#html twoFish fish
#html squarelimit 2
