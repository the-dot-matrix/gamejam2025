(local Game (require :src.game))
(local Vec (require :src.vec))
(local Screen {}) (set Screen.__index Screen)

(fn Screen.new [!]
  (let [res     (Vec:new 480 360)
        border  (Vec:new 10 10)
        game    (Game:new)
        units   (+ game.area (* border 2))
        convert (/ res units)
        cmpx    (math.min convert.x convert.y)
        pixels  (* units cmpx)
        screen  (love.graphics.newCanvas res.x res.y)
        native  (love.graphics.newCanvas pixels.x pixels.y)
        s {: res : border : screen : native : cmpx : game }]
    (native:setFilter :nearest :nearest 0)
    (screen:setFilter :nearest :nearest 0)
    (setmetatable s !)))

(fn Screen.update [! dt] (!.game:update dt))

(fn Screen.draw [!]
  (love.graphics.push)
  (love.graphics.origin)
  (love.graphics.setCanvas !.native)
  (love.graphics.clear 0.08 0.08 0.08)
  (love.graphics.push)
  (love.graphics.translate 
    (* !.cmpx !.border.x)
    (* !.cmpx !.border.y 0.25))
  (!.game:draw !.cmpx)
  (love.graphics.pop)
  (love.graphics.setCanvas !.screen)
  (love.graphics.clear 0.04 0.04 0.04)
  (love.graphics.push)
  (love.graphics.translate 
    (/ (- (!.screen:getWidth) (!.native:getWidth)) 2) 
    (/ (- (!.screen:getHeight) (!.native:getHeight)) 2))
  (love.graphics.draw !.native)
  (love.graphics.pop)
  (love.graphics.pop)
  (love.graphics.setCanvas)
  (love.graphics.draw !.screen))

(fn Screen.keypressed [! key] (!.game:keypressed key))

Screen
