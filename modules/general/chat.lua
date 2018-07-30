local A, L = unpack(select(2, ...))

--[[ Blizzard ]]
local _G = _G

--[[ Lua ]]

--[[ Locals ]]
local E = A.enum
local S = A.Skins
local T = A.Tools
local media = LibStub("LibSharedMedia-3.0")

local Chat = {}

function Chat:Init()
	
	local db = A["Profile"]["Options"]["Chat"]

	for _,name in pairs(CHAT_FRAMES) do
		local frame = _G[name]
		if frame then

			local bf = _G[name.."ButtonFrame"]
			if bf then 
				S:Kill(bf)
				bf:Hide()
			end
			frame:SetClampedToScreen(false)
			S:Kill(frame)

			S:Font(frame, 11, "SHADOW")
			local tab = _G[name.."Tab"]
			if tab then

				--hooksecurefunc(tab, "SetAlpha", function(self, alpha)
					--if (alpha == self.noMouseAlpha) then
						--T:FadeOut(self, 4)
					--end
				--end)

				S:Kill(tab)
				tab.text = _G[name.."TabText"]
				S:Font(tab.text, 12)
				tab.text:SetTextColor(1, 1, 1)
				hooksecurefunc(tab.text, "SetTextColor", function(t, r, g, b, a)
					if r ~= 1 or g ~= 1 or b ~= 1 then
						t:SetTextColor(1, 1, 1)
					end
				end)
			end
			local editbox = _G[name.."EditBox"]
			if editbox then
				for i = 1, editbox:GetNumRegions() do
					local region = select(i, editbox:GetRegions())
					if region:GetObjectType() == "Texture" then 
						if region:GetTexture() ~= "Color-ffffffff-CSimpleTexture" then
							region:SetTexture(nil)
						end
					end
				end	
				editbox:SetHeight(24)
				S:Font(editbox, 12, "SHADOW")
				editbox:SetBackdrop(E.backdrops.editboxborder)
				editbox:SetBackdropColor(0, 0, 0, 0.4)
				editbox:SetPoint(E.regions.TL, frame, E.regions.BL, 0, -5)
				editbox:SetPoint(E.regions.TR, frame, E.regions.BR, 0, -5)
				local r, g, b, a = unpack(A.colors.backdrop.default)
				editbox:SetBackdropColor(r, g, b, 0.67)
				editbox:SetBackdropBorderColor(unpack(A.colors.backdrop.border))
				S:Font(_G[name.."EditBoxHeader"], 12, "SHADOW")
			end
		end
	end
	QuickJoinToastButton:Hide()
	ChatFrameMenuButton:Hide()
end

function Chat:Update(...)

end

A.general:set("chat", Chat)
