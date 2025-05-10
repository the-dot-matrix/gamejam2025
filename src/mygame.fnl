(local Vector (require "src.vector"))
(local Spawner (require "src.spawner"))
(local Wall (require "src.wall"))
(local Ball (require "src.ball"))
(local (dpcm scale) (values 2 2))
(local playarea (Vector:new 117 234))
(local border (Vector:new 10 10))
(var (canvas walls balls) (values nil nil nil))

(fn love.load []
  (let [window    (+ playarea (* border 2))
        scaled    (* window dpcm)
        render    (* window dpcm scale)]
    (love.window.updateMode render.x render.y {"vsync" false})
    (love.graphics.setDefaultFilter :nearest)
    (love.graphics.setFont (love.graphics.newFont 16))
    (set canvas (love.graphics.newCanvas scaled.x scaled.y)))
  (set walls (Spawner:new Wall))
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
  (walls:spawn 0 0 (/ playarea.x 2) (* playarea.y 0.8))
  (walls:spawn (/ playarea.x 2) (* playarea.y 0.8) playarea.x 0))

(fn love.update [dt] 
  (walls:update dt)
  (balls:update dt))

(fn love.draw []
  (love.graphics.setCanvas canvas)
  (love.graphics.clear)
  (love.graphics.push)
  (love.graphics.translate 
    (* dpcm border.x) 
    (* dpcm border.y 0.25))
  (walls:draw dpcm) 
  (balls:draw dpcm)
  (love.graphics.pop)
  (love.graphics.setCanvas)
  (love.graphics.push)
  (love.graphics.scale scale scale)
  (love.graphics.setColor 1 1 1 1)
  (love.graphics.draw canvas)
  (love.graphics.pop)
  (love.graphics.setColor 0 1 0 1)
  (love.graphics.print (..  
    "fps:" (love.timer.getFPS))))

(fn love.keypressed [key]
  (balls:spawn 
    (love.math.random (* playarea.x 0.1) (* playarea.x 0.9)) 
    (* playarea.y 0.1)))
