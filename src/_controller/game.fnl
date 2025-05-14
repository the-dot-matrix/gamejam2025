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
        pos { :lb (Vec:new -20 35)  :rb (Vec:new 20 35) 
              :l (Vec:new -40 50)   :u (Vec:new -40 70) 
              :r (Vec:new -40 90)   :d (Vec:new -40 110)
              :start (Vec:new -40 140) :select (Vec:new 30 140)
              :x (Vec:new 20 90)    :y (Vec:new 20 70)
              :a (Vec:new 60 125)   :b (Vec:new 60 145)}
        game {: units : ctrl : map : s : c : keys : pos}]
    (gradient:setPixel 0 0 (/ 220 255) (/ 89 255) (/ 157 255))
    (gradient:setPixel 0 1 (/ 89 255) (/ 157 255) (/ 220 255))
    (local ! (setmetatable game !))
    (set !.g (love.graphics.newImage gradient))
    !))

(fn Game.update [! dt])

(fn Game.draw [! scale]
  (love.graphics.draw !.g 0 0 0 !.units.x (/ !.units.y 2))
  (love.graphics.setBlendMode :screen :premultiplied)
  (love.graphics.draw !.ctrl !.c.x !.c.y 0 !.s.x !.s.y)
  (love.graphics.draw !.map !.c.x !.c.y 0 !.s.x !.s.y)
  (love.graphics.setBlendMode :alpha)
  (love.graphics.printf (.. 
    "Welcome to our Spring Lisp Game Jam Submission\n"
    "To remap your controller, click on the boxes below,\n"
    "then press any key or mouse button")
    0 0 !.units.x :center)
  (each [ctrl hid (pairs !.keys)]
    (local p (. !.pos ctrl))
    (love.graphics.printf hid 
      p.x p.y !.units.x :center)))

Game
