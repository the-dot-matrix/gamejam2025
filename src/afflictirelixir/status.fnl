(local Card (require :src.afflictirelixir.card))
(local Tile (require :src.afflictirelixir.tile))
(local Humor (require :src.afflictirelixir.humor))
(local Status {}) (set Status.__index Status)

(fn Status.new [! x y]
  (setmetatable {: x : y 
    :cards (accumulate [sum [] i h (ipairs Humor.humors)]
              (do (table.insert sum (Card:new h)) sum))} 
    !))

(fn Status.update [! humor])

(fn Status.draw [!]
  (each [i c (ipairs !.cards)] (case i
    1 (c:draw (+ !.x 1.75) !.y)
    2 (c:draw !.x (+ !.y 2.625))
    3 (c:draw (- !.x 1.75) !.y)
    4 (c:draw !.x (- !.y 2.625))))
  (love.graphics.stencil #((. !.cards 2 :draw) (. !.cards 2) 
    !.x (+ !.y 2.625)))
  (love.graphics.setStencilTest :less 1)
  ((. !.cards 1 :draw) (. !.cards 1) (+ !.x 1.75) !.y)
  (love.graphics.setStencilTest))

Status
