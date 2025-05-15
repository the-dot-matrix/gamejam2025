(local CART {}) (set CART.__index CART)

(fn CART.new [!]
  (local ! (setmetatable {} !))
  (let [files   (love.filesystem.getDirectoryItems :src)
        (x w h)   (values 165 380 48)]
    (set !.games [])
    (var g 1)
    (each [i name (ipairs files)] (when 
      (love.filesystem.getInfo (.. :src/ name) :directory) 
      (tset !.games name {: x :y (* (+ g 1) h -1) : w : h})
      (set g (+ g 1))))
    (set !.texttrans (love.math.newTransform 
      0 0 (/ math.pi 2)))
    !))

(fn CART.update [! name]
  (each [name g (pairs !.games)] 
    (set (g.selected g.hovering) (values false false)))
  (set (. !.games name :selected) true)
  (require (.. :src. name :.game)))

(fn CART.draw [!]
  (love.graphics.push)
  (love.graphics.applyTransform !.texttrans)
  (each [name g (pairs !.games)]
    (if g.hovering (love.graphics.setColor 0 0 0 0.2)
      (if g.selected  (love.graphics.setColor 0 0 0 0.8)
                      (love.graphics.setColor 1 1 1 0.4)))
    (love.graphics.rectangle :fill g.x g.y g.w g.h)
    (if g.hovering (love.graphics.setColor 1 1 1 0.2)
      (if g.selected  (love.graphics.setColor 1 1 1 0.8)
                      (love.graphics.setColor 0 0 0 0.4)))
    (love.graphics.print name g.x g.y))
  (love.graphics.setColor 1 1 1 1)
  (love.graphics.pop))

(fn CART.mousemoved [! x y]
  (each [name g (pairs !.games)]
    (local (tx ty) (!.texttrans:inverseTransformPoint x y))
    (if (and  (> tx g.x) (< tx (+ g.x g.w))
              (> ty g.y) (< ty (+ g.y g.h)))
      (set g.hovering (not g.selected))
      (set g.hovering false))))

(fn CART.mousepressed [! x y]
  (var game nil)
  (each [name g (pairs !.games)]
    (local (tx ty) (!.texttrans:inverseTransformPoint x y))
    (when (and  (> tx g.x) (< tx (+ g.x g.w))
                (> ty g.y) (< ty (+ g.y g.h)))
      (set game name)))
  game)

CART
