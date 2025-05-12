;; all obj run through here.
;; uses flag based system with tags.
;; obj respond to corresponding tags.
;; obj through flags to trigger corresponding obj.
(local handler {})

;; setup container for objects? (obj1.flag [tags/obj2])
;; each obj 'inherits' a sub object of handler to throw and catch flags.
;; handler.new instatiates that sub object.
(fn handler.new [!]
 (let [! (setmetatable {} !)
       messenger {:tags {}}]
 ))

;; : flags : objects.

handler