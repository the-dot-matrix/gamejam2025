(local Entity {}) (set Entity.__index Entity)
(local Sprite (require :src.afflictirelixir.sprite))
(local Vec (require :src.vec))

(local (left up right down) (values 6 1 16 12))
;; 0 9 0 10

(fn tileB [tx ty]
 (Vec:new (values (* tx 16) ( * ty 16))))

;;CURRENT ENTITY NEW VALUES ARE BAD USED ONLY FOR CURRENT GAMEBOARD
(fn Entity.new [! ?name ?X ?Y]
  (let [(x y)   (values (or ?X 0) (or ?Y 0)) ;; used for 16x16 tile system
        pos     (tileB (+ left x) (+ up y))
        sprite  (Sprite:new ?name)
        anim    {}
        state   :static
        pframe  0
        frame   0
        direc   1]
    (setmetatable {: pos : sprite 
      : anim : state : pframe : frame : direc} !)))


(fn Entity.setAnim [! name f1 f2]
  (tset !.anim name { : f1 : f2}))

(fn Entity.genAnim [! anims]
  (each [k v (pairs anims)]
    (!:setAnim  k (. v 1) (. v 2))))

(fn Entity.setState [! state]
  (set !.state state))
 
;; pass in a logic class that controls how each entity works?
;; brain behavior, heart behavior etc.

(fn Entity.update [! dt]
  (set !.frame (% (+ !.frame (* dt 12)) 12))
  (when (not= (math.floor !.frame) (math.floor !.pframe))
    (local anim (. !.anim !.state))
    (!.sprite:update dt anim)
    (when (= (math.floor !.frame) 0)
      (if (= !.pos.x (* (- right 1) 16))
        (set !.direc -1))
      (if (= !.pos.x (* left 16))
        (set !.direc 1))
      (set !.pos (+ !.pos (tileB !.direc 0)))
      )
      )
  (set !.pframe !.frame))

(fn Entity.draw [!]
  (let [(x y)   (values !.pos.x !.pos.y)
        r       0
        (sX sY) (values 1 1)
        (oX oY) (values 0 0)
        sprite  !.sprite
        anim    (. !.anim !.state)]
  (!.sprite:draw  x y r sX sY oX oY anim)))

Entity