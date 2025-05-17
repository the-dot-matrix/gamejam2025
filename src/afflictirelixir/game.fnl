(local Vec (require :src.vec))
(local Line (require :src.line))
(local Wall (require :src.afflictirelixir.wall))
(local Entity (require :src.afflictirelixir.entity))
(local Spawner (require :src.spawner))
(local Hand (require :src.afflictirelixir.hand))
(local Status (require :src.afflictirelixir.status))
(local Humor (require :src.afflictirelixir.humor))
(local Game {}) (set Game.__index Game)

(fn tIndex [a ...]
  (local tileLength 16)
  (if a (unpack [(* a 16) (tIndex ...)]) nil))
(fn spawnBox [spawner x1 y1 x2 y2]
  (for [x x1 x2 1] (spawner:spawn (tIndex x y1)))
  (for [x x1 x2 1] (spawner:spawn (tIndex x y2)))
  (for [y y1 y2 1] (spawner:spawn (tIndex x1 y)))
  (for [y y1 y2 1] (spawner:spawn (tIndex x2 y))))

(fn Game.new [!]
  (local ! (setmetatable {} !))
  (set !.area (Vec:new 320 240))
  (set !.border (Vec:new 0 0))
  (set !.units (+ !.area (* !.border 2)))
  (set !.hand (Hand:new 0 1 #(!.status.update !.status nil $1)))
  (set !.status (Status:new 2 7 #(!.hand.update !.hand $1)))
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
                    #(!.status.update !.status $1)))
  !)

(fn Game.update [! dt]
  (!.enemies:update dt)
  (!.wizard:update dt))

(fn Game.draw [! scale]
  (love.graphics.clear 0.65 0.65 0.65)
  (love.graphics.push)
  (love.graphics.translate 
    (* scale !.border.x)
    (* scale !.border.y))
  (love.graphics.scale scale scale)
  (love.graphics.push)
  (love.graphics.translate (/ 16 2) 0)
  (!.walls:draw)
  (!.enemies:draw)
  (!.wizard:draw)
  (love.graphics.pop)
  (love.graphics.push)
  (love.graphics.translate (* 16 0.75) 0)
  (!.hand:draw)
  (love.graphics.pop)
  (love.graphics.push)
  (love.graphics.translate (* 16 0.25) (/ 16 8))
  (!.status:draw)
  (love.graphics.pop)
  (love.graphics.pop))

(fn Game.keypressed [! key]
  (when (= key :y) (!.status:update nil (!.hand:update)))
  (!.wizard:keypressed key))

(fn Game.keyreleased [! key]
  (!.wizard:keyreleased key))

Game
