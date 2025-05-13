(local spriteBox {}) (set spriteBox.__index spriteBox)
(local game :afflictelixir/)
(local missingTexture (.. :src/ game :img/sprites/Missing_Texture.bmp))
(local (width height padding) (16 16 1))

(fn spriteBox.new [!]
  (setmetatable spriteBox !))

(fn spriteBox.add [! Name ?fileType]
  ;; AutoSlices sprite sheet according to image dimensions and 
  ;; listed default dimensions.
  ;; Assume all files have padding tiles
  ;; if ?fileType not specified assumes .bmp
  ;; fileName example: :Brain_Boi
  ;; fileType example: :.bmp
  (let [fileType      (or ?fileType :.bmp)
        fileName      (.. Name fileType)
        path          (.. :src/ game :img/sprites/ fileName)
        fileExists?   (love.filesystem.exists path)
        path          (if fileExists? path missingTexture)
        image         (love.graphics.newImage path)
        (w h)         (image:getDimensions)
        tileCount     #(values (/ (- $2 $1) (+ $3 $1))
                      (/ (- $4 $1) (+ $5 $1)))
                      ;; padding w width h height
        (tileW tileH) (tileCount padding w width h height)
        goodPadding?  (and (= :integer (math.type tileW))
                        (= :integer (math.type tileH)))
        tileNumber    (* tileW tileH)
        quads         (if goodPadding?
                        (fcollect [index 1 tileNumber 1]
                          (let [i (% (- index 1) tileW)
                                floor math.floor
                                j (floor (/ (- index 1) tileW))]
                                (if (> j tileH)
                                  (break))
                                (love.graphics.newQuad)))
                        nil)]))

spriteBox