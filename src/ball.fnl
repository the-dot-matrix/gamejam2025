(local Ball {}) (set Ball.__index Ball)
(local Point (require :src.point))
(local Line (require :src.line))
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
  (let [pos (Point:new x y)
        vel (Point:new 0 0)
        radius (or (. sizes pocket?) ballradiuscm)]
    (setmetatable {: radius : pos : vel : pocket?} self)))

(fn Ball.update [self dt intersect?] (when (not self.pocket?)
  (let [newpos  (+ self.pos (* self.vel dt))
        lines   (intersect? self.pos newpos self.radius)]
    (if (= (length lines) 0) 
        (do (set self.pos newpos) 
            (set self.vel.y (+ self.vel.y (* a dt))))
        (set self.bounce (* (/ 1 (length lines))
          (accumulate [w (Line:new 0 0 0 0) _ c (ipairs lines)]
            (+ w c))))))))

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

Ball
