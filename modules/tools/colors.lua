local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF

A.colors = {
	health = {
		low = { .54, .16, .11 },
		medium = { .40, .26, .04 },
		dead = { 77/255, 15/255, 15/255 },
		disconnected = { .5, .5, .5, .5 }
	},
	power = {
		["MANA"] = { 80/255, 109/255, 155/255 },
		["RAGE"] = { 200/255, 33/255, 33/255 },
		["FURY"] = { 200/255, 33/255, 200/255 }
	},
	backdrop = {
        default = { 0.1, 0.1, 0.1, 1 },
        halfalpha = { .1, .1, .1, .5 },
        ["75alpha"] = { .1, .1, .1, .75 },
        ["25alpha"] = { .1, .1, .1, .25 },
        light = { .13, .13, .13, 1 },
        border = { .33, .33, .33, 1 }
	},
	text = {
		dead = { 1, 0, 0 },
		ghost = { 1, 1, 0 },
		disconnected = { 0, 0, 0 },
		default = { 1, 1, 1, 1 }
	},
	healPrediction = {
		my = { 0, .827, .765, .5 },
		all = { 0, .631, .557, .5 },
		absorb = { .7, .7, 1, .5 },
		healAbsorb = { .7, .7, 1, .5 }
	},
	moving = {
		backdrop = { .1, .1, .1, .5 },
		border = { .3, .3, .6, .5 }
	}
}