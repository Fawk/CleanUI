local A, L = unpack(select(2, ...))

A.colors = {
	health = {
		low = { .54, .16, .11 },
		medium = { .40, .26, .04 },
		dead = { 100/255, 15/255, 15/255 },
		disconnected = { .2, .2, .2, },
		standard = { 49/255, 207/255, 37/255 }
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
		[SPELL_POWER_COMBO_POINTS] = { 255/255, 245/255, 105/255 },
		[SPELL_POWER_SOUL_SHARDS] = { 128/255, 82/255, 105/255 },
		[SPELL_POWER_CHI] = { 181/255, 255/255, 235/255 },
		[SPELL_POWER_HOLY_POWER] = { 242/255, 230/255, 153/255 },
		[SPELL_POWER_ARCANE_CHARGES] = { 26/255, 26/255, 250/255 },
		[SPELL_POWER_LUNAR_POWER] = { 77/255, 133/255, 230/255 },
		[SPELL_POWER_INSANITY] = { 102/255,	0, 204/255 },
		runes = {
			[1] = { .67, .13, .13 },
			[2] = { 0, .67, .99 },
			[3] = { 0.33, .67, .33 }
		}
	},
	backdrop = {
        default = { 0.1, 0.1, 0.1, 1 },
        halfalpha = { .1, .1, .1, .5 },
        ["75alpha"] = { .1, .1, .1, .75 },
        ["25alpha"] = { .1, .1, .1, .25 },
        light = { .13, .13, .13, 1 },
        border = { .33, .33, .33, 1 }
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
	text = {
		["white"]	= "|cFFFFFFFF",
		["black"]	= "|cFF000000",
		["red"]		= "|cFFFF0000",
		["green"]	= "|cFF00FF00",
		["blue"]	= "|cFF0000FF",
		["yellow"]	= "|cFFFFFF00",
		["purple"]	= "|cFFFF00FF",
		["cyan"]	= "|cFF00FFFF",
		["orange"]	= "|cFFFF8000",
		["pink"] 	= "|cFFFF0080"
	}
}

local colorPattern = "[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]"
function A:AddColorReplaceLogicIfNeeded(tag)
	local x, y = tag.format:find("%[color:"..colorPattern.."%]")
	if (x and y) then
		local m = tag.format:sub(x, y)
		tag:AddReplaceLogic(m, "|cFF"..m:match(colorPattern))
	end
end

A.colors.class = {}
for classToken, color in next, RAID_CLASS_COLORS do
	A.colors.class[classToken] = {color.r, color.g, color.b}
end

local function colorsAndPercent(a, b, ...)
	if(a <= 0 or b == 0) then
		return nil, ...
	elseif(a >= b) then
		return nil, select(select('#', ...) - 2, ...)
	end

	local num = select('#', ...) / 3
	local segment, relperc = math.modf((a / b) * (num - 1))
	return relperc, select((segment * 3) + 1, ...)
end

function A:ColorGradient(...)
	local relperc, r1, g1, b1, r2, g2, b2 = colorsAndPercent(...)
	if(relperc) then
		return r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc
	else
		return r1, g1, b1
	end
end

function A:ColorBar(bar, parent, min, max, gradient, classOverride)
	local db = bar.db
	local r, g, b, a, t
	local mult = db["Background Multiplier"]
	local colorType = db["Color By"]
	if (colorType == "Class") then
		r, g, b = unpack(A.colors.class[classOverride or select(2, UnitClass(parent.unit))] or A.colors.backdrop.default)
	elseif (colorType == "Power") then
		t = A.colors.power[parent.powerToken]
		if not t then
			t = A.colors.power[parent.powerType]
		end
	elseif (colorType == "Health") then
		r, g, b = unpack(A.colors.health.standard)
	elseif (colorType == "Gradient") then
		r, g, b = A:ColorGradient(min, max, gradient(parent.unit))
	elseif (colorType == "Custom") then
		t = db["Custom Color"]
	end
	if t then
		r, g, b, a = unpack(t)
	end

	if (r) then
		bar:SetStatusBarColor(r, g, b, a or 1)
		if (tonumber(mult) >= 0) then
			bar.bg:SetVertexColor(r * mult, g * mult, b * mult)
		else
			bar.bg:Hide()
		end
	end
end