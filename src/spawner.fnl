(local Spawner {}) (set Spawner.__index Spawner)
(local Set (require "src.set"))

(fn Spawner.new [self class]
  (setmetatable {: class :spawns [] :repeats {}} self))

(fn Spawner.update [self dt tick?]
  (each [A spawn (ipairs self.spawns)]
    (when tick? (self:resolve A spawn)) 
    (self:solve dt tick? A spawn)))

(fn Spawner.draw [self]
  (each [_ spawn (ipairs self.spawns)] (spawn:draw)))

(fn Spawner.spawn [self ...]
  (table.insert self.spawns (self.class:new ...))
  (table.insert self.repeats {}))

(fn Spawner.repeat? [self i check]
  (accumulate [repeat? false k _ (pairs (. self.repeats i))]
    (or repeat? (= check k))))

(fn Spawner.solve [self dt tick? A spawn]
  (let [checks  (icollect [B other (ipairs self.spawns)]
                  (when (not= A B) [B (spawn:collide? other)]))
        check   (Set:new  (icollect [_ c (ipairs checks)]
                            (when (. c 2) (. c 1))))
        collides  (icollect [_ c (ipairs checks)] (. c 2))
        repeat?   (self:repeat? A check)]
    (if (or (not tick?) (= (length collides) 0) repeat?)
        (spawn:update dt [])
        (do (spawn:update dt collides)
            (set (. self :repeats A check) true)))))

(fn Spawner.resolve [self A spawn]
  (each [check _ (pairs (. self :repeats A))]
    (when (accumulate [no? true B v (pairs check)]
            (and no? (not (spawn:collide? (. self.spawns B)))))
        (set (. self :repeats A check) nil))))

(fn Spawner.onscreen [self]
  (let [(w h) (love.graphics.getDimensions)]
    (var onscreen 0)
    (each [_ v (ipairs self.spawns)]
      (if (and (and (> v.position.x 0) (< (+ v.position.x 50) w))
              (and (> v.position.y 0) (< (+ v.position.y 75) h)))
      (set onscreen (+ onscreen 1))
      ))
  onscreen))

Spawner
