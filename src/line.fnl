(local Vec (require :src.vec))
(local Line {}) (set Line.__index Line)

(fn Line.new [! a b ...]
  (let [(a b) (if ...
                  (values (Vec:new a b) (Vec:new ...))
                  (values a (+ a b)))
        line  (if (< a.x b.x) {: a : b} {:a b :b a})]
    (setmetatable line !)))

(fn Line.normal [!]
  (let [v (Vec:new (- !.b.y !.a.y) (- !.a.x !.b.x))] (v:unit)))

(fn Line.draw [! scale]
  (love.graphics.line 
    (* !.a.x scale) (* !.a.y scale) 
    (* !.b.x scale) (* !.b.y scale)))

(fn Line.intersect? [! Ba Bb Bsize]
  (let [normal  (!:normal)
        Bb      (- Bb (Vec:new Bsize (normal:polar) true))
        x1x2    (- !.a.x !.b.x)
        y1y2    (- !.a.y !.b.y)
        x1x3    (- !.a.x Ba.x)
        y1y3    (- !.a.y Ba.y)
        x3x4    (- Ba.x Bb.x)
        y3y4    (- Ba.y Bb.y)
        denom   (- (*  x1x2 y3y4) (*  y1y2 x3x4))
        t       (/ (- (* x1x3 y3y4) (* y1y3 x3x4)) denom)
        u       (/ (- (* x1x2 y1y3) (* y1y2 x1x3)) denom -1)
        tx      (+ !.a.x (* t (- !.b.x !.a.x)))
        ty      (+ !.a.y (* t (- !.b.y !.a.y)))
        ux      (+ Ba.x (* u (- Bb.x Ba.x)))
        uy      (+ Ba.y (* u (- Bb.y Ba.y)))]
    (when (and (<= 0 t) (<= t 1) (<= 0 u) (<= u 1)) normal)))

Line
