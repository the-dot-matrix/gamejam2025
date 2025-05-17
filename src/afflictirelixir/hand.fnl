(local Card (require :src.afflictirelixir.card))
(local Tile (require :src.afflictirelixir.tile))
(local Hand {}) (set Hand.__index Hand)

(fn Hand.new [! x y usecard]
  (setmetatable {: x : y :cards [] : usecard} !))

(fn Hand.update [! humor]
  (if humor (table.insert !.cards (Card:new humor))
            (when (> (length !.cards) 0) 
                  (!.usecard (table.remove !.cards 
                                (length !.cards))))))

(fn Hand.draw [!]
  (love.graphics.setColor 1 1 1 1)
  (love.graphics.print  :bottom 
    (* !.x Tile.size) (* (- !.y 0.875) Tile.size))
  (love.graphics.printf :top    
    !.x (* (- !.y 0.875) Tile.size)
    (* Card.w 2.5 Tile.size) :right)
  (love.graphics.rectangle :line 
    (* !.x Tile.size) (* !.y Tile.size) 
    (* Card.w 2.5 Tile.size) (* Card.h Tile.size))
  (let [C (length !.cards)
        offset #(+ Card.w (* (- $1 2) (/ Card.w 2 (- C 2))))]
    (each [i card (ipairs !.cards)] (case i
      1 (card:draw !.x !.y)
      (where c (= c C)) (card:draw (+ !.x (* Card.w 1.5)) !.y)
      _ (card:draw (+ !.x (offset i)) !.y)))))

Hand
