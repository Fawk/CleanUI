local A, L = unpack(select(2, ...))

--[[ Blizzard ]]

--[[ Lua ]]

--[[ Locals ]]
local E = A.enum
local T = A.Tools
local U = A.Utils
local Units = A.Units
local media = LibStub("LibSharedMedia-3.0")

--[[ Default Layouts ]]
local defaults = {
	["TANK"] = {}, -- Some placement logic here...
	["HEALER"] = {},
	["DPS"] = {}
}

--[[

	["Position"] = {
		["Local Point"] = "TOP",
		["Point"] = "TOP",
		["Relative To"] = "Target",
		["Offset X"] = 0,
		["Offset Y"] = 0
	}

	T,T,Target,0,0

]]

local points = {
	["TOP"] = "T",
	["BOTTOM"] = "B",
	["RIGHT"] = "R",
	["LEFT"] = "L",
	["TOPRIGHT"] = "TR",
	["TOPLEFT"] = "TL",
	["BOTTOMRIGHT"] = "BR",
	["BOTTOMLEFT"] = "BL"
}

local Layout = {}

function Layout:Init()

	local custom = A.db.global.customLayouts
	if (custom and #custom > 0) then

	end

end

function Layout:Preview(id)
	-- Hide currently active preview...

	local custom = A.db.global.customLayouts

	local layout = defaults[id] or (custom and custom[id])
	if (layout) then
		-- Show preview
	end
end

function Layout:Choose(id)
	
end

A.modules.layout = Layout