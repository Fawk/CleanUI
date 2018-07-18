local A, L = unpack(select(2, ...))

--[[ Blizzard ]]
local _G = _G

--[[ Lua ]]

--[[ Locals ]]
local E = A.enum
local media = LibStub("LibSharedMedia-3.0")

local Skins = {}

function Skins:Kill(frame)
	if not frame.GetNumRegions then return end
	for _,region in next, { frame:GetRegions() } do
		if (region.GetChildren) then
			for _,child in next, { region:GetChildren() } do
				self:Kill(child)
			end
		end
		if (region:GetObjectType() == "Texture") then 
			region:SetTexture(nil)
		end
	end
end

function Skins:Font(fs, size, style)
	if (not fs or not fs.SetFont) then return end
	style = style or "OUTLINE"
	fs:SetFont(media:Fetch("font", "Default"), size, style == "SHADOW" and "NONE" or style)
	if (style == "SHADOW") then
		fs:SetShadowColor(0, 0, 0, 1) 
		fs:SetShadowOffset(1, -1) 
	end
end

A.Skins = Skins