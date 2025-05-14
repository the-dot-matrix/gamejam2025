(local Vec (require :src.vec))
(local Screen (require :src.screen))
(local games [])
(var (screen upscale overlay downscale texttrans) (values))

(fn love.load []
  (let [image   (love.graphics.newImage :img/overlay.png)
        res     (Vec:new (image:getWidth) (image:getHeight))
        (w h)   (love.graphics.getDimensions)
        display (Vec:new w h)
        fitto   (/ display res)
        smaller (math.min fitto.x fitto.y)
        win     (* res smaller)
        font    (love.graphics.newFont 42 :mono)
        files   (love.filesystem.getDirectoryItems :src)]
    (font:setFilter :nearest)
    (love.graphics.setFont font)
    (set downscale smaller)
    (set overlay image)
    (each [_ name (ipairs files)] (when 
      (love.filesystem.getInfo (.. :src/ name) :directory) 
      (table.insert games {: name :x 165 :w 380 :h 48})))
    (each [i game (ipairs games)] 
      (set game.y (* (+ i 1) game.h -1)))
    (set texttrans (love.math.newTransform 0 0 (/ math.pi 2)
      downscale downscale))))

(fn love.update [dt] (when screen (screen:update dt)))

(fn love.draw []
  (love.graphics.push)
  (love.graphics.translate 450 25)
  (love.graphics.scale upscale upscale)
  (when screen (screen:draw))
  (love.graphics.pop)
  (love.graphics.push)
  (love.graphics.scale downscale downscale)
  (love.graphics.draw overlay)
  (love.graphics.pop)
  (love.graphics.push)
  (love.graphics.applyTransform texttrans)
  (each [i g (ipairs games)]
    (if g.selected (love.graphics.setColor 0 0 0 0.4)
                   (love.graphics.setColor 1 1 1 0.4))
    (love.graphics.rectangle :fill g.x g.y g.w g.h)
    (if g.selected (love.graphics.setColor 1 1 1 0.8)
                   (love.graphics.setColor 0 0 0 0.8))
    (love.graphics.print g.name g.x g.y))
  (love.graphics.setColor 1 1 1 1)
  (love.graphics.pop))

(fn love.keypressed [key] 
  (when (= key :escape) (love.event.push :quit))
  (when (and screen screen.keypressed) 
    (screen:keypressed key)))

(fn love.mousepressed [x y button]
  (each [i g (ipairs games)]
    (local (tx ty) (texttrans:inverseTransformPoint x y))
    (when (and  (> tx g.x) (< tx (+ g.x g.w))
                (> ty g.y) (< ty (+ g.y g.h)))
      (let [game    (require (.. :src. g.name :.game))
            view    (Vec:new 1600 1200)
            render  (Screen:new game)
            fitto   (/ view render.res)
            larger  (math.min fitto.x fitto.y)]
        (each [i g (ipairs games)] (set g.selected false))
        (set g.selected true)
        (set upscale (* larger downscale))
        (set screen render)))))
