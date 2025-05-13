(local Vec (require :src.vec))
(local Line (require :src.line))
(local Spawner (require :src.spawner))
(local Sprite (require :src.afflictirelixir.sprite))
(local Game {}) (set Game.__index Game)

(fn Game.new [!]
  (local ! (setmetatable {} !))
  (set !.area (Vec:new 256 200))
  (set !.border (Vec:new 5 0))
  (set !.units (+ !.area (* !.border 2)))
  (set !.walls (Spawner:new Line))
  (!.walls:spawn 0 0 !.area.x 0)
  (!.walls:spawn !.area.x 0 !.area.x !.area.y)
  (!.walls:spawn !.area.x !.area.y 0 !.area.y)
  (!.walls:spawn 0 !.area.y 0 0)
  (set !.heart    (Sprite:new :heart))
  (set !.brain    (Sprite:new :brain))
  (set !.spleen   (Sprite:new :spleen))
  (set !.galblad  (Sprite:new :galblad))
  (!:keypressed)
  !)

(fn Game.update [! dt]
  (set !.tick (+ (or !.tick 0) dt))
  (set !.tick? (> !.tick _G.TICKRATE))
  (!.walls:update !.tick !.tick?)
  (!.heart:update dt)
  (!.brain:update dt)
  (!.spleen:update dt)
  (!.galblad:update dt)
  (when !.tick? (set !.tick 0)))

(fn Game.draw [! scale]
  (love.graphics.push)
  (love.graphics.translate 
    (* scale !.border.x)
    (* scale !.border.y))
  (!.walls:draw scale)
  (!.heart:draw (* !.area.x 0.25) (* !.area.y 0.25))
  (!.brain:draw (* !.area.x 0.75) (* !.area.y 0.25))
  (!.spleen:draw (* !.area.x 0.25) (* !.area.y 0.75))
  (!.galblad:draw (* !.area.x 0.75) (* !.area.y 0.75))
  (love.graphics.pop))

(fn Game.keypressed [! key])

Game
