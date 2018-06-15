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
	"combat"
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
		if (key:equals("LMB", "MMB", "RMB")) then
			frame:SetAttribute(keyMap[key], "macro")
			frame:SetAttribute("*macrotext"..keyMap[key]:match("%d"), action)
		else
			registerAttributeIfNeeded(frame, key)
			frame:SetAttribute(keyMap[key], action)
		end
	end
end

function CC:GetInitString(initString, db)
	local initiated = {}
	for key, action in next, db do
		if (key:equals("LMB", "MMB", "RMB")) then
			initString = initString..'\nself:SetAttribute("'..keyMap[key]..'","macro");'
			initString = initString..'\nself:SetAttribute("*macrotext"'..keyMap[key]:match("%d")..'","'..action..'");'
			initiated[key] = true
		else
			local mapped = keyMap[key]
			local needed = mapped:matchAny("LMB", "MMB", "RMB")
			if (not initiated[needed]) then
				initString = initString..'\nself:SetAttribute("'..keyMap[needed]..'","macro");'
			end
			initString = initString..'\nself:SetAttribute("'..keyMap[key]..'","'..action..'");'
		end
	end
	return initString
end

function CC:GetOptions(enabled, click, order)

	local config = {
		enabled = enabled,
		canToggle = true,
		type = "group",
		order = order,
		placement = function(self)

		end,
		onClick = click,
		children = {

		}
	}

	return config
end

