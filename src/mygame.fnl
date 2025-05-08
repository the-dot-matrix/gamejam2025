(local Rectangle (require "src.rectangle"))
(local Spawner (require "src.spawner"))
(local tickrate (/ 1 60))
(local (w h) (love.graphics.getDimensions))
(var (dtick rectangleSpawner) (values 0 nil))
(var spawned 0)

(fn love.load [] 
  (love.window.updateMode w h {"vsync" false})
  (love.graphics.setFont (love.graphics.newFont 16))
  (set rectangleSpawner (Spawner:new Rectangle))
  (rectangleSpawner:spawn false (- 0 w) 0 (+ w 20) h 0)
  (rectangleSpawner:spawn false (- w 20) 0 (+ w 20) h 0)
  (rectangleSpawner:spawn false 0 (- 0 h) w (+ h 20) 0)
  (rectangleSpawner:spawn false 0 (- h 20) w (+ h 20) 0))

(fn love.update [dt]
  (set dtick (+ dtick dt))
  (rectangleSpawner:update dt (> dtick tickrate))
  (when (> dtick tickrate) (set dtick (% dtick tickrate))))

(fn love.draw []
  (love.graphics.setColor 1 1 1 1)
  (rectangleSpawner:draw)
  (love.graphics.setColor 0 1 0 1)
  (love.graphics.print (..  
    "\t spawned: " spawned
    "\t onscreen: " (rectangleSpawner:onscreen w h)
    "\t fps:" (love.timer.getFPS))))

(fn love.keypressed [key]
  (when (= key :space) (rectangleSpawner:spawn true))
  (set spawned (+ spawned 1)))
