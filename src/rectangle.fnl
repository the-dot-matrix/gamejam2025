(local Rectangle {}) (set Rectangle.__index Rectangle)
(local Vector (require :src.vector))

(fn Rectangle.new [self x y w h s]
  (let [size      (Vector:new (or w 50) (or h 75))
        x         (or x (+ (* (love.math.random) 200) 50))
        y         (or y (+ (* (love.math.random) 200) 50))
        distance  (Vector:new x y)
        speed     (or s (+ (* (love.math.random) 400) 100))
        direction (* (love.math.random) 2 math.pi)
        velocity  (Vector:new speed direction true)
        mode      :line
        rectangle {: size : distance : velocity : mode }]
    (setmetatable rectangle self)))

(fn Rectangle.update [self dt collides]
  (when self.newvelocity 
    (set self.velocity self.newvelocity)
    (set self.newvelocity nil))
  (set self.distance (+ self.distance (* self.velocity dt)))
  (when (and  (> (length collides) 0) 
              (> (self.velocity:mag) 0)
              (= self.mode :line)) 
    (do (set self.newvelocity (self:bounces collides))
        (set self.mode :fill)))
  (when (= (length collides) 0) (set self.mode :line)))

(fn Rectangle.draw [self collides]
  (let [(x y) (values self.distance.x self.distance.y)
        (w h) (values self.size.x self.size.y)]
    (love.graphics.rectangle self.mode x y w h)))

(fn Rectangle.collide? [self other]
  (let [left      #$1.distance.x
        right     #(+ $1.distance.x $1.size.x)
        top       #$1.distance.y
        bottom    #(+ $1.distance.y $1.size.y)
        maxleft   (math.max (left self) (left other))
        minright  (math.min (right self) (right other))
        maxtop    (math.max (top self) (top other))
        minbottom (math.min (bottom self) (bottom other))
        width     (- minright maxleft)
        height    (- minbottom maxtop)
        size      (Vector:new width height)
        distance  (Vector:new maxleft maxtop)
        collide   {: size : distance :velocity other.velocity}]
    (when (and (>= width 1) (>= height 1)) collide)))

(fn Rectangle.bounces [self cs]
  (let [flipx     (* self.velocity (Vector:new -1 1))
        flipy     (* self.velocity (Vector:new 1 -1))
        flipboth  (* self.velocity (Vector:new 1 -1))
        cwidth    (. cs 1 :size :x)
        cheight   (. cs 1 :size :y)
        init      (case [(length cs) cwidth cheight]
                    (where [1 w h] (< w h)) [(flipx:polar) 1]
                    (where [1 w h] (> w h)) [(flipy:polar) 1]
                    _ [0 0])
        accum     (accumulate [accum init _ c (ipairs cs)]
                    (self:bounce c accum))
        (sum cnt) (unpack accum)]
    (Vector:new (self.velocity:mag) (/ sum cnt) true)))

(fn Rectangle.bounce [self collide accum]
  (let [(sum count) (unpack accum)
        center      #(+ $1.distance (/ $1.size 2))
        direction   (- (center self) (center collide))
        unitvector  (/ direction (direction:mag))
        pushangle   (unitvector:polar)]
    (if (not= (collide.velocity:mag) 0)
      [(+ sum pushangle) (+ count 1)]
      [sum count])))

Rectangle
