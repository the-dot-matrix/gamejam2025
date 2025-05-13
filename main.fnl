(local Vec (require :src.vec))
(local Screen (require :src.screen))
(var (screen upscale overlay downscale) (values))

(fn love.load []
  (let [image   (love.graphics.newImage :img/overlay.png)
        res     (Vec:new (image:getWidth) (image:getHeight))
        (w h)   (values 1600 900)
        display (Vec:new w h)
        fitto   (/ res display)
        smaller (/ (math.min fitto.x fitto.y) 1.0)
        smaller (+ (* (math.floor smaller) 1.0) 1.0)
        smaller (/ 1 smaller)
        win     (* res smaller)
        view    (Vec:new 1600 1200)
        render  (Screen:new)
        fitto   (/ view render.res)
        larger  (math.min fitto.x fitto.y)
        font    (love.graphics.newFont 8 :mono)]
    (love.window.updateMode win.x win.y 
      {:vsync _G.VSYNC :borderless true})
    (font:setFilter :nearest)
    (love.graphics.setFont font)
    (set downscale smaller)
    (set overlay image)
    (set upscale (* larger smaller))
    (set screen render)))

(fn love.update [dt] (screen:update dt))

(fn love.draw []
  (love.graphics.push)
  (love.graphics.translate 450 25)
  (love.graphics.scale upscale upscale)
  (screen:draw)
  (love.graphics.pop)
  (love.graphics.push)
  (love.graphics.scale downscale downscale)
  (love.graphics.draw overlay)
  (love.graphics.pop))

(fn love.keypressed [key] 
  (when (= key :escape) (love.event.push :quit))
  (screen:keypressed key))
