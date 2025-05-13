(local Sprite {}) (set Sprite.__index Sprite)
(local game :afflictirelixir/)
(local missingTexture (.. :src/ game :img/nil.png))
(local (width height padding) (values 16 16 1))

(fn Sprite.new [! ?name ?fileType]
  ;; AutoSlices sprite sheet according to image dimensions and 
  ;; listed default dimensions.
  ;; Assume all files have padding tiles no double up padding
  ;; if ?fileType not specified assumes .bmp
  ;; fileName example: :Brain_Boi
  ;; fileType example: :.bmp
  (let [fileType      (or ?fileType :.png)
        name          (or ?name :nil)
        fileName      (.. name fileType)
        path          (.. :src/ game :img/ fileName)
        fileExists?   (love.filesystem.getInfo path)
        path          (if fileExists? path missingTexture)
        image         (love.graphics.newImage path)
        (w h)         (image:getDimensions)
        tileCounter     #(values (/ (- $2 $1) (+ $3 $1))
                        (/ (- $4 $1) (+ $5 $1)))
        (tileW tileH) (tileCounter padding w width h height)
        floor         math.floor
        goodPadding?  (and  (= tileW (floor tileW))
                            (= tileH (floor tileH)))
        tileCount     (* tileW tileH)
        quads         (if goodPadding?
                        (fcollect [index 1 tileCount 1]
                          (let [i (% (- index 1) tileW)
                                j (floor (/ (- index 1) tileW))]
                            (love.graphics.newQuad 
                              (+ 1 (* i (+ width padding)))
                              (+ 1 (* j (+ height padding)))
                              width height w h))) nil)
        sprite        {: image : quads : tileCount :frame 0}]
    (if (not goodPadding?) (error (.. "poorly padded " name)))
    (setmetatable sprite !)))

(fn Sprite.update [! dt]
  (set !.frame (% (+ !.frame (* dt 12)) (length !.quads))))

(fn Sprite.draw [! ?x ?y ?scale ?flipX? ?flipY?]
  (let [x (or ?x 100)
        y (or ?y 100)
        r 0
        scale  (if ?scale ?scale 1)
        sX (if ?flipX? (* -1 scale) scale)
        sY (if ?flipY? (* -1 scale) scale)
        oX 0
        oY 0
        center #(math.floor (/ (- $1 $2) 2))]
    (love.graphics.push)
    (love.graphics.translate  (center x (+ x width)) 
                              (center y (+ y height)))
    (love.graphics.draw !.image 
      (. !.quads (+ (math.floor !.frame) 1))
      x y r sX sY oX oY)
    (love.graphics.pop)))

Sprite

;;instructions:
;; (local Sprite (require :src.afflictirelixir.sprite))
;; new sprite object
;; (local name (Sprite:new :name))
;; drawing
;; (name:draw ?x ?y ?scale ?flipX? ?flipY?)
;; all variables ommitable technically,