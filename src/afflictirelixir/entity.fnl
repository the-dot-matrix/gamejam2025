(local Entity {}) (set Entity.__index Entity)
(local Sprite (require :src.afflictirelixir.sprite))
(local Vec (require :src.vec))

(fn Entity.new [! ?name ?X ?Y ]
  (let [pos     (Vec:new (or ?X 0) (or ?Y 0))
        r       0
        scale   (Vec:new 1 1)
        origin  (Vec:new 0 0)
        sprite  (Sprite:new ?name)]
    (setmetatable {: pos : r : scale : origin : sprite} !)))

;; pass in a logic class that controls how each entity works?
;; brain behavior, heart behavior etc.

(fn Entity.update [! dt]
  (!.sprite:update dt)
  )

(fn Entity.draw [!]
  (let [(x y)   (values !.pos.x !.pos.y)
        r       !.r
        (sX sY) (values !.scale.x !.scale.y)
        (oX oY) (values !.origin.x !.origin.y)
        sprite  !.sprite]
  (!.sprite:draw  x y r sX sY oX oY)))

Entity