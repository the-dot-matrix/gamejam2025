(local CART (require :src.CART))
(local CRT (require :src.CRT))
(local CTRL (require :src.CTRL))
(local Vec (require :src.vec))
(var (cart crt ctrl game overlay downscale upscale) (values))

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
    (set cart (CART:new downscale))
    (set ctrl (CTRL:new))))

(fn love.update [dt] (when crt (crt:update dt)))

(fn love.draw []
  (love.graphics.push)
  (love.graphics.scale downscale downscale)
  (love.graphics.push)
  (love.graphics.translate 900 50)
  (love.graphics.scale upscale upscale)  
  (when crt (crt:draw))
  (love.graphics.pop)
  (love.graphics.draw overlay)
  (ctrl:draw)
  (love.graphics.pop)
  (cart:draw))

(fn love.keypressed [key ...] 
  (when (= key :escape) (love.event.push :quit))
  (ctrl:keypressed key ...))

(fn love.keyreleased [key ...] 
  (ctrl:keyreleased key ...))

(fn love.mousemoved [...] 
  (cart:mousemoved ...) 
  (ctrl:mousemoved ...))

(fn love.mousepressed [...] 
  (local Game (cart:mousepressed ...))
  (when Game 
    (set game (Game:new))
    (let [view    (Vec:new 1600 1200)
          render  (CRT:new game)
          fitto   (/ view render.res)
          larger  (math.min fitto.x fitto.y)]
      (set upscale larger)
      (set crt render)
      (ctrl:register game)))
  (ctrl:mousepressed ...))
