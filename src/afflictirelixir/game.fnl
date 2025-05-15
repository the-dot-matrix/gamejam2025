(local Vec (require :src.vec))
(local Line (require :src.line))
(local Spawner (require :src.spawner))
(local Entity (require :src.afflictirelixir.entity))
(local Game {}) (set Game.__index Game)

(fn tIndex [a ...]
  (local tileLength 16)
  (if a (unpack [(* a 16) (tIndex ...)]) nil))
(fn spawnBox [spawner x1 y1 x2 y2]
  (spawner:spawn (tIndex x1 y1 x2 y1))
  (spawner:spawn (tIndex x1 y1 x1 y2))
  (spawner:spawn (tIndex x1 y2 x2 y2))
  (spawner:spawn (tIndex x2 y1 x2 y2)))

(fn Game.new [!]
  (local ! (setmetatable {} !))
  (set !.area (Vec:new 256 192)) ; 16 12
  (set !.border (Vec:new 5 0))
  (set !.units (+ !.area (* !.border 2)))
  (set !.bounds (Spawner:new Line))
  (set !.board (Spawner:new Line))
  (set !.cards (Spawner:new Line))
  (set !.trans (Spawner:new Line))
  (!.bounds:spawn 0 0 !.area.x 0)
  (!.bounds:spawn !.area.x 0 !.area.x !.area.y)
  (!.bounds:spawn !.area.x !.area.y 0 !.area.y)
  (!.bounds:spawn 0 !.area.y 0 0)
  (local (left up right down) (values 6 1 16 12))
  (spawnBox !.board left up right down) ; 0 0 9 10 ; x1 y1 x2 y2
  (spawnBox !.cards 0 1 5 4)
  (spawnBox !.trans 2 4 4 7)
  (spawnBox !.trans 2 9 4 12)
  (spawnBox !.trans 3.5 6.5 5.5 9.5)
  (spawnBox !.trans 0.5 6.5 2.5 9.5)
  ; x{00 9} y{00 10}
  (set !.heart    (Entity:new :heart    0 0   :enemy))
  (set !.brain    (Entity:new :brain    9 0   :enemy))
  (set !.spleen   (Entity:new :spleen   0 10  :enemy))
  (set !.galblad  (Entity:new :galblad  9 10  :enemy))
  (set !.wizard   (Entity:new :wizard   4 5   :chara))
  (fn enemyAnimSet [entity]
    (entity:genAnim {:static [1 6] :walk [7 12]}))
  (enemyAnimSet !.heart)
  (enemyAnimSet !.brain)
  (enemyAnimSet !.spleen)
  (enemyAnimSet !.galblad)
  (!.heart:setState :walk) ;; swap between :walk and :static
  (set !.bg       (Entity:new))
  !)

(fn Game.update [! dt]
  (!.heart:update dt)
  (!.brain:update dt)
  (!.spleen:update dt)
  (!.galblad:update dt))

(fn Game.draw [! scale]
  (love.graphics.clear 0.65 0.65 0.65)
  (love.graphics.push)
  (love.graphics.translate 
    (* scale !.border.x)
    (* scale !.border.y))
  (love.graphics.push)
  (love.graphics.translate (/ -16 4) (/ -16 4))
  (!.board:draw scale)
  ;; entity draws
  (!.heart:draw) 
  (!.brain:draw)
  (!.spleen:draw) 
  (!.galblad:draw)
  (!.wizard:draw)
  ;; end of entity draws
  (love.graphics.push)
  (love.graphics.translate (/ 16 2) (/ -16 4))
  (!.cards:draw scale)
  (love.graphics.pop)
  (love.graphics.push)
  (love.graphics.translate 0 (/ 16 4))
  (!.trans:draw scale)
  (love.graphics.pop)
  (love.graphics.pop)
  (love.graphics.pop)
  )



Game