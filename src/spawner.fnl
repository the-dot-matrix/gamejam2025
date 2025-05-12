(local Spawner {}) (set Spawner.__index Spawner)

(fn Spawner.new [! class query?]
  (setmetatable {: class :spawns [] : query?} !))

(fn Spawner.update [! dt tick?]
  (each [A spawn (ipairs !.spawns)] 
    (when spawn.update (spawn:update dt !.query?))))

(fn Spawner.draw [! scale]
  (each [_ spawn (ipairs !.spawns)] 
    (when spawn.draw (spawn:draw scale))))

(fn Spawner.spawn [! ...]
  (table.insert !.spawns (!.class:new ...)))

(fn Spawner.query [! f]
  #(icollect [_ spawn (ipairs !.spawns)] 
    ((. spawn f) spawn $...)))

Spawner
