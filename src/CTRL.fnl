(local CTRL {}) (set CTRL.__index CTRL)

(fn CTRL.new [! scale]
  (let [mapO {:u :w       :r :d     :d :s     :l :a 
              :x :lshift  :y :space :a :return :b :rshift}
        o    #(pairs mapO) 
        mapI (accumulate [m {} k v (o)] (do (tset m v k) m))]
    (setmetatable {: mapI : mapO} !)))

(fn CTRL.draw [!]
  (love.graphics.push)
  (love.graphics.pop))

(fn CTRL.register [! handler?]
  (set !.handler? handler?)
  (set !.keypressed? (. handler? :keypressed))
  (set !.keyreleased? (. handler? :keyreleased)))

(fn CTRL.keypressed [! key]
  (let [mapped? (. !.mapI key)] 
    (when (and mapped? !.handler? !.keypressed?) 
      (!.keypressed? !.handler? mapped?))))

(fn CTRL.keyreleased [! key]
  (let [mapped? (. !.mapI key)] 
    (when (and mapped? !.handler? !.keyreleased?) 
      (!.keyreleased? !.handler? mapped?))))

(fn CTRL.mousemoved [! x y])

(fn CTRL.mousepressed [! x y click])

CTRL
