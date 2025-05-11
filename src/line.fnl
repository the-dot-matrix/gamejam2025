(local Vec (require :src.vec))
(local Line {}) (set Line.__index Line)

(fn Line.new [self x1 y1 x2 y2]
  (let [(a b) (values (Vec:new x1 y1) (Vec:new x2 y2))
        line  (if (< a.x b.x) {: a : b} {:a b :b a})]
    (setmetatable line self)))
(fn Line.para [self]
  (Vec:new (- self.b.x self.a.x) (- self.b.y self.a.y)))
(fn Line.perp [self]
  (Vec:new (- self.b.y self.a.y) (- self.a.x self.b.x)))

(fn Line.draw [self scale]
  (love.graphics.line 
    (* self.a.x scale) (* self.a.y scale) 
    (* self.b.x scale) (* self.b.y scale)))

(fn Line.intersect? [self Ba Bb Bsize]
  (let [perp      (self:perp)
        normal    (* (perp:unit) Bsize 4)
        Bouter    (Vec:new Bsize (normal:polar) true)
        Bb        (- Bb Bouter)
        x1x2      (- self.a.x self.b.x)
        y1y2      (- self.a.y self.b.y)
        x1x3      (- self.a.x Ba.x)
        y1y3      (- self.a.y Ba.y)
        x3x4      (- Ba.x Bb.x)
        y3y4      (- Ba.y Bb.y)
        denom     (- (*  x1x2 y3y4) (*  y1y2 x3x4))
        t         (/ (- (* x1x3 y3y4) (* y1y3 x3x4)) denom)
        u         (/ (- (* x1x2 y1y3) (* y1y2 x1x3)) denom -1)
        tx        (+ self.a.x (* t (- self.b.x self.a.x)))
        ty        (+ self.a.y (* t (- self.b.y self.a.y)))
        ux        (+ Ba.x (* u (- Bb.x Ba.x)))
        uy        (+ Ba.y (* u (- Bb.y Ba.y)))]
    (when (and (<= 0 t) (<= t 1) (<= 0 u) (<= u 1))
      (Line:new tx ty (+ tx normal.x) (+ ty normal.y)))))

(fn arithmetic [f op a b]
  (let [msg (.. "can't (" op ") line by non-line/number")]
    (case [(type a) (getmetatable a) (type b) (getmetatable b)]
      [:number _ _ Line] (Line:new  
        (f a b.a.x) (f a b.a.y) 
        (f a b.b.x) (f a b.b.y))
      [_ Line :number _] (Line:new
        (f a.a.x b) (f a.a.y b) 
        (f a.b.x b) (f a.b.y b))
      [_ Line _ Line] (Line:new 
        (f a.a.x b.a.x) (f a.a.y b.a.y)
        (f a.b.x b.b.x) (f a.b.y b.b.y))
      _ (error msg))))
(fn Line.__add [a b] (arithmetic #(+ $1 $2) :+ a b))
(fn Line.__sub [a b] (arithmetic #(- $1 $2) :- a b))
(fn Line.__mul [a b] (arithmetic #(* $1 $2) :* a b))
(fn Line.__div [a b] (arithmetic #(/ $1 $2) :/ a b))

Line
