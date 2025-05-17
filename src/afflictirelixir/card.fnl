(local Humor (require :src.afflictirelixir.humor))
(local Sprite (require :src.afflictirelixir.sprite))
(local Tile (require :src.afflictirelixir.tile))
(local Card {:w 2 :h 3}) (set Card.__index Card)

(fn Card.new [! humor facedown?]
  (setmetatable { :sprite (Sprite:new (. Humor.toenemy humor.name))
                  : humor 
                  :down? (or facedown? false)} !))

(fn Card.update [! down?] (set !.down? down?))

(fn Card.draw [! x y]
  (if !.down? (love.graphics.setColor 0 0 0 0.5)
    (love.graphics.setColor (. Humor.color !.humor.name)))
  (love.graphics.rectangle :fill 
    (* x Tile.size) (* y Tile.size) 
    (* Card.w Tile.size) (* Card.h Tile.size))
  (if !.down? (love.graphics.setBlendMode :subtract)
              (love.graphics.setBlendMode :add))
  (love.graphics.setColor 1 1 1 0.5)
  (!.sprite:draw  (* (+ x (/ Card.w 2) -0.5) Tile.size) 
                  (* (+ y (/ Card.w 2) -0.0) Tile.size) )
  (love.graphics.setBlendMode :alpha)
  (if !.down? (love.graphics.setColor 1 1 1 1)
    (love.graphics.setColor 0 0 0 1))
  (love.graphics.rectangle :line 
    (* x Tile.size) (* y Tile.size) 
    (* Card.w Tile.size) (* Card.h Tile.size))
  (love.graphics.setColor 1 1 1 1))

(fn Card.keypressed [! key]
  (each [_ v (ipairs !.entities)]
    (v:keypressed key)))

(fn Card.keyreleased [! key]
  (each [_ v (ipairs !.entities)]
    (v:keyreleased key)))

Card
