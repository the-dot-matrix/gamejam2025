(local Vec (require :src.vec))
(local Line (require :src.line))
(local Phys (require :src.phys))
(local Ball {}) (set Ball.__index Ball)
(local debug false)
(local ballin (/ 2.25 2))
(local ballcm (* ballin 2.54))
(local (crn mid) (values (* ballcm 2.25) (* ballcm 1.75)))
(local sizes {:UL crn :UR crn :ML mid :MR mid :DL crn :DR crn})

(fn Ball.new [! x y pocket?]
  (let [radius  (or (. sizes pocket?) ballcm)
        (p v a) (values (Vec:new x y) (Vec:new) (Vec:new))]
    (setmetatable {: radius : p : v : a : pocket?} !)))

(fn Ball.update [! dt walls?] (when (not !.pocket?)
  (let [tang (when !.norm (Line.normal (Line:new !.p !.norm)))]
    (set !.a (Phys.acc !.v dt !.norm tang))
    (set !.v (Phys.vel !.v !.a dt tang))
    (set !.p (Phys.pos !.p !.v dt))
    (set !.norm (Phys.avg 
      (walls? !.p (Phys.pos !.p !.v dt) !.radius))))))

(fn Ball.draw [! s]
  (local (angle1 angle2) (case !.pocket?
    :UL (values (* 0.0 math.pi) (* 0.5 math.pi))
    :UR (values (* 0.5 math.pi) (* 1.0 math.pi))
    :ML (values (* 1.5 math.pi) (* 2.5 math.pi))
    :MR (values (* 0.5 math.pi) (* 1.5 math.pi))
    :DL (values (* 1.5 math.pi) (* 2.0 math.pi))
    :DR (values (* 1.0 math.pi) (* 1.5 math.pi))
    _   (values (* 0.0 math.pi) (* 2.0 math.pi))))
  (love.graphics.arc :line (* s !.p.x) (* s !.p.y) 
    (* s !.radius) angle1 angle2)
  (when debug
    (love.graphics.setColor 1 0 0 1)
    (local v (Line:new !.p.x !.p.y
      (+ !.p.x !.v.x) (+ !.p.y !.v.y)))
    (v:draw s)
    (love.graphics.setColor 0 0 1 1)
    (when !.norm 
      (local n (Line:new !.p (* 2 !.radius !.norm)))
      (n:draw s))
    (love.graphics.setColor 1 1 1 1)))

Ball
