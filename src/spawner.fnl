(local Spawner {}) (set Spawner.__index Spawner)

(fn Spawner.new [self class query?]
  (setmetatable {: class :spawns [] : query?} self))

(fn Spawner.update [self dt tick?]
  (each [A spawn (ipairs self.spawns)] 
    (spawn:update dt self.query?)))

(fn Spawner.draw [self scale]
  (each [_ spawn (ipairs self.spawns)] 
    (spawn:draw scale)))

(fn Spawner.spawn [self ...]
  (table.insert self.spawns (self.class:new ...)))

(fn Spawner.query [self f]
  #(icollect [_ spawn (ipairs self.spawns)] 
    ((. spawn f) spawn $...)))

Spawner
