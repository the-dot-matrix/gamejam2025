(local Humor {
  ;TODO EGA16 colors
  :humors [ {:name :blood   :color [1 0 0 1]}
            {:name :phlegm  :color [0 0 1 1]}
            {:name :yellow  :color [1 1 0 1]}
            {:name :black   :color [0 1 0 1]} ]})
(set Humor.color 
  { (. Humor.humors 1 :name) (. Humor.humors 1 :color)
    (. Humor.humors 2 :name) (. Humor.humors 2 :color)
    (. Humor.humors 3 :name) (. Humor.humors 3 :color)
    (. Humor.humors 4 :name) (. Humor.humors 4 :color)})
(set Humor.curedby
  { (. Humor.humors 1 :name) (. Humor.humors 2)
    (. Humor.humors 2 :name) (. Humor.humors 3)
    (. Humor.humors 3 :name) (. Humor.humors 4)
    (. Humor.humors 4 :name) (. Humor.humors 1)})
(set Humor.byenemy
  { :heart (. Humor.humors 1 :name)
    :brain (. Humor.humors 2 :name)
    :spleen (. Humor.humors 3 :name)
    :galblad (. Humor.humors 4 :name)})
(set Humor.__index Humor)

(fn Humor.random []
  (. Humor.humors (love.math.random 1 (length Humor.humors))))

Humor
