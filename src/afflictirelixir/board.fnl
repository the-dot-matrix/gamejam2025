(local Wall (require :src.afflictirelixir.wall))
(local Entity (require :src.afflictirelixir.entity))
(local Spawner (require :src.spawner))
(local Board {}) (set Board.__index Board)

(fn tIndex [a ...]
  (local tileLength 16)
  (if a (unpack [(* a 16) (tIndex ...)]) nil))
(fn spawnBox [spawner x1 y1 x2 y2]
  (for [x x1 x2 1] (spawner:spawn (tIndex x y1)))
  (for [x x1 x2 1] (spawner:spawn (tIndex x y2)))
  (for [y y1 y2 1] (spawner:spawn (tIndex x1 y)))
  (for [y y1 y2 1] (spawner:spawn (tIndex x2 y))))

(fn Board.new [! level status]
  (set !.walls (Spawner:new Wall))
  (set !.enemies (Spawner:new Entity))
  (set !.data (love.image.newImageData 
                (.. :src/afflictirelixir/img/ level :.png)))
  (set !.status status)
  (!.data:mapPixel #(Board.map ! $...))
  (when (not !.wizard) 
    (set !.wizard (Entity:new :wizard 7 7 :chara 
                    (!.walls:query :collide?) 
                    (!.enemies:query :collide?)
                    #(!.status.update !.status $1))))
  !)

(fn Board.map [! x y r g b a]
  (case [r g b]
    [1 1 1] (!.walls:spawn (tIndex x y))
    [1 0 0] (!.enemies:spawn :heart x y :enemy)
    [0 1 0] (!.enemies:spawn :galblad x y :enemy)
    [0 0 1] (!.enemies:spawn :brain x y :enemy)
    [1 1 0] (!.enemies:spawn :spleen x y :enemy)
    [0 1 1] (set !.wizard (Entity:new :wizard x y :chara 
                            (!.walls:query :collide?) 
                            (!.enemies:query :collide?)
                            #(!.status.update !.status $1))))
  (values r g b))

(fn Board.update [! dt]
  (!.enemies:update dt)
  (!.wizard:update dt))

(fn Board.draw [!]
  (!.walls:draw)
  (!.enemies:draw)
  (!.wizard:draw))

(fn Board.keypressed [! key]
  (!.wizard:keypressed key))

(fn Board.keyreleased [! key]
  (!.wizard:keyreleased key))

Board
