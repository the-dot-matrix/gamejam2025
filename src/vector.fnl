(local Vector {}) (set Vector.__index Vector)

(fn Vector.new [self a b polar?]
  (let [x (if polar? (* (math.cos b) a) a)
        y (if polar? (* (math.sin b) a) b)]
    (setmetatable {: x : y} self)))
(fn Vector.polar [self] (math.atan2 self.y self.x))

(fn Vector.mag [self] 
  (math.sqrt (+ (^ self.x 2) (^ self.y 2))))

(fn Vector.arithmetic [f op a b]
  (let [msg (.. "can't (" op ") vector by non-vector/scalar")]
    (case [(type a) (getmetatable a) (type b) (getmetatable b)]
      [:number _ _ Vector] (Vector:new (f a b.x) (f a b.y))
      [_ Vector :number _] (Vector:new (f a.x b) (f a.y b))
      [_ Vector _ Vector]  (Vector:new (f a.x b.x) (f a.y b.y))
      _ (error msg))))
(fn Vector.__add [a b] (Vector.arithmetic #(+ $1 $2) :+ a b))
(fn Vector.__sub [a b] (Vector.arithmetic #(- $1 $2) :- a b))
(fn Vector.__mul [a b] (Vector.arithmetic #(* $1 $2) :* a b))
(fn Vector.__div [a b] (Vector.arithmetic #(/ $1 $2) :/ a b))

Vector
