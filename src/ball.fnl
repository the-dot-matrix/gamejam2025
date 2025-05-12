(local Vec (require :src.vec))
(local Line (require :src.line))
(local Ball {}) (set Ball.__index Ball)
(local debug false)
(local ballin (/ 2.25 2))
(local ballcm (* ballin 2.54))
(local (crn mid) (values (* ballcm 2.25) (* ballcm 1.75)))
(local sizes {:UL crn :UR crn :ML mid :MR mid :DL crn :DR crn})
(local (M G MU D P B) (values 200 986 0.04 0.1 0.5 1.1))
(local Z (* (/ 6 360) 2 math.pi))

(fn Ball.new [! x y pocket?]
  (let [radius  (or (. sizes pocket?) ballcm)
        (d v a) (values (Vec:new x y) (Vec:new) (Vec:new))]
    (setmetatable {: radius : d : v : pocket?} !)))

(fn Ball.update [! dt intersect?] (when (not !.pocket?)
  (let [np  #(+ !.d (* !.v dt))
        ws  #(intersect? !.d (np) !.radius)
        z   (* 1 (!:ac Z))
        ∥   (when !.⊥ (Line.⊥ (Line:new !.d !.⊥)))
        g   (Vec:new 0 (* 1 z))
        a   (when !.⊥ (Vec:new (!:ac (!.⊥:polar) z)))
        d   (when ∥ (- (+ (∥:polar) math.pi) (!.v:polar)))
        mag (* -1 (!.v:#))
        mag (if (> (math.abs (or d 0)) D) (* P mag) mag)
        b   (when !.⊥ (* !.⊥ (/ mag -10) (/ B dt)))]
    (set !.a (+ g a))
    (when (and !.⊥ (not= (∥:polar) 0))
      (set !.a (+ !.a b))
      (set !.v (Vec:new mag (∥:polar) true)))
    (set !.v (+ !.v (* !.a dt)))
    (when (and !.⊥ (= (∥:polar) 0)) (set !.v (Vec:new)))
    (set (!.d !.⊥) (values (np) nil))
    (when (> (length (ws)) 0) 
      (set !.⊥ (* (/ 1 (length (ws)))
        (accumulate [sum (Vec:new) _ normal (ipairs (ws))]
          (+ sum normal))))))))

(fn Ball.draw [! s]
  (local (angle1 angle2) (case !.pocket?
    :UL (values (* 0.0 math.pi) (* 0.5 math.pi))
    :UR (values (* 0.5 math.pi) (* 1.0 math.pi))
    :ML (values (* 1.5 math.pi) (* 2.5 math.pi))
    :MR (values (* 0.5 math.pi) (* 1.5 math.pi))
    :DL (values (* 1.5 math.pi) (* 2.0 math.pi))
    :DR (values (* 1.0 math.pi) (* 1.5 math.pi))
    _   (values (* 0.0 math.pi) (* 2.0 math.pi))))
  (love.graphics.arc :line (* s !.d.x) (* s !.d.y) 
    (* s !.radius) angle1 angle2)
  (when debug
    (love.graphics.setColor 1 0 0 1)
    (local v (Line:new !.d.x !.d.y
      (+ !.d.x !.v.x) (+ !.d.y !.v.y)))
    (v:draw s)
    (love.graphics.setColor 0 0 1 1)
    (when !.⊥ 
      (local n (Line:new !.d (* 2 !.radius !.⊥)))
      (n:draw s))
    (love.graphics.setColor 1 1 1 1)))

(fn Ball.ac [! theta gravity?]
  (let [gravity   (* M (or gravity? G))
        net       (* gravity (math.sin theta))
        normal    (* gravity (math.cos theta))
        friction  (* normal MU)]
    (values (/ (- net friction) M) (/ net M 1))))

Ball
