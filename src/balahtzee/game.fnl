(local Vec (require :src.vec))
(local Line (require :src.line))
(local Ball (require :src.balahtzee.ball))
(local Spawner (require :src.spawner))
(local Game {}) (set Game.__index Game)

(fn Game.new [!]
  (local ! (setmetatable {} !))
  (set !.area (Vec:new 117 234))
  (set !.border (Vec:new 101.5 3))
  (set !.units (+ !.area (* !.border 2)))
  (set !.walls (Spawner:new Line))
  (!.walls:spawn 0 0 !.area.x 0)
  (!.walls:spawn !.area.x 0 !.area.x !.area.y)
  (!.walls:spawn !.area.x !.area.y 0 !.area.y)
  (!.walls:spawn 0 !.area.y 0 0)
  (set !.balls (Spawner:new Ball (!.walls:query :intersect?)))
  (!.balls:spawn 0 0 :UL)
  (!.balls:spawn !.area.x 0 :UR)
  (!.balls:spawn 0 (/ !.area.y 2) :ML)
  (!.balls:spawn !.area.x (/ !.area.y 2) :MR)
  (!.balls:spawn 0 !.area.y :DL)
  (!.balls:spawn !.area.x !.area.y :DR)
  ; testing collisions
  (!.walls:spawn 
    0 0 (* !.area.x 0.4) (* !.area.y 0.8))
  (!.walls:spawn 
    (* !.area.x 0.6) (* !.area.y 0.8) !.area.x 0)
  ; end testing
  !)

(fn Game.update [! dt]
  (set !.tick (+ (or !.tick 0) dt))
  (set !.tick? (> !.tick _G.TICKRATE))
  (!.walls:update !.tick !.tick?)
  (!.balls:update !.tick !.tick?)
  (when !.tick? (set !.tick nil)))

(fn Game.draw [! cmpx]
  (love.graphics.push)
  (love.graphics.translate 
    (* cmpx !.border.x)
    (* cmpx !.border.y 0.5))
  (!.balls:draw cmpx)
  (!.walls:draw cmpx) 
  (love.graphics.pop))

(fn Game.keypressed [! key]
  (!.balls:spawn 
    (love.math.random (* !.area.x 0.1) (* !.area.x 0.9)) 
    (* !.area.y 0.1)))

Game
