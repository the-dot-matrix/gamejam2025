(local Vec (require :src.vec))
(local Game {}) (set Game.__index Game)

(fn Game.new [!] 
  (let [units (Vec:new 266 200)
        gradient (love.image.newImageData 1 2)
        g #(love.graphics.newImage gradient)]
    (gradient:setPixel 0 0 (/ 220 255) (/ 89 255) (/ 157 255))
    (gradient:setPixel 0 1 (/ 89 255) (/ 157 255) (/ 220 255))
    (setmetatable {: units :g (g)} !)))

(fn Game.update [! dt])

(fn Game.draw [! scale]
  (love.graphics.draw !.g 0 0 0 !.units.x (/ !.units.y 2)))

Game
