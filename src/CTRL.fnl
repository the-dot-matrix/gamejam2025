(local Vec (require :src.vec))
(local CTRL {}) (set CTRL.__index CTRL)

(fn CTRL.new [!]
  (let [offset (Vec:new 25 1075)
        mapO {:u :w       :r :d     :d :s       :l :a 
              :x :lshift  :y :space :a :return  :b :rshift
              :lb 1 :rb 2 :start :backspace :select :tab}
        o    #(pairs mapO) 
        mapI (accumulate [m {} k v (o)] (do (tset m v k) m))
        f   #(love.graphics.newImage (.. :img/ctrl/ $1 :.png))
        hi  (accumulate [m {} k v (o)] (do (tset m k (f k)) m))
        presses {}
        overlay (love.graphics.newImage :img/ctrl.png)
        ctrl {: offset : mapI : mapO : overlay : hi : presses}]
    (setmetatable ctrl !)))

(fn CTRL.update [! ctrl hid]
  (when (and (. !.mapO ctrl) hid) (tset !.mapO ctrl hid))
  (set !.mapI (accumulate [m {} k v (pairs !.mapO) ] 
    (do (tset m v k) m))))

(fn CTRL.draw [!]
  (love.graphics.push)
  (love.graphics.setColor 0.33 0.33 0.33 1)
  (love.graphics.setBlendMode :screen :premultiplied)
  (love.graphics.draw !.overlay !.offset.x !.offset.y)
  (love.graphics.setColor 0.66 0.66 0.66 1)
  (each [m pressed? (pairs !.presses)] (when pressed?
    (love.graphics.draw (. !.hi m) !.offset.x !.offset.y)))
  (love.graphics.setBlendMode :alpha)
  (love.graphics.setColor 1 1 1 1)
  (love.graphics.pop))

(fn CTRL.register [! handler? transform?]
  (set !.handler? handler?)
  (set !.transform? transform?)
  (set !.keypressed?    (. handler? :keypressed))
  (set !.keyreleased?   (. handler? :keyreleased))
  (set !.mousemoved?    (. handler? :mousemoved))
  (set !.mousepressed?  (. handler? :mousepressed)))

(fn CTRL.keypressed [! key]
  (let [mapped? (. !.mapI key)] 
    (when mapped? (set (. !.presses mapped?) true))
    (when (and !.handler? !.keypressed?) 
      (!.keypressed? !.handler? mapped? key))))

(fn CTRL.keyreleased [! key]
  (let [mapped? (. !.mapI key)] 
    (when mapped? (set (. !.presses mapped?) false))
    (when (and !.handler? !.keyreleased?) 
      (!.keyreleased? !.handler? mapped? key))))

(fn CTRL.mousemoved [! x y]
  (when (and !.handler? !.mousemoved?)
    (local (tx ty) (if !.transform? 
      (!.transform?:inverseTransformPoint x y)
      (values x y))) 
    (!.mousemoved? !.handler? tx ty)))

(fn CTRL.mousepressed [! x y click]
  (let [mapped? (. !.mapI click)] 
    (when mapped? (set (. !.presses mapped?) true)
      (when (and !.handler? !.keypressed?) 
        (!.keypressed? !.handler? mapped? click))))
  (when (and !.handler? !.mousepressed?)
    (local (tx ty) (if !.transform? 
      (!.transform?:inverseTransformPoint x y)
      (values x y))) 
    (!.mousepressed? !.handler? tx ty click)))

(fn CTRL.mousereleased [! x y click]
  (let [mapped? (. !.mapI click)] 
    (when mapped? (set (. !.presses mapped?) false)
      (when (and !.handler? !.handler? !.keyreleased?) 
        (!.keyreleased? !.handler? mapped? click)))))

CTRL
