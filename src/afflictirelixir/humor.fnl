(local Humor {
  ;TODO EGA16 colors
  :humors [ {:name :blood   :color [1 0 0 1]}
            {:name :yellow  :color [1 1 0 1]} 
            {:name :black   :color [0 0 1 1]} 
            {:name :phlegm  :color [0 1 0 1]}]})
(set Humor.color 
  { (. Humor.humors 1 :name) (. Humor.humors 1 :color)
    (. Humor.humors 2 :name) (. Humor.humors 2 :color)
    (. Humor.humors 3 :name) (. Humor.humors 3 :color)
    (. Humor.humors 4 :name) (. Humor.humors 4 :color)})
(set Humor.__index Humor)

(fn Humor.random []
  (. Humor.humors (love.math.random 1 (length Humor.humors))))

Humor
