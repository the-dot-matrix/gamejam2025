(local Games {:a :balahtzee :b :afflictirelixir})
(local Game (require (.. :src. Games.b :.game)))
(local Vec (require :src.vec))
(local Screen {}) (set Screen.__index Screen)

(fn Screen.new [!]
  (let [res     (Vec:new 266 200)
        game    (Game:new)
        units   game.units
        convert (/ res units)
        cmpx    (math.min convert.x convert.y)
        pixels  (* units cmpx)
        screen  (love.graphics.newCanvas res.x res.y)
        native  (love.graphics.newCanvas pixels.x pixels.y)
        centerf #(math.floor (/ (- $1 $2) 2))
        centerx (centerf (screen:getWidth)  (native:getWidth))
        centery (centerf (screen:getHeight) (native:getHeight))
        mid     (Vec:new centerx centery)
        pfx     (love.graphics.newShader :img/crt.glsl)
        s {: res : screen : native : cmpx : game : mid : pfx}]
    (native:setFilter :nearest :nearest 0)
    (screen:setFilter :nearest :nearest 0)
    (setmetatable s !)))

(fn Screen.update [! dt] (!.game:update dt))

(fn Screen.draw [!]
  (love.graphics.push)
  (love.graphics.origin)
  (love.graphics.setCanvas !.native)
  (love.graphics.clear 0.04 0.04 0.04)
  (love.graphics.push)
  (!.game:draw !.cmpx)
  (love.graphics.pop)
  (love.graphics.setCanvas !.screen)
  (love.graphics.clear 0.02 0.02 0.02)
  (love.graphics.push)
  (love.graphics.translate !.mid.x !.mid.y)
  (love.graphics.draw !.native)
  (love.graphics.pop)
  (love.graphics.push)
  (love.graphics.setColor 0 1 0 1)
  (love.graphics.scale 2 2)
  (love.graphics.print (..  
    "  FPS:" (love.timer.getFPS)))
  (love.graphics.setColor 1 1 1 1)
  (love.graphics.pop)
  (love.graphics.pop)
  (love.graphics.setCanvas)
  (love.graphics.setShader !.pfx)
  (love.graphics.draw !.screen)
  (love.graphics.setShader))

(fn Screen.keypressed [! key] (!.game:keypressed key))

Screen
