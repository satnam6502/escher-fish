# escher-fish

I love [Escher's fish](https://en.wikipedia.org/wiki/Sky_and_Water_I), and I especially love [Peter Henderson](https://www.linkedin.com/in/peter-henderson-98a48742/)'s rendering of Escher's fish, which has inspired much of the work I have done on algebraic specification of circuit layout, building on the original work on [Ruby](https://www.cs.ox.ac.uk/people/geraint.jones/ruby/) for circuit design and layout by [Mary Sheeran](https://www.cse.chalmers.se/~ms/) and [Geraint Jones](https://www.cs.ox.ac.uk/people/geraint.jones/).

Here we have Escher's *Square Limit*, drawn in Lean 4 using the algebra of pictures from the 2002 update of Peter
Henderson's 1982 paper [*Functional Geometry*](https://eprints.soton.ac.uk/id/eprint/257577/1/funcgeo2.pdf).

![Square Limit to depth 2](squarelimit.svg)

## Running

```
lake build
.lake/build/bin/escher            # writes squarelimit.svg
.lake/build/bin/escher out.svg    # or to a path of your choosing
```

## Reading the code alongside the paper

| Paper | Lean |
| --- | --- |
| §5, a picture as a function of vectors `a`, `b`, `c`; `blank`, `over`, `beside`, `above`, `rot`, `flip`, `rot45`; the utility functions `quartet` and `nonet` | [`Escher/Picture.lean`](Escher/Picture.lean) |
| Figure 4, the basic fish | [`Escher/Fish.lean`](Escher/Fish.lean) |
| §3, `fish2`, `fish3`, `t`, `u`, `side`, `corner`, `squarelimit` | [`Escher/SquareLimit.lean`](Escher/SquareLimit.lean) |
| §6, laws such as `rot(beside(p,q)) = above(rot(q),rot(p))`, proved for all pictures | [`Escher/Laws.lean`](Escher/Laws.lean) |
| Rendering the curves | [`Escher/Svg.lean`](Escher/Svg.lean) |

The paper's `side[n]` and `corner[n]` become functions of the depth `n`, and
`beside(m, n, p, q)` / `above(m, n, p, q)` are written `beside' m n p q` /
`above' m n p q`. Otherwise the equations read as they do in the paper:

```lean
def squarelimit (n : Nat) :=
  nonet (corner n) (side n) (rot (rot (rot (corner n))))
        (rot (side n)) u (rot (rot (rot (side n))))
        (rot (corner n)) (rot (rot (side n))) (rot (rot (corner n)))
```

Coordinates are exact rationals (`Rat`) rather than `Float`, so the laws can be
proved: floating-point addition is not even associative. Some laws hold only up to
the order in which curves are drawn; these are stated with `≈`, meaning the two
pictures draw the same curves in every locating box. For example:

```lean
theorem rot_beside : rot (beside p q) ≈ above (rot q) (rot p)
```

## Credits

The fish's Bézier control points are Einar Høst's transcription of Henderson's
fish, from [einarwh/escher-workshop](https://github.com/einarwh/escher-workshop)
(MIT licence).
