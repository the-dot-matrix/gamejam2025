(local Spawner {}) (set Spawner.__index Spawner)

(fn Spawner.new [self class]
  (setmetatable {: class :spawns []} self))

(fn Spawner.update [self dt]
  (each [iself spawn (ipairs self.spawns)]
    (spawn:update dt 
      (icollect [iother v (ipairs self.spawns)] 
        (when (and (not= iself iother)) (spawn:collide? v))))))

(fn Spawner.draw [self]
  (each [_ spawn (ipairs self.spawns)] (spawn:draw)))

(fn Spawner.spawn [self ...] 
  (table.insert self.spawns (self.class:new ...)))

Spawner
