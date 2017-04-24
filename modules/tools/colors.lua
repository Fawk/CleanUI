local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF

A.colors = {
	health = {
		low = { .54, .16, .11 },
		medium = { .40, .26, .04 }
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
	}
}