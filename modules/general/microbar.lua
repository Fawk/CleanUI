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

	local db = A["Profile"]["Options"][moduleName]

	if (db["Enabled"]) then

		local position = db["Position"]
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

		microButtonBar:SetPoint(position["Local Point"], A.frameParent, position["Point"], position["Offset X"], position["Offset Y"])
		A:CreateMover(microButtonBar, db, moduleName)

		if (db["Hide"]) then
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

A.general:set("microbar", MicroBar)