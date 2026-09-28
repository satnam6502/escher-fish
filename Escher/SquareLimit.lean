import Escher.Fish

/-!
# Square Limit

Section 3 of Henderson's *Functional Geometry*, equation by equation.
-/

namespace Picture

def fish2 := flip (rot45 fish)
def fish3 := rot (rot (rot fish2))

def t := over fish (over fish2 fish3)

def u := over (over fish2 (rot fish2))
              (over (rot (rot fish2)) (rot (rot (rot fish2))))

def side : Nat → Picture
  | 0     => blank
  | n + 1 => quartet (side n) (side n) (rot t) t

def corner : Nat → Picture
  | 0     => blank
  | n + 1 => quartet (corner n) (side n) (rot (side n)) u

def squarelimit (n : Nat) :=
  nonet (corner n) (side n) (rot (rot (rot (corner n))))
        (rot (side n)) u (rot (rot (rot (side n))))
        (rot (corner n)) (rot (rot (side n))) (rot (rot (corner n)))

end Picture
