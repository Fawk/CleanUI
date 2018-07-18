local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local CreateFrame = CreateFrame
local LAB = LibStub("LibActionButton-1.0")
local buildText = A.TextBuilder
local bindingMode = false
local capture = CreateFrame("Frame", "KeyBinder", A.frameParent)

local _G = _G

local AB = {
	bars = A:OrderedTable()
}

local keys = {
	["SHIFT"] = "S",
	["CTRL"] = "C",
	["ALT"] = "A",
	["MOUSEWHEELUP"] = "WU",
	["MOUSEWHEELDOWN"] = "WD",
	["BUTTON3"] = "MB",
	["BUTTON4"] = "M4",
	["BUTTON5"] = "M5",
	["LeftButton"] = "LB",
	["RightButton"] = "RB"
}

local mousewheel = {
	["-1"] = "MOUSEWHEELDOWN",
	["1"] = "MOUSEWHEELUP",
}

local mouse = {
	["MiddleButton"] = "BUTTON3",
	["Button4"] = "BUTTON4",
	["Button5"] = "BUTTON5"
}

local ignored = {
	["LSHIFT"] = true,
	["RSHIFT"] = true,
	["LCTRL"] = true,
	["RCTRL"] = true,
	["LALT"] = true,
	["RALT"] = true,
	["ENTER"] = true
}

local function replace(name)
	for key, binding in next, A["Profile"]["Options"]["Key Bindings"] do
		local name2 = ""
		binding:gsub("%w+", function(m) name2 = name2 == "" and m or name2.."_"..m end)
		if name2 == name then
			A["Profile"]["Options"]["Key Bindings"][key] = ""
		end
	end
end

local function addModifier(key)
	local modifier = ""
	if IsShiftKeyDown() then modifier = "SHIFT-" end
	if IsAltKeyDown() then modifier = "ALT-"..modifier end
	if IsControlKeyDown() then modifier = "CTRL-"..modifier end
	return modifier..key
end

local function setupCapture()

	capture:SetScript("OnKeyUp", function(self, key)
		if not self.button then return end;

		if key == "ESCAPE" then
			SetBinding(self.button.actualKey)
			A["Profile"]["Options"]["Key Bindings"][self.button.actualKey] = ""
			A.dbProvider:Save()
			AB:SetupBindings(A["Profile"]["Options"]["Key Bindings"])
		else
			if not ignored[key] then
				replace(self.button:GetName())
				A["Profile"]["Options"]["Key Bindings"][addModifier(key)] = self.button:GetName()
				A.dbProvider:Save()
				AB:SetupBindings(A["Profile"]["Options"]["Key Bindings"])
			end
		end
	end)
	capture:SetScript("OnMouseUp", function(self, key)
		if not self.button then return end;

		replace(self.button:GetName())
		local realkey = mouse[key]
		A["Profile"]["Options"]["Key Bindings"][addModifier(realkey)] = self.button:GetName()
		A.dbProvider:Save()
		AB:SetupBindings(A["Profile"]["Options"]["Key Bindings"])
	end)
	capture:SetScript("OnMouseWheel", function(self, key)
		if not self.button then return end;

		if not ignored[key] then
			local realkey = mousewheel[tostring(key)]
			replace(self.button:GetName())
			A["Profile"]["Options"]["Key Bindings"][addModifier(realkey)] = self.button:GetName()
			A.dbProvider:Save()
			AB:SetupBindings(A["Profile"]["Options"]["Key Bindings"])
		end
	end)
	capture:SetScript("OnLeave", function(self, userMoved)
		if bindingMode then
			self.button = nil
			self:ClearAllPoints();
			self:Hide();
		end
	end)
end

local bars = {
	[1] = "ActionButton",
	[2] = "MultiBarBottomLeftButton",
	[3] = "MultiBarBottomRightButton",
	[4] = "MultiBarRightButton",
	[5] = "MultiBarLeftButton"
}

local emptySlots = { 
	[1] = {},
	[2] = {},
	[3] = {},
	[4] = {},
	[5] = {}
}

local barAnchors = {}

function AB:Init()
	self:HideArt()

	local db = A["Profile"]["Options"]["Actionbars"]

	if (not db["Enabled"]) then
		return
	end

	for x = 1, 5 do

		local bar = db["Bars"]["Bar"..x]
		local position = bar["Position"]
		local orientation = bar["Orientation"]
		local size = bar["Size"]

		local anchor = barAnchors[x]
		if (not anchor) then
			anchor = CreateFrame("Frame", A:GetName().."_Bar"..x, A.frameParent)
			barAnchors[x] = anchor
		end

		A:CreateMover(anchor, db, "Bar"..x)

		for i = 1, 12 do
			_G[bars[x]..i]:SetSize(size, size)
			_G[bars[x]..i.."Icon"]:SetTexCoord(0.133,0.867,0.133,0.867)
			_G[bars[x]..i.."NormalTexture"]:SetTexture(nil)
			_G[bars[x]..i.."HotKey"]:SetFont(media:Fetch("font", "NotoBold"), 10, "OUTLINE")
			_G[bars[x]..i.."HotKey"]:ClearAllPoints()
			_G[bars[x]..i.."HotKey"]:SetPoint("TOPRIGHT", _G[bars[x]..i], "TOPRIGHT", 0, 0)
			_G[bars[x]..i.."Name"]:SetFont(media:Fetch("font", "NotoBold"), 10, "OUTLINE")
			_G[bars[x]..i.."Count"]:SetFont(media:Fetch("font", "NotoBold"), 10, "OUTLINE")
			_G[bars[x]..i.."Border"]:SetSize(size + size, size + size)
			_G[bars[x]..i.."Cooldown"]:SetSize(size, size)
			
			local cd = _G[bars[x]..i.."Cooldown"]:GetRegions()
			cd:SetFont(media:Fetch("font", "NotoBold"), 14, "OUTLINE")
			
			if (not emptySlots[x][i]) then
				emptySlots[x][i] = CreateFrame("Frame", nil, A.frameParent)
				emptySlots[x][i]:SetPoint("TOPLEFT", _G[bars[x]..i], "TOPLEFT", -1, 1)
				emptySlots[x][i]:SetPoint("BOTTOMRIGHT", _G[bars[x]..i], "BOTTOMRIGHT", 1, -1)
				emptySlots[x][i]:SetBackdrop(A.enum.backdrops.editboxborder)
				emptySlots[x][i]:SetBackdropColor(0.1, 0.1, 0.1, 1)
				emptySlots[x][i]:SetBackdropBorderColor(0, 0, 0, 1)
			end

			if(_G[bars[x]..i.."FloatingBG"]) then
				_G[bars[x]..i.."FloatingBG"]:SetTexture(nil)
			end

			if (i == 1) then
				hooksecurefunc(_G[bars[x]..i], "SetPoint", function(self, lp, r, p, x, y)
					if (r ~= anchor) then
						if (orientation == "HORIZONTAL") then
							self:SetPoint("LEFT", anchor, "LEFT", 0, 0)
						else
							self:SetPoint("TOP", anchor, "TOP", 0, 0)
						end
					end
				end)
			end
		end
	end

	self:Update()
end

function AB:Update(...)

	local db = A["Profile"]["Options"]["Actionbars"]

	if (not db["Enabled"]) then
		return
	end

	for x = 1, 5 do

		local bar = db["Bars"]["Bar"..x]
		local position = bar["Position"]
		local orientation = bar["Orientation"]
		local size = bar["Size"]

		local anchor = barAnchors[x]

		local width, height
		if (orientation == "HORIZONTAL") then
			width, height = (size * 12) + (bar["X Spacing"] * 11), size
		else
			width, height = size, (size * 12) + (bar["Y Spacing"] * 11)
		end

		anchor:SetSize(width, height)
		A.Units:Position(anchor, position, "FrameParent")

		anchor.getMoverSize = function(self) return width, height end
		A:UpdateMoveableFrames()

		local relative = anchor
		for i = 1, 12 do

			_G[bars[x]..i]:ClearAllPoints()

			if (orientation == "HORIZONTAL") then
				if (i == 1) then
					_G[bars[x]..i]:SetPoint("LEFT", relative, "LEFT", 0, 0)
				else
					_G[bars[x]..i]:SetPoint("LEFT", relative, "RIGHT", bar["X Spacing"], 0)
				end
			else
				if (i == 1) then
					_G[bars[x]..i]:SetPoint("TOP", relative, "TOP", 0, 0)
				else
					_G[bars[x]..i]:SetPoint("TOP", relative, "BOTTOM", 0, bar["Y Spacing"])
				end
			end

			relative = _G[bars[x]..i]
		end
	end
end

function AB:BindingMode()
	bindingMode = not bindingMode
	if bindingMode then
		A:Debug("Started binding...")
		if not self.bindingWindow then
			local window = CreateFrame("Frame", nil, A.frameParent)
			window:SetSize(300, 100)
			window:SetPoint("TOP", A.frameParent, "TOP", 0, -100)
			window:SetBackdrop(E.backdrops.editboxborder)
			window:SetBackdropColor(unpack(A.colors.backdrop.default))
			window:SetBackdropBorderColor(unpack(A.colors.backdrop.border))

			local text = buildText(window, 11):outline():atCenter():build()
			text:SetText(L["You can now bind the actionbar keys"])

			self.bindingWindow = window
		end
		self.bindingWindow:Show()

		self.bars:foreach(function(bar)
			bar.buttons:foreach(function(button)
				if button:IsMouseOver() then
					capture.button = button
				end
				button.captureFrame:SetFrameLevel(3)
			end)
		end)

		capture:SetFrameStrata("DIALOG");
		capture:SetFrameLevel(99)
		capture:EnableMouse(true);
		capture:EnableKeyboard(true);
		capture:EnableMouseWheel(true);

		setupCapture()

		capture:Hide()

	else
		A:Debug("Stopped binding...")
		self.bindingWindow:Hide()

		self.bars:foreach(function(bar)
			bar.buttons:foreach(function(button)
				button.captureFrame:SetFrameLevel(1)
			end)
		end)
	end
end

function AB:HideArt()
	-- Hidden parent frame
	local UIHider = CreateFrame("Frame")
	UIHider:Hide()
	
	--ArtifactWatchBar:SetParent(UIHider)
	--HonorWatchBar:SetParent(UIHider)

	--MainMenuExpBar:UnregisterAllEvents()
	--MainMenuExpBar:Hide()
	--MainMenuExpBar:SetParent(UIHider)

	--ReputationWatchBar:UnregisterAllEvents()
	--ReputationWatchBar:Hide()
	--ReputationWatchBar:SetParent(UIHider)
	IconIntroTracker:UnregisterAllEvents()
	IconIntroTracker:Hide()
	IconIntroTracker:SetParent(UIHider)

	MainMenuBarArtFrame.LeftEndCap:Hide()
	MainMenuBarArtFrame.RightEndCap:Hide()
	MainMenuBarArtFrameBackground:Hide()
	--MainMenuBarRightEndCap:Hide()
	--MainMenuBarBackpackButtonNormalTexture:SetTexture(nil)

	for i = 0, 3 do
		--_G["MainMenuBarTexture"..i]:Hide()
	end

	InterfaceOptionsActionBarsPanelAlwaysShowActionBars:EnableMouse(false)
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDownButton:SetScale(0.0001)
	InterfaceOptionsActionBarsPanelLockActionBars:SetScale(0.0001)
	InterfaceOptionsActionBarsPanelAlwaysShowActionBars:SetAlpha(0)
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDownButton:SetAlpha(0)
	InterfaceOptionsActionBarsPanelLockActionBars:SetAlpha(0)
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:SetAlpha(0)
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:SetScale(0.0001)

	ActionBarUpButton:Hide()
	ActionBarDownButton:Hide()
	--MainMenuBarPageNumber:Hide()

	if PlayerTalentFrame then
		PlayerTalentFrame:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	else
		hooksecurefunc("TalentFrame_LoadUI", function() PlayerTalentFrame:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED") end)
	end
end

A.general.actionbars = AB