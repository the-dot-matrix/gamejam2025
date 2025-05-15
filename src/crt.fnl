(local Vec (require :src.vec))
(local CRT {}) (set CRT.__index CRT)

(fn CRT.new [! game]
  (let [res     (Vec:new 266 200)
        units   (or game.units res)
        convert (/ res units)
        scale   (math.min convert.x convert.y)
        pixels  (* units scale)
        screen  (love.graphics.newCanvas res.x res.y)
        native  (love.graphics.newCanvas pixels.x pixels.y)
        centerf #(math.floor (/ (- $1 $2) 2))
        centerx (centerf (screen:getWidth)  (native:getWidth))
        centery (centerf (screen:getHeight) (native:getHeight))
        mid     (Vec:new centerx centery)
        pfx     (love.graphics.newShader :img/crt.glsl)
        s {: res : screen : native : scale : game : mid : pfx}]
    (native:setFilter :nearest :nearest 0)
    (screen:setFilter :nearest :nearest 0)
    (setmetatable s !)))

(fn CRT.update [! dt] (!.game:update dt))

(fn CRT.draw [!]
  (love.graphics.push)
  (love.graphics.origin)
  (love.graphics.setCanvas !.native)
  (love.graphics.clear 0.04 0.04 0.04)
  (love.graphics.push)
  (!.game:draw !.scale)
  (love.graphics.pop)
  (love.graphics.setCanvas !.screen)
  (love.graphics.clear 0.02 0.02 0.02)
  (love.graphics.translate !.mid.x !.mid.y)
  (love.graphics.draw !.native)
  (love.graphics.push)
  (love.graphics.setColor 0 1 0 1)
  (when _G.DEBUG (love.graphics.print (..  
    "  FPS:" (love.timer.getFPS))))
  (love.graphics.setColor 1 1 1 1)
  (love.graphics.pop)
  (love.graphics.pop)
  (love.graphics.setCanvas)
  (love.graphics.setShader !.pfx)
  (love.graphics.draw !.screen)
  (love.graphics.setShader))

CRT
