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

	local db = A.db.profile.general.overrideBar

	if not db then return end

	if (db.enabled) then

		local position = db.position
		local overrideBar = CreateFrame("Frame", nil, A.frameParent)

		overrideBar:SetHeight(MainMenuBarBackpackButton:GetHeight())
		overrideBar:SetWidth(MainMenuBarBackpackButton:GetWidth())

		
		overrideBar:SetPoint(position.localPoint, A.frameParent, position.point, position.x, position.y)
		A:CreateMover(overrideBar, db, moduleName)

		if (db.hide) then

			overrideBar:Hide()
		end
	end
end

function OverrideBar:Update(...)

end

A.general.overrideBar = OverrideBar