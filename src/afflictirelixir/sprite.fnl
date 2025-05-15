(local Sprite {}) (set Sprite.__index Sprite)
(local Vec (require :src.Vec))
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
        frame         0
        r             0
        scale         (Vec:new 1 1)
        origin        (Vec:new 0 0)
        sprite        {: image : quads : tileCount : frame : scale : origin}]
    (if (not goodPadding?) (error (.. "poorly padded " name)))
    (setmetatable sprite !)))

(fn Sprite.getQuads [! f1 f2]
  (fcollect [index f1 f2 1]
    (. !.quads index)))

(fn Sprite.update [! dt ?anim] ;; dt is currently redundant
  (local anim (if ?anim (fcollect [i ?anim.f1 ?anim.f2 1] (. !.quads i)) !.quads))
  (set !.frame (% (+ !.frame (* 12 12 dt)) (length anim))))

(fn Sprite.draw [! ?X ?Y ?R ?scaleX ?scaleY 
                ?originX ?originY ?anim]
  (let [x       (or ?X 0)
        y       (or ?Y 0)
        r       (or ?R 0)
        sX      (or ?scaleX !.scale.x)
        sY      (or ?scaleY !.scale.y)
        oX      (or ?originX !.origin.x)
        oY      (or ?originY !.origin.y)
        anim   (if ?anim (fcollect [i ?anim.f1 ?anim.f2 1] (. !.quads i)) !.quads)]
    (love.graphics.draw !.image 
      (. anim (+ (math.floor !.frame) 1))
      x y r sX sY oX oY)))

Sprite

;;instructions:
;; (local Sprite (require :src.afflictirelixir.sprite))
;; new sprite object
;; (local name (Sprite:new :name))
;; drawing
;; (name:draw ?x ?y ?scale ?flipX? ?flipY?)
;; all variables ommitable technically,