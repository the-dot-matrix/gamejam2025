(local Wall {}) (set Wall.__index Wall)
(local Vector (require "src.vector"))

(fn Wall.new [self x1 y1 x2 y2]
  (let [a (Vector:new x1 y1)
        b (Vector:new x2 y2)]
    (setmetatable {: a : b} self)))

(fn Wall.update [self])

(fn Wall.draw [self scale]
  (love.graphics.setColor 1 1 1 1)
  (love.graphics.line 
    (* self.a.x scale) (* self.a.y scale) 
    (* self.b.x scale) (* self.b.y scale)))

(fn Wall.intersect? [self Ba Bb Bsize]
  (let [normal  (Vector:new (- self.b.y self.a.y)
                            (- self.b.x self.a.x))
        Bouter  (* -1 (Vector:new Bsize (normal:polar) true))
        ;Ba      (- Ba Bouter)
        Bb      (+ Bb Bouter)
        x1x2    (- self.a.x self.b.x)
        y1y2    (- self.a.y self.b.y)
        x1x3    (- self.a.x Ba.x)
        y1y3    (- self.a.y Ba.y)
        x3x4    (- Ba.x Bb.x)
        y3y4    (- Ba.y Bb.y)
        denom   (- (*  x1x2 y3y4) (*  y1y2 x3x4))
        t       (/ (- (* x1x3 y3y4) (* y1y3 x3x4)) denom)
        u       (/ (- (* x1x2 y1y3) (* y1y2 x1x3)) denom -1)
        tx      (+ self.a.x (* t (- self.b.x self.a.x)))
        ty      (+ self.a.y (* t (- self.b.y self.a.y)))
        ux      (+ Ba.x (* u (- Bb.x Ba.x)))
        uy      (+ Ba.y (* u (- Bb.y Ba.y)))]
    (when (and (<= 0 t) (<= t 1) (<= 0 u) (<= u 1))
      (- (Vector:new ux uy) Bouter))))
; TODO position correction is slightly off
; allows ball to slide down walls when they should get stuck
; fix with better reposition or adding normal / friction / net
; forces to model that just consists of gravity thus far?

Wall
