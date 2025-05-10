(local Point (require :src.point))
(local Line (require :src.line))
(local Ball {}) (set Ball.__index Ball)
(local ballin (/ 2.25 2))
(local ballcm (* ballin 2.54))
(local (crn mid) (values (* ballcm 2.25) (* ballcm 1.75)))
(local sizes {:UL crn :UR crn :ML mid :MR mid :DL crn :DR crn})
(local (m g mu) (values 200 986 0.04))
(local ztheta (* (/ 6 360) 2 math.pi))

(fn Ball.new [self x y pocket?]
  (let [pos (Point:new x y)
        vel (Point:new 0 0)
        radius (or (. sizes pocket?) ballcm)]
    (setmetatable {: radius : pos : vel : pocket?} self)))

(fn Ball.update [self dt intersect?] (when (not self.pocket?)
  (let [newpos  (+ self.pos (* self.vel dt))
        walls   (intersect? self.pos newpos self.radius)
        newvel  (+ self.vel.y (* (self:force ztheta) dt))]
    (if (= (length walls) 0) 
        (do (set self.pos newpos) 
            (set self.vel.y newvel))
        (set self.bounce (* (/ 1 (length walls))
          (accumulate [n (Line:new 0 0 0 0) _ c (ipairs walls)]
            (+ n c))))))))

(fn Ball.draw [self s]
  (local (angle1 angle2) (case self.pocket?
    :UL (values (* 0.0 math.pi) (* 0.5 math.pi))
    :UR (values (* 0.5 math.pi) (* 1.0 math.pi))
    :ML (values (* 1.5 math.pi) (* 2.5 math.pi))
    :MR (values (* 0.5 math.pi) (* 1.5 math.pi))
    :DL (values (* 1.5 math.pi) (* 2.0 math.pi))
    :DR (values (* 1.0 math.pi) (* 1.5 math.pi))
    _   (values (* 0.0 math.pi) (* 2.0 math.pi))))
  (love.graphics.arc :line (* s self.pos.x) (* s self.pos.y) 
    (* s self.radius) angle1 angle2)
  (when self.bounce 
    (love.graphics.setColor 1 0 0 1)
    (self.bounce:draw s)
    (love.graphics.setColor 1 1 1 1)))

(fn Ball.force [self theta]
  (let [gravity   (* m g)
        normal    (* -1 gravity (math.cos theta))
        net       (* gravity (math.sin theta))
        friction  (* normal mu)
        total     (+ net friction)]
    (/ total m)))

Ball
