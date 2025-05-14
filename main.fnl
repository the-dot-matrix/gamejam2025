(local CART (require :src.CART))
(local CRT (require :src.CRT))
(local CTRL (require :src.CTRL))
(local Vec (require :src.vec))
(var (FONT font cart crt ctrl game frame sdown sup) (values))

(fn boot [Game]
  (set game (Game:new ctrl.mapO))
  (let [view    (Vec:new 1600 1200)
        render  (CRT:new game)
        fitto   (/ view render.res)
        larger  (math.min fitto.x fitto.y)]
    (set sup larger)
    (set crt render)
    (ctrl:register game)))

(fn love.load []
  (let [image   (love.graphics.newImage :img/overlay.png)
        res     (Vec:new (image:getWidth) (image:getHeight))
        (w h)   (love.graphics.getDimensions)
        display (Vec:new w h)
        fitto   (/ display res)
        smaller (math.min fitto.x fitto.y)
        win     (* res smaller)]
    (set FONT (love.graphics.newFont 42))
    (set font (love.graphics.newFont 9 :mono))
    (font:setFilter :nearest)
    (set sdown smaller)
    (set frame image)
    (set cart (CART:new sdown))
    (set ctrl (CTRL:new))
    (boot (cart:update :_controller))))

(fn love.update [dt] (when crt (crt:update dt)))

(fn love.draw []
  (love.graphics.push)
  (love.graphics.scale sdown sdown)
  (love.graphics.push)
  (love.graphics.translate 900 50)
  (love.graphics.scale sup sup)
  (love.graphics.setFont font)  
  (when crt (crt:draw))
  (love.graphics.pop)
  (love.graphics.setFont FONT)
  (love.graphics.draw frame)
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
  (when Game (boot Game))
  (ctrl:mousepressed ...))

(fn love.mousereleased [...] (ctrl:mousereleased ...))
