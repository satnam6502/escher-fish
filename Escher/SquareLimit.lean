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

def quartet (p q r s : Picture) := above (beside p q) (beside r s)

/-- `side[n] = quartet(side[n-1], side[n-1], rot(t), t)` -/
def side : Nat → Picture
  | 0     => blank
  | n + 1 => quartet (side n) (side n) (rot t) t

/-- `corner[n] = quartet(corner[n-1], side[n-1], rot(side[n-1]), u)` -/
def corner : Nat → Picture
  | 0     => blank
  | n + 1 => quartet (corner n) (side n) (rot (side n)) u

def nonet (p q r
           s t u
           v w x : Picture) :=
  above' 1 2 (beside' 1 2 p (beside q r))
             (above (beside' 1 2 s (beside t u))
                    (beside' 1 2 v (beside w x)))

def squarelimit (n : Nat) :=
  nonet (corner n) (side n) (rot (rot (rot (corner n))))
        (rot (side n)) u (rot (rot (rot (side n))))
        (rot (corner n)) (rot (rot (side n))) (rot (rot (corner n)))

end Picture
