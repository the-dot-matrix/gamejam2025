(local Entity {}) (set Entity.__index Entity)
(local Sprite (require :src.afflictirelixir.sprite))
(local Vec (require :src.vec))

(local (left up right down) (values 6 1 16 12))
;; 0 9 0 10


(fn tileB [tx ty]
 (Vec:new (values (* tx 16) ( * ty 16))))

;;CURRENT ENTITY NEW VALUES ARE BAD USED ONLY FOR CURRENT GAMEBOARD
(fn Entity.new [! ?name  ?x ?y ?eType ?query]
  (let [(X Y)   (values (or ?x 0) (or ?y 0))
        pos     (tileB (+ left X) (+ up Y))
        sprite  (Sprite:new ?name)
        anim    {:default {:f1 1 :f2 (length sprite.quads)}}
        state   :default
        pframe  0
        frame   0
        direc   (Vec:new 1 0)
        eType   (or ?eType :nil)
        collides (or ?query #(error "entity given invalid query"))]
    (setmetatable {: pos : sprite : eType
      : anim : state : pframe : frame : direc : collides} !)))

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
          (set !.pos oldpos))))))

(fn Entity.keyreleased [! key]
  (when (= !.eType :chara)
    (var keyUsed? false)
    (each [_ v (ipairs keys)]
      (if (= v key) (set keyUsed? true)))))

Entity