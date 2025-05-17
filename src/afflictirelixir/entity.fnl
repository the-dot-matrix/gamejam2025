(local Entity {}) (set Entity.__index Entity)
(local Sprite (require :src.afflictirelixir.sprite))
(local Vec (require :src.vec))

;; 0 9 0 10


(fn tileB [tx ty]
 (Vec:new (values (* tx 16) ( * ty 16))))

;;CURRENT ENTITY NEW VALUES ARE BAD USED ONLY FOR CURRENT GAMEBOARD
(fn Entity.new [! ?name  ?x ?y ?eType collides encounters statusupdate]
  (let [(X Y)   (values (or ?x 0) (or ?y 0))
        pos     (tileB X Y)
        sprite  (Sprite:new ?name)
        anim    {:static {:f1 1 :f2 6} :walk {:f1 7 :f2 12}}
        state   :walk
        pframe  0
        frame   0
        direc   (Vec:new 1 0)
        eType   (or ?eType :nil)
        name    ?name]
    (setmetatable {: name : pos : sprite : eType
      : anim : state : pframe : frame : direc 
      : collides : encounters : statusupdate} !)))

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
  (local anim (. !.anim !.state))
  (!.sprite:update dt anim)
  (set !.frame (% (+ !.frame (* dt 12)) 12))
  (when (not= (math.floor !.frame) (math.floor !.pframe))
    (case !.eType
      :enemy
      nil
      :chara
      nil))
  (set !.pframe !.frame))

(fn Entity.draw [!]
  (let [(x y)   (values !.pos.x !.pos.y)
        r       0
        (sX sY) (values 1 1)
        (oX oY) (values 0 0)
        sprite  !.sprite
        anim    (. !.anim !.state)]
  (!.sprite:draw  x y r sX sY oX oY anim)))

(fn Entity.collide? [! x y] 
  (when (and (= !.pos.x x) (= !.pos.y y)) !.name))

(local keys [:u :d :l :r])
(fn Entity.keypressed [! key]
  (when (= !.eType :chara)
    (var keyUsed? false)
    (each [_ v (ipairs keys)]
      (if (= v key) (set keyUsed? true)))
    (when keyUsed?
      (when (= !.eType :chara)
        (local oldpos (Vec:new !.pos.x !.pos.y))
        (case key 
          :u  (set !.pos (+ !.pos (tileB 0 -1))) 
          :l  (set !.pos (+ !.pos (tileB -1 0)))
          :d  (set !.pos (+ !.pos (tileB 0 1)))
          :r  (set !.pos (+ !.pos (tileB 1 0))))
        (when (> (length (!.collides !.pos.x !.pos.y)) 0)
          (set !.pos oldpos))
        (local encounters (!.encounters !.pos.x !.pos.y))
        (when (> (length encounters) 0)
          (!.statusupdate (. encounters 1)))))))

(fn Entity.keyreleased [! key]
  (when (= !.eType :chara)
    (var keyUsed? false)
    (each [_ v (ipairs keys)]
      (if (= v key) (set keyUsed? true)))))

Entity