(local Vec (require :src.vec))
(local Screen (require :src.screen))
(var (screen pxpx) (values nil nil))

(fn love.load []
  (let [(w h)   (love.window.getDesktopDimensions)
        display (Vec:new w h)
        render  (Screen:new)
        fitto   (/ display render.res)
        scale   (/ (math.min fitto.x fitto.y) 1.0)
        scale   (- (* (math.floor scale) 1.0) 1.0)
        window  (* render.res scale)]
    (love.window.updateMode window.x window.y {:vsync true})
    (love.graphics.setFont (love.graphics.newFont 16))
    (set pxpx scale)
    (set screen render)))

(fn love.update [dt] (screen:update dt))

(fn love.draw []
  (love.graphics.push)
  (love.graphics.scale pxpx pxpx)
  (screen:draw)
  (love.graphics.pop)
  (love.graphics.setColor 0 1 0 1)
  (love.graphics.print (..  
    :fps: (love.timer.getFPS)))
  (love.graphics.setColor 1 1 1 1))

(fn love.keypressed [key] (screen:keypressed key))
