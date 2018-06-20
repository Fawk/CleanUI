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

local conditionMap = {
	"dead",
	"harm",
	"help",
	"combat",
	"talent:[1-7]/[1-3]"
}

local function registerAttributeIfNeeded(frame, key)
	local mapped = keyMap[key]
	local needed = mapped:matchAny("LMB", "MMB", "RMB")
	if (needed and not frame:GetAttribute(keyMap[needed])) then
		frame:SetAttribute(keyMap[needed], "macro")
	end
end

local function blizzardCommand(frame, mapped, command, initString)
	if (initString) then
		return initString..'\nself:SetAttribute("'..mapped:gsub("macrotext", "type")..'","'..command..'");'
	else
		frame:SetAttribute(mapped, command)
	end
end

local CC = {}

function CC:Setup(frame, db)
	if (not db["Enabled"]) then return end

	for key, action in next, db["Actions"] do

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
	if (not db["Enabled"]) then return initString end

	local initiated = {}
	for key, action in next, db["Actions"] do

		local mapped = keyMap[key]

		local command = action:anyMatch("target", "togglemenu")
		if (command) then
			initString = blizzardCommand(frame, mapped, command, initString)
		else
			if (key:equals("LMB", "MMB", "RMB")) then
				initString = initString..'\nself:SetAttribute("'..mapped..'","macro");'
				initString = initString..'\nself:SetAttribute("*macrotext'..mapped:match("%d")..'","'..action..'");'
				initiated[key] = true
			else
				local needed = mapped:matchAny("LMB", "MMB", "RMB")
				if (not initiated[needed]) then
					initString = initString..'\nself:SetAttribute("'..keyMap[needed]..'","macro");'
				end
				initString = initString..'\nself:SetAttribute("'..mapped..'","'..action..'");'
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
		local split = action:explode(";")

		for _,row in next, split do
			row = row:trim()

			local spell, conditions = nil, {}
			if (row:anyMatch("target", "togglemenu")) then
				spell = row
			else
				spell = row:match("%s[A-Za-z%s]+"):trim()
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
					if (condition:match(mappedCondition)) then
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

function CC:ToggleClickCastWindow(group)

	-- List the existing actions
	if (A.clickCastWindow) then
		A.clickCastWindow:Hide()
		A.clickCastWindow = nil
	end

	local parent = CreateFrame("Frame", nil, A.frameParent)
	parent:SetPoint("CENTER")
	parent:SetBackdrop(A.enum.backdrops.editbox)
	parent:SetBackdropColor(0.3, 0.3, 0.3, 0.3)
	parent:SetSize(600, 600)

	local relative = parent

	local actions = splitActionsByConditions(group.db["Actions"])
	actions:foreach(function(action)

		local row = CreateFrame("Frame", nil, parent)
		row:SetSize(parent:GetWidth(), 20)

		if (relative == parent) then
			row:SetPoint("TOPLEFT")
			row:SetPoint("TOPRIGHT")
		else
			row:SetPoint("TOPLEFT", relative, "BOTTOMLEFT", 0, 0)
			row:SetPoint("TOPRIGHT", relative, "BOTTOMRIGHT", 0, 0)
		end

		local keys = {}
		for key,_ in next, keyMap do
			table.insert(keys, key)
		end

		local keyDropdown = buildDropdown(row)
				:atLeft()
				:x(10)
				:addItems(keys)
				:size(200, 20)
				:fontSize(10)
				:build()

		keyDropdown:SetValue(action.key)

		local selectedConditions = {}
		for i = 1, action.conditions:count() do
			local condition = action.conditions:get(i)
			if (condition.active) then
				table.insert(selectedConditions, i)
			end
		end

		local conditions = {}
		for _,mappedCondition in next, conditionMap do
			if (not mappedCondition:find("talent")) then
				table.insert(conditions, mappedCondition)
			end
		end

		local talents = getTalentTable()
		local conditionDropdown = buildMultiDropdown(row)
				:rightOf(keyDropdown)
				:x(5)
				:size(150, 20)
				:fontSize(10)
				:overrideText("Conditions")
				:addItems(conditions)
				:addItems(talents)
				:stayOpenAfterChoosing()
				:build()

		conditionDropdown:SetValue(selectedConditions)

	--[[
		Something like this:

		[ ] Dead [ ] Help [ ] Harm [ ] Combat [ talent dropdown ] [ textbox with that will search for available spell/target/togglemenu for use on textChanged ]
	]]

		local textbox = buildEditbox(row)
				:atRight()
				:x(-10)
				:size(200, row:GetHeight())
				:onTextChanged(function(self)
					local text = self:GetText()
					if (text) then
						local command = text:anyMatch("target", "togglemenu")
						if (command) then
							self.acceptButton:SetEnabled(true)
						else
							-- Do the search here
							local searchResult -- Do stuff...
							if (searchResult) then
								if (searchResult:count() > 1) then
									-- Specific one must be chosen
								else

									self.acceptButton:SetEnabled(true)
								end
							else
								self.acceptButton:SetEnabled(false)
							end
						end
					end
				end)
				:onValueChanged(function(self, value)

				end)
				:build()
		
		textbox:SetFont(media:Fetch("font", "Default"), 10, "OUTLINE")
		textbox:SetValue(action.spell)
		
		textbox.acceptButton = buildButton(textbox)
				:atRight()
				:backdrop(E.backdrops.editboxborder, { 0.1, 0.1, 0.1, 1 }, { .8, .8, .8, 1 })
				:onClick(function(self, b, d)
					-- Save to db here
					local value = self:GetParent():GetText()
					-- Do something with this
				end)
				:build()
		--textbox.acceptButton:SetFont(media:Fetch("font", "Default"), 10, "OUTLINE")
		textbox.acceptButton:SetText("Ok")

		relative = row
	end)

	-- New action button for key, with save that has to be pressed to verify against existing actions for that key

	A.clickCastWindow = parent
end

function CC:GetOptions(enabled, order)

	local config = {
		enabled = enabled,
		canToggle = true,
		type = "group",
		order = order,
		placement = function(self)
			self:SetPoint("LEFT", self.parent, "RIGHT", 50, 0)
		end,
		onClick = function(self)
			CC:ToggleClickCastWindow(self)
		end,
		children = {}
	}

	return config
end

A.modules.clickcast = CC