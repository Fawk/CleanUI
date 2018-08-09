local AddonName = ...
local A, L = unpack(select(2, ...))
local buildCheckbox = A.CheckBoxBuilder
local buildDropdown = A.DropdownBuilder
local buildEditbox = A.EditBoxBuilder
local buildButton = A.ButtonBuilder
local buildText = A.TextBuilder
local buildMultiDropdown = A.MultiDropdownBuilder

local media = LibStub("LibSharedMedia-3.0")

local E = A.enum
local T = A.Tools

local keyMap = {
	["LMB"] = "*type1",
	["MMB"] = "*type3",
	["RMB"] = "*type2",
	["SHIFT-LMB"] = "shift-macrotext1",
	["SHIFT-MMB"] = "shift-macrotext3",
	["SHIFT-RMB"] = "shift-macrotext2",
	["CTRL-LMB"] = "ctrl-macrotext1",
	["CTRL-MMB"] = "ctrl-macrotext3",
	["CTRL-RMB"] = "ctrl-macrotext2",
	["ALT-LMB"] = "alt-macrotext1",
	["ALT-MMB"] = "alt-macrotext3",
	["ALT-RMB"] = "alt-macrotext2",
	["CTRL-SHIFT-LMB"] = "ctrl-shift-macrotext1",
	["CTRL-SHIFT-MMB"] = "ctrl-shift-macrotext3",
	["CTRL-SHIFT-RMB"] = "ctrl-shift-macrotext2",
	["ALT-CTRL-SHIFT-LMB"] = "alt-ctrl-shift-macrotext1",
	["ALT-CTRL-SHIFT-MMB"] = "alt-ctrl-shift-macrotext3",
	["ALT-CTRL-SHIFT-RMB"] = "alt-ctrl-shift-macrotext2",
	["ALT-CTRL-LMB"] = "alt-ctrl-macrotext1",
	["ALT-CTRL-MMB"] = "alt-ctrl-macrotext3",
	["ALT-CTRL-RMB"] = "alt-ctrl-macrotext2",
	["ALT-SHIFT-LMB"] = "alt-shift-macrotext1",
	["ALT-SHIFT-MMB"] = "alt-shift-macrotext3",
	["ALT-SHIFT-RMB"] = "alt-shift-macrotext2"
}

local additional = {
	"type1",
	"type2",
	"type3"
}

local conditionMap = {
	"help",
	"harm",
	"dead",
	"nodead",
	"combat",
	"talent:[1-7]/[1-3]"
}

local function registerAttributeIfNeeded(frame, key)
	local mapped = keyMap[key]
	local needed = mapped:anyMatch("LMB", "MMB", "RMB")
	if (needed and not frame:GetAttribute(keyMap[needed])) then
		frame:SetAttribute(keyMap[needed], "macro")
	end
end

local function blizzardCommand(frame, mapped, command, initString)
	if (initString) then
		return initString..'\nframe:SetAttribute("'..mapped:gsub("macrotext", "type")..'","'..command..'");'
	else
		frame:SetAttribute(mapped:gsub("macrotext", "type"), command)
	end
end

local CC = {}

function CC:Setup(frame, db)
	if (not db or not db.enabled) then return end

	for key, attribute in next, keyMap do
		if (frame:GetAttribute(attribute)) then
			frame:SetAttribute(attribute, nil)
		end
	end

	for _,key in next, additional do
		for _,extra in next, { "alt-", "ctrl-", "shift-", "alt-ctrl-", "alt-ctrl-shift-", "ctrl-shift-", "alt-shift-" } do
			local attr = extra..key
			if (frame:GetAttribute(attr)) then
				frame:SetAttribute(attr, nil)
			end
		end
	end

	for key, action in next, db.actions do

		local mapped = keyMap[key]

		local command = action:anyMatch("target", "togglemenu")
		if (command) then
			blizzardCommand(frame, mapped, command)
		else
			if (key:equals("LMB", "MMB", "RMB")) then
				frame:SetAttribute(mapped, "macro")
				frame:SetAttribute("*macrotext"..mapped:match("%d"), action)
			else
				registerAttributeIfNeeded(frame, key)
				frame:SetAttribute(mapped, action)
			end
		end
	end
end

function CC:GetInitString(initString, db)
	if (not db.enabled) then return initString end

	local initiated = {}
	for key, action in next, db.actions do

		local mapped = keyMap[key]

		local command = action:anyMatch("target", "togglemenu")
		if (command) then
			initString = blizzardCommand(frame, mapped, command, initString)
		else
			if (key:equals("LMB", "MMB", "RMB")) then
				initString = initString..'\nframe:SetAttribute("'..mapped..'","macro");'
				initString = initString..'\nframe:SetAttribute("*macrotext'..mapped:match("%d")..'","'..action..'");'
				initiated[key] = true
			else
				local needed = mapped:anyMatch("LMB", "MMB", "RMB")
				if (needed and not initiated[needed]) then
					initString = initString..'\nframe:SetAttribute("'..keyMap[needed]..'","macro");'
				end
				initString = initString..'\nframe:SetAttribute("'..mapped..'","'..action..'");'
			end
		end
	end
	return initString
end

--[[

	"*macrotext1", "/cast [@mouseover,help] Something; [@mouseover,help,dead] Ress; [@mouseover,harm] Harmful Spell"

	will turn into

	LMB + [help] - Something
	LMB + [help] + [dead] - Ress
	LMB + [harm] - Harmful Spell

]]
local function splitActionsByConditions(db)
	local actions = A:OrderedTable()

	for key, action in next, db do
		if (action) then

			local split = action:explode(";")

			for _,row in next, split do
				row = row:trim()

				if (row and row:match("[%w]+")) then

					local spell, conditions = nil, {}
					if (row:anyMatch("target", "togglemenu")) then
						spell = row
					else
						spell = row:match("%s[:A-Za-z%s]+"):trim()
						conditions = row:match("%[[@%w,:/]+%]"):sub(2):sub(1, -2):explode(",")
					end

					local map = {
						["key"] = key,
						["spell"] = spell,
						["conditions"] = A:OrderedTable()
					}

					for _,mappedCondition in next, conditionMap do
						local cond = {
							text = mappedCondition,
							active = false
						}
						for _,condition in next, conditions do
							if (condition:match("^"..mappedCondition)) then
								cond.active = true
							end
						end

						if (not mappedCondition:find("talent")) then
							map.conditions:add(cond)
						end
					end
					actions:add(map)
				end
			end
		end
	end

	return actions
end

local function getTalentTable()
	local talents = {}
	for tier = 1, 7 do
		for column = 1, 3 do
			table.insert(talents, string.format("talent:%d/%d", tier, column))
		end
	end
	return talents
end

local function mapActionsByKey(actions)
	local mapped = {}
	actions:foreach(function(action)
		if (not mapped[action.key]) then
			mapped[action.key] = {}
		end

		table.insert(mapped[action.key], action)
	end)
	return mapped
end

local function concat(tbl)
   	local t = "[@mouseover"
   	for i = 1, tbl.conditions:count() do
   		local condition = tbl.conditions:get(i)
   		if (condition.active) then
			t = t..","..condition.text
		end
   	end
   	return t.."] "..tbl.spell
end

local function createRows(parent)
	local rows = CreateFrame("Frame", nil, parent)
	rows:SetPoint("TOPLEFT", 0, -20)
	rows:SetPoint("TOPRIGHT", 0, -20)
	rows:SetPoint("BOTTOMLEFT", 0, 0)
	rows:SetPoint("BOTTOMRIGHT", 0, 0)
	return rows
end

local talentIcons = {
}

local function search(text)
	local result = A:OrderedTable()

	-- Search in spellbook
	local num = GetNumSpellTabs()
	for i = 1, num do
		local name, texture, offset, numSpells = GetSpellTabInfo(i)
		local currentSpec = GetSpecialization()
		local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec))

		if (name == currentSpecName) then
			for x = 1, numSpells do
				local spellName, spellSubName = GetSpellBookItemName(offset + x, BOOKTYPE_SPELL);
				local spellType, spellId = GetSpellBookItemInfo(spellName)
				if (not IsPassiveSpell(spellId) and (text ~= "" and spellName:find(text))) then
					result:addUnique(spellName)
				end
			end
		end
	end

	-- Search for spells that might active through talent
	for tier = 1, 7 do
		for column = 1, 3 do
			local talentID, name, texture, selected, available, spellID, unknown, row, column, unknown, known = GetTalentInfo(tier, column, 1)
			if (not IsPassiveSpell(spellID) and (text ~= "" and name:find(text))) then
				talentIcons[name] = texture
				result:addUnique(name)
			end
		end
	end

	return result
end

function CC:ToggleClickCastWindow(group)

	-- List the existing actions
	if (A.clickCastWindow) then
		A.clickCastWindow:Hide()
		A.clickCastWindow = nil
	end

	local parent = CreateFrame("Frame", T:frameName(group.parent.name, "Clickcast"), A.frameParent)
	parent:SetPoint("TOPLEFT", group, "TOPRIGHT", 50, 0)

	parent.rows = createRows(parent)

	local actions = splitActionsByConditions(group.db.actions)
	local mappedActions = mapActionsByKey(actions)

	parent:SetSize(350, 20 + (20 * T:tcount(mappedActions["LMB"] or {})))

	local keys = {}
	for key,_ in next, keyMap do
		table.insert(keys, key)
	end

	local conditions = {}
	for _,mappedCondition in next, conditionMap do
		if (not mappedCondition:find("talent")) then
			table.insert(conditions, mappedCondition)
		end
	end

	local lastRow
	local keyDropdown = buildDropdown(parent)
			:atTopLeft()
			:addItems(keys)
			:size(150, 20)
			:fontSize(10)
			:backdrop(E.backdrops.editboxborder, { 0.1, 0.1, 0.1, 1 }, { .3, .3, .3, 1 })
			:onItemClick(function(self, ...)

				parent.rows:Hide()
				parent.rows = nil
				parent.rows = createRows(parent)

				local button, dropdown, mouseButton = ...

				local relative = parent.rows
				actions = splitActionsByConditions(group.db.actions)
				mappedActions = mapActionsByKey(actions)
				local mapped = mappedActions[button.name]
				if (mapped) then
					parent:SetHeight(20 + (20 * T:tcount(mapped)))

					for _,action in next, mapped do

						local row = CreateFrame("Frame", nil, parent.rows)
						row:SetSize(parent.rows:GetWidth(), 20)

						if (relative == parent.rows) then
							row:SetPoint("TOPLEFT")
							row:SetPoint("TOPRIGHT")
						else
							row:SetPoint("TOPLEFT", relative, "BOTTOMLEFT", 0, 0)
							row:SetPoint("TOPRIGHT", relative, "BOTTOMRIGHT", 0, 0)
						end

						local selectedConditions = {}
						for i = 1, action.conditions:count() do
							local condition = action.conditions:get(i)
							if (condition.active) then
								table.insert(selectedConditions, i)
							end
						end

						local talents = getTalentTable()
						local conditionDropdown = buildMultiDropdown(row)
								:atLeft()
								:size(100, 20)
								:fontSize(10)
								:overrideText("Conditions")
								:addItems(conditions)
								:addItems(talents)
								:backdrop(E.backdrops.editboxborder, { 0.1, 0.1, 0.1, 1 }, { .3, .3, .3, 1 })
								:readonly()
								:build()

						conditionDropdown:SetValue(selectedConditions)

						conditionDropdown.selectedButton:HookScript("OnEnter", function(self, userMoved)
							if (userMoved) then
								GameTooltip:SetOwner(self)
								GameTooltip:AddLine("Active Conditions:")
								self:GetParent().selectedItems:foreach(function(index)
									GameTooltip:AddLine(self:GetParent().items:get(index).name)
								end)
								GameTooltip:Show()
							end
						end)

						conditionDropdown.selectedButton:HookScript("OnLeave", function(self, userMoved)
							if (userMoved) then
								GameTooltip:Hide()
							end
						end)

						local textbox = buildEditbox(row)
								:rightOf(conditionDropdown)
								:size(200, row:GetHeight())
								:build()
						
						textbox:SetFont(media:Fetch("font", "Default"), 10, "OUTLINE")
						textbox:SetValue(action.spell)
						textbox:SetActive(false)

						local icon = select(3, GetSpellInfo(action.spell))
						if (icon) then
							textbox.icon = textbox:CreateTexture(nil, "OVERLAY")
							textbox.icon:SetSize(18, 18)
							textbox.icon:SetTexture(icon)
							textbox.icon:SetPoint("LEFT", textbox, "LEFT", 1, 0)
							textbox.icon:SetTexCoord(0.133,0.867,0.133,0.867)
							textbox:SetTextInsets(25, 0, 0, 0)
						else
							textbox:SetTextInsets(5, 0, 0, 0)
						end

						local deleteButton = buildButton(row)
								:rightOf(textbox)
								:size(20, 20)
								:backdrop(E.backdrops.editboxborder, { 0.1, 0.1, 0.1, 1 }, { .3, .3, .3, 1 })
								:onClick(function(self, b, d)
									-- Delete this clickcast from the db
									local command = action.spell:anyMatch("target", "togglemenu")
									if (command) then
										group.db.actions[action.key] = nil
									else
										local con = concat(action)
										if (T:tcount(group.db.actions) > 1) then 
											group.db.actions[action.key] = group.db.actions[action.key]:gsub(con:escape().."[;%s]?[%s]?", "")
										else
											group.db.actions[action.key] = nil
										end
									end

									local rowCount = 0
									if (group.db.actions[action.key]) then
										rowCount =  T:tcount(group.db.actions[action.key]:explode(";"))
									end

									parent:SetHeight(20 + (20 * rowCount))

									A.dbProvider:Save()
									dropdown:SimulateClickOnActiveItem()
									dropdown:Close()
									GameTooltip:Hide()
									A:UpdateDb()
								end)
								:build()

						deleteButton.text = buildText(deleteButton, 22)
								:atCenter()
								:build()

						deleteButton.text:SetText("x")
						deleteButton.text:SetTextColor(1, 0.3, 0.3, 1)
						deleteButton:SetScript("OnEnter", function(self, userMoved)
							if (userMoved) then
								GameTooltip:SetOwner(self)
								GameTooltip:SetText("Delete")
							end
						end)
						deleteButton:SetScript("OnLeave", function(self, userMoved)
							if (userMoved) then
								GameTooltip:Hide()
							end
						end)

						relative = row
						lastRow = row
					end
				else
					parent:SetHeight(20)
				end
			end)
			:build()

	keyDropdown:SetValue("LMB")
	keyDropdown:SimulateClickOnActiveItem()
	keyDropdown:Close()

	local talents = getTalentTable()
	local conditionDropdown = buildMultiDropdown(parent)
			:atTopLeft()
			:againstBottomLeft()
			:size(100, 20)
			:fontSize(10)
			:overrideText("Conditions")
			:addItems(conditions)
			:addItems(talents)
			:backdrop(E.backdrops.editboxborder, { 0.1, 0.1, 0.1, 1 }, { .3, .3, .3, 1 })
			:stayOpenAfterChoosing()
			:build()

	conditionDropdown.selectedButton:HookScript("OnEnter", function(self, userMoved)
		if (userMoved) then
			GameTooltip:SetOwner(self)
			GameTooltip:AddLine("Active Conditions:")
			self:GetParent().selectedItems:foreach(function(index)
				GameTooltip:AddLine(self:GetParent().items:get(index).name)
			end)
			GameTooltip:Show()
		end
	end)

	conditionDropdown.selectedButton:HookScript("OnLeave", function(self, userMoved)
		if (userMoved) then
			GameTooltip:Hide()
		end
	end)

	local textbox = buildEditbox(parent)
		:rightOf(conditionDropdown)
		:size(200, 20)
		:onTextChanged(function(self)
			local text = self:GetText()
			if (text) then
				local command = text:anyMatch("target", "togglemenu")
				if (command) then
					self.createButton:SetEnabled(true)
				else
					-- Do the search here
					local searchResult = search(text)

					if (self.buttonList) then
						self.buttonList:Hide()
						self.buttonList = nil
					end

					if (searchResult and not searchResult:isEmpty()) then

						local parent = self

						self.buttonList = CreateFrame("Frame", nil, self)
						self.buttonList:SetPoint("TOP", self, "BOTTOM", 0, 0)
						self.buttonList:SetSize(200, searchResult:count() * 20)
						self.buttonList.buttons = A:OrderedTable()

						local relative = self.buttonList
						searchResult:foreach(function(spellName)
							local builder = buildButton(self.buttonList)
									:onClick(function(self, b, d)
										if (b == "LeftButton" and not d) then
											parent:SetText(self.text:GetText())

											local icon = select(3, GetSpellInfo(self.text:GetText()))
											if (icon) then
												parent.icon:SetTexture(icon)
												parent:SetTextInsets(25, 0, 0, 0)
											else
												parent:SetTextInsets(5, 0, 0, 0)
											end

											parent.buttonList:Hide()
											parent.buttonList = nil

											parent.createButton:SetEnabled(true)
										end
									end)
									:backdrop(E.backdrops.editbox, { 0.1, 0.1, 0.1, 1 }, { .3, .3, .3, 0 })
									:size(200, 20)

							if (relative == self.buttonList) then
								builder:atTop()
							else
								builder:below(relative)
							end

							local button = builder:build()

							local icon = select(3, GetSpellInfo(spellName))

							button.icon = button:CreateTexture(nil, "OVERLAY")
							button.icon:SetSize(20, 20)
							button.icon:SetPoint("LEFT")
							button.icon:SetTexture(talentIcons[spellName] or icon)

							button.text = buildText(button, 10)
									:rightOf(button.icon)
									:x(5)
									:outline()
									:build()

							button.text:SetText(spellName)

							relative = button

							self.buttonList.buttons:add(button)
						end)
					else
						self.createButton:SetEnabled(false)
					end
				end
			end
		end)
		:onEditFocusLost(function(self)
			if (self.buttonList) then
				self.buttonList:Hide()
				self.buttonList = nil
			end
		end)
		:build()


	textbox.icon = textbox:CreateTexture(nil, "OVERLAY")
	textbox.icon:SetSize(20, 20)
	textbox.icon:SetPoint("LEFT")

	local createButton = buildButton(parent)
			:rightOf(textbox)
			:backdrop(E.backdrops.editboxborder, { 0.1, 0.1, 0.1, 1 }, { .3, .3, .3, 1 })
			:size(50, 20)
			:onClick(function(self, b, d)

				local conditions = conditionDropdown:GetValue()
				local spell = textbox:GetText()

				local key = keyDropdown:GetValue()
				local actionTbl = group.db.actions[key]

				local command = spell:anyMatch("target", "togglemenu")
				if (command) then
					-- Present notification here that conditions does not work for blizzard commands and this will
					-- also override any other settings for this key combination
					group.db.actions[key] = command
				else
					if (actionTbl and (actionTbl:find("target") or actionTbl:find("togglemenu"))) then
						-- Present notification here stating that the previous setting has a blizzard command and that
						-- needs to be removed before you can add something that is not.
					else
						local function concatConditions(c)
							local s = "@mouseover"
							c:foreach(function(cc)
								s = s..","..conditionDropdown.items:get(cc).name
							end)
							return s
						end

						local concatted = concatConditions(conditions)

						local toSave
						if (not actionTbl) then
							toSave = string.format("/cast [%s] %s", concatted, spell)
							group.db.actions[key] = toSave
						else
							if (actionTbl:find(concatted)) then
								-- Already exists, add a notification of some kind
							else
								toSave = string.format("[%s] %s;", concatted, spell)
								if (actionTbl:sub(-1) ~= ";") then
									toSave = "; "..toSave
									group.db.actions[key] = actionTbl..toSave
								else
									group.db.actions[key] = actionTbl.." "..toSave
								end
							end
						end
					end
				end

				parent:SetHeight(20 + (20 * T:tcount(group.db.actions[key]:explode(";"))))

				-- Save to db here and reload the rows
				textbox:SetText("")
				textbox:ClearFocus()
				textbox.icon:SetTexture(nil)
				textbox:SetTextInsets(5, 0, 0, 0)
				conditionDropdown:SetValue({})
				A.dbProvider:Save()
				keyDropdown:SimulateClickOnActiveItem()
				keyDropdown:Close()
				GameTooltip:Hide()
				A:UpdateDb()
			end)
			:build()

	createButton.text = buildText(createButton, 10)
			:atCenter()
			:build()

	createButton.text:SetText("Create")
	textbox.createButton = createButton

	A.clickCastWindow = parent
end

function CC:GetOptions(enabled, extraClick, order)

	local config = {
		enabled = enabled,
		canToggle = true,
		type = "group",
		order = order,
		placement = function(self)
			self:SetPoint("LEFT", self.parent, "RIGHT", 50, 0)
		end,
		onClick = function(self)
			extraClick(self)
			CC:ToggleClickCastWindow(self)
		end,
		children = {}
	}

	return config
end

A.general.clickcast = CC