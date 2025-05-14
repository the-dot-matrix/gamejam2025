(local Vec (require :src.vec))
(local Game {}) (set Game.__index Game)

(fn Game.new [!] 
  (let [units (Vec:new 266 200)
        gradient (love.image.newImageData 1 2)
        g #(love.graphics.newImage gradient)
        ctrl (love.graphics.newImage :img/ctrl.png)
        map (love.graphics.newImage :img/map.png)
        sx (/ units.x (ctrl:getWidth) 1.1)
        sy (/ units.y (ctrl:getHeight) 1.1)
        s (Vec:new sx sy)
        cx (/ (- units.x (* (ctrl:getWidth) sx)) 2)
        cy (* (- units.y (* (ctrl:getHeight) sy)) 2)
        c (Vec:new cx cy)]
    (gradient:setPixel 0 0 (/ 220 255) (/ 89 255) (/ 157 255))
    (gradient:setPixel 0 1 (/ 89 255) (/ 157 255) (/ 220 255))
    (setmetatable {: units :g (g) : ctrl : map : s : c} !)))

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
    0 0 !.units.x :center))

Game
