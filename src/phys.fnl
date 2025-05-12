(local Vec (require :src.vec))
(local Phys {}) (set Phys.__index Phys)

(fn Phys.force [theta gravity?]
  (let [(M G MU)  (values 200 986 0.04)
        gravity   (* M (or gravity? G))
        net       (* gravity (math.sin theta))
        normal    (* gravity (math.cos theta))
        friction  (* normal  MU)]
    (values (/ (- net friction) M) (/ net M))))

(fn Phys.acc [v dt norm?]
  (let [z (Phys.force (* (/ 6 360) 2 math.pi))
        g (Vec:new 0 z)
        i (when norm? (Vec:new (Phys.force (norm?:polar) z)))
        b (when norm? (* norm? (/ (v:#) 5) (/ 0.33 dt)))]
    (+ g i b)))

(fn Phys.vel [v a dt tan?]
  (let [d   (when tan? (- (v:polar) (tan?:polar) math.pi))
        d   (when d (when (> d math.pi) (- d (* 2 math.pi))))
        d   (when d (math.abs d))
        mag (if (< 0.10 (or d 0)) (* -0.25 (v:#)) (* -1 (v:#)))
        vt  (when tan? (Vec:new mag (tan?:polar) true))
        vx  (if (= v.x 0) (love.math.random -1 1) v.x)
        vx  (Vec:new (* -1 vx) 0)
        vx  (Vec:new mag (vx:polar) true)
        ax  (math.abs a.x)
        ax  (if (> vx.x 0) (* -1 ax) ax)
        ax  (Vec:new ax a.y)]
    (case [(and tan? (tan?:polar))]
      (where [t] (not= t 0))  (+ (* a dt) vt)
      (where [t] (= t 0))     (+ (* ax dt) vx)
      _                       (+ (* a dt) v))))

(fn Phys.pos [p v dt] (+ p (* v dt)))

Phys
