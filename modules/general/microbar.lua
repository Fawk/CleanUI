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
		for _,name in next, MICRO_BUTTONS do
			local button = _G[name]
			microButtonBar:SetWidth(microButtonBar:GetWidth() + button:GetWidth())
			microButtonBar:SetHeight(button:GetHeight())

			button:ClearAllPoints()
			if (relative == microButtonBar) then
				button:SetPoint("LEFT", relative, "LEFT", 0, 0)
			else
				button:SetPoint("LEFT", relative, "RIGHT", -2, 0)
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

A.general.microbar = MicroBar