local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local E = A.enum
local buildText = A.TextBuilder
local buildButton = A.ButtonBuilder
local buildEditbox = A.EditBoxBuilder
local buildDropdown = A.DropdownBuilder
local spells, items = {}, {}
local cacheInit = false

local find = string.find
local lower = string.lower
local length = string.length

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
	if length(text) > 1 then
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
		prio = 1,
		type = 1
	},
	harm = {
		prio = 1,
		type = 1
	},
	combat = {
		prio = 3,
		type = 3
	},
	nocombat = {
		prio = 2,
		type = 3
	},
	dead = {
		prio = 2,
		type = 2
	},
	alive = {
		prio = 2,
		type = 2
	}
}

local function createRow(parent, db)

	local row = CreateFrame("Frame", nil, parent)

	if db then
		for _,state in next, db.states do
			local stateButton = buildButton(parent):onClick(function(self, button, down)

			end):onHover(function(self, motion)
				if self.hover and not self.oldText then
					self.oldText = self:GetText()
				end

				self:SetText(self.hover and L["Remove?"] or self.oldText)
			end):build()
		end
	end

	local addButton = buildButton(parent):onClick(function(self, button, down)
		if not down and button == "LeftButton" then
			-- Display dropdown with choices to add, modifiers,
			local dropdownBuilder = buildDropdown(parent):below(self):onItemClick(function(self, itemButton)

			end)

			-- iterate choices and addItem to dropdown

			local dropdown = dropdownBuilder:build()
		end
	end):build()

	local editbox = buildEditbox(parent):onTextChanged(function(self, userInput) 
		if userInput then
			local searchResult = search(self:GetText())
			if #searchResult > 1 then
				-- Display dropdown with searchResult where each result in list is clickable, thus choosing the result
				-- set self.valid to true when clicking one of the choices
			end
		end
	end):onEnterPressed(function(self)
		if self.valid then
			self:SetEnabled(false)
			--icon:SetTexture(nil)
		end
	end):build()

	if db then
		editbox:SetEnabled(false)

		local icon = parent:CreateTexture(nil, "OVERLAY")
		icon:SetTexture(db.icon)

		local editButton = buildButton(parent):rightOf(editbox):onClick(function(self, button, down)
			editbox:SetEnabled(true)
			icon:SetTexture(nil)
		end):build()
	end
end

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

	for i = 1, parent:GetNumRegions() do
		select(i, parent:GetRegions()):Hide()
	end

	if db then
		for _,binding in next, db do
			createRow(parent, binding)
		end
	end

	createRow(parent, nil)
end