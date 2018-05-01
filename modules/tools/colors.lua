local A, L = unpack(select(2, ...))

A.colors = {
	health = {
		low = { .54, .16, .11 },
		medium = { .40, .26, .04 },
		dead = { 100/255, 15/255, 15/255 },
		disconnected = { .2, .2, .2, }
	},
	power = {
		["MANA"] = { 80/255, 109/255, 155/255 },
		["RAGE"] = { 200/255, 33/255, 33/255 },
		["FURY"] = { 200/255, 33/255, 200/255 },
		["FOCUS"] = { 255/255, 128/255, 64/255 },
		["RUNIC_POWER"] = { 0, 209/255, 1 },
		["MAELSTROM"] = { 0, 128/255, 1 },
		["ENERGY"] = { 200/255,	200/255, 33/255 },
		["PAIN"] = { 255/255, 156/255, 0 },
		[SPELL_POWER_COMBO_POINTS] = { 148/255, 16/255, 8/255 }
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
		disconnected = { .45, .25, .25 },
		default = { 1, 1, 1 }
	},
	healPrediction = {
		my = { 0, .827, .765, .5 },
		all = { 0, .631, .557, .5 },
		absorb = { .7, .7, 1, .5 },
		healAbsorb = { .7, .7, 1, .5 },
		overAbsorb = { 1, 1, .5, .5 },
		overHealAbsorb = { 1, .7, .7, .5 }
	},
	moving = {
		backdrop = { .1, .1, .1, .7 },
		border = { .3, .3, .6, .5 }
	},
	border = {
		target = { 1, 1, 1, 0.3 },
		combat = { 1, 0, 0, 0.5 }
	},
	debuff = {
		["Curse"] = { 200/255, 33/255, 200/255 },
		["Disease"] = { 143/255, 71/255, 0 },
		["Magic"] = { 33/255, 33/255, 200/255 },
		["Poison"] = { 33/255, 155/255, 33/255 },
		["Physical"] = { 155/255, 33/255, 33/255 }
	},
	keybindings = {
		remove = { 1, .13, .13 },
		states = {
			modifier = { .13, .13, 1 },
			help = { .13, 1, .13 },
			harm = { 1, .13, .13 },
			state = { .53, .53, 0 }
		}
	},
	castbar = { 0.33, 0.33, 0.53 }
}