(local Vec (require :src.vec))
(local Line (require :src.line))
(local Phys (require :src.balahtzee.phys))
(local Ball {}) (set Ball.__index Ball)

(fn Ball.new [! x y pocket?]
  (let [ballin  (/ 2.25 2)
        ballcm  (* ballin 2.54)
        (crn mid) (values (* ballcm 3.125) (* ballcm 2.375))
        sizes {:UL crn :UR crn :ML mid :MR mid :DL crn :DR crn}
        radius  (or (. sizes pocket?) ballcm)
        (p v a) (values (Vec:new x y) (Vec:new) (Vec:new))]
    (setmetatable {: radius : p : v : a : pocket?} !)))

(fn Ball.update [! dt tick? walls?] 
  (when (and tick? (not !.pocket?))
    (let [tan (when !.norm (Line.normal (Line:new !.p !.norm)))
          new #(Phys.pos !.p !.v dt)]
      (set !.a (Phys.acc !.v dt !.norm))
      (set !.v (Phys.vel !.v !.a dt tan))
      (set !.p (Phys.pos !.p !.v dt))
      (set !.norm (Vec.avg (walls? !.p (new) !.radius))))))

(fn Ball.draw [! s]
  (local (angle1 angle2) (case !.pocket?
    :UL (values (* 0.0 math.pi) (* 0.5 math.pi))
    :UR (values (* 0.5 math.pi) (* 1.0 math.pi))
    :ML (values (* 1.5 math.pi) (* 2.5 math.pi))
    :MR (values (* 0.5 math.pi) (* 1.5 math.pi))
    :DL (values (* 1.5 math.pi) (* 2.0 math.pi))
    :DR (values (* 1.0 math.pi) (* 1.5 math.pi))
    _   (values (* 0.0 math.pi) (* 2.0 math.pi))))
  (love.graphics.arc (or (and !.pocket? :fill) :line)
    (* s !.p.x) (* s !.p.y) (* s !.radius) angle1 angle2)
  (when _G.DEBUG
    (love.graphics.setColor 1 0 0 1)
    (local v (Line:new !.p (* 0.1 !.v)))
    (v:draw s)
    (love.graphics.setColor 0 0 1 1)
    (when !.norm 
      (local n (Line:new !.p (* 2 !.radius !.norm)))
      (n:draw s))
    (love.graphics.setColor 1 1 1 1)))

Ball
