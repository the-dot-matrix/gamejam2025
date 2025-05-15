(local Vec (require :src.vec))
(local Game {}) (set Game.__index Game)

(fn Game.new [! error? trace?] 
  (let [units     (Vec:new 266 200)
        gradient  (love.image.newImageData 1 2)
        g {: units}]
    (gradient:setPixel 0 0 (/ 89 255) (/ 157 255) (/ 220 255))
    (gradient:setPixel 0 1 (/ 220 255) (/ 89 255) (/ 157 255))
    (set g.grad (love.graphics.newImage gradient))
    (set (!.msg !.trace) (values "no error reported" ""))
    (when error? (set !.msg error?))
    (when trace? (set !.trace trace?))
    (print !.msg)
    (print !.trace)
    (setmetatable g !)))

(fn Game.draw [! scale]
  (love.graphics.draw !.grad 0 0 0 !.units.x (/ !.units.y 2))
  (love.graphics.printf (.. 
    "oh no! one of the games crashed\t( u n u )\n"
    "please report this error to the developer, and\n"
    "you can re-run the game from a safe state by\n"
    "clicking its box on the shelf again\n\n")
    0 8 !.units.x :center)
  (love.graphics.printf (.. !.msg "\n" !.trace) 
    16 48 (/ !.units.x 2) :left))

Game
