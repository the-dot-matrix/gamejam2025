(local Point {}) (set Point.__index Point)

(fn Point.new [self a b polar?]
  (let [x (if polar? (* (math.cos b) a) a)
        y (if polar? (* (math.sin b) a) b)]
    (setmetatable {: x : y} self)))
(fn Point.polar [self] (math.atan2 self.y self.x))
(fn Point.# [self] (math.sqrt (+ (^ self.x 2) (^ self.y 2))))
(fn Point.unit [self] (/ self (self:#)))

(fn Point.sign [self]
  (let [sign #(case [$1]  (where [v] (< v 0)) -1
                          (where [v] (= v 0)) 0
                          (where [v] (> v 0)) 1)]
    (Point:new (sign self.x) (sign self.y))))

(fn arithmetic [f op a b]
  (let [msg (.. "can't (" op ") point by non-point/number")]
    (case [(type a) (getmetatable a) (type b) (getmetatable b)]
      [:number _ _ Point] (Point:new (f a b.x) (f a b.y))
      [_ Point :number _] (Point:new (f a.x b) (f a.y b))
      [_ Point _ Point]  (Point:new (f a.x b.x) (f a.y b.y))
      _ (error msg))))
(fn Point.__add [a b] (arithmetic #(+ $1 $2) :+ a b))
(fn Point.__sub [a b] (arithmetic #(- $1 $2) :- a b))
(fn Point.__mul [a b] (arithmetic #(* $1 $2) :* a b))
(fn Point.__div [a b] (arithmetic #(/ $1 $2) :/ a b))

Point
