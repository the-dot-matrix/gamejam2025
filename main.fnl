(local CART (require :src.CART))
(local CRT (require :src.CRT))
(local CTRL (require :src.CTRL))
(local Vec (require :src.vec))
(var (FONT font cart crt ctrl game frame sdown sup) (values))

(fn boot [Game]
  (set game (Game:new ctrl.mapO #(ctrl.update ctrl $1 $2)))
  (let [view    (Vec:new 1600 1200)
        render  (CRT:new game)
        fitto   (/ view render.res)
        larger  (math.min fitto.x fitto.y)]
    (set sup (love.math.newTransform 900 50 0 larger larger))
    (set crt render)
    (ctrl:register game sup)))

(fn love.load []
  (let [image   (love.graphics.newImage :img/overlay.png)
        res     (Vec:new (image:getWidth) (image:getHeight))
        (w h)   (love.graphics.getDimensions)
        display (Vec:new w h)
        fitto   (/ display res)
        smaller (math.min fitto.x fitto.y)
        win     (* res smaller)]
    (set FONT (love.graphics.newFont 42))
    (set font (love.graphics.newFont 8 :mono))
    (font:setFilter :nearest)
    (set sdown (love.math.newTransform 0 0 0 smaller smaller))
    (set frame image)
    (set cart (CART:new smaller))
    (set ctrl (CTRL:new))
    (boot (cart:update :_controller))))

(fn love.update [dt] (when crt (crt:update dt)))

(fn love.draw []
  (love.graphics.push)
  (love.graphics.applyTransform sdown)
  (love.graphics.push)
  (love.graphics.applyTransform sup)
  (love.graphics.setFont font)  
  (when crt (crt:draw))
  (love.graphics.pop)
  (love.graphics.setFont FONT)
  (love.graphics.draw frame)
  (cart:draw)
  (ctrl:draw)
  (love.graphics.pop))

(fn love.keypressed [key ...] 
  (when (= key :escape) (love.event.push :quit))
  (ctrl:keypressed key ...))

(fn love.keyreleased [key ...] 
  (ctrl:keyreleased key ...))

(fn love.mousemoved [x y ...]
  (local (tx ty) (sdown:inverseTransformPoint x y))
  (cart:mousemoved tx ty ...) 
  (ctrl:mousemoved tx ty ...))

(fn love.mousepressed [x y ...] 
  (local (tx ty) (sdown:inverseTransformPoint x y))
  (local Game (cart:mousepressed tx ty ...))
  (ctrl:mousepressed tx ty ...)
  (when Game (boot Game)))

(fn love.mousereleased [...] (ctrl:mousereleased ...))
