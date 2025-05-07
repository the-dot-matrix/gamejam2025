(local Spawner {}) (set Spawner.__index Spawner)

(fn Spawner.new [self class]
  (setmetatable {: class :spawns [] :unresolved []} self))

(fn Spawner.update [self dt tick?]
  (each [A spawn (ipairs self.spawns)]
    (spawn:update dt (icollect [B v (ipairs self.spawns)]
      (let [unresolved  (. self.unresolved A)
            collide?    (spawn:collide? v)]
        (when (and tick? (not= A B))
          (when (not collide?) (set (. unresolved B) false)) 
          (when (and collide? (not (. unresolved B)))
            (set (. unresolved B) true)
            collide?)))))))

(fn Spawner.draw [self]
  (each [_ spawn (ipairs self.spawns)] (spawn:draw)))

(fn Spawner.spawn [self ...]
  (table.insert self.spawns (self.class:new ...))
  (table.insert self.unresolved []))

Spawner
