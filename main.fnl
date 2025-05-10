(local Point (require "src.point"))
(local Spawner (require "src.spawner"))
(local Line (require "src.line"))
(local Ball (require "src.ball"))
(local playarea (Point:new 116 232))
(local border (Point:new 10 10))
(var (cmpx game screen pxpx) (values nil nil nil nil))
(var (walls balls) (values nil nil))

(fn love.load []
  (let [(w h)   (love.window.getDesktopDimensions)
        display (Point:new w h)
        render  (Point:new 480 360)
        fitted  (/ display render)
        scale   (- (math.ceil (math.min fitted.x fitted.y)) 1)
        window  (* render scale)
        units   (+ playarea (* border 2))
        convert (/ render units)
        ratio   (math.min convert.x convert.y)
        pixels  (* units ratio)]
    (love.window.updateMode window.x window.y {"vsync" false})
    (love.graphics.setDefaultFilter :nearest :nearest 0)
    (love.graphics.setFont (love.graphics.newFont 16))
    (set pxpx scale)
    (set screen (love.graphics.newCanvas render.x render.y))
    (set game (love.graphics.newCanvas pixels.x pixels.y))
    (set cmpx ratio))
  (set walls (Spawner:new Line))
  (walls:spawn 0 0 playarea.x 0)
  (walls:spawn playarea.x 0 playarea.x playarea.y)
  (walls:spawn playarea.x playarea.y 0 playarea.y)
  (walls:spawn 0 playarea.y 0 0)
  (set balls (Spawner:new Ball (walls:query :intersect?)))
  (balls:spawn 0 0 :UL)
  (balls:spawn playarea.x 0 :UR)
  (balls:spawn 0 (/ playarea.y 2) :ML)
  (balls:spawn playarea.x (/ playarea.y 2) :MR)
  (balls:spawn 0 playarea.y :DL)
  (balls:spawn playarea.x playarea.y :DR)
  ; testing collisions
  (walls:spawn 
    0 0 (/ playarea.x 2) (* playarea.y 0.8))
  (walls:spawn 
    (/ playarea.x 2) (* playarea.y 0.8) playarea.x 0))

(fn love.update [dt] 
  (walls:update dt)
  (balls:update dt))

(fn love.draw []
  (love.graphics.setCanvas game)
  (love.graphics.clear 0.08 0.08 0.08)
  (love.graphics.push)
  (love.graphics.translate 
    (* cmpx border.x)
    (* cmpx border.y 0.25))
  (walls:draw cmpx) 
  (balls:draw cmpx)
  (love.graphics.pop)
  (love.graphics.setCanvas screen)
  (love.graphics.clear 0.04 0.04 0.04)
  (love.graphics.push)
  (love.graphics.translate 
    (/ (- (screen:getWidth) (game:getWidth)) 2) 
    (/ (- (screen:getHeight) (game:getHeight)) 2))
  (love.graphics.draw game)
  (love.graphics.pop)
  (love.graphics.setCanvas)
  (love.graphics.push)
  (love.graphics.scale pxpx pxpx)
  (love.graphics.draw screen)
  (love.graphics.pop)
  (love.graphics.setColor 0 1 0 1)
  (love.graphics.print (..  
    "fps:" (love.timer.getFPS)))
  (love.graphics.setColor 1 1 1 1))

(fn love.keypressed [key]
  (balls:spawn 
    (love.math.random (* playarea.x 0.1) (* playarea.x 0.9)) 
    (* playarea.y 0.1)))
