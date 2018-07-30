local A, L = unpack(select(2, ...))

--[[ Blizzard ]]
local _G = _G

--[[ Lua ]]
local unpack = unpack

--[[ Locals ]]
local E = A.enum
local S = A.Skins
local T = A.Tools
local media = LibStub("LibSharedMedia-3.0")
local iconLib = LibStub("LibDBIcon-1.0", true)

local moduleName = "Minimap"
local M = {}

function M:Init()

	local minimapConfig = A["Profile"]["Options"][moduleName]

	Minimap.Update = function(self, db)
		self:SetSize(db.Size - 3, db.Size - 3)
		MinimapBackdrop:SetSize(db.Size, db.Size)
	end

	local position = minimapConfig["Position"]
	local x, y = position["Offset X"], position["Offset Y"]

	MinimapCluster:ClearAllPoints()
	MinimapCluster:SetPoint(position["Local Point"], A.frameParent, position["Point"], x, y)
	MinimapCluster:SetSize(minimapConfig.Size - 3, minimapConfig.Size - 3)
	Minimap:SetSize(MinimapCluster:GetSize())

	Minimap:ClearAllPoints()
	Minimap:SetAllPoints(MinimapCluster)

	hooksecurefunc(MinimapCluster, "SetPoint", function(self, lp, r, p, x, y)
		if r == UIParent then return end;

	end)

	Minimap:SetMinResize(E.minimap.min, E.minimap.min)
	Minimap:SetMaxResize(E.minimap.max, E.minimap.max)

	MinimapCluster.ignoreFramePositionManager = true
	Minimap.ignoreFramePositionManager = true

	MinimapCluster.db = minimapConfig

    A:CreateMover(MinimapCluster, minimapConfig, moduleName)

	--Minimap:SetMaskTexture(media:Fetch("widget", "cui-minimap-mask-square"))
	Minimap:SetArchBlobRingScalar(0)
	Minimap:SetArchBlobRingAlpha(0)
	Minimap:SetQuestBlobRingScalar(0)
	Minimap:SetQuestBlobRingAlpha(0)
	MinimapBackdrop:SetSize(minimapConfig.Size, minimapConfig.Size)
	--MinimapBackdrop:SetBackdrop(backdrop(0, 1, 0, 0, 0, 0))
	MinimapBackdrop:SetBackdropColor(unpack(A.colors.backdrop.default))
	MinimapBackdrop:SetParent(Minimap)
	MinimapBackdrop:SetPoint(E.regions.C)
	MinimapBackdrop:SetFrameLevel(Minimap:GetFrameLevel()-1)
	MinimapBorder:SetTexture(nil)
	MinimapBorderTop:SetTexture(nil)

	S:Kill(MinimapZoomOut)		
	MinimapZoomOut:SetSize(18, 18)
	MinimapZoomOut:SetPoint(E.regions.BR, Minimap, E.regions.BR, -3, 5)
	MinimapZoomOut:SetFrameLevel(Minimap:GetFrameLevel()+1)

	S:Kill(MinimapZoomIn)
	MinimapZoomIn:SetSize(18, 18)
	MinimapZoomIn:SetPoint(E.regions.BR, Minimap, E.regions.BR, -3, 25)
	MinimapZoomIn:SetFrameLevel(Minimap:GetFrameLevel()+1)

	MinimapZoomIn:GetNormalTexture():SetAllPoints()
	MinimapZoomOut:GetNormalTexture():SetAllPoints()

	S:Kill(MinimapZoneTextButton)

	MinimapZoneTextButton:SetParent(Minimap)
	MinimapZoneTextButton:SetPoint(E.regions.T, Minimap, E.regions.T, 0, -5)
	MinimapZoneTextButton:SetHeight(20)
	MinimapZoneTextButton:SetWidth(175)
	--MinimapZoneTextButton:SetBackdrop(backdrop(3, 1))
	local r, g, b, a = unpack(A.colors.backdrop.default)
	MinimapZoneTextButton:SetBackdropColor(r, g, b, 0.76)
	MinimapZoneTextButton:SetBackdropBorderColor(unpack(A.colors.backdrop.border))
	S:Font(MinimapZoneText, 11, "NONE")
	MinimapZoneText:SetPoint(E.regions.C)

	hooksecurefunc(MinimapZoneText, "SetTextColor", function(t, rr, gg, bb)
		local pvpType, isSubZonePvP, factionName = GetZonePVPInfo();
		if ( pvpType == "sanctuary" ) then
		elseif ( pvpType == "arena" ) then
		elseif ( pvpType == "friendly" ) then
		elseif ( pvpType == "hostile" ) then
		elseif ( pvpType == "contested" ) then
		else
			if rr ~= 1 or gg ~= 1 or bb ~= 1 then
				t:SetTextColor(1, 1, 1);
			end
		end
	end)

	GuildInstanceDifficulty:SetParent(Minimap)
	GuildInstanceDifficulty:ClearAllPoints()
	GuildInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 2, -2)

	MiniMapInstanceDifficulty:SetParent(Minimap)
	MiniMapInstanceDifficulty:ClearAllPoints()
	MiniMapInstanceDifficulty:SetAllPoints(GuildInstanceDifficulty)

	MiniMapWorldMapButton:Hide()
	GarrisonLandingPageMinimapButton:SetAlpha(0)

	MiniMapTracking:Hide()
	Minimap:SetScript("OnMouseUp", function(self, button)
		if button == "RightButton" then
			ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "cursor", -10, -20)
		elseif button == "LeftButton" then
			local x, y = GetCursorPosition();
			x = x / self:GetEffectiveScale();
			y = y / self:GetEffectiveScale();

			local cx, cy = self:GetCenter();
			x = x - cx;
			y = y - cy;
			if ( sqrt(x * x + y * y) < (self:GetWidth() / 2) ) then
				self:PingLocation(x, y);
			end
		end
	end)

	if (iconLib) then
		local callbackObj = {
			Func = function()
				local minimapButtonRelative = Minimap
				for _, v in pairs({ Minimap:GetChildren() }) do
					local childName = v:GetName() or ""
					if childName:find("^LibDBIcon10_") then
						local libName
						string.gsub(childName, "_(%w+)", function(w) libName = w end)
						local minimapButton = iconLib.objects[libName]
						if minimapButton:IsShown() then
							minimapButton:ClearAllPoints()
							minimapButton:SetPoint(E.regions.TR, minimapButtonRelative, minimapButtonRelative == Minimap and E.regions.TL or E.regions.BR, 0, 2)
							minimapButton:SetSize(28, 28)
							--minimapButton:SetBackdrop(backdrop(0, 1))
							minimapButton:SetBackdropColor(unpack(A.colors.backdrop["75alpha"]))
							minimapButton.icon:ClearAllPoints()
							minimapButton.icon:SetPoint("CENTER")
							minimapButton.icon:SetSize(24, 24)

							for i = 1, minimapButton:GetNumRegions() do
								local region = select(i, minimapButton:GetRegions())
								if region:GetObjectType() == "Texture" and region:GetTexture() then
									if string.find(region:GetTexture(), "Interface\\Minimap") then
										region:SetTexture(nil)
									end
								end
							end

							minimapButtonRelative = minimapButton
						end
					end
				end
			end
		}

		iconLib.RegisterCallback(callbackObj, "LibDBIcon_IconCreated", "Func")

		callbackObj:Func()
	end

	local function killTimeFrames()

		S:Kill(TimeManagerClockButton)
		S:Font(TimeManagerClockButton, 10)
		--f:SetPoint(E.regions.C, TimeManagerClockButton, E.regions.C, 0, 0)
		--f:SetJustifyH(E.regions.C)
		--f:SetJustifyV(E.regions.C)
		TimeManagerClockButton:SetSize(44, 20)
		TimeManagerClockButton:SetPoint(E.regions.BL, Minimap, E.regions.BL, 3, 3)
		--TimeManagerClockButton:SetBackdrop(backdrop(3, 1))
		TimeManagerClockButton:SetBackdropColor(r, g, b, 0.76)
		TimeManagerClockButton:SetBackdropBorderColor(unpack(A.colors.backdrop.border))
		S:Kill(GameTimeFrame)
		GameTimeFrame:SetSize(28, 28)
		--GameTimeFrame:ClearAllPoints()
		GameTimeFrame:SetPoint(E.regions.TR, Minimap, E.regions.TR, -5, -5)
		GameTimeFrame.tex = GameTimeFrame:CreateTexture(nil, "BACKGROUND")
		--GameTimeFrame.tex:SetTexture(media:Fetch("widget", "cui-calendar"))
		GameTimeFrame.tex:SetAllPoints()
		S:Font(GameTimeFrame, 10)
		--f:SetTextColor(1, 1, 1)
		--f:ClearAllPoints()
		--f:SetPoint(E.regions.C, GameTimeFrame, E.regions.C, 0, -3)
		MiniMapMailBorder:SetTexture(nil)
		--MiniMapMailIcon:SetTexture(media:Fetch("widget", "cui-mail-icon"))
		MiniMapMailFrame:ClearAllPoints()
		MiniMapMailFrame:SetPoint(E.regions.B, TimeManagerClockButton, E.regions.T, 0, -5)

	end

	if not IsAddOnLoaded("Blizzard_TimeManager") then
		LoadAddOn("Blizzard_TimeManager")
	end

	killTimeFrames()

end

function M:Update(...)

end

A.general:set("minimap", M)