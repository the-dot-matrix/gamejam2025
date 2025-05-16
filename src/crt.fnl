(local Vec (require :src.vec))
(local CRT {}) (set CRT.__index CRT)

(fn CRT.new [! game]
  (let [res     (Vec:new 1600 1200) 
        dpi     (Vec:new 640 480)
        perfect (Vec:new 320 240)
        d2irl   (/ res dpi)
        p2d     (/ dpi perfect)
        units   (or game.units perfect)
        convert (/ perfect units)
        u2p     (math.min convert.x convert.y)
        actual  (* units u2p)
        r       (* d2irl p2d)
        scale   (love.math.newTransform 0 0 0 r.x r.y)
        tv      (love.graphics.newCanvas res.x res.y)
        p480    (love.graphics.newCanvas dpi.x dpi.y)
        console (love.graphics.newCanvas actual.x actual.y)
        centerf #(math.floor (/ (- $1 $2) 2))
        centerx (centerf perfect.x actual.x)
        centery (centerf perfect.y actual.y)
        mid     (Vec:new centerx centery)
        postfx  (love.graphics.newShader :img/crt.glsl)
        s       { : res     : scale 
                  : postfx  : mid     : game
                  : tv      : p480    : console 
                  : d2irl   : p2d     : u2p   }]
    (console:setFilter :nearest :nearest 0)
    (p480:setFilter :nearest :nearest 0)
    (tv:setFilter :linear :nearest 0)
    (setmetatable s !)))

(fn CRT.update [! dt] (when !.game.update (!.game:update dt)))

(fn CRT.draw [!]
  (love.graphics.push)
  (love.graphics.origin)
  (love.graphics.setCanvas {1 !.console :stencil true})
  (love.graphics.clear 0.04 0.04 0.04)
  (love.graphics.push)
  (!.game:draw !.u2p)
  (love.graphics.pop)
  (love.graphics.push)
  (love.graphics.scale !.p2d.x !.p2d.y)
  (love.graphics.setCanvas !.p480)
  (love.graphics.clear 0.02 0.02 0.02)
  (love.graphics.draw !.console !.mid.x !.mid.y)
  (love.graphics.pop)
  (love.graphics.push)
  (love.graphics.scale !.d2irl.x !.d2irl.y)
  (love.graphics.push)
  (when _G.DEBUG 
    (love.graphics.setColor 0 0 0 0.5)
    (love.graphics.rectangle :fill 0 !.mid.y 48 12)
    (love.graphics.setColor 0 1 0 1)
    (love.graphics.print (..  
      "  FPS:" (love.timer.getFPS)) 0 !.mid.y)
    (love.graphics.setColor 1 1 1 1))
  (love.graphics.pop)
  (love.graphics.setCanvas !.tv)
  (love.graphics.setShader !.postfx)
  (love.graphics.draw !.p480)
  (love.graphics.setCanvas)
  (love.graphics.setShader)
  (love.graphics.pop)
  (love.graphics.pop)
  (love.graphics.draw !.tv))

CRT
