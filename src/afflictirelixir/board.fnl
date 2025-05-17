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
  (local (left up right down) (values 6 1 18 13))
  (spawnBox !.walls left up right down)
  (set !.enemies (Spawner:new Entity))
  (set !.heart    (!.enemies:spawn :heart    1 1   :enemy))
  (set !.brain    (!.enemies:spawn :brain    11 1   :enemy))
  (set !.spleen   (!.enemies:spawn :spleen   1 11  :enemy))
  (set !.galblad  (!.enemies:spawn :galblad  11 11  :enemy))
  (set !.wizard   (Entity:new :wizard   4 5   :chara 
                    (!.walls:query :collide?) 
                    (!.enemies:query :collide?)
                    #(status.update status $1)))
  !)

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
