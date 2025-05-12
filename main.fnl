(local game (require :src.game))
(local entity (require :src.entity))
(var bob nil)
(fn love.load []
  (set bob (entity:new))
  (each [k v (pairs bob)]
    (print k v))
  )

(fn love.update [dt] )

(fn love.draw []
  (bob:draw)
  )

(fn love.keypressed [key] 
  (when (= key :escape) (love.event.push :quit)))
