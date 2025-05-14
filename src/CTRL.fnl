(local Vec (require :src.vec))
(local CTRL {}) (set CTRL.__index CTRL)

(fn CTRL.new [! scale]
  (let [offset (Vec:new 25 1075)
        mapO {:u :w       :r :d     :d :s       :l :a 
              :x :lshift  :y :space :a :return  :b :rshift
              :lb 1 :rb 2 :start :backspace :select "`"}
        o    #(pairs mapO) 
        mapI (accumulate [m {} k v (o)] (do (tset m v k) m))
        f   #(love.graphics.newImage (.. :img/ctrl/ $1 :.png))
        hi  (accumulate [m {} k v (o)] (do (tset m k (f k)) m))
        presses {}
        overlay (love.graphics.newImage :img/ctrl.png)
        ctrl {: offset : mapI : mapO : overlay : hi : presses}]
    (setmetatable ctrl !)))

(fn CTRL.draw [!]
  (love.graphics.push)
  (love.graphics.setColor 0.4 0.4 0.4 1)
  (love.graphics.setBlendMode :screen :premultiplied)
  (love.graphics.draw !.overlay !.offset.x !.offset.y)
  (love.graphics.setColor 0.8 0.8 0.8 1)
  (each [m pressed? (pairs !.presses)] (when pressed? 
    
    (love.graphics.draw (. !.hi m) !.offset.x !.offset.y)))
  (love.graphics.setBlendMode :alpha)
  (love.graphics.pop))

(fn CTRL.register [! handler?]
  (set !.handler? handler?)
  (set !.keypressed? (. handler? :keypressed))
  (set !.keyreleased? (. handler? :keyreleased)))

(fn CTRL.keypressed [! key]
  (let [mapped? (. !.mapI key)] 
    (when mapped? (set (. !.presses mapped?) true)
      (when (and !.handler? !.keypressed?) 
        (!.keypressed? !.handler? mapped?)))))

(fn CTRL.keyreleased [! key]
  (let [mapped? (. !.mapI key)] 
    (when mapped? (set (. !.presses mapped?) false)
      (when (and !.handler? !.keyreleased?) 
        (!.keyreleased? !.handler? mapped?)))))

(fn CTRL.mousemoved [! x y])

(fn CTRL.mousepressed [! x y click]
  (let [mapped? (. !.mapI click)] 
    (when mapped? (set (. !.presses mapped?) true)
      (when (and !.handler? !.keypressed?) 
        (!.keypressed? !.handler? mapped?)))))

(fn CTRL.mousereleased [! x y click]
  (let [mapped? (. !.mapI click)] 
    (when mapped? (set (. !.presses mapped?) false)
      (when (and !.handler? !.handler? !.keyreleased?) 
        (!.keyreleased? !.handler? mapped?)))))

CTRL
