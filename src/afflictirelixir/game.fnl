(local Vec (require :src.vec))
(local Line (require :src.line))
(local Wall (require :src.afflictirelixir.wall))
(local Entity (require :src.afflictirelixir.entity))
(local Spawner (require :src.spawner))
(local Hand (require :src.afflictirelixir.hand))
(local Status (require :src.afflictirelixir.status))
(local Humor (require :src.afflictirelixir.humor))
(local Game {}) (set Game.__index Game)

(fn tIndex [a ...]
  (local tileLength 16)
  (if a (unpack [(* a 16) (tIndex ...)]) nil))
(fn spawnBox [spawner x1 y1 x2 y2]
  (for [x x1 x2 1] (spawner:spawn (tIndex x y1)))
  (for [x x1 x2 1] (spawner:spawn (tIndex x y2)))
  (for [y y1 y2 1] (spawner:spawn (tIndex x1 y)))
  (for [y y1 y2 1] (spawner:spawn (tIndex x2 y))))

(fn Game.new [!]
  (local ! (setmetatable {} !))
  (set !.area (Vec:new 256 192))
  (set !.border (Vec:new 3 4))
  (set !.units (+ !.area (* !.border 2)))
  (set !.hand (Hand:new 0 1))
  (set !.status (Status:new 2 7))
  (set !.walls (Spawner:new Wall))
  (local (left up right down) (values 6 1 15 11))
  (spawnBox !.walls left up right down)
  (set !.entities [])
  (set !.heart    (Entity:new :heart    1 1   :enemy))
  (set !.brain    (Entity:new :brain    8 1   :enemy))
  (set !.spleen   (Entity:new :spleen   1 9  :enemy))
  (set !.galblad  (Entity:new :galblad  8 9  :enemy))
  (set !.wizard   (Entity:new :wizard   4 5   :chara (!.walls:query :collide?)))
  (set !.entities [!.heart !.brain !.spleen !.galblad !.wizard])
  (fn Game.grabETypeEntity [entities eType]
    (icollect [_ v (ipairs entities)] (if (= v.eType eType) v)))
  (fn setAnimEnemy [entities]
    (each [_ v (ipairs (!.grabETypeEntity entities :enemy))]
      (v:genAnim {:static [1 6] :walk [7 12]})))
  (setAnimEnemy !.entities)
  ;;setStateEnemy useful for future in game.update potentially
  (fn setStateEnemy [entities state]
    (each [_ v (ipairs (!.grabETypeEntity entities :enemy))]
      (v:setState state)))
  (setStateEnemy !.entities :walk) ;; swap between :walk and :static
  (set !.bg       (Entity:new))
  !)

(fn Game.update [! dt]
  (each [_ v (ipairs !.entities)]
    (v:update dt)))

(fn Game.draw [! scale]
  (love.graphics.clear 0.65 0.65 0.65)
  (love.graphics.push)
  (love.graphics.translate 
    (* scale !.border.x)
    (* scale !.border.y))
  (love.graphics.push)
  (love.graphics.translate (* -16 0.125) (* -16 0.625))
  ;; entity draws
  (love.graphics.push)
  (love.graphics.scale scale scale)
  (!.walls:draw)
  (each [_ v (ipairs !.entities)] (v:draw))
  (love.graphics.push)
  (love.graphics.translate (/ 16 2) (/ 16 8))
  (!.hand:draw)
  (love.graphics.pop)
  (!.status:draw)
  (love.graphics.pop)
  ;; end of entity draws
  (love.graphics.pop)
  (love.graphics.pop))

(fn Game.keypressed [! key]
  (when (= key :y) (!.hand:update (Humor.random)))
  (each [_ v (ipairs !.entities)]
    (v:keypressed key)))

(fn Game.keyreleased [! key]
  (each [_ v (ipairs !.entities)]
    (v:keyreleased key)))

Game
