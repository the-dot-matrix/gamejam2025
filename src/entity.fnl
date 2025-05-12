(local entity {}) (set entity.__index entity)

(fn entity.new [!]
 (let [x 100
       y 100
       w 50
       h 50]
       (setmetatable {: x : y : w : h} !)))

(fn entity.draw [!]
  (love.graphics.rectangle :line  !.x !.y !.w !.h))


entity