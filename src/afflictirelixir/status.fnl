(local Card (require :src.afflictirelixir.card))
(local Tile (require :src.afflictirelixir.tile))
(local Humor (require :src.afflictirelixir.humor))
(local Status {}) (set Status.__index Status)

(fn Status.new [! x y addcard]
  (setmetatable {: x : y 
    :cards (accumulate [sum [] i h (ipairs Humor.humors)]
              (do (table.insert sum (Card:new h true)) sum))
    :cycle (love.graphics.newImage 
              :src/afflictirelixir/img/cycle.png)
    : addcard} 
    !))

(fn Status.update [! enemy hand]
  (local humor (or  (and hand hand.humor.name) 
                    (. Humor.byenemy enemy)))
  (each [i card (ipairs !.cards)]
    (when (= card.humor.name humor)
      (local s (% (+ i -1 1) (length !.cards)))
      (local strong (. !.cards (+ s 1)))
      (if (not strong.down?) 
        (when (not hand) (!.addcard card.humor))
        (do (when (not hand) (card:update false))
            (local w (% (+ i -1 (- (length !.cards) 1)) 
                        (length !.cards)))
            (local weak (. !.cards (+ w 1)))
            ((. weak :update) weak true))))))

(fn Status.draw [!]
  (each [i c (ipairs !.cards)] (case i
    1 nil
    2 (c:draw !.x (+ !.y 2.625))
    3 (c:draw (- !.x 1.75) !.y)
    4 (c:draw !.x (- !.y 2.625))))
  (love.graphics.stencil #((. !.cards 2 :draw) (. !.cards 2) 
    !.x (+ !.y 2.625)))
  (love.graphics.setStencilTest :less 1)
  ((. !.cards 1 :draw) (. !.cards 1) (+ !.x 1.75) !.y)
  (love.graphics.setStencilTest)
  (love.graphics.push)
  (love.graphics.rotate (/ math.pi 16))
  (love.graphics.setBlendMode :screen)
  (love.graphics.draw !.cycle 
    (* (+ !.x 0.5) Tile.size) (* (- !.y 1.25) Tile.size))
  (love.graphics.setBlendMode :alpha)
  (love.graphics.pop))

Status
