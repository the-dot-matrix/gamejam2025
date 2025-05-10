(local Ball {}) (set Ball.__index Ball)
(local Vector (require "src.vector"))
(local ballradiusin (/ 2.25 2))
(local ballradiuscm (* ballradiusin 2.54))
(local cornerpocket (* ballradiuscm 2.25))
(local middlepocket (* ballradiuscm 1.75))
(local sizes {:UL cornerpocket :UR cornerpocket
              :ML middlepocket :MR middlepocket 
              :DL cornerpocket :DR cornerpocket})
(local (m g mu theta) (values 200 986 0.04))
(local theta (* (/ 6 360) 2 math.pi))
(local fgrav (* m g))
(local fnorm (* -1 fgrav (math.cos theta)))
(local fnet (* fgrav (math.sin theta)))
(local ffric (* fnorm mu))
(local ftotal (+ fnet ffric))
(local a (/ ftotal m))
(fn Ball.new [self x y pocket?]
  (let [pos (Vector:new x y)
        vel (Vector:new 0 0)
        radius (or (. sizes pocket?) ballradiuscm)]
    (setmetatable {: radius : pos : vel : pocket?} self)))

(fn Ball.update [self dt intersect?]
  (let [newpos  (+ self.pos (* self.vel dt))
        outer   (* self.radius (self.vel:sign))
        walls   (intersect? self.pos newpos self.radius)]
    (when (not self.pocket?)
      (if (= (length walls) 0) 
        (do (set self.pos newpos) 
            (set self.vel.y (+ self.vel.y (* a dt 1))))
        (set self.pos (* (/ 1 (length walls))
          (accumulate [v (Vector:new 0 0) _ p (ipairs walls)]
            (+ v p))))))))

(fn Ball.draw [self s]
  (love.graphics.setColor 1 1 1 1)
  (local (angle1 angle2) (case self.pocket?
    :UL (values (* 0.0 math.pi) (* 0.5 math.pi))
    :UR (values (* 0.5 math.pi) (* 1.0 math.pi))
    :ML (values (* 1.5 math.pi) (* 2.5 math.pi))
    :MR (values (* 0.5 math.pi) (* 1.5 math.pi))
    :DL (values (* 1.5 math.pi) (* 2.0 math.pi))
    :DR (values (* 1.0 math.pi) (* 1.5 math.pi))
    _   (values (* 0.0 math.pi) (* 2.0 math.pi))))
  (love.graphics.arc :line (* s self.pos.x) (* s self.pos.y) 
    (* s self.radius) angle1 angle2))

Ball
