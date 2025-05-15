(local Vec (require :src.vec))
(local Game {}) (set Game.__index Game)

(fn Game.new [! keys rebind!] 
  (let [units     (Vec:new 266 200)
        gradient  (love.image.newImageData 1 2)
        ctrl      (love.graphics.newImage :img/ctrl.png)
        map       (love.graphics.newImage :img/map.png)
        sx        (/ units.x (ctrl:getWidth) 1.1)
        sy        (/ units.y (ctrl:getHeight) 1.1)
        s         (Vec:new sx sy)
        cx        (/ (- units.x (* (ctrl:getWidth) sx)) 2)
        cy        (* (- units.y (* (ctrl:getHeight) sy)) 2)
        c         (Vec:new cx cy)
        lb        {:x 75    :y 34   :a :left}
        l         {:x 75    :y 58   :a :left}
        u         {:x 75    :y 78   :a :left}
        r         {:x 75    :y 98   :a :left}
        d         {:x 75    :y 118  :a :left}
        rb        {:x -85   :y 34   :a :right}
        a         {:x -85   :y 58   :a :right}
        x         {:x -85   :y 78   :a :right}
        y         {:x -85   :y 98   :a :right}    
        b         {:x -85   :y 118  :a :right}
        start     {:x -148  :y 155  :a :right}
        select    {:x 138   :y 155  :a :left}
        maps      { : lb : rb : l : u : r : d : start : select 
                    : x : y : a : b}
        g {: units : ctrl : map : s : c : maps : rebind!}]
    (gradient:setPixel 0 0 (/ 220 255) (/ 89 255) (/ 157 255))
    (gradient:setPixel 0 1 (/ 89 255) (/ 157 255) (/ 220 255))
    (set g.grad (love.graphics.newImage gradient))
    (each [name hid (pairs keys)] 
      (set (. g.maps name :hid) hid))
    (each [name m (pairs maps)] (set m.w 42) (set m.h 12))
    (setmetatable g !)))

(fn Game.draw [! scale]
  (love.graphics.draw !.grad 0 0 0 !.units.x (/ !.units.y 2))
  (love.graphics.setBlendMode :screen :premultiplied)
  (love.graphics.draw !.ctrl !.c.x !.c.y 0 !.s.x !.s.y)
  (love.graphics.draw !.map !.c.x !.c.y 0 !.s.x !.s.y)
  (love.graphics.setBlendMode :alpha)
  (each [name m (pairs !.maps)]
    (let [x (if (= m.a :right) (- (+ m.x !.units.x) m.w) m.x)
          hid m.hid
          hid (if (= (type hid) :number) (.. :mouse hid) hid)]
      (if m.hovering (love.graphics.setColor 0 0 0 0.33)
        (if m.selected  (love.graphics.setColor 0 0 0 0.99)
                        (love.graphics.setColor 1 1 1 0.66)))
      (love.graphics.rectangle :fill x m.y m.w m.h)
      (if m.hovering (love.graphics.setColor 1 1 1 0.33)
        (if m.selected  (love.graphics.setColor 1 1 1 0.99)
                        (love.graphics.setColor 0 0 0 0.66)))
      (love.graphics.printf hid m.x m.y !.units.x m.a)))
  (love.graphics.setColor 1 1 1 1)
  (love.graphics.printf (.. 
    "welcome to our spring lisp game jam submission\n"
    "to remap your controller, click on a box below,"
    "then press any key or mouse button"
    "-- will not rebind anything already bound")
    0 0 !.units.x :center))

(fn Game.mousemoved [! x y]
  (each [name m (pairs !.maps)]
    (let [mx (if (= m.a :right) (- (+ m.x !.units.x) m.w) m.x)]
      (if (and  (> x mx) (< x (+ mx m.w))
                (> y m.y) (< y (+ m.y m.h)))
        (set m.hovering (not m.selected))
        (set m.hovering false)))))

(fn Game.mousepressed [! x y click]
  (if !.rebinding? 
    (!:rebind click)
    (each [name m (pairs !.maps)]
      (let [mx m.x
            mx (if (= m.a :right) (- (+ mx !.units.x) m.w) mx)]
        (when (and  (> x mx) (< x (+ mx m.w))
                    (> y m.y) (< y (+ m.y m.h)))
          (each [name m (pairs !.maps)]
            (set (m.selected m.hovering) (values false false)))
          (set (. !.maps name :selected) true)
          (set !.rebinding? name))))))

(fn Game.keypressed [! k] (when !.rebinding? (!:rebind k)))

(fn Game.rebind [! binding]
  (var mt? true)
  (each [name m (pairs !.maps)]
      (set (m.selected m.hovering) (values false false))
      (set mt? (and mt? (not= m.hid binding))))
  (when mt? (!.rebind! !.rebinding? binding)
            (set (. !.maps !.rebinding? :hid) binding))
  (set !.rebinding? nil))

Game
