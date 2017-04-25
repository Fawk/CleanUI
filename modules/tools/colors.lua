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
		["RAGE"] = { 200/255, 33/255, 33/255 }
	},
	backdrop = {
        default = { 0.10, 0.10, 0.10, 1 },
        halfalpha = { .10, .10, .10, .5 },
        ["75alpha"] = { .10, .10, .10, .75 },
        ["25alpha"] = { .10, .10, .10, .25 },
        light = { 0.13, 0.13, 0.13, 1 },
        border = { 0.33, 0.33, 0.33, 1 }
	},
	text = {
		dead = { 1, 0, 0 },
		ghost = { 1, 1, 0 },
		disconnected = { 0, 0, 0 }
	},
	healPrediction = {
		my = { 0, 0.827, 0.765, 0.5 },
		all = { 0, 0.631, 0.557, 0.5 },
		absorb = { 1, 1, 1, 0.5 },
		healAbsorb = { 1, 1, 1, 0.5 }
	}
}