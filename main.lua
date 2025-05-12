_G.DEBUG = false
_G.TICKRATE = 1 / 120
_G.VSYNC = true
fennel = require("bin.fennel")
fennel.install({correlate=true})
fennel.dofile("main.fnl")
