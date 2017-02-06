
local A, L, O = unpack(select(2, ...))
local _G, E, media = _G, A.enum, LibStub("LibSharedMedia-3.0")
local iconLib = LibStub("LibDBIcon-1.0", true)

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
local function font(size, outline) return media:Fetch("font", "FrancophilSans"), size, outline or "NONE" end
local function kill(frame) 
	if not frame.GetNumRegions then return end
	for i = 1, frame:GetNumRegions() do
		local region = select(i, frame:GetRegions())
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
	b:SetBackdropBorderColor(unpack(E.colors.backdropborder))
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
			_G[bd]:SetBackdropColor(unpack(E.colors.backdrop))
			_G[bd]:SetBackdropBorderColor(unpack(E.colors.backdropborder))
		end
	end

	--Chat
	do

		for _,name in pairs(CHAT_FRAMES) do
			local frame = _G[name]
			if frame then
				local bf = _G[name.."ButtonFrame"]
				if bf then 
					kill(bf)
					bf:Hide()
				end
				frame:SetClampedToScreen(false)
				kill(frame)
				frame:SetFont(font(12))
				local tab = _G[name.."Tab"]
				if tab then
					kill(tab)
					tab.text = _G[name.."TabText"]
					tab.text:SetFont(font(12))
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
							if region:GetTexture() ~= "Color-ffffffff" then
								region:SetTexture(nil)
							end
						end
					end	
					editbox:SetHeight(24)
					editbox:SetFont(font(12))
					editbox:SetBackdrop(backdrop(3, 1))
					editbox:SetPoint(E.regions.TL, frame, E.regions.BL, 0, -5)
					editbox:SetPoint(E.regions.TR, frame, E.regions.BR, 0, -5)
					local r, g, b, a = unpack(E.colors.backdrop)
					editbox:SetBackdropColor(r, g, b, 0.67)
					editbox:SetBackdropBorderColor(unpack(E.colors.backdropborder))
					_G[name.."EditBoxHeader"]:SetFont(font(12))
				end
			end
		end
		QuickJoinToastButton:Hide()
		ChatFrameMenuButton:Hide()
	end

	--GameTooltip
	do
		local function checkTooltipColor()
			local _r, _g, _b, _a = unpack(E.colors.backdroplight)
			local r, g, b = GameTooltip:GetBackdropColor()
			if(r ~= _r or g ~= _g or b ~= _b) then
				GameTooltip:SetBackdropColor(_r, _g, _b)
			end
		end
		
		GameTooltipHeaderText:SetFont(font(13))
		GameTooltipText:SetFont(font(12))
		GameTooltipTextSmall:SetFont(font(11))

		GameTooltip:HookScript("OnSizeChanged", checkTooltipColor)
		GameTooltip:RegisterEvent("CURSOR_UPDATE", checkTooltipColor)
		GameTooltip:HookScript("OnShow", function(self)
			self:SetBackdropColor(unpack(E.colors.backdroplight))
			self:SetBackdropBorderColor(unpack(E.colors.backdropborder))
		end)
		
		for _,shoppingTooltip in pairs(GameTooltip.shoppingTooltips) do
			shoppingTooltip:SetBackdrop(backdrop(3, 1))
			shoppingTooltip:HookScript("OnShow", function(self)
				self:SetBackdropColor(unpack(E.colors.backdroplight))
				self:SetBackdropBorderColor(unpack(E.colors.backdropborder))
			end)
		end

		for _,st in pairs(shoppingTexts) do
			_G[st]:SetFont(font(12))
		end
	end

	--ColorPickerFrame
	do
		ColorPickerFrame:SetBackdrop(backdrop(3, 1))
		ColorPickerFrame:SetBackdropColor(unpack(E.colors.backdrop))
		ColorPickerFrame:SetBackdropBorderColor(unpack(E.colors.backdropborder))
		
		for i = 1, ColorPickerFrame:GetNumRegions() do
			local region = select(i, ColorPickerFrame:GetRegions())
			if region:GetObjectType() == "FontString" then
				region:SetFont(font(12))
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
		OpacitySliderFrame:SetBackdropBorderColor(unpack(E.colors.backdropborder))
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
			self:SetPoint(db.Position["Local Point"], db.Position["Relative To"], db.Position["Point"], db.Position["Offset X"], db.Position["Offset Y"])
			MinimapBackdrop:SetSize(db.Size, db.Size)
		end
		A.OptionsContainer.shortcuts[O["Minimap"]]:AddSubscriber(Minimap)

		--Minimap:ClearAllPoints()
		Minimap:SetMinResize(E.minimap.min, E.minimap.min)
		Minimap:SetMaxResize(E.minimap.max, E.minimap.max)
		Minimap:SetPoint(minimapConfig.Position["Local Point"], minimapConfig.Position["Relative To"], minimapConfig.Position["Point"], minimapConfig.Position["Offset X"], minimapConfig.Position["Offset Y"])
		Minimap:SetSize(minimapConfig.Size - 3, minimapConfig.Size - 3)
		Minimap:SetMaskTexture(media:Fetch("widget", "cui-minimap-mask-square"))
		MinimapBackdrop:SetSize(minimapConfig.Size, minimapConfig.Size)
		MinimapBackdrop:SetBackdrop(backdrop(0, 1, 0, 0, 0, 0))
		MinimapBackdrop:SetBackdropColor(unpack(E.colors.backdrop))
		MinimapBackdrop:SetParent(Minimap)
		MinimapBackdrop:SetPoint(E.regions.C)
		MinimapBackdrop:SetFrameLevel(Minimap:GetFrameLevel()-1)
		MinimapBorder:SetTexture(nil)
		MinimapBorderTop:SetTexture(nil)
		Minimap:SetArchBlobRingScalar(0)
		Minimap:SetArchBlobRingAlpha(0)
		Minimap:SetQuestBlobRingScalar(0)
		Minimap:SetQuestBlobRingAlpha(0)

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
		MinimapZoneTextButton:SetPoint(E.regions.T, Minimap, E.regions.T, 0, -5)
		MinimapZoneTextButton:SetHeight(20)
		MinimapZoneTextButton:SetWidth(175)
		MinimapZoneTextButton:SetBackdrop(backdrop(3, 1))
		local r, g, b, a = unpack(E.colors.backdrop)
		MinimapZoneTextButton:SetBackdropColor(r, g, b, 0.76)
		MinimapZoneTextButton:SetBackdropBorderColor(unpack(E.colors.backdropborder))
		MinimapZoneText:SetFont(font(12, "NONE"))
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

		MiniMapWorldMapButton:Hide()
		GarrisonLandingPageMinimapButton:SetAlpha(0)

		MiniMapTracking:Hide()
		Minimap:SetScript("OnMouseUp", function(self, button)
			if button == "RightButton" then
				ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "cursor", -10, -20)
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
							minimapButton:SetBackdropColor(unpack(E.colors.backdrop75alpha))
							minimapButton.icon:ClearAllPoints()
							minimapButton.icon:SetPoint("CENTER")
							minimapButton.icon:SetSize(24, 24)

							for i = 1, minimapButton:GetNumRegions() do
								local region = select(i, minimapButton:GetRegions())
								if region:GetObjectType() == "Texture" and region:GetTexture() then
									if not string.find(region:GetTexture(), "AddOns") then
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
		
		-- Minimap.cuiButtons = {
		-- 	count = 0,
		-- 	objects = {},
		-- 	list = nil
		-- }
		-- local callbackObj = {
		-- 	Func = function()
		-- 		A:Debug("LibDBIcon callback")
		-- 		for _, v in pairs({ Minimap:GetChildren() }) do
		-- 			local childName = v:GetName() or ""
		-- 			if childName:find("^LibDBIcon10_") then
		-- 				local libName
		-- 				string.gsub(childName, "_(%w+)", function(w) libName = w end)
		-- 				local minimapButton = iconLib.objects[libName]
		-- 				if minimapButton and not Minimap.cuiButtons.objects[libName] then
		-- 					if not minimapButton.db.hide then
		-- 						Minimap.cuiButtons.objects[libName] = true
		-- 						Minimap.cuiButtons.count = Minimap.cuiButtons.count + 1
		-- 					end
		-- 				end
		-- 				minimapButton:Hide()
		-- 			end
		-- 		end

		-- 		if Minimap.cuiButtons.list then
		-- 			local dropdown = Minimap.cuiButtons.list
		-- 			dropdown:SetHeight(Minimap.cuiButtons.count * 22)

		-- 			local exists, last = 0, nil 
		-- 			for k,v in pairs(dropdown.items) do
		-- 				exists = exists + 1
		-- 			end

		-- 			local relative = dropdown

		-- 			for name,_ in pairs(Minimap.cuiButtons.objects) do
		-- 				if dropdown.items[name] then
		-- 					local button = dropdown.items[name]
		-- 					button:SetPoint(E.regions.T, relative, (relative.isParent and E.regions.T or E.regions.B), 0, 0)
		-- 					relative = button
		-- 				else
		-- 					local libButton = iconLib.objects[name]
		-- 					local button = CreateFrame("Button", nil, dropdown)

		-- 					button.name = name
		-- 					button.dataObject = libButton.dataObject
		-- 					button:RegisterForClicks("anyUp")
		-- 					button:SetScript("OnClick", libButton:GetScript("OnClick"))
		-- 					button:SetScript("OnEnter", libButton:GetScript("OnEnter"))
		-- 					button:SetScript("OnLeave", libButton:GetScript("OnLeave"))
		-- 					button:SetSize(150, 22)
		-- 					button:SetPoint(E.regions.T, relative, (relative.isParent and E.regions.T or E.regions.B), 0, 0)

		-- 					button.icon = button:CreateTexture(nil, "OVERLAY")
		-- 					button.icon:SetSize(20, 20)
		-- 					button.icon:SetTexture(libButton.icon:GetTexture())
		-- 					button.icon:SetPoint(E.regions.L, button, E.regions.L, 2, -1)

		-- 					button.text = button:CreateFontString(nil, "OVERLAY")
		-- 					button.text:SetSize(130, 20)
		-- 					button.text:SetFont(font(11))
		-- 					button.text:SetText(name)
		-- 					button.text:SetJustifyH(E.regions.L)
		-- 					button.text:SetPoint(E.regions.L, button.icon, E.regions.R, 5, 0)

		-- 					relative = button
		-- 					dropdown.items[name] = button
		-- 				end
		-- 			end					
		-- 		else
		-- 			local dropdownButton = CreateFrame("Button", nil, Minimap)
		-- 			dropdownButton:SetPoint(E.regions.TL, Minimap, E.regions.TL, 5, -5)
		-- 			dropdownButton:SetBackdrop(backdrop(3, 1))
		-- 			dropdownButton:SetBackdropColor(r, g, b, 1)
		-- 			dropdownButton:SetBackdropBorderColor(unpack(E.colors.backdropborder))
		-- 			dropdownButton:SetSize(22, 20)

		-- 			dropdownButton.icon = dropdownButton:CreateTexture(nil, "OVERLAY")
		-- 			dropdownButton.icon:SetTexture(media:Fetch("widget", "cui-minimap-buttons-button"))
		-- 			dropdownButton.icon:SetPoint(E.regions.C)

		-- 			local dropdown = CreateFrame("Frame", nil, Minimap)
		-- 			dropdown:SetPoint(E.regions.TR, dropdownButton, E.regions.TL, 0, 0)
		-- 			dropdown:SetSize(150, Minimap.cuiButtons.count * 16)
		-- 			dropdown:SetBackdrop(backdrop(3, 1))
		-- 			dropdown:SetBackdropColor(r, g, b, 1)
		-- 			dropdown:SetBackdropBorderColor(unpack(E.colors.backdropborder))
		-- 			dropdown:Hide()
		-- 			dropdown.hidden = true
		-- 			dropdown:SetFrameLevel(11)
		-- 			dropdown.items = {}
		-- 			dropdown.isParent = true

		-- 			dropdownButton:SetScript("OnClick", function(self, button, down)
		-- 				if button == "LeftButton" and not down then
		-- 					if dropdown.hidden then
		-- 						dropdown:Show()
		-- 					else
		-- 						dropdown:Hide()
		-- 					end
		-- 					dropdown.hidden = not dropdown.hidden
		-- 				end
		-- 			end)

		-- 			dropdown.toggle = dropdownButton
		-- 			Minimap.cuiButtons.list = dropdown
		-- 		end
		-- 	end
		-- }

		-- iconLib.RegisterCallback(callbackObj, "LibDBIcon_IconCreated", "Func")

		-- callbackObj:Func()

		local function killTimeFrames()

			kill(TimeManagerClockButton)
			local f = setFont(TimeManagerClockButton, 11)
			f:SetPoint(E.regions.C, TimeManagerClockButton, E.regions.C, 0, 0)
			f:SetJustifyH(E.regions.C)
			f:SetJustifyV(E.regions.C)
			TimeManagerClockButton:SetSize(44, 20)
			TimeManagerClockButton:SetPoint(E.regions.BL, Minimap, E.regions.BL, 3, 3)
			TimeManagerClockButton:SetBackdrop(backdrop(3, 1))
			TimeManagerClockButton:SetBackdropColor(r, g, b, 0.76)
			TimeManagerClockButton:SetBackdropBorderColor(unpack(E.colors.backdropborder))
			kill(GameTimeFrame)
			GameTimeFrame:SetSize(28, 28)
			--GameTimeFrame:ClearAllPoints()
			GameTimeFrame:SetPoint(E.regions.TR, Minimap, E.regions.TR, -5, -5)
			GameTimeFrame.tex = GameTimeFrame:CreateTexture(nil, "BACKGROUND")
			GameTimeFrame.tex:SetTexture(media:Fetch("widget", "cui-calendar"))
			GameTimeFrame.tex:SetAllPoints()
			f = setFont(GameTimeFrame, 11)
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

	--Blizzard windows
	do
		--GameMenuFrame
		local gameMenuFrame = _G["GameMenuFrame"]
		_G["GameMenuFrameHeader"]:SetTexture(nil)
		local f = setFont(gameMenuFrame, 13)
		f:SetPoint(E.regions.T, gameMenuFrame, E.regions.T, 0, -8)
		f:SetTextColor(1, 1, 1)
		for _,b in pairs({ gameMenuFrame:GetChildren() }) do
			b.Left:SetAlpha(0)
			b.Middle:SetAlpha(0)
			b.Right:SetAlpha(0)
			b:SetHighlightTexture(media:Fetch("widget", "cui-gamemenubuttonhover"))
			b:SetBackdrop(backdrop(3, 1))
			b:SetBackdropColor(unpack(E.colors.backdroplight))
			b:SetBackdropBorderColor(unpack(E.colors.backdropborder))
			setFont(b, 12)
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

		--Something else

		--Something else

		--Something else

		--Something else


	end
end

A.SetStyle = setStyle