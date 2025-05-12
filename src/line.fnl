(local Vec (require :src.vec))
(local Line {}) (set Line.__index Line)

(fn Line.new [self a b ...]
  (let [(a b) (if ...
                  (values (Vec:new a b) (Vec:new ...))
                  (values a (+ a b)))
        line  (if (< a.x b.x) {: a : b} {:a b :b a})]
    (setmetatable line self)))

(fn Line.⊥ [self]
  (let [v (Vec:new  (- self.b.y self.a.y) 
                    (- self.a.x self.b.x))]
    (v:unit)))

(fn Line.draw [self scale]
  (love.graphics.line 
    (* self.a.x scale) (* self.a.y scale) 
    (* self.b.x scale) (* self.b.y scale)))

(fn Line.intersect? [self Ba Bb Bsize]
  (let [⊥       (self:⊥)
        Bb      (- Bb (Vec:new Bsize (⊥:polar) true))
        x1x2    (- self.a.x self.b.x)
        y1y2    (- self.a.y self.b.y)
        x1x3    (- self.a.x Ba.x)
        y1y3    (- self.a.y Ba.y)
        x3x4    (- Ba.x Bb.x)
        y3y4    (- Ba.y Bb.y)
        denom   (- (*  x1x2 y3y4) (*  y1y2 x3x4))
        t       (/ (- (* x1x3 y3y4) (* y1y3 x3x4)) denom)
        u       (/ (- (* x1x2 y1y3) (* y1y2 x1x3)) denom -1)
        tx      (+ self.a.x (* t (- self.b.x self.a.x)))
        ty      (+ self.a.y (* t (- self.b.y self.a.y)))
        ux      (+ Ba.x (* u (- Bb.x Ba.x)))
        uy      (+ Ba.y (* u (- Bb.y Ba.y)))]
    (when (and (<= 0 t) (<= t 1) (<= 0 u) (<= u 1)) ⊥)))

Line
