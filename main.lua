_G.DEBUG = false
_G.TICKRATE = 1 / 240
fennel = require("bin.fennel")
fennel.install({correlate=true})
fennel.dofile("main.fnl")
