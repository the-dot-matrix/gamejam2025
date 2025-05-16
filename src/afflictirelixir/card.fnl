(local Humor (require :src.afflictirelixir.humor))
(local Tile (require :src.afflictirelixir.tile))
(local Card {:w 2 :h 3}) (set Card.__index Card)

(fn Card.new [! humor]
  (setmetatable {: humor} !))

(fn Card.update [! dt])

(fn Card.draw [! x y]
  (love.graphics.setColor (. Humor.color !.humor.name))
  (love.graphics.rectangle :fill 
    (* x Tile.size) (* y Tile.size) 
    (* Card.w Tile.size) (* Card.h Tile.size))
  (love.graphics.setColor 0 0 0 1)
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
