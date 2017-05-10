local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local E = A.enum
local buildText = A.TextBuilder
local buildButton = A.ButtonBuilder
local buildEditbox = A.EditBoxBuilder
local buildDropdown = A.DropdownBuilder
local spells, items = {}, {}
local cacheInit = false
local actions = { ["cast"] = false, ["use"] = false }

local find = string.find
local lower = string.lower
local length = string.length
local tinsert = table.insert
local tsort, tinsert, tremove = table.sort, table.insert, table.remove
local select = select

local GetSpellInfo = GetSpellInfo

function string:split(sep)
   local sep, fields = sep or ":", {}
   local pattern = string.format("([^%s]+)", sep)
   self:gsub(pattern, function(c) fields[#fields+1] = c end)
   return fields
end

function string:ltrim()
   return self:gsub("^%s*", "") 
end

local function tsize(t)
	local i = 0
	for x in next, t do i = i + 1 end
	return i
end

local function sortStates(t, k)
    local keys, newtbl = {}, {}
    for k in next, t do table.insert(keys, k) end
    tsort(keys, function(a,b) return t[a][k] < t[b][k] end)
    for _,v in ipairs(keys) do tinsert(newtbl, { key = v, value = t[v][k] }) end
    
    local relative = nil
    for _,v in next, newtbl do
    	local row = v.value
    	local isParent = false
    	if not relative then
    		relative = row:GetParent()
    	end
    	row:SetPoint("TOPLEFT", relative, isParent and "TOPLEFT" or "BOTTOMLEFT", 0, 0)
    	row:SetPoint("TOPRIGHT", relative, isParent and "TOPRIGHT" or "BOTTOMRIGHT", 0, 0)
    	relative = row
    end
end

local function createCache()
	for i = 1, GetNumSpellTabs() do
		local name,texture,offset,numSpells = GetSpellTabInfo(i)
		for spellId = 1, numSpells do
			local name,_,icon,_,_,_,id = GetSpellInfo(spellId, "spell")
			if name and (IsSpellHelpful(spellId) or IsSpellHarmful(spellId)) then
				spells[name] = { icon = icon, id = id }
			end
		end
	end
	for i = 1, NUM_BAG_SLOTS do
		for slotId = 1, GetContainerNumSlots(i) do
			local itemId = select(10, GetContainerItemInfo(i, slotId))
			local spellName = GetItemSpell(itemId)
			if spellName and (IsHelpfulItem(itemId) or IsHarmfulItem(itemId)) then
				local name,_,_,_,_,_,_,_,_,texture = GetItemInfo(itemId)
				items[name] = { icon = texture, id = itemId }
			end
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
	alt = "Alt",
	ctrl = "Ctrl",
	shift = "Shift"
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
		prio = 3,
		type = 3
	},
	dead = {
		prio = 2,
		type = 2
	},
	nodead = {
		prio = 2,
		type = 2
	}
}

local function verifyState(stateButtons, state, button)
	if not stateButtons[state] then
        if states[state] then
            for name,_ in next, stateButtons do
                if states[name].type == states[state].type then
                    A:Debug("Two of the same state type is not allowed. E.g both dead and nodead.")
                end
            end
            return true
        elseif modifiers[state] then
            return true
        end
	else
		A:Debug("Two of the same exact state is not necessary.")
	end

	return false
end

local function resolveAction(db)
   return db:gmatch("/%w+")():sub(1)
end

local function resolveVariations(db)
    local variations = {}
    for _,variation in next, db:split(";") do tinsert(variations, variation) end
    return variations
end

local function resolveStates(db)
    local s = {}
    for match in g:gmatch("%a+") do if states[match] then table.insert(s, match) end end
    return s
end

local function resolveName(db)
    for match in db:gmatch("%a+") do if spells[match] or items[match] then return match end end
end

local function resolveIcon(name)
    return items[name] and items[name].icon or (spells[name] and spells[name].icon or nil)
end

local function getLast(tbl)
	local ret
	for _,o in next, tbl do ret = o end
	return ret
end

local function createRow(parent, binding, db)

	local row = CreateFrame("Frame", nil, parent)
	row:SetHeight(20)
	row.stateButtons = {}

	if not parent["Keybindings"] then
		parent["Keybindings"] = A:OrderedTable()
		row:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
		row:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, 0)
	else
		row:SetPoint("TOPLEFT", parent["Keybindings"]:last(), "BOTTOMLEFT", 0, 0)
		row:SetPoint("TOPRIGHT", parent["Keybindings"]:last(), "BOTTOMRIGHT", 0, 0)
	end
	parent["Keybindings"]:add(row)

	if db then
		for _,state in next, binding.states do
			local stateButton = buildButton(row):onClick(function(self, button, down)
				tremove(row.stateButtons, state)
			end):onHover(function(self, motion)
				if self.hover and not self.oldText then
					self.oldText = self:GetText()
				end

				self:SetText(self.hover and L["Remove?"] or self.oldText)
			end):build()

			if not verifyState(row.stateButtons, state, stateButton) then
				stateButton:Hide()
			else
				local parent = tsize(row.stateButtons) > 0 and getLast(row.stateButtons) or row
				stateButton:SetPoint("LEFT", parent, parent == row and "LEFT" or "RIGHT", 5, 0)
				row.stateButtons[state] = stateButton
			end
		end

		sortStates(row.stateButtons, "prio")
	end

	local addButton = buildButton(row):onClick(function(self, button, down)
		if not down and button == "LeftButton" then
			
			if self.dropdown then
				self.dropdown:Hide()
			end

			local dropdownBuilder = buildDropdown(row):below(self):onItemClick(function(self, itemButton)
				if row.editbox.valid then
					Keybindings:Save(parent["Keybindings"], db)
				end
			end)

			for state,_ in next, states do 
				dropdownBuilder:addItem(state)
			end

			for modifier,_ in next, modifiers do
				dropdownBuilder:addItem(modifier)
			end

			self.dropdown = dropdownBuilder:build()
		end
	end):build()

	local editbox = buildEditbox(row):onTextChanged(function(self, userInput) 
		if userInput then
			local searchResult = search(self:GetText())
			if #searchResult > 1 then

				if self.dropdown then
					self.dropdown:Hide()
				end

				local dropdownBuilder = buildDropdown(row):below(self):onItemClick(function(self, itemButton)
					editbox.valid = true
					editbox:SetText(itemButton.name)
					self:Hide()
				end)

				for name, searchObject in next, searchResult do
					local type, obj = searchObject.type, searchObject.obj
					local texture, id = obj.texture, obj.id

					dropdownBuilder:addItem(name)
				end

				self.dropdown = dropdownBuilder:build()
			end
		end
	end):onEnterPressed(function(self)
		if self.valid then
			self:SetEnabled(false)
			row.icon:SetTexture(resolveIcon(self:GetText()))
			if tsize(row.stateButtons) > 0 then
				Keybindings:Save(parent["Keybindings"], db)
			end
		end
	end):build()

    editbox:SetText(binding.name)
    editbox:SetEnabled(false)

    local icon = row:CreateTexture(nil, "OVERLAY")
    icon:SetTexture(binding.icon)

    local editButton = buildButton(row):rightOf(editbox):onClick(function(self, button, down)
        editbox:SetEnabled(true)
        icon:SetTexture(nil)
    end):build()

    row.iocn = icon
	row.editbox = editbox
	row.addButton = addButton
end

local Keybindings = {}

--local function setup(button, )

-- macro
-- /cast [@unit,harm] Shadow Word: Pain
-- /cast [@unit,help] Plea
-- /cast [@unit,help,dead,nocombat] Ressurection
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

function Keybindings:Init(parent, unit, db)
	if not cacheInit then
		createCache()
		cacheInit = true
	end

	for _,region in next, { parent:GetRegions() } do
		region:Hide()
	end

    local bindings = {}
    for _,binding in next, db do
        local action = resolveAction(db)
        for _,variation in next, resolveVariations(db) do
            local name = resolveName(variation)
            tinsert(bindings, {
                action = action,
                states = resolveStates(variation),
                name = name,
                icon = resolveIcon(name)
            })
        end
    end

    for _,binding in next, bindings do
        createRow(parent, binding)
    end

	createRow(parent, nil)
end

function Keybindings:Save(bindings, db)

end