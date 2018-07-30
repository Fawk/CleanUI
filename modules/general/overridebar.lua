local A, L = unpack(select(2, ...))

--[[ Blizzard ]]
local _G = _G

--[[ Lua ]]

--[[ Locals ]]
local E = A.enum
local S = A.Skins
local T = A.Tools
local media = LibStub("LibSharedMedia-3.0")

local moduleName = "Override Bar"
local OverrideBar = {}

function OverrideBar:Init()

	local db = A["Profile"]["Options"][moduleName]

	if not db then return end

	if (db["Enabled"]) then

		local position = db["Position"]
		local overrideBar = CreateFrame("Frame", nil, A.frameParent)

		overrideBar:SetHeight(MainMenuBarBackpackButton:GetHeight())
		overrideBar:SetWidth(MainMenuBarBackpackButton:GetWidth())

		
		overrideBar:SetPoint(position["Local Point"], A.frameParent, position["Point"], position["Offset X"], position["Offset Y"])
		A:CreateMover(overrideBar, db, moduleName)

		if (db["Hide"]) then

			overrideBar:Hide()
		end
	end
end

function OverrideBar:Update(...)

end

A.general:set("overrideBar", OverrideBar)