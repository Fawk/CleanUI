local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local E = A.enum
local buildText = A.TextBuilder
local buildButton = A.ButtonBuilder
local buildEditbox = A.EditBoxBuilder
local spells, items = {}, {}
local cacheInit = false

local find = string.find
local lower = string.lower

local function createCache()
	for i = 1, GetNumSpellTabs() do
		local name,texture,offset,numSpells = GetSpellTabInfo(i)
		for spellId = 1, numSpells do
			local name,_,icon,_,_,_,id = GetSpellInfo(spellId, "spell")
			spells[name] = { icon = icon, id = id }
		end
	end
	for i = 1, NUM_BAG_SLOTS do
		for slotId = 1, GetContainerNumSlots(i) do
			local itemId = select(10, GetContainerItemInfo))
			local name,_,_,_,_,_,_,_,_,texture,_ = GetItemInfo(itemId)
			items[name] = { icon = texture, id = itemId }
		end
	end
end

local function search(text)
	local result = {}
	for name, obj in next, spells do
		if find(lower(name), lower(text)) then
			result[name] = { obj = obj, type = "spell" }
		end
	end
	for name, obj in next, items do
		if find(lower(name), lower(text)) then
			result[name] = { obj = obj, type = "item" }
		end
	end
	return result
end

local modifiers = {
	alt = "Alt"
	ctrl = "Ctrl",
	shift = "Shift",
}

local states = {
	help = {

	},
	harm = {

	},
	combat = {

	},
	nocombat = {

	},
	dead = {

	},
	exists = {
	}
}

local Mouseover = {}

--local function setup(button, )

-- macro
-- /cast [@mouseover,harm] Shadow Word: Pain
-- /cast [@mouseover,help] Plea
-- /cast [@mouseover,help,dead,nocombat] Ressurection
-- /

-- Left Mouse Button:
-- 
-- [Help] Plea
-- [Harm] Shadow Word: Pain
-- [Help] [Dead] [Out of Combat] Ressurection
-- [Help] [Shift] Shadow Mend
-- [Harm] [Shift] Pennance
-- [Help] [Ctrl] Dispel
-- [Help] [Ctrl] [Shift] Pain Suppression

function Mouseover:Init(parent, unit, db)
	if not cacheInit then
		createCache()
		cacheInit = true
	end

	if db then

	end

	local addButton = buildButton(parent):withOnClick(function(self, button, down)
		if not down and button == "LeftButton" then
			-- Display dropdown with choices too add, modifiers, 
		end
	end):build()

	local editbox = buildEditbox(parent):withTextChanged(function(self, userInput) 
		if userInput then
			local searchResult = search(self:GetText())
			-- Display dropdown with searchresult where each result in list is clickable, thus choosing the result
		end
	end):build()
end