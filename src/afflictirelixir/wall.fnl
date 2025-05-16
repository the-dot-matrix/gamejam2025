(local Wall {}) (set Wall.__index Wall)
(local Sprite (require :src.afflictirelixir.sprite))
(local Vec (require :src.vec))

(local (left up right down) (values 6 1 16 12))
(fn tileB [tx ty] (Vec:new (values (* tx 16) ( * ty 16))))

(fn Wall.new [! x y]
  (setmetatable {:sprite (Sprite:new :wall) : x : y} !))

(fn Wall.draw [!] (!.sprite:draw !.x !.y))

(fn Wall.collide? [! x y] (when (and (= !.x x) (= !.y y)) true))

Wall
