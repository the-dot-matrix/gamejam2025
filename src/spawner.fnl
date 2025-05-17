(local Spawner {}) (set Spawner.__index Spawner)

(fn Spawner.new [! class query? delete?]
  (setmetatable {: class :spawns [] : query? : delete?} !))

(fn Spawner.update [! dt tick?]
  (each [A spawn (ipairs !.spawns)] 
    (when spawn.update (spawn:update dt tick? !.query?))))

(fn Spawner.draw [! scale]
  (each [_ spawn (ipairs !.spawns)] 
    (when spawn.draw (spawn:draw scale))))

(fn Spawner.spawn [! ...]
  (table.insert !.spawns (!.class:new ...)))

(fn Spawner.query [! f]
  (fn [...]
      (local deletes [])
      (local answers (icollect [i spawn (ipairs !.spawns)] 
        (do (local answer ((. spawn f) spawn ...))
            (when (and answer !.delete?) (table.insert deletes i))
            answer)))
      (each [_ i (ipairs deletes)]
        (table.remove !.spawns i))
      answers))

Spawner
