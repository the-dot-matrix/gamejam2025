(local CART {}) (set CART.__index CART)

(fn CART.new [! scale]
  (local ! (setmetatable {} !))
  (let [files   (love.filesystem.getDirectoryItems :src)]
    (set !.games [])
    (each [_ name (ipairs files)] (when 
      (love.filesystem.getInfo (.. :src/ name) :directory) 
      (table.insert !.games {: name :x 165 :w 380 :h 48})))
    (each [i game (ipairs !.games)] 
      (set game.y (* (+ i 1) game.h -1)))
    (set !.texttrans (love.math.newTransform 0 0 (/ math.pi 2)
      scale scale))
    (set !.scale !.scale)
    !))

(fn CART.draw [!]
  (love.graphics.push)
  (love.graphics.applyTransform !.texttrans)
  (each [i g (ipairs !.games)]
    (if g.hovering (love.graphics.setColor 0 0 0 0.3)
      (if g.selected  (love.graphics.setColor 0 0 0 0.9)
                      (love.graphics.setColor 1 1 1 0.6)))
    (love.graphics.rectangle :fill g.x g.y g.w g.h)
    (if g.hovering (love.graphics.setColor 1 1 1 0.3)
      (if g.selected  (love.graphics.setColor 1 1 1 0.9)
                      (love.graphics.setColor 0 0 0 0.6)))
    (love.graphics.print g.name g.x g.y))
  (love.graphics.setColor 1 1 1 1)
  (love.graphics.pop))

(fn CART.mousemoved [! x y]
  (each [i g (ipairs !.games)]
    (local (tx ty) (!.texttrans:inverseTransformPoint x y))
    (if (and  (> tx g.x) (< tx (+ g.x g.w))
              (> ty g.y) (< ty (+ g.y g.h)))
      (set g.hovering (not g.selected))
      (set g.hovering false))))

(fn CART.mousepressed [! x y]
  (var game nil)
  (each [i g (ipairs !.games)]
    (local (tx ty) (!.texttrans:inverseTransformPoint x y))
    (when (and  (> tx g.x) (< tx (+ g.x g.w))
                (> ty g.y) (< ty (+ g.y g.h)))
      (each [i g (ipairs !.games)] 
        (set (g.selected g.hovering) (values false false)))
        (set g.selected true)
        (set game (require (.. :src. g.name :.game)))))
  game)

CART
