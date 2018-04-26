
local A, L = unpack(select(2, ...))
local _G, E, media = _G, A.enum, LibStub("LibSharedMedia-3.0")
local iconLib = LibStub("LibDBIcon-1.0", true)
local Tools = A.Tools
local buildText = A.TextBuilder
local oUF = oUF or A.oUF

local backdrops = { "DropDownList1MenuBackdrop", "DropDownList2MenuBackdrop", "GameTooltip", "GameMenuFrame" }
local shoppingTexts = {
	"ShoppingTooltip1TextLeft1",
	"ShoppingTooltip1TextLeft2",
	"ShoppingTooltip1TextLeft3",
	"ShoppingTooltip1TextLeft4",
	"ShoppingTooltip1TextRight1",
	"ShoppingTooltip1TextRight2",
	"ShoppingTooltip1TextRight3",
	"ShoppingTooltip1TextRight4",

	"ShoppingTooltip2TextLeft1",
	"ShoppingTooltip2TextLeft2",
	"ShoppingTooltip2TextLeft3",
	"ShoppingTooltip2TextLeft4",
	"ShoppingTooltip2TextRight1",
	"ShoppingTooltip2TextRight2",
	"ShoppingTooltip2TextRight3",
	"ShoppingTooltip2TextRight4"
}

local function backdrop(es, ts, t, b, r, l)
	return { 
		bgFile = media:Fetch("background", "cui-default-bg"), 
		tile = ts > 0 and true or false, 
		tileSize = ts or 0, 
		edgeFile = es > 0 and media:Fetch("border", "cui-round-border2") or nil, 
		edgeSize = es or 0, 
		insets = { 
			top = t or 1, 
			bottom = b or 1, 
			left = l or 1,
			right = r or 1 
		} 
	}
end
local function font(size, outline) return media:Fetch("font", "NotoBold"), size, outline or "NONE" end
local function kill(frame) 
	if not frame.GetNumRegions then return end
	for i = 1, frame:GetNumRegions() do
		local region = select(i, frame:GetRegions())
		if region.GetChildren then
			for k,v in pairs({ region:GetChildren() }) do
				kill(v)
			end
		end
		if region:GetObjectType() == "Texture" then 
			region:SetTexture(nil)
		end
	end
end
local function setFont(frame, size, outline)
	if not frame.GetNumRegions then return end
	local r, c = "", 0
	for i = 1, frame:GetNumRegions() do
		local region = select(i, frame:GetRegions())
		if region:GetObjectType() == "FontString" then 
			region:SetFont(font(size, outline == "SHADOW" and "NONE" or outline)) 
			if outline == "SHADOW" then 
				region:SetShadowColor(0, 0, 0, 1) 
				region:SetShadowOffset(1, -1) 
			end
			c=c+1 
			r=region 
		end
	end
	if c == 1 then return r end
end
local function button(parent, point, width, height, text, fontSize, fontOutline, fontAlignH, fontAlignV, onClick)
	local b = CreateFrame("Button", nil, parent)
	b:SetPoint(unpack(point))
	b:SetSize(width, height)
	b:SetBackdrop(backdrop(3, 1))
	b:SetBackdropColor(0.15, 0.15, 0.15, 1)
	b:SetBackdropBorderColor(unpack(A.colors.backdrop.border))
	b.text = b:CreateFontString(nil, "OVERLAY")
	b.text:SetFont(font(fontSize, fontOutline))
	b.text:SetText(text)
	b.text:SetJustifyH(fontAlignH or E.regions.C)
	b.text:SetJustifyV(fontAlignV or E.regions.C)
	b:SetFontString(b.text)
	b:SetScript("OnClick", onClick)
	return b
end

local function setStyle()

	--General
	do
		for _,bd in pairs(backdrops) do
			_G[bd]:SetBackdrop(backdrop(3, 1))
			_G[bd]:SetBackdropColor(unpack(A.colors.backdrop.default))
			_G[bd]:SetBackdropBorderColor(unpack(A.colors.backdrop.border))
		end
	end

	--ChallengerKeyStoneFrame:SetFrameStrata("HIGH")

	--Chat
	do
		CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1.0;
		CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0;
		CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1.0;
		CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 0.4;
		CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 0.6;
		CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0;
		
		local db = A["Profile"]["Options"]["Chat"]
	
		for _,name in pairs(CHAT_FRAMES) do
			local frame = _G[name]
			if frame then
	
				if db["Hide In Combat"] then
		
					frame:RegisterEvent("PLAYER_REGEN_DISABLED")
					frame:RegisterEvent("PLAYER_REGEN_ENABLED")
					frame:HookScript("OnEvent", function(self, event, ...)
						if event == "PLAYER_REGEN_DISABLED" then
							self:SetAlpha(0)
							local tab = _G[name.."Tab"]
							if tab then
								tab:SetAlpha(0)
							end
						elseif event == "PLAYER_REGEN_ENABLED" then
							self:SetAlpha(1)
							local tab = _G[name.."Tab"]
							if tab then
								tab:SetAlpha(1)
							end
						end
					end)
					
				end

				local bf = _G[name.."ButtonFrame"]
				if bf then 
					kill(bf)
					bf:Hide()
				end
				frame:SetClampedToScreen(false)
				kill(frame)
				--frame:SetFont(font(12))
				frame:SetFont(media:Fetch("font", "NotoBold"), 10, "NONE")
				local tab = _G[name.."Tab"]
				if tab then
					kill(tab)
					tab.text = _G[name.."TabText"]
					tab.text:SetFont(font(10))
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
					editbox:SetFont(font(10))
					editbox:SetBackdrop(backdrop(3, 1))
					editbox:SetPoint(E.regions.TL, frame, E.regions.BL, 0, -5)
					editbox:SetPoint(E.regions.TR, frame, E.regions.BR, 0, -5)
					local r, g, b, a = unpack(A.colors.backdrop.default)
					editbox:SetBackdropColor(r, g, b, 0.67)
					editbox:SetBackdropBorderColor(unpack(A.colors.backdrop.border))
					_G[name.."EditBoxHeader"]:SetFont(font(10))
				end
			end
		end
		QuickJoinToastButton:Hide()
		ChatFrameMenuButton:Hide()
	end

	--GameTooltip
	do
		local function checkTooltipColor()
			local _r, _g, _b, _a = unpack(A.colors.backdrop.light)
			local r, g, b = GameTooltip:GetBackdropColor()
			if(r ~= _r or g ~= _g or b ~= _b) then
				GameTooltip:SetBackdropColor(_r, _g, _b)
			end
		end
		
		GameTooltipHeaderText:SetFont(font(11))
		GameTooltipText:SetFont(font(10))
		GameTooltipTextSmall:SetFont(font(10))

		GameTooltip:HookScript("OnSizeChanged", checkTooltipColor)
		GameTooltip:RegisterEvent("CURSOR_UPDATE", checkTooltipColor)
		GameTooltip:HookScript("OnShow", function(self)
			self:SetBackdropColor(unpack(A.colors.backdrop.light))
			self:SetBackdropBorderColor(unpack(A.colors.backdrop.border))
		end)
		
		for _,shoppingTooltip in pairs(GameTooltip.shoppingTooltips) do
			shoppingTooltip:SetBackdrop(backdrop(3, 1))
			shoppingTooltip:HookScript("OnShow", function(self)
				self:SetBackdropColor(unpack(A.colors.backdrop.light))
				self:SetBackdropBorderColor(unpack(A.colors.backdrop.border))
			end)
		end

		for _,st in pairs(shoppingTexts) do
			_G[st]:SetFont(font(10))
		end

		_G["WorldMapTooltip"]:HookScript("OnShow", function(self)
			self:SetBackdrop(backdrop(3, 1))
			self:SetBackdropColor(unpack(A.colors.backdrop.light))
			self:SetBackdropBorderColor(unpack(A.colors.backdrop.border))
		end)
	end

	--ColorPickerFrame
	do
		ColorPickerFrame:SetBackdrop(backdrop(3, 1))
		ColorPickerFrame:SetBackdropColor(unpack(A.colors.backdrop.default))
		ColorPickerFrame:SetBackdropBorderColor(unpack(A.colors.backdrop.border))
		
		for i = 1, ColorPickerFrame:GetNumRegions() do
			local region = select(i, ColorPickerFrame:GetRegions())
			if region:GetObjectType() == "FontString" then
				region:SetFont(font(10))
				region:SetTextColor(1, 1, 1, 1)
				region:SetPoint(E.regions.T, region:GetParent(), E.regions.T, 0, -5)
			end
	        if region:GetObjectType() == "Texture" and region:GetName() == "ColorSwatch" then
	            ColorPickerFrame.ColorSwatch = region
	        end
		end
		
		ColorPickerFrameHeader:SetTexture(nil)
		OpacitySliderFrame:SetBackdrop(backdrop(3, 1))
		OpacitySliderFrame:SetBackdropColor(0, 0, 0, 0.75)
		OpacitySliderFrame:SetBackdropBorderColor(unpack(A.colors.backdrop.border))
		OpacitySliderFrame:SetThumbTexture(media:Fetch("widget", "cui-slider-thumb-texture"))
		OpacitySliderFrame:GetThumbTexture():SetSize(16, 16)
		OpacitySliderFrame:SetWidth(6)
		setFont(OpacitySliderFrame, 16)

		ColorPickerOkayButton:Hide()
		ColorPickerCancelButton:Hide()

		ColorPickerOkayButton._Show = ColorPickerOkayButton.Show
		ColorPickerOkayButton.Show = nil

		ColorPickerCancelButton._Show = ColorPickerCancelButton.Show
		ColorPickerCancelButton.Show = nil

		local okayButton = button(ColorPickerFrame, { E.regions.B, ColorPickerFrame, E.regions.B, 0, 5 }, 60, 25, "Okay", 11, nil, nil, nil, 
			function(self, button, down) 
				ColorPickerOkayButton:Click(button, down) 
			end)

		local cancelButton = button(ColorPickerFrame, { E.regions.L, okayButton, E.regions.R, 5, 0 }, 60, 25, "Cancel", 11, nil, nil, nil, 
			function(self, button, down) 
				ColorPickerCancelButton:Click(button, down) 
			end)

		ColorPickerOkayButton:HookScript('OnClick', function()
			collectgarbage("collect"); --Couldn't hurt to do this, this button usually executes a lot of code.
		end)
	end

	--Actionbars
	do
		_G["MainMenuBarLeftEndCap"]:SetTexture(nil)
		_G["MainMenuBarRightEndCap"]:SetTexture(nil)
	end

	--Minimap
	do
		local minimapConfig = A["Profile"]["Options"]["Minimap"]

		Minimap.Update = function(self, db)
			self:SetSize(db.Size - 3, db.Size - 3)
			MinimapBackdrop:SetSize(db.Size, db.Size)
		end
		--A["OptionsContainer"]:GetOption("Minimap"):AddSubscriber(Minimap)



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

        A:CreateMover(MinimapCluster, minimapConfig, "Minimap")

		Minimap:SetMaskTexture(media:Fetch("widget", "cui-minimap-mask-square"))
		Minimap:SetArchBlobRingScalar(0)
		Minimap:SetArchBlobRingAlpha(0)
		Minimap:SetQuestBlobRingScalar(0)
		Minimap:SetQuestBlobRingAlpha(0)
		MinimapBackdrop:SetSize(minimapConfig.Size, minimapConfig.Size)
		MinimapBackdrop:SetBackdrop(backdrop(0, 1, 0, 0, 0, 0))
		MinimapBackdrop:SetBackdropColor(unpack(A.colors.backdrop.default))
		MinimapBackdrop:SetParent(Minimap)
		MinimapBackdrop:SetPoint(E.regions.C)
		MinimapBackdrop:SetFrameLevel(Minimap:GetFrameLevel()-1)
		MinimapBorder:SetTexture(nil)
		MinimapBorderTop:SetTexture(nil)

		kill(MinimapZoomOut)		
		MinimapZoomOut:SetSize(18, 18)
		MinimapZoomOut:SetPoint(E.regions.BR, Minimap, E.regions.BR, -3, 5)
		MinimapZoomOut:SetFrameLevel(Minimap:GetFrameLevel()+1)

		kill(MinimapZoomIn)
		MinimapZoomIn:SetSize(18, 18)
		MinimapZoomIn:SetPoint(E.regions.BR, Minimap, E.regions.BR, -3, 25)
		MinimapZoomIn:SetFrameLevel(Minimap:GetFrameLevel()+1)

		MinimapZoomOut:SetNormalTexture(media:Fetch("widget", "cui-minimap-minus-zoom"))
		MinimapZoomOut:SetPushedTexture(media:Fetch("widget", "cui-minimap-minus-pushed"))
		MinimapZoomOut:SetDisabledTexture(media:Fetch("widget", "cui-minimap-minus-disabled"))
		MinimapZoomOut:SetHighlightTexture(media:Fetch("widget", "cui-minimap-highlight"))
		MinimapZoomIn:SetNormalTexture(media:Fetch("widget", "cui-minimap-plus-zoom"))
		MinimapZoomIn:SetPushedTexture(media:Fetch("widget", "cui-minimap-plus-pushed"))
		MinimapZoomIn:SetDisabledTexture(media:Fetch("widget", "cui-minimap-plus-disabled"))
		MinimapZoomIn:SetHighlightTexture(media:Fetch("widget", "cui-minimap-highlight"))

		MinimapZoomIn:GetNormalTexture():SetAllPoints()
		MinimapZoomOut:GetNormalTexture():SetAllPoints()

		kill(MinimapZoneTextButton)

		MinimapZoneTextButton:SetParent(Minimap)
		MinimapZoneTextButton:SetPoint(E.regions.T, Minimap, E.regions.T, 0, -5)
		MinimapZoneTextButton:SetHeight(20)
		MinimapZoneTextButton:SetWidth(175)
		MinimapZoneTextButton:SetBackdrop(backdrop(3, 1))
		local r, g, b, a = unpack(A.colors.backdrop.default)
		MinimapZoneTextButton:SetBackdropColor(r, g, b, 0.76)
		MinimapZoneTextButton:SetBackdropBorderColor(unpack(A.colors.backdrop.border))
		MinimapZoneText:SetFont(font(11, "NONE"))
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
							minimapButton:SetBackdrop(backdrop(0, 1))
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

		local function killTimeFrames()

			kill(TimeManagerClockButton)
			local f = setFont(TimeManagerClockButton, 10)
			f:SetPoint(E.regions.C, TimeManagerClockButton, E.regions.C, 0, 0)
			f:SetJustifyH(E.regions.C)
			f:SetJustifyV(E.regions.C)
			TimeManagerClockButton:SetSize(44, 20)
			TimeManagerClockButton:SetPoint(E.regions.BL, Minimap, E.regions.BL, 3, 3)
			TimeManagerClockButton:SetBackdrop(backdrop(3, 1))
			TimeManagerClockButton:SetBackdropColor(r, g, b, 0.76)
			TimeManagerClockButton:SetBackdropBorderColor(unpack(A.colors.backdrop.border))
			kill(GameTimeFrame)
			GameTimeFrame:SetSize(28, 28)
			--GameTimeFrame:ClearAllPoints()
			GameTimeFrame:SetPoint(E.regions.TR, Minimap, E.regions.TR, -5, -5)
			GameTimeFrame.tex = GameTimeFrame:CreateTexture(nil, "BACKGROUND")
			GameTimeFrame.tex:SetTexture(media:Fetch("widget", "cui-calendar"))
			GameTimeFrame.tex:SetAllPoints()
			f = setFont(GameTimeFrame, 10)
			f:SetTextColor(1, 1, 1)
			--f:ClearAllPoints()
			f:SetPoint(E.regions.C, GameTimeFrame, E.regions.C, 0, -3)
			MiniMapMailBorder:SetTexture(nil)
			MiniMapMailIcon:SetTexture(media:Fetch("widget", "cui-mail-icon"))
			MiniMapMailFrame:ClearAllPoints()
			MiniMapMailFrame:SetPoint(E.regions.B, TimeManagerClockButton, E.regions.T, 0, -5)

		end

		if not IsAddOnLoaded("Blizzard_TimeManager") then
			LoadAddOn("Blizzard_TimeManager")
		end

		killTimeFrames()
	end
    
    -- Quest Log
    do
        if not IsAddOnLoaded("Blizzard_ObjectiveTracker") then 
            LoadAddOn("Blizzard_ObjectiveTracker")
        end
        
        ObjectiveTrackerFrame:SetAlpha(0)
        ObjectiveTrackerFrame.ignoreFramePositionManager = true

        local db = A["Profile"]["Options"]["Objective Tracker"]
        local size = db["Size"]
        local position = db["Position"]

        local x, y = position["Offset X"], position["Offset Y"]

        ObjectiveTrackerFrame:SetSize(size["Width"], size["Height"])

        ObjectiveTrackerFrame:ClearAllPoints()
        ObjectiveTrackerFrame:SetPoint(position["Local Point"], A.frameParent, position["Point"], x, y)

        hooksecurefunc(ObjectiveTrackerFrame, "SetPoint", function(self, lp, r, p, x1, y2)
    		if r ~= A.frameParent then
    			if (r.GetName and r:GetName():find("Mover")) then return end;
			    self:ClearAllPoints()
	    		self:SetPoint(position["Local Point"], A.frameParent, position["Point"], x, y)
	    	end
        end)

        hooksecurefunc(ObjectiveTrackerFrame, "SetParent", function(self, parent)
        	if parent ~= A.frameParent then
        		self:SetParent(A.frameParent)
        	end
        end)

        A:CreateMover(ObjectiveTrackerFrame, db, "Objective Tracker")

        local ff = CreateFrame("Frame")
        ff.timer = 0
        ff:SetScript("OnUpdate", function(self, elapsed)
            self.timer = self.timer + elapsed
            if self.timer > 0.01 then
                if ObjectiveTrackerBlocksFrameHeader ~= nil then
                    kill(ObjectiveTrackerBlocksFrame.QuestHeader)
                    setFont(ObjectiveTrackerBlocksFrame.QuestHeader, 12)
                    kill(ObjectiveTrackerBlocksFrame.AchievementHeader)
                    setFont(ObjectiveTrackerBlocksFrame.AchievementHeader, 12)
                    kill(ObjectiveTrackerBlocksFrame.ScenarioHeader)
                    setFont(ObjectiveTrackerBlocksFrame.ScenarioHeader, 12)

                    kill(BONUS_OBJECTIVE_TRACKER_MODULE.Header)
                    setFont(BONUS_OBJECTIVE_TRACKER_MODULE.Header, 11)
                    kill(WORLD_QUEST_TRACKER_MODULE.Header)
                    setFont(WORLD_QUEST_TRACKER_MODULE.Header, 11)
                    
                    setFont(ObjectiveTrackerFrame.HeaderMenu, 11)
                    
                    for k,v in pairs({ ObjectiveTrackerBlocksFrame:GetChildren() }) do
                        if v.currentLine then
                            setFont(v.currentLine, 11)
                        elseif v.HeaderText then
                            setFont(v.HeaderText, 11)
                        end
                        for x, y in pairs({ v:GetChildren() }) do
                        	setFont(y, 10)
                        end
                        setFont(v, 10)
                    end
                    
                    self:SetScript("OnUpdate", nil)
                    Tools:FadeIn(ObjectiveTrackerFrame)
                end
                self.timer = 0
            end
        end)

        hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", function(_, block)
            local item = block.itemButton
            if item and not item.skinned then
                item:SetSize(25, 25)
                --item:SetTemplate("Transparent")
                --item:StyleButton()
                item:SetNormalTexture(nil)
                --item.icon:SetTexCoord(unpack(E.TexCoords))
                item.icon:SetPoint("TOPLEFT", item, 2, -2)
                item.icon:SetPoint("BOTTOMRIGHT", item, -2, 2)
                item.Cooldown:SetAllPoints(item.icon)
                item.Count:ClearAllPoints()
                item.Count:SetPoint("TOPLEFT", 1, -1)
                item.Count:SetFont(media:Fetch("font", "Noto"), 12, "OUTLINE")
                item.Count:SetShadowOffset(5, -5)
                --E:RegisterCooldown(item.Cooldown)
                item.skinned = true
            end

            for k,v in pairs({ ObjectiveTrackerBlocksFrame:GetChildren() }) do
                if v.currentLine then
                    setFont(v.currentLine, 10)
                elseif v.HeaderText then
                    setFont(v.HeaderText, 11)
                end
                for x, y in pairs({ v:GetChildren() }) do
                	setFont(y, 10)
                end
                setFont(v, 10)
            end
        end)
        
        hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddObjective", function(_, block)
            local item = block.itemButton
            if item and not item.skinned then
                item:SetSize(25, 25)
                --item:SetTemplate("Transparent")
                --item:StyleButton()
                item:SetNormalTexture(nil)
                --item.icon:SetTexCoord(unpack(E.TexCoords))
                item.icon:SetPoint("TOPLEFT", item, 2, -2)
                item.icon:SetPoint("BOTTOMRIGHT", item, -2, 2)
                item.Cooldown:SetAllPoints(item.icon)
                item.Count:ClearAllPoints()
                item.Count:SetPoint("TOPLEFT", 1, -1)
                item.Count:SetFont(media:Fetch("font", "Noto"), 12, "OUTLINE")
                item.Count:SetShadowOffset(5, -5)
                --E:RegisterCooldown(item.Cooldown)
                item.skinned = true
            end

            for k,v in pairs({ ObjectiveTrackerBlocksFrame:GetChildren() }) do
                if v.currentLine then
                    setFont(v.currentLine, 10)
                elseif v.HeaderText then
                    setFont(v.HeaderText, 11)
                end
                for x, y in pairs({ v:GetChildren() }) do
                	setFont(y, 10)
                end
                setFont(v, 10)
            end
        end)
    end

    -- Vechicle
    do
    	local position = A["Profile"]["Options"]["Vehicle Seat Indicator"]["Position"]
    	local w, h = VehicleSeatIndicator:GetSize()
    	Tools:HookSetPoint(VehicleSeatIndicator, position, w, h)

    	VehicleSeatIndicatorBackgroundTexture:ClearAllPoints()
    	VehicleSeatIndicatorBackgroundTexture:SetParent(VehicleSeatIndicator)
    	VehicleSeatIndicatorBackgroundTexture:SetPoint("TOPLEFT")
    	VehicleSeatIndicatorBackgroundTexture:SetSize(w, h)

    	VehicleSeatIndicator:SetSize(w, h)

        A:CreateMover(VehicleSeatIndicator, { 
            ["Position"] = position,
            ["Size"] = {
                ["Width"] = w,
                ["Height"] = h
            }
        }, "Vehicle Seat Indicator")
   	end

   	-- TalkingHeadFrame
   	do
   		--[[hooksecurefunc("TalkingHeadFrame_OnShow", function()
	    	local position = A["Profile"]["Options"]["Talking Head Frame"]["Position"]
	    	local w, h = _G["TalkingHeadFrame"]:GetSize()
	    	Tools:HookSetPoint(_G["TalkingHeadFrame"], position, w, h)

	        A:CreateMover(_G["TalkingHeadFrame"], { 
	            ["Position"] = position,
	            ["Size"] = {
	                ["Width"] = w,
	                ["Height"] = h
	            }
	        }, "Talking Head Frame")
	    end)]]
   	end

	--Blizzard windows
	do
		--GameMenuFrame
		local gameMenuFrame = _G["GameMenuFrame"]
		_G["GameMenuFrameHeader"]:SetTexture(nil)
		local f = setFont(gameMenuFrame, 11)
		f:SetPoint(E.regions.T, gameMenuFrame, E.regions.T, 0, -8)
		f:SetTextColor(1, 1, 1)
		for _,b in pairs({ gameMenuFrame:GetChildren() }) do
			b.Left:SetAlpha(0)
			b.Middle:SetAlpha(0)
			b.Right:SetAlpha(0)
			b:SetHighlightTexture(media:Fetch("widget", "cui-gamemenubuttonhover"))
			b:SetBackdrop(backdrop(3, 1))
			b:SetBackdropColor(unpack(A.colors.backdrop.light))
			b:SetBackdropBorderColor(unpack(A.colors.backdrop.border))
			setFont(b, 10)
		end

		-- OrderHallCommandBar
		local ff = CreateFrame("Frame")
		ff:SetScript("OnUpdate", function(self, elapsed)
			local b = OrderHallCommandBar
			if b then
				b:UnregisterAllEvents()
				b:SetScript("OnShow", b.Hide)
				b:Hide()
			end

			UIParent:UnregisterEvent("UNIT_AURA")
		end)

		--Character Info
		kill(PaperDollFrame)

 		-- Hide and create own window

		local db = A["Profile"]["Options"]["Character Info"]

		if db and not db["Enabled"] then
	 		hooksecurefunc("ToggleCharacter", function()
				HideUIPanel(CharacterFrame)

				local position = db["Position"]

				if not A.frames.character then

					local x, y = position["Offset X"], position["Offset Y"]

					local charFrame = CreateFrame("Frame", Tools:frameName("CleanUI_Character Info"), A.frameParent)
					charFrame:SetFrameStrata("HIGH")
					charFrame:SetClampedToScreen(true)
					charFrame:SetSize(346, 512)
					charFrame:SetPoint(position["Local Point"], A.frameParent, position["Point"], x, y)
					charFrame.Toggle = function(self)
						if self:IsShown() then
							self:Hide()
						else
							self:Show()
						end
					end

					charFrame.moveAble = true
					charFrame:SetMovable(charFrame.moveAble)
					charFrame:RegisterForDrag("LeftButton")

					local background = charFrame:CreateTexture(nil, "BACKGROUND")
					background:SetPoint("CENTER")
					background:SetSize(512, 512)
					background:SetTexture(media:Fetch("background", "cui-alliance-char-background"))

					charFrame.background = background

					-- Lets add all the important stuff, name, title, level, class, model, a button or two for the drawers, animation dropdown?, information to the drawers (item slots, stats, reputation, currencies, equipment sets etc.)

					local textBackground = CreateFrame("Frame", nil, charFrame)
					textBackground:SetFrameLevel(4)
					textBackground:SetSize(309, 51)
					textBackground:SetPoint("TOP", 0, -17)

					textBackground.texture = textBackground:CreateTexture(nil)
					textBackground.texture:SetAllPoints()
					textBackground.texture:SetTexture(media:Fetch("background", "cui-default-bg"))
					textBackground.texture:SetVertexColor(17/255, 17/255, 17/255, 0.8)

					textBackground:SetScript("OnMouseDown", function(self, button)
						if charFrame.moveAble then
							charFrame:StartMoving()
						end
					end)

					textBackground:SetScript("OnMouseUp", function(self, button)
						if charFrame.moveAble then
							charFrame:StopMovingOrSizing()
							local lp, r, p, x, y = charFrame:GetPoint()
							db["Position"] = Tools:TranslatePosition(charFrame, lp, A.frameParent, p, x, y)
							A.dbProvider:Save()
						end   
					end)

					charFrame.textBackground = textBackground

					local name = buildText(textBackground, 13):atTopLeft():x(13):y(-13):build()
					name:SetText(UnitName("player").." "..(GetTitleName(GetCurrentTitle()) or ""))
					
					charFrame.name = name

					local level = buildText(textBackground, 13):atTopLeft():againstBottomLeft():alignWith(name):build()
					level:SetTextColor(1, 0.82, 0)
					level:SetText("Level "..UnitLevel("player"))

					charFrame.level = level

					local class = buildText(textBackground, 13):rightOf(level):x(3):build()
					class:SetTextColor(unpack(oUF.colors.class[select(2, UnitClass("player"))]))
					class:SetText(UnitClass("player"))

					charFrame.class = class

					local model = CreateFrame("PlayerModel", nil, charFrame, "ModelWithControlsTemplate")
					model:SetFrameLevel(3)
					model:SetSize(346, 508)
					model:SetPoint("CENTER")
					model:SetUnit("player")
					model:SetPosition(0, 0, -0.3)
					model:SetScript("OnLoad", function(self)
						Model_OnLoad(self, MODELFRAME_MAX_PLAYER_ZOOM, nil, nil, CharacterModelFrame_OnMouseUp);
					end)

					charFrame.model = model

					local slots = {
						"CharacterHeadSlot",
						"CharacterNeckSlot",
						"CharacterShoulderSlot",
						"CharacterBackSlot",
						"CharacterChestSlot",
						"CharacterShirtSlot",
						"CharacterTabardSlot",
						"CharacterWristSlot",
						"CharacterHandsSlot",
						"CharacterWaistSlot",
						"CharacterLegsSlot",
						"CharacterFeetSlot",
						"CharacterFinger0Slot",
						"CharacterFinger1Slot",
						"CharacterTrinket0Slot",
						"CharacterTrinket1Slot",
						"CharacterMainHandSlot",
						"CharacterSecondaryHandSlot"
					}

					local slotSize = 40

					local items = CreateFrame("Frame", nil, charFrame)
					items:SetSize(((#slots / 6) * slotSize) + 6, ((#slots / 3) * slotSize) + 6)
					items:SetPoint("RIGHT", charFrame, "LEFT", 0, 0)
					items:SetBackdrop(backdrop(3, 1))
					items:SetBackdropColor(17/255, 17/255, 17/255, 1)
					items:SetBackdropBorderColor(0, 0, 0, 1)
					items.buttons = {}

					local function getSlotAnchorInfo(index)
						local lp, r, p, x, y = "TOPLEFT", nil, "BOTTOMLEFT", 0, 0
						if index == 1 then 
							r = items
							lp = "TOPLEFT"
							p = "TOPLEFT"
							x = 3
							y = -3
						else
							r = items.buttons[index - 1]
							if index == 7 or index == 13 or index == 20 then
								r = items.buttons[index - 6]
								p = "TOPRIGHT"
							end
						end
						return lp, r, p, x, y
					end

					for i,slot in next, slots do
						local button = CreateFrame("Button", slot, items, "PaperDollItemSlotButtonTemplate")
						button:SetSize(slotSize - 2, slotSize - 2)
						button:SetBackdrop({
							bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
							edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
							edgeSize = 1,
							insets = {
								top = -1,
								left = -1,
								bottom = -1,
								right = -1
							}
						})

						button:SetBackdropBorderColor(1, 1, 1)
						button:SetBackdropColor(0, 0, 0, 0)
						
						local lp, r, p, x, y = getSlotAnchorInfo(i)
						button:SetPoint(lp, r, p, x, y)
						button.IconBorder:SetTexture(nil)
						button.icon:SetTexCoord(0.133, 0.867, 0.133, 0.867)

						for _,region in next, { button:GetRegions() } do
							if region.GetObjectType and region:GetObjectType() == "Texture" and region:GetName() ~= nil and region:GetName():find("NormalTexture") then
								region:SetTexture(nil)
							end
						end

						items.buttons[i] = button
					end

					charFrame:RegisterEvent("UNIT_NAME")
					charFrame:RegisterEvent("PLAYER_LEVEL_UP")
					charFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
					charFrame:SetScript("OnEvent", function(self, event, ...)
						local arg1, arg2, arg3, arg4, arg5 = ...

						Tools:Switch(event, 
							"UNIT_NAME", function()
								if arg1 == "player" then return end;
								self.name:SetText(UnitName(arg1).." "..(GetTitleName(GetCurrentTitle()) or ""))
							end,
							"PLAYER_LEVEL_UP", function()
								self.level:SetText("Level "..UnitLevel("player"))
							end,
							"PLAYER_EQUIPMENT_CHANGED", function()
								self.model:SetUnit("player")
								self.model:SetPosition(0, 0, 0)
								self.model:SetPosition(0, 0, -0.13)
							end)
					end)

					A.frames.character = charFrame
				else
					A.frames.character:Toggle()
					A.frames.character.model:SetPosition(0, 0, -0.13)
				end
	 		end)
	 	end

		CharacterFrame:EnableMouse(true)
		CharacterFrame.moveAble = true
		CharacterFrame:SetMovable(CharacterFrame)
		CharacterFrame:RegisterForDrag("LeftButton")
		CharacterFrame.ignoreFramePositionManager = true
		CharacterFrame:SetClampedToScreen(true)
		
		kill(CharacterFrame)
		kill(CharacterFrameBg)
		CharacterFrame:SetSize(346, 512)
		
		hooksecurefunc(CharacterFrame, "SetWidth", function(self, width)
			if width ~= 346 then
				self:SetWidth(346)
			end
		end)
		
		CharacterFrame.CuiBackground = CharacterFrame:CreateTexture(nil, "BACKGROUND")
		CharacterFrame.CuiBackground:SetPoint("CENTER")
		CharacterFrame.CuiBackground:SetSize(512, 512)
		CharacterFrame.CuiBackground:SetTexture(media:Fetch("background", "cui-alliance-char-background"))
		
		CharacterFrameTitleText:SetFont(media:Fetch("font", "NotoBold"), 13, "NONE")
		CharacterFrameTitleText:ClearAllPoints()
		CharacterFrameTitleText:SetPoint("TOPLEFT", 30, -30)
		--CharacterFrameTitleText:SetShadowColor(0, 0, 0)
		--CharacterFrameTitleText:SetShadowOffset(1, -1)
		
		CharacterLevelText:ClearAllPoints()
		CharacterLevelText:SetPoint("TOPLEFT", CharacterFrameTitleText, "BOTTOMLEFT", -16, 5)
		CharacterLevelText:SetFont(media:Fetch("font", "NotoBold"), 13, "NONE")
		--CharacterLevelText:SetShadowColor(0, 0, 0)
		--CharacterLevelText:SetShadowOffset(1, -1)
		
		CharacterFramePortrait:Hide()
		CharacterStatsPane.ItemLevelCategory.oldShow = CharacterStatsPane.ItemLevelCategory.Show
		CharacterStatsPane.AttributesCategory.oldShow = CharacterStatsPane.AttributesCategory.Show
		CharacterStatsPane.EnhancementsCategory.oldShow = CharacterStatsPane.EnhancementsCategory.Show
		
		CharacterStatsPane.ItemLevelCategory.Show = CharacterStatsPane.ItemLevelCategory.Hide
		
		CharacterStatsPane.ItemLevelCategory:Hide()
		CharacterStatsPane.AttributesCategory:Hide()
		CharacterStatsPane.EnhancementsCategory:Hide()
		
		CharacterFramePortraitFrame:SetTexture(nil)
		CharacterFramePortrait:SetTexture(nil)
		for k,v in pairs({ CharacterStatsPane:GetChildren() }) do
			kill(v)
		end

		CharacterStatsPane.ClassBackground:SetTexture(nil)

		local statsContainer = CreateFrame("Frame", nil, CharacterFrame)
		statsContainer:SetSize(200, 220)
		statsContainer:SetPoint("BOTTOMRIGHT", CharacterFrame, "BOTTOMRIGHT", -24, 40)
		statsContainer:SetBackdrop(backdrop(3, 1))
		statsContainer:SetBackdropColor(0, 0, 0 ,0)
		statsContainer:SetBackdropBorderColor(0, 0, 0, 0)
		statsContainer.ag = statsContainer:CreateAnimationGroup()
		
		statsContainer.fadeIn = statsContainer.ag:CreateAnimation("Alpha")
		statsContainer.fadeIn:SetFromAlpha(0)
		statsContainer.fadeIn:SetToAlpha(1)
		statsContainer.fadeIn:SetDuration(0.5)
		statsContainer.fadeIn:SetScript("OnFinished", function(self, ...)
			statsContainer.hidden = false
		end)
		
		statsContainer.fadeOut = statsContainer.ag:CreateAnimation("Alpha")
		statsContainer.fadeOut:SetFromAlpha(1)
		statsContainer.fadeOut:SetToAlpha(0)
		statsContainer.fadeOut:SetDuration(0.5)
		statsContainer.fadeOut:SetScript("OnFinished", function(self, ...)
			statsContainer.hidden = true
		end)
		
		statsContainer.timer = 0
		statsContainer.hidden = true
		statsContainer:SetScript("OnUpdate", function(self, elapsed)
			self.timer = self.timer + elapsed
			if self.timer > 0.1 then
				if self:IsMouseOver() and self.hidden then
					self.fadeIn:Play()
				elseif not self:IsMouseOver() and not self.hidden then
					self.fadeOut:Play()
				end
				self.timer = 0
			end
		end)
		
		CharacterStatsPane.AttributesCategory:ClearAllPoints()
		hooksecurefunc(CharacterStatsPane.AttributesCategory, "SetPoint", function(self, lp, r, p, x, y)
			if lp ~= "TOP" or r ~= CharacterStatsPane.ItemLevelFrame or p ~= "BOTTOM" then
				self:SetPoint("TOP", CharacterStatsPane.ItemLevelFrame, "BOTTOM", 0, 4)
			end
		end)
		
		CharacterStatsPane.ItemLevelFrame:ClearAllPoints()
		CharacterStatsPane.ItemLevelFrame:SetSize(185, 19)
		CharacterStatsPane.ItemLevelFrame:SetPoint("TOP", statsContainer, "TOP", 0, -20)
		hooksecurefunc(CharacterStatsPane.ItemLevelFrame, "SetPoint", function(self, lp, r, p, x, y)
			if lp ~= "TOP" or r ~= statsContainer or p ~= "TOP" then
				self:SetPoint("TOP", statsContainer, "TOP", 0, -10)
			end
		end)
		
		local itemLevelLabel = statsContainer:CreateFontString(nil, "OVERLAY")
		itemLevelLabel:SetFont(media:Fetch("font", "Noto"), 10, "NONE")
		itemLevelLabel:SetShadowColor(0, 0, 0)
		itemLevelLabel:SetShadowOffset(1, -1)
		itemLevelLabel:SetPoint("LEFT", CharacterStatsPane.ItemLevelFrame, "LEFT", 10, 0)
		itemLevelLabel:SetText("Item Level:")
		itemLevelLabel:SetTextColor(1, 0.8, 0)
		
		CharacterStatsPane.ItemLevelFrame.Value:SetFont(media:Fetch("font", "Noto"), 10, "NONE")
		CharacterStatsPane.ItemLevelFrame.Value:SetShadowColor(0, 0, 0)
		CharacterStatsPane.ItemLevelFrame.Value:SetShadowOffset(1, -1)
		CharacterStatsPane.ItemLevelFrame.Value:ClearAllPoints()
		CharacterStatsPane.ItemLevelFrame.Value:SetPoint("RIGHT", -8, 0)
		hooksecurefunc(CharacterStatsPane.ItemLevelFrame.Value, "SetTextColor", function(self, r, g, b) 
			if r ~= 1 or g ~= 1 or b ~= 1 then
				self:SetTextColor(1, 1, 1)
			end
		end)
		
		CharacterStatsPane.ItemLevelFrame.Value.modified = false
		hooksecurefunc(CharacterStatsPane.ItemLevelFrame.Value, "SetText", function(self, text)
			if not string.find(text, "/") then
				local total, equipped, pvp = GetAverageItemLevel()
				self:SetText(equipped.." / "..total)
			end
		end)
		
		CharacterStatsPane.ItemLevelFrame.Background:SetAtlas("UI-Character-Info-Line-Bounce")
		CharacterStatsPane.ItemLevelFrame.Background:SetAlpha(0.3)
		CharacterStatsPane.ItemLevelFrame.Background:SetSize(CharacterStatsPane.ItemLevelFrame:GetSize())

		CharacterStatsPane.AttributesCategory:SetSize(1, 1)
		CharacterStatsPane.EnhancementsCategory:SetSize(1, 1)
		CharacterStatsPane.AttributesCategory.Title:SetText("")
		CharacterStatsPane.EnhancementsCategory.Title:SetText("")
		
		-- Add item level as a row with xxx / xxx format
		
		local statsUpdateFrame = CreateFrame("Frame")
		statsUpdateFrame.timer = 0
		
		statsUpdateFrame:SetScript("OnUpdate", function(self, elapsed)
			self.timer = self.timer + elapsed
			if self.timer > 0.1 then
				for k,v in pairs({ CharacterStatsPane:GetChildren() }) do
					if v.Label then
						v.Label:SetFont(media:Fetch("font", "Noto"), 10, "NONE")
						v.Value:SetFont(media:Fetch("font", "Noto"), 10, "NONE")
					end
				end
				self.timer = 0
			end
		end)
		
		CharacterFrameInsetBg:SetTexture(nil)
		CharacterFrameInsetRightBg:SetTexture(nil)
		kill(CharacterFrameInsetRight)
		kill(CharacterModelFrame)
		kill(PaperDollItemsFrame)
		
		CharacterModelFrameBackgroundOverlay:SetTexture(nil)
		
		hooksecurefunc(CharacterModelFrameBackgroundOverlay, "SetTexture", function(self, texture)
			if texture ~= nil then
				self:SetTexture(nil)
			end
		end)
		
		CharacterModelFrame:SetSize(346, 430)
		CharacterModelFrame:ClearAllPoints()
		CharacterModelFrame:SetPoint("BOTTOM", -1, 2)
		
		CharacterFrameInsetInsetLeftBorder:SetTexture(nil)
		CharacterFrameInsetInsetBotLeftCorner:SetTexture(nil)
		CharacterFrameInsetInsetRightBorder:SetTexture(nil)
		CharacterFrameInsetInsetBotRightCorner:SetTexture(nil)
		CharacterFrameInsetInsetBottomBorder:SetTexture(nil)
		CharacterFrameInsetInsetTopRightCorner:SetTexture(nil)
		CharacterFrameInsetInsetTopLeftCorner:SetTexture(nil)
		CharacterFrameInsetInsetTopBorder:SetTexture(nil)
		CharacterFrameTopTileStreaks:SetTexture(nil)
		
		CharacterModelFrameBackgroundTopLeft:SetTexture(nil)
		CharacterModelFrameBackgroundBotLeft:SetTexture(nil)
		CharacterModelFrameBackgroundBotRight:SetTexture(nil)
		CharacterModelFrameBackgroundTopRight:SetTexture(nil)

		local slots = {
			"CharacterHeadSlot",
			"CharacterNeckSlot",
			"CharacterShoulderSlot",
			"CharacterBackSlot",
			"CharacterChestSlot",
			"CharacterShirtSlot",
			"CharacterTabardSlot",
			"CharacterWristSlot",
			"CharacterHandsSlot",
			"CharacterWaistSlot",
			"CharacterLegsSlot",
			"CharacterFeetSlot",
			"CharacterFinger0Slot",
			"CharacterFinger1Slot",
			"CharacterTrinket0Slot",
			"CharacterTrinket1Slot",
			"CharacterMainHandSlot",
			"CharacterSecondaryHandSlot"
		}
		
		for _,slot in pairs(slots) do

			_G[slot]:SetWidth(_G[slot]:GetWidth() - 3)
			_G[slot]:SetHeight(_G[slot]:GetHeight() - 3)
			_G[slot.."Frame"]:SetTexture(nil)
        	_G[slot]:SetBackdrop({
	            bgFile = media:Fetch("statusbar", "Default"),
	            tile = true,
	            tileSize = 16,
	            insets = {
	                top = -1,
	                bottom = -1,
	                left = -1,
	                right = -1,
	            }
	        })
        	_G[slot]:SetBackdropColor(0, 0, 0)
			_G[slot.."IconTexture"]:SetTexCoord(0.133, 0.867, 0.133, 0.867)
			_G[slot.."NormalTexture"]:SetTexture(nil)
			hooksecurefunc(_G[slot]["IconBorder"], "SetTexture", function(self, texture)
				_G[slot]:SetBackdropColor(self:GetVertexColor())
				if texture ~= nil then
					self:SetTexture(nil)
				end
			end)

			if not _G[slot]:IsEventRegistered("PLAYER_EQUIPMENT_CHANGED") then
				_G[slot]:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
			end

			_G[slot]:HookScript("OnEvent", function(self, e)
				if e == "PLAYER_EQUIPMENT_CHANGED" then
					local color = { _G[slot]["IconBorder"]:GetVertexColor() }
					local slotId = GetInventorySlotInfo(string.sub(slot, 10))
					local rarity = GetInventoryItemQuality("player", slotId)
					if not rarity then
						color = { 1, 1, 1 }
					end
					
					self:SetBackdropColor(unpack(color))
				end
			end)
		end
		
		local itemsContainer = CreateFrame("Frame", nil, CharacterFrame)
		itemsContainer:SetSize(200, 220)
		itemsContainer:SetPoint("BOTTOMLEFT", CharacterFrame, "BOTTOMLEFT", 5, 10)
		itemsContainer:SetBackdrop(backdrop(3, 1))
		itemsContainer:SetBackdropColor(0, 0, 0, 0)
		itemsContainer:SetBackdropBorderColor(0, 0, 0, 0)
		
		CharacterHeadSlot:ClearAllPoints()
		CharacterHeadSlot:SetPoint("TOPLEFT", itemsContainer, "TOPLEFT", 23, -13)
		
		CharacterChestSlot:ClearAllPoints()
		CharacterChestSlot:SetPoint("LEFT", CharacterHeadSlot, "RIGHT", 2, 0)
		
		CharacterHandsSlot:ClearAllPoints()
		CharacterHandsSlot:SetPoint("LEFT", CharacterChestSlot, "RIGHT", 2, 0)
		
		CharacterFinger0Slot:ClearAllPoints()
		CharacterFinger0Slot:SetPoint("LEFT", CharacterHandsSlot, "RIGHT", 2, 0)
		
		CharacterMainHandSlot:ClearAllPoints()
		CharacterMainHandSlot:SetPoint("TOP", CharacterWristSlot, "BOTTOM", 0, -2)
		
		CharacterSecondaryHandSlot:ClearAllPoints()
		CharacterSecondaryHandSlot:SetPoint("TOP", CharacterFeetSlot, "BOTTOM", 0, -2)

		for k,v in pairs({CharacterMainHandSlot:GetRegions()}) do
			if v:GetObjectType() == "Texture" then
				if v:GetTexture() == [[Interface\CharacterFrame\Char-Paperdoll-Parts]] then
					v:SetTexture(nil)
				end
			end
		end

		for k,v in pairs({CharacterSecondaryHandSlot:GetRegions()}) do
			if v:GetObjectType() == "Texture" then
				if v:GetTexture() == [[Interface\CharacterFrame\Char-Paperdoll-Parts]] then
					v:SetTexture(nil)
				end
			end
		end

		hooksecurefunc(CharacterModelFrameBackgroundTopLeft, "SetTexture", function(self, texture)
			if texture ~= nil then
				self:SetTexture(nil)
			end
		end)
		
		hooksecurefunc(CharacterModelFrameBackgroundBotLeft, "SetTexture", function(self, texture)
			if texture ~= nil then
				self:SetTexture(nil)
			end
		end)
		
		hooksecurefunc(CharacterModelFrameBackgroundBotRight, "SetTexture", function(self, texture)
			if texture ~= nil then
				self:SetTexture(nil)
			end
		end)
		
		hooksecurefunc(CharacterModelFrameBackgroundTopRight, "SetTexture", function(self, texture)
			if texture ~= nil then
				self:SetTexture(nil)
			end
		end)
		
		PaperDollInnerBorderTopLeft:SetTexture(nil)
		PaperDollInnerBorderTopRight:SetTexture(nil)
		PaperDollInnerBorderBottomLeft:SetTexture(nil)
		PaperDollInnerBorderBottomRight:SetTexture(nil)
		PaperDollInnerBorderLeft:SetTexture(nil)
		PaperDollInnerBorderRight:SetTexture(nil)
		PaperDollInnerBorderTop:SetTexture(nil)
		PaperDollInnerBorderBottom:SetTexture(nil)
		PaperDollInnerBorderBottom2:SetTexture(nil)
		
		PaperDollSidebarTabs.DecorLeft:SetTexture(nil)
		PaperDollSidebarTabs.DecorRight:SetTexture(nil)
		
		--PaperDollSidebarTab1:Hide()
		--PaperDollSidebarTab2:Hide()
		--PaperDollSidebarTab3:Hide()

		PaperDollSidebarTab1:ClearAllPoints()
		PaperDollSidebarTab1:SetPoint("BOTTOMLEFT", statsContainer, "TOPLEFT", 49, -15)
		PaperDollSidebarTab2:ClearAllPoints()
		PaperDollSidebarTab2:SetPoint("LEFT", PaperDollSidebarTab1, "RIGHT", 0, 0)
		PaperDollSidebarTab3:ClearAllPoints()
		PaperDollSidebarTab3:SetPoint("LEFT", PaperDollSidebarTab2, "RIGHT", 0, 0)

		
		CharacterFrameTab1:Hide()
		CharacterFrameTab2:Hide()
		CharacterFrameTab3:Hide()
		
		--Add these to some modified dropdowns
		--PaperDollTitlesPaneScrollChild
		--PaperDollEquipmentManagerPaneScrollChild
		--ReputationListScrollFrameScrollChildFrame
		TokenFrameContainerScrollChild:SetHeight(400)
					

		--Extra Action Buttons

		local eabdb = A["Profile"]["Options"]["Extra Action Button"]
		local position = eabdb["Position"]
		local button = _G["ExtraActionBarFrame"]
		button.ignoreFramePositionManager = true

		local x, y = position["Offset X"], position["Offset Y"]

		if button then
			A:CreateMover(button, eabdb, "Extra Action Button")
			button:SetPoint(position["Local Point"], A.frameParent, position["Point"], x, y)
			button:SetParent(A.frameParent)
		end

		--Something else

		--Something else


	end
end

A.SetStyle = setStyle