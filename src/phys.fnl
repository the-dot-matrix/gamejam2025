(local Vec (require :src.vec))
(local Phys {}) (set Phys.__index Phys)
(local (M G MU D P B) (values 200 986 0.04 0.1 0.5 1.1))
(local Z (* (/ 6 360) 2 math.pi))

(fn Phys.force [theta gravity?]
  (let [gravity   (* M (or gravity? G))
        net       (* gravity (math.sin theta))
        normal    (* gravity (math.cos theta))
        friction  (* normal MU)]
    (values (/ (- net friction) M) (/ net M))))

(fn Phys.acc [v dt norm? tang?]
  (var anew nil)
  (let [z   (Phys.force Z)
        g   (Vec:new 0 z)
        i   (when norm? (Vec:new (Phys.force (norm?:polar) z)))
        d   (when tang? (- (+ (tang?:polar) math.pi) (v:polar)))
        mag (if (> (math.abs (or d 0)) D) 
                (* -1 P (v:#)) 
                (* -1   (v:#)))
        b   (when norm? (* norm? (/ mag -10) (/ B dt)))]
    (set anew (+ g i))
    (when norm? (set anew (+ anew b))))
  anew)

(fn Phys.vel [v a dt tang?]
  (var vnew nil)
  (let [d   (when tang? (- (+ (tang?:polar) math.pi) (v:polar)))
        mag (if (> (math.abs (or d 0)) D) 
                (* -1 P (v:#)) 
                (* -1   (v:#)))]
    (when tang? (not= (tang?:polar) 0)
      (set vnew (Vec:new mag (tang?:polar) true)))
    (set vnew (+ v (* a dt)))
    (when (and tang? (= (tang?:polar) 0)) (set vnew (Vec:new))))
  vnew)

(fn Phys.pos [p v dt] (+ p (* v dt)))

(fn Phys.avg [vecs] (when (> (length vecs) 0)
  (/  (accumulate [s (Vec:new) _ v (ipairs vecs)] (+ s v))
      (length vecs))))

Phys
