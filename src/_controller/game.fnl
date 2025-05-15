(local Vec (require :src.vec))
(local Game {}) (set Game.__index Game)

(fn Game.new [! keys] 
  (let [units     (Vec:new 266 200)
        gradient  (love.image.newImageData 1 2)
        ctrl      (love.graphics.newImage :img/ctrl.png)
        map       (love.graphics.newImage :img/map.png)
        sx        (/ units.x (ctrl:getWidth) 1.1)
        sy        (/ units.y (ctrl:getHeight) 1.1)
        s         (Vec:new sx sy)
        cx        (/ (- units.x (* (ctrl:getWidth) sx)) 2)
        cy        (* (- units.y (* (ctrl:getHeight) sy)) 2)
        c         (Vec:new cx cy)
        lb        {:x 75    :y 34   :a :left}
        l         {:x 75    :y 58   :a :left}
        u         {:x 75    :y 78   :a :left}
        r         {:x 75    :y 98  :a :left}
        d         {:x 75    :y 118  :a :left}
        rb        {:x -85   :y 34   :a :right}
        a         {:x -85   :y 58   :a :right}
        x         {:x -85   :y 78   :a :right}
        y         {:x -85   :y 98  :a :right}    
        b         {:x -85   :y 118  :a :right}
        start     {:x -148  :y 155  :a :right}
        select    {:x 138   :y 155  :a :left}
        maps      { : lb : rb : l : u : r : d : start : select 
                    : x : y : a : b}
        g {: units : ctrl : map : s : c : keys : maps}]
    (gradient:setPixel 0 0 (/ 220 255) (/ 89 255) (/ 157 255))
    (gradient:setPixel 0 1 (/ 89 255) (/ 157 255) (/ 220 255))
    (set g.grad (love.graphics.newImage gradient))
    (setmetatable g !)))

(fn Game.update [! dt])

(fn Game.draw [! scale]
  (love.graphics.draw !.grad 0 0 0 !.units.x (/ !.units.y 2))
  (love.graphics.setBlendMode :screen :premultiplied)
  (love.graphics.draw !.ctrl !.c.x !.c.y 0 !.s.x !.s.y)
  (love.graphics.draw !.map !.c.x !.c.y 0 !.s.x !.s.y)
  (love.graphics.setBlendMode :alpha)
  (each [ctrl i (pairs !.keys)]
    (let [a     (. !.maps ctrl :a)
          (w h) (values 42 12)
          x     (. !.maps ctrl :x)
          x     (if (= a :right) (- (+ x !.units.x) w) x)
          y     (. !.maps ctrl :y)]
    (love.graphics.setColor 0 0 0 0.5)
    (love.graphics.rectangle :fill x y w h)
    (love.graphics.setColor 1 1 1 1)
    (love.graphics.printf i (. !.maps ctrl :x) y !.units.x a)))
  (love.graphics.printf (.. 
    "welcome to our spring lisp game jam submission\n"
    "to remap your controller, click on the boxes below,\n"
    "then press any key or mouse button")
    0 0 !.units.x :center))

Game
