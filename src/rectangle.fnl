(local Rectangle {}) (set Rectangle.__index Rectangle)
(local Vector (require :src.vector))

(fn Rectangle.new [self x y w h s]
  (let [size        (Vector:new (or w 50) (or h 75))
        x           (or x (+ (* (love.math.random) 200) 50))
        y           (or y (+ (* (love.math.random) 200) 50))
        position    (Vector:new x y)
        speed       (or s (+ (* (love.math.random) 400) 100))
        direction   (* (love.math.random) 2 math.pi)
        velocity    (Vector:new speed direction true)
        rectangle   {: size : position : velocity :mode :line}]
    (setmetatable rectangle self)))

(fn Rectangle.update [self dt]
  (when self.newvelocity
    (set self.velocity self.newvelocity)
    (set self.newvelocity nil))
  (set self.position (+ self.position (* self.velocity dt))))

(fn Rectangle.solve [self dt collides]
  (when (and (> (length collides) 0) (> (self.velocity:#) 0))
    (set self.newvelocity (self:bounces collides))
    (set self.mode :fill))
  (when (= (length collides) 0) (set self.mode :line)))

(fn Rectangle.draw [self collides]
  (let [(x y) (values self.position.x self.position.y)
        (w h) (values self.size.x self.size.y)]
    (love.graphics.rectangle self.mode x y w h)))

(fn Rectangle.collide? [self other]
  (let [left      #$1.position.x
        right     #(+ $1.position.x $1.size.x)
        top       #$1.position.y
        bottom    #(+ $1.position.y $1.size.y)
        maxleft   (math.max (left self) (left other))
        minright  (math.min (right self) (right other))
        maxtop    (math.max (top self) (top other))
        minbottom (math.min (bottom self) (bottom other))
        width     (- minright maxleft)
        height    (- minbottom maxtop)
        size      (Vector:new width height)
        position  (Vector:new maxleft maxtop)
        collide   {: size : position :velocity other.velocity}]
    (when (and (>= width 1) (>= height 1)) collide)))

(fn Rectangle.bounces [self collides]
  (let [count (length collides)
        sum   (accumulate [sum 0 _ collide (ipairs collides)] 
                (self:bounce collide sum))]
    (Vector:new (self.velocity:#) (/ sum count) true)))

(fn Rectangle.bounce [self collide sum]
  (let [center  #(+ $1.position (/ $1.size 2))
        push    (- (center self) (center collide))
        reflect (self.velocity:orient push)]
    (if (not= (collide.velocity:#) 0)
      (+ sum (push:polar))
      (+ sum (reflect:polar)))))

Rectangle
