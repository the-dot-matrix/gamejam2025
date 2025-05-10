(local Wall {}) (set Wall.__index Wall)
(local Vector (require "src.vector"))

(fn Wall.new [self x1 y1 x2 y2]
  (let [a (Vector:new x1 y1)
        b (Vector:new x2 y2)
        w (if (< a.x b.x) {: a : b} {:a b :b a})]
    (setmetatable w self)))

(fn Wall.update [self])

(fn Wall.draw [self scale]
  (love.graphics.line 
    (* self.a.x scale) (* self.a.y scale) 
    (* self.b.x scale) (* self.b.y scale)))

(fn Wall.intersect? [self Ba Bb Bsize]
  (let [normal    (Vector:new (- self.b.y self.a.y)
                            (- self.a.x self.b.x))
        normunit  (* (normal:unit) Bsize 4)
        Bouter    (* (Vector:new Bsize (normunit:polar) true))
        Ba        (- Ba Bouter)
        Bb        (+ Bb Bouter)
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
      (Wall:new tx ty (+ tx normunit.x) (+ ty normunit.y)))))

(fn arithmetic [f op a b]
  (let [msg (.. "can't (" op ") wall by non-wall/scalar")]
    (case [(type a) (getmetatable a) (type b) (getmetatable b)]
      [:number _ _ Wall] (Wall:new  
        (f a b.a.x) (f a b.a.y) 
        (f a b.b.x) (f a b.b.y))
      [_ Wall :number _] (Wall:new
        (f a b.a.x) (f a b.a.y) 
        (f a b.b.x) (f a b.b.y))
      [_ Wall _ Wall] (Wall:new 
        (f a.a.x b.a.x) (f a.a.y b.a.y)
        (f a.b.x b.b.x) (f a.b.y b.b.y))
      _ (error msg))))
(fn Wall.__add [a b] (arithmetic #(+ $1 $2) :+ a b))
(fn Wall.__sub [a b] (arithmetic #(- $1 $2) :- a b))
(fn Wall.__mul [a b] (arithmetic #(* $1 $2) :* a b))
(fn Wall.__div [a b] (arithmetic #(/ $1 $2) :/ a b))

Wall
