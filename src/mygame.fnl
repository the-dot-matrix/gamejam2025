(local Rectangle (require "src.rectangle"))
(local Spawner (require "src.spawner"))
(local tickrate (/ 1 60))
(var (dtick rectangleSpawner) (values 0 nil))

(fn love.load [] (let [(w h) (love.graphics.getDimensions)]
  (love.window.updateMode w h {"vsync" false})
  (love.graphics.setFont (love.graphics.newFont 16))
  (set rectangleSpawner (Spawner:new Rectangle))
  (rectangleSpawner:spawn (- 0 w) (- 5 0) (+ w 5) (- h 10) 0)
  (rectangleSpawner:spawn (- w 5) (- 5 0) (+ w 5) (- h 10) 0)
  (rectangleSpawner:spawn (+ 0 0) (- 0 h) (+ w 0) (+ h 5) 0)
  (rectangleSpawner:spawn (+ 0 0) (- h 5) (+ w 0) (+ h 5) 0)))

(fn love.update [dt]
  (set dtick (+ dtick dt))
  (rectangleSpawner:update dt (> dtick tickrate))
  (when (> dtick tickrate) (set dtick (% dtick tickrate))))

(fn love.draw []
  (love.graphics.setColor 1 1 1 1)
  (rectangleSpawner:draw)
  (love.graphics.setColor 0 1 0 1)
  (love.graphics.print (.. 
    "tick:\t" (/ (math.floor (* (/ dtick tickrate) 100)) 100)
    "\nfps:\t" (love.timer.getFPS))))

(fn love.keypressed [key]
  (when (= key :space) (rectangleSpawner:spawn)))
