(local Set {}) (set Set.__index Set)

(fn Set.new [self t]
  (let [s (setmetatable {} self)]
    (each [_ v (ipairs t)] (tset s v true))
    s))

(fn Set.# [a b]
  (accumulate [sum 0 _ k (pairs a)] (if k (+ sum 1) sum)))

(fn Set.__add [a b]
  (let [res (Set.new {})]
    (each [k (pairs a)] (tset res k true))
    (each [k (pairs b)] (tset res k true))
    res))

(fn Set.__mul [a b]
  (let [res (Set.new {})]
    (each [k (pairs a)] (tset res k (. b k)))
    res))

(fn Set.__le [a b]
  (each [k (pairs a)]
    (when (not (. b k)) (lua "return false")))
  true)

(fn Set.__lt [a b] (and (<= a b) (not (<= b a))))

(fn Set.__eq [a b] (and (<= a b) (<= b a)))

Set
