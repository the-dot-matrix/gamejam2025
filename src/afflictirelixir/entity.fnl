(local Entity {}) (set Entity.__index Entity)
(local Sprite (require :src.afflictirelixir.sprite))
(local Vec (require :src.vec))

(fn Entity.new [! ?name ?X ?Y ]
  (let [pos     (Vec:new (or ?X 0) (or ?Y 0))
        r       0
        scale   (Vec:new 1 1)
        origin  (Vec:new 0 0)
        sprite  (Sprite:new ?name)
        anim    {}
        state   :static]
    (setmetatable {: pos : r : scale : origin : sprite : anim : state} !)))

(fn Entity.setAnim [! name f1 f2]
  (tset !.anim name { : f1 : f2}))

(fn Entity.setState [! state]
  (set !.state state))

;; pass in a logic class that controls how each entity works?
;; brain behavior, heart behavior etc.

(fn Entity.update [! dt]
  (local anim (. !.anim !.state))
  (!.sprite:update dt anim)
  )

(fn Entity.draw [!]
  (let [(x y)   (values !.pos.x !.pos.y)
        r       !.r
        (sX sY) (values !.scale.x !.scale.y)
        (oX oY) (values !.origin.x !.origin.y)
        sprite  !.sprite
        anim    (. !.anim !.state)]
  (!.sprite:draw  x y r sX sY oX oY anim)))

Entity