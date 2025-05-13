(local Vec (require :src.vec))
(local Line (require :src.line))
(local Spawner (require :src.spawner))
(local Game {}) (set Game.__index Game)

(fn Game.new [!]
  (local ! (setmetatable {} !))
  (set !.area (Vec:new 352 352))
  (set !.border (Vec:new 64 4))
  (set !.units (+ !.area (* !.border 2)))
  (set !.walls (Spawner:new Line))
  (!.walls:spawn 0 0 !.area.x 0)
  (!.walls:spawn !.area.x 0 !.area.x !.area.y)
  (!.walls:spawn !.area.x !.area.y 0 !.area.y)
  (!.walls:spawn 0 !.area.y 0 0)
  (set !.dabois [])
  (for [i 1 2]
    (table.insert !.dabois {
      :img      (love.graphics.newImage 
                  (.. :src/afflictirelixir/img/sprites/b i :.bmp))})
    (local boi (. !.dabois i))
    (set boi.scalex (/ !.area.x (boi.img:getWidth) 4))
    (set boi.scaley (/ !.area.y (boi.img:getHeight) 4)))
  (!:keypressed)
  !)

(fn Game.update [! dt]
  (set !.tick (+ (or !.tick 0) dt))
  (set !.tick? (> !.tick _G.TICKRATE))
  (!.walls:update !.tick !.tick?)
  (when !.tick? (set !.tick nil)))

(fn Game.draw [! cmpx]
  (love.graphics.push)
  (love.graphics.translate 
    (* cmpx !.border.x)
    (* cmpx !.border.y))
  (!.walls:draw cmpx)
  (each [_ boi (ipairs !.dabois)]
    (love.graphics.push)
    (love.graphics.scale boi.scalex boi.scaley)
    (love.graphics.draw boi.img (/ boi.x boi.scalex) 
                                (/ boi.y boi.scaley))
    (love.graphics.pop))
  (love.graphics.pop))

(fn Game.keypressed [! key]
  (each [_ boi (ipairs !.dabois)]
    (set boi.x (love.math.random  (* !.area.x 0.2) 
                                  (* !.area.x 0.8)))
    (set boi.y (love.math.random  (* !.area.y 0.2) 
                                  (* !.area.y 0.8)))))

Game
