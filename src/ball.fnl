(local Vec (require :src.vec))
(local Line (require :src.line))
(local Ball {}) (set Ball.__index Ball)
(local debug false)
(local ballin (/ 2.25 2))
(local ballcm (* ballin 2.54))
(local (crn mid) (values (* ballcm 2.25) (* ballcm 1.75)))
(local sizes {:UL crn :UR crn :ML mid :MR mid :DL crn :DR crn})
(local (M G MU D P B) (values 200 986 0.04 0.1 0.5 0.33))
(local Ztheta (* (/ 6 360) 2 math.pi))

(fn Ball.new [self x y pocket?]
  (let [radius  (or (. sizes pocket?) ballcm)
        (d v)   (values (Vec:new x y) (Vec:new))]
    (setmetatable {: radius : d : v : pocket?} self)))

(fn Ball.update [self dt intersect?] (when (not self.pocket?)
  (let [np  #(+ self.d (* self.v dt))
        w   #(intersect? self.d (np) self.radius)
        fz  (* 1 (Ball:accel Ztheta))
        n   (when self.n self.n)
        l   (when n (self.d:line self.n)) 
        r   (when n (l:perp)) ;; TODO calc r from n
        g   (Vec:new 0 (* 1 fz))
        a   (when n (Vec:new (self:accel (n:polar) fz)))
        d   (when r (- (+ (r:polar) math.pi) (self.v:polar)))
        mag (* -1 (self.v:#))
        mag (if (> (math.abs (or d 0)) D) (* P mag) mag)
        b   (when n (* n (/ mag -10) (/ B dt)))]
    (set self.a (+ g a))
    (when (and self.n (not= (r:polar) 0))
      (set self.a (+ self.a b))
      (set self.v (Vec:new mag (r:polar) true)))
    (set self.v (+ self.v (* self.a dt)))
    (when (and self.n (= (r:polar) 0)) (set self.v (Vec:new)))
    (set (self.d self.n) (values (np) nil))
    (when (> (length (w)) 0) 
      (set self.n (* (/ 1 (length (w)))
        (accumulate [sum (Vec:new) _ normal (ipairs (w))]
          (+ sum normal))))))))

(fn Ball.draw [self s]
  (local (angle1 angle2) (case self.pocket?
    :UL (values (* 0.0 math.pi) (* 0.5 math.pi))
    :UR (values (* 0.5 math.pi) (* 1.0 math.pi))
    :ML (values (* 1.5 math.pi) (* 2.5 math.pi))
    :MR (values (* 0.5 math.pi) (* 1.5 math.pi))
    :DL (values (* 1.5 math.pi) (* 2.0 math.pi))
    :DR (values (* 1.0 math.pi) (* 1.5 math.pi))
    _   (values (* 0.0 math.pi) (* 2.0 math.pi))))
  (love.graphics.arc :line (* s self.d.x) (* s self.d.y) 
    (* s self.radius) angle1 angle2)
  (when debug
    (love.graphics.setColor 1 0 0 1)
    (local v (Line:new self.d.x self.d.y
      (+ self.d.x self.v.x) (+ self.d.y self.v.y)))
    (v:draw s)
    (love.graphics.setColor 0 0 1 1)
    (when self.n 
      (local n (self.d:line self.n))
      (n:draw s))
    (love.graphics.setColor 1 1 1 1)))

(fn Ball.accel [self theta gravity?]
  (let [gravity   (* M (or gravity? G))
        net       (* gravity (math.sin theta))
        normal    (* gravity (math.cos theta))
        friction  (* normal MU)]
    (values (/ (- net friction) M) (/ net M 1))))

Ball
