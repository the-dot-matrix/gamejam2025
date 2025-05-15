(local CART (require :src.CART))
(local CRT (require :src.CRT))
(local CTRL (require :src.CTRL))
(local Vec (require :src.vec))
(var (bad cart crt ctrl) (values))
(var (FONT font game frame sdown sup) (values))

(fn boot [name error? trace?]
  (local Game (cart:update name))
  (local cgame #(Game:new ctrl.mapO #(ctrl.update ctrl $1 $2)))
  (local egame #(Game:new error? trace?))
  (set game (case name
    :_controller_rebind (cgame)
    :_bad_screen_of_sad (egame)
    _ (Game:new)))
  (let [view    (Vec:new 1600 1200)
        render  (CRT:new game)
        fitto   (/ view render.res)
        larger  (math.min fitto.x fitto.y)
        t       (Vec:new 900 50)]
    (set sup (love.math.newTransform t.x t.y 0 larger larger))
    (set crt render)
    (ctrl:register game render.scale)))
(fn safe [f ...] 
  (let [bad #(boot :_bad_screen_of_sad $... (fennel.traceback))
        fixf  #(love.graphics.setCanvas)
        safef #(do (fixf) (bad $...))
        (a b) (if _G.DEBUG (f ...) (xpcall f safef ...))]
    (if _G.DEBUG a b)))

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
    (safe #(boot :_controller_rebind))))

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
  (local (ttx tty) (sup:inverseTransformPoint tx ty))
  (safe cart.mousemoved cart tx ty ...) 
  (safe ctrl.mousemoved ctrl ttx tty ...))

(fn love.mousepressed [x y ...] 
  (local (tx ty) (sdown:inverseTransformPoint x y))
  (local (ttx tty) (sup:inverseTransformPoint tx ty))
  (local name (safe cart.mousepressed cart tx ty ...))
  (safe ctrl.mousepressed ctrl ttx tty ...)
  (when name (safe #(boot name))))

(fn love.mousereleased [...] 
  (safe ctrl.mousereleased ctrl ...))
