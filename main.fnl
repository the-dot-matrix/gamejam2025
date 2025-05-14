(local Vec (require :src.vec))
(local CRT (require :src.crt))
(local Cart (require :src.cart))
(local games [])
(var (cart screen upscale overlay downscale) (values))

(fn love.load []
  (let [image   (love.graphics.newImage :img/overlay.png)
        res     (Vec:new (image:getWidth) (image:getHeight))
        (w h)   (love.graphics.getDimensions)
        display (Vec:new w h)
        fitto   (/ display res)
        smaller (math.min fitto.x fitto.y)
        win     (* res smaller)
        font    (love.graphics.newFont 42 :mono)]
    (font:setFilter :nearest)
    (love.graphics.setFont font)
    (set downscale smaller)
    (set overlay image)
    (set cart (Cart:new downscale))))

(fn love.update [dt] (when screen (screen:update dt)))

(fn love.draw []
  (love.graphics.push)
  (love.graphics.scale downscale downscale)
  (love.graphics.push)
  (love.graphics.translate 900 50)
  (love.graphics.scale upscale upscale)  
  (when screen (screen:draw))
  (love.graphics.pop)
  (love.graphics.draw overlay)
  (love.graphics.pop)
  (cart:draw))

(fn love.keypressed [key ...] 
  (when (= key :escape) (love.event.push :quit))
  (when (and screen screen.keypressed) 
    (screen:keypressed key ...)))

(fn love.mousemoved [...] (cart:mousemoved ...))

(fn love.mousepressed [...] 
  (local game (cart:mousepressed ...))
  (when game 
    (let [view    (Vec:new 1600 1200)
          render  (CRT:new game)
          fitto   (/ view render.res)
          larger  (math.min fitto.x fitto.y)]
      (set upscale larger)
      (set screen render))))
