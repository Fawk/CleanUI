local AddonName = ...
local A, L = unpack(select(2, ...))

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
	"nodead",
	"harm",
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

local CC = {}

function CC:Init(frame, db)
	for key, action in next, db do

		local mapped = keyMap[key]

		if (key:equals("LMB", "MMB", "RMB")) then
			frame:SetAttribute(mapped, "macro")
			frame:SetAttribute("*macrotext"..mapped:match("%d"), action)
		else
			registerAttributeIfNeeded(frame, key)
			frame:SetAttribute(mapped, action)
		end
	end
end

function CC:GetInitString(initString, db)
	local initiated = {}
	for key, action in next, db do

		local mapped = keyMap[key]

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
		local split = action:split(";")
		for _,row in next, split do
			row = row:trim()
			local spell = row:match("%s[A-Za-z%s]+"):trim()
			local conditions = row:match("%[[@%w,]+%]"):sub(2):sub(1, -2):split(",")

			local map = {
				["spell"] = spell,
				["conditions"] = A:OrderedTable()
			}
			for _,condition in next, conditions do
				for _,mappedCondition in next, conditionMap do
					if (condition:match(mappedCondition)) then
						map.conditions:add(condition)
					end
				end
			end

			actions:add(map)
		end
	end

	return actions
end

function CC:ToggleClickCastWindow(group)
	-- List the actions
	-- New action button for key, with save that has to be pressed to verify against existing actions for that key
	local actions = splitActionsByConditions(group.db)
	actions:foreach(function(action)
	--[[
		Something like this:

		[ ] Dead [ ] Help [ ] Harm [ ] Combat [ talent dropdown ] [ textbox with that will search for available item/spell for use on textChanged ]
	]]
	end)
end

function CC:GetOptions(enabled, order)

	local config = {
		enabled = enabled,
		canToggle = true,
		type = "group",
		order = order,
		placement = function(self)

		end,
		onClick = function(self)
			CC:ToggleClickCastWindow(self)
		end,
		children = {}
	}

	return config
end

