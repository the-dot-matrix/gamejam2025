(local Vec {}) (set Vec.__index Vec)

(fn Vec.new [self a b polar?]
  (let [(a b) (values (or a 0) (or b 0))
        x (if polar? (* (math.cos b) a) a)
        y (if polar? (* (math.sin b) a) b)]
    (setmetatable {: x : y} self)))
(fn Vec.polar [self] (math.atan2 self.y self.x))
(fn Vec.# [self] (math.sqrt (+ (^ self.x 2) (^ self.y 2))))
(fn Vec.unit [self] (/ self (self:#)))

(fn Vec.sign [self]
  (let [sign #(case [$1]  (where [v] (< v 0)) -1
                          (where [v] (= v 0)) 0
                          (where [v] (> v 0)) 1)]
    (Vec:new (sign self.x) (sign self.y))))

(fn arithmetic [f op a b]
  (let [msg (.. "can't (" op ") vector by non-vector/number")]
    (case [(type a) (getmetatable a) (type b) (getmetatable b)]
      [:number _ _ Vec] (Vec:new (f a b.x) (f a b.y))
      [_ Vec :number _] (Vec:new (f a.x b) (f a.y b))
      [_ Vec _ Vec]     (Vec:new (f a.x b.x) (f a.y b.y))
      [_ Vec :nil _]    a
      [:nil _ _ Vec]    b
      _ (error msg))))
(fn Vec.__add [a b] (arithmetic #(+ $1 $2) :+ a b))
(fn Vec.__sub [a b] (arithmetic #(- $1 $2) :- a b))
(fn Vec.__mul [a b] (arithmetic #(* $1 $2) :* a b))
(fn Vec.__div [a b] (arithmetic #(/ $1 $2) :/ a b))

Vec
