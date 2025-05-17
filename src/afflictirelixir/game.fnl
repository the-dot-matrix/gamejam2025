(local Vec (require :src.vec))
(local Hand (require :src.afflictirelixir.hand))
(local Status (require :src.afflictirelixir.status))
(local Board (require :src.afflictirelixir.board))
(local Game {}) (set Game.__index Game)

(fn Game.new [!]
  (local ! (setmetatable {} !))
  (set !.area (Vec:new 320 240))
  (set !.border (Vec:new 0 0))
  (set !.units (+ !.area (* !.border 2)))
  (set !.hand (Hand:new 0 1 #(!.status.update !.status nil $1)))
  (set !.status (Status:new 2 7 #(!.hand.update !.hand $1)))
  (set !.board (Board:new :level1 !.status))
  !)

(fn Game.update [! dt]
  (!.board:update dt))

(fn Game.draw [! scale]
  (love.graphics.clear 0.65 0.65 0.65)
  (love.graphics.push)
  (love.graphics.translate 
    (* scale !.border.x)
    (* scale !.border.y))
  (love.graphics.scale scale scale)
  (love.graphics.push)
  (love.graphics.translate (/ 16 2) 0)
  (!.board:draw)
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
  (!.board:keypressed key))

(fn Game.keyreleased [! key]
  (!.board:keyreleased key))

Game
