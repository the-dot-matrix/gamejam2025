(local CART (require :src.CART))
(local CRT (require :src.CRT))
(local CTRL (require :src.CTRL))
(local Vec (require :src.vec))
(var (bad cart crt ctrl) (values))
(var (FONT font game frame sdown sup) (values))

(fn safe [f ...] 
  (let [fixf #(love.graphics.setCanvas)
        (_ result) (xpcall f #(do (fixf) (bad $...)) ...)]
    result))

(fn boot [name error? trace?]
  (local Game (safe #(cart:update name)))
  (local cgame #(Game:new ctrl.mapO #(ctrl.update ctrl $1 $2)))
  (local egame #(Game:new error? trace?))
  (set game (case name
    :_controller_rebind (safe #(cgame))
    :_bad_screen_of_sad (safe #(egame))
    _ (safe #(Game:new))))
  (let [view    (Vec:new 1600 1200)
        render  (safe #(CRT:new game))
        fitto   (/ view render.res)
        larger  (math.min fitto.x fitto.y)]
    (set sup (love.math.newTransform 900 50 0 larger larger))
    (set crt render)
    (safe #(ctrl:register game sup))))
(set bad #(boot :_bad_screen_of_sad $... (fennel.traceback)))

(fn love.load []
  (let [image   (love.graphics.newImage :img/overlay.png)
        res     (Vec:new (image:getWidth) (image:getHeight))
        (w h)   (love.graphics.getDimensions)
        display (Vec:new w h)
        fitto   (/ display res)
        smaller (math.min fitto.x fitto.y)
        win     (* res smaller)]
    (set FONT (love.graphics.newFont 36))
    (set font (love.graphics.newFont 8 :mono))
    (font:setFilter :nearest)
    (set sdown (love.math.newTransform 0 0 0 smaller smaller))
    (set frame image)
    (set cart (CART:new smaller))
    (set ctrl (CTRL:new))
    (boot :_controller_rebind)))

(fn love.update [dt] (when crt (safe #(crt:update dt))))

(fn love.draw []
  (love.graphics.push)
  (love.graphics.applyTransform sdown)
  (love.graphics.push)
  (love.graphics.applyTransform sup)
  (love.graphics.setFont font)  
  (when crt (safe #(crt:draw)))
  (love.graphics.pop)
  (love.graphics.setFont FONT)
  (love.graphics.draw frame)
  (safe #(cart:draw))
  (safe #(ctrl:draw))
  (love.graphics.pop))

(fn love.keypressed [key ...] 
  (when (= key :escape) (love.event.push :quit))
  (safe ctrl.keypressed ctrl key ...))

(fn love.keyreleased [key ...] 
  (safe ctrl.keyreleased ctrl key ...))

(fn love.mousemoved [x y ...]
  (local (tx ty) (sdown:inverseTransformPoint x y))
  (safe cart.mousemoved cart tx ty ...) 
  (safe ctrl.mousemoved ctrl tx ty ...))

(fn love.mousepressed [x y ...] 
  (local (tx ty) (sdown:inverseTransformPoint x y))
  (local name (safe cart.mousepressed cart tx ty ...))
  (safe ctrl.mousepressed ctrl tx ty ...)
  (when name (safe #(boot name))))

(fn love.mousereleased [...] 
  (safe ctrl.mousereleased ctrl ...))
