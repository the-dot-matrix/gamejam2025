(local Games {:a :balahtzee :b :afflictirelixir})
(local Game (require (.. :src. Games.a :.game)))
(local Vec (require :src.vec))
(local Screen {}) (set Screen.__index Screen)

(fn Screen.new [!]
  (let [res     (Vec:new 400 300)
        game    (Game:new)
        units   game.units
        convert (/ res units)
        cmpx    (math.min convert.x convert.y)
        pixels  (* units cmpx)
        screen  (love.graphics.newCanvas res.x res.y)
        native  (love.graphics.newCanvas pixels.x pixels.y)
        center  #(math.floor (/ (- $1 $2) 2))
        centerx (center (screen:getWidth) (native:getWidth))
        centery (center (screen:getHeight) (native:getHeight))
        cvec    (Vec:new centerx centery)
        s {: res : screen : native : cmpx : game :center cvec}]
    (native:setFilter :nearest :nearest 1)
    (screen:setFilter :nearest :nearest 1)
    (setmetatable s !)))

(fn Screen.update [! dt] (!.game:update dt))

(fn Screen.draw [!]
  (love.graphics.push)
  (love.graphics.origin)
  (love.graphics.setCanvas !.native)
  (love.graphics.clear 0.08 0.08 0.08)
  (love.graphics.push)
  (!.game:draw !.cmpx)
  (love.graphics.pop)
  (love.graphics.setCanvas !.screen)
  (love.graphics.clear 0.04 0.04 0.04)
  (love.graphics.push)
  (love.graphics.translate !.center.x !.center.y)
  (love.graphics.draw !.native)
  (love.graphics.pop)
  (love.graphics.pop)
  (love.graphics.setCanvas)
  (love.graphics.draw !.screen))

(fn Screen.keypressed [! key] (!.game:keypressed key))

Screen
