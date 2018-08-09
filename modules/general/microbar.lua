local A, L = unpack(select(2, ...))

--[[ Blizzard ]]
local _G = _G

--[[ Lua ]]

--[[ Locals ]]
local E = A.enum
local S = A.Skins
local T = A.Tools
local media = LibStub("LibSharedMedia-3.0")

local moduleName = "Micro Bar"
local MicroBar = {}

function MicroBar:Init()
	if true then return end
	local db = A.db.profile.general.microBar

	if (db.enabled) then

		local position = db.position
		local microButtonBar = CreateFrame("Frame", nil, A.frameParent)

		local relative = microButtonBar
		for i,name in next, MICRO_BUTTONS do
			local button = _G[name]
			microButtonBar:SetWidth(microButtonBar:GetWidth() + button:GetWidth())
			microButtonBar:SetHeight(button:GetHeight())

			button:ClearAllPoints()
			if (relative == microButtonBar) then
				button:SetPoint("LEFT", relative, "LEFT", 0, 0)
			else
				button:SetPoint("LEFT", relative, "RIGHT", -2, 0)
			end

			if (i == 1) then
				hooksecurefunc(button, "SetPoint", function(self, lp, r, p, x, y)
					if (r ~= microButtonBar) then
						self:ClearAllPoints()
						self:SetPoint("LEFT", microButtonBar, "LEFT")
					end
				end)
			end

			relative = button
		end

		microButtonBar:SetPoint(position.localPoint, A.frameParent, position.point, position.x, position.y)
		A:CreateMover(microButtonBar, db, moduleName)

		if (db.hide) then
			for _,name in next, MICRO_BUTTONS do
				local button = _G[name]
				button:Hide()
			end

			microButtonBar:Hide()
		end
	end
end

function MicroBar:Update(...)

end

A.general.microbar = MicroBar