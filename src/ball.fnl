(local Vec (require :src.vec))
(local Line (require :src.line))
(local Ball {}) (set Ball.__index Ball)
(local debug false)
(local ballin (/ 2.25 2))
(local ballcm (* ballin 2.54))
(local (crn mid) (values (* ballcm 2.25) (* ballcm 1.75)))
(local sizes {:UL crn :UR crn :ML mid :MR mid :DL crn :DR crn})
(local (m g mu) (values 200 986 0.04))
(local ztheta (* (/ 6 360) 2 math.pi))

(fn Ball.new [self x y pocket?]
  (let [radius    (or (. sizes pocket?) ballcm)
        (pos vel) (values (Vec:new x y) (Vec:new 0 0))]
    (setmetatable {: radius : pos : vel : pocket?} self)))

(fn Ball.update [self dt intersect?] (when (not self.pocket?)
  (let [newp  (+ self.pos (* self.vel dt))
        walls (intersect? self.pos newp self.radius)
        fz    (Ball:accel ztheta)
        n     (when self.push? (self.push?:para))
        r     (when self.push? (self.push?:perp))
        accel (if n (Vec:new (self:accel (n:polar) (* -1 fz)))
                    (Vec:new 0 fz))
        mag   (* -1 (self.vel:#))]
    (when self.push? (if (= (r:polar) 0)
      (set self.vel (Vec:new 0 0))
      (set self.vel (Vec:new mag (r:polar) true))))
    (set self.vel (+ self.vel (* accel dt)))
    (if (= (length walls) 0) 
      (set (self.pos self.push?) (values newp nil))
      (set self.push? (* (/ 1 (length walls))
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
  (when debug
    (love.graphics.setColor 1 0 0 1)
    (local vel (Line:new self.pos.x self.pos.y
      (+ self.pos.x self.vel.x) (+ self.pos.y self.vel.y)))
    (vel:draw s)
    (love.graphics.setColor 0 0 1 1)
    (when self.push? (self.push?:draw s))
    (love.graphics.setColor 1 1 1 1)))

(fn Ball.accel [self theta gravity?]
  (let [gravity   (* m (or gravity? g))
        net       (* gravity (math.sin theta))
        normal    (* gravity (math.cos theta))
        friction  (* normal mu)]
    (values (/ (- net friction) m) (/ net m 1))))

Ball
