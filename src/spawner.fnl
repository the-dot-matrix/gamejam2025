(local Spawner {}) (set Spawner.__index Spawner)
(local Set (require "src.set"))

(fn Spawner.new [self class]
  (setmetatable {: class :spawns [] :repeat [] :soft []} self))

(fn Spawner.update [self dt tick?]
  (each [A spawn (ipairs self.spawns)]
    (when (and tick? (. self.soft A)) (self:resolve A spawn))
    (when (. self.soft A) (self:solve dt tick? A spawn))
    (spawn:update dt)))

(fn Spawner.draw [self]
  (each [_ spawn (ipairs self.spawns)] (spawn:draw)))

(fn Spawner.spawn [self softORhard ...]
  (table.insert self.spawns (self.class:new ...))
  (table.insert self.repeat {})
  (table.insert self.soft softORhard))

(fn Spawner.repeat? [self i check]
  (accumulate [repeat? false k _ (pairs (. self.repeat i))]
    (or repeat? (<= check k))))

(fn Spawner.solve [self dt tick? A spawn]
  (let [check (icollect [B other (ipairs self.spawns)]
                (when (not= A B) 
                  [B (. self.soft B) (spawn:collide? other)]))
        softs (Set:new  (icollect [_ c (ipairs check)]
                          (when (and (. c 3) (. c 2)) 
                            (. c 1))))
        hards (icollect [_ c (ipairs check)] 
                (when (not (. c 2)) (. c 3)))
        all   (icollect [_ c (ipairs check)] (. c 3))
        new?  (not (self:repeat? A softs))]
    (when (and tick? (> (softs:#) 0) new?)
      (spawn:solve dt all)
      (when (> (softs:#) 0) 
        (set (. self :repeat A softs) true)))
    (spawn:solve dt hards)))

(fn Spawner.resolve [self A spawn]
  (each [check _ (pairs (. self :repeat A))]
    (when (accumulate [no? true B v (pairs check)]
            (and no? (not (spawn:collide? (. self.spawns B)))))
      (set (. self :repeat A check) nil))))

(fn Spawner.onscreen [self w h]
  (let [inL     #(> $1.position.x 0)
        inU     #(> $1.position.y 0)
        inR     #(< (+ $1.position.x $1.size.x) w)
        inB     #(< (+ $1.position.y $1.size.y) h)
        inside  #(and (inL $1) (inU $1) (inR $1) (inB $1))]
    (accumulate [sum 0 _ v (ipairs self.spawns)]
      (if (inside v) (+ sum 1) sum))))

Spawner
