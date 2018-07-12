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
	if true then

		self:HideArt()

		local db = A["Profile"]["Options"]["Actionbars"]

		if (not db["Enabled"]) then
			return
		end

		for x = 1, 5 do

			local bar = db["Bars"][x]
			local position = bar["Position"]
			local orientation = bar["Orientation"]
			local size = bar["Size"]

			local anchor = barAnchors[x]
			if (not anchor) then
				anchor = CreateFrame("Frame", A:GetName().."Bar"..x, A.frameParent)
				barAnchors[x] = anchor
			end

			local width, height
			if (orientation == "HORIZONTAL") then
				width, height = (size * 12) + (bar["X Spacing"] * 11), size
			else
				width, height = size, (size * 12) + (bar["Y Spacing"] * 11)
			end

			anchor:SetSize(width, height)
			A.Units:Position(anchor, position, "FrameParent")

			anchor.getMoverSize = function(self) return width, height end
			A:CreateMover(anchor, bar, "Bar "..x)

			local relative = anchor
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
				hooksecurefunc(_G[bars[x]..i.."Cooldown"], "SetCooldown", function(self, start, duration)
					for region in next, { self:GetRegions() } do  
						if (type(region) ~= "number") then
							print(region:GetObjectType())
						end
					end
				end)

				if (not emptySlots[x][i]) then
					emptySlots[x][i] = anchor:CreateTexture(nil, "BACKGROUND")
					emptySlots[x][i]:SetPoint("CENTER", _G[bars[x]..i], "CENTER", 0, 0)
					emptySlots[x][i]:SetTexture([[Interface\BUTTONS\UI-EmptySlot-Disabled]])
					emptySlots[x][i]:SetVertexColor(0.3, 0.3, 0.3, 1)
					emptySlots[x][i]:SetSize(size + size, size + size)
				end

				if(_G[bars[x]..i.."FloatingBG"]) then
					_G[bars[x]..i.."FloatingBG"]:SetTexture(nil)
				end

				_G[bars[x]..i]:ClearAllPoints()

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

		-- local delayedUpdate = CreateFrame("Frame")
		-- delayedUpdate:SetScript("OnUpdate", function(self, elapsed)
		-- 	self.elapsed = (self.elapsed or 0) + elapsed
		-- 	if (self.elapsed > 0.5) then
		-- 		for x = 1, 5 do
		-- 			for i = 1, 12 do
		-- 				ActionButton_UpdateAction(_G[bars[x]..i], true)
		-- 				ActionButton_Update(_G[bars[x]..i])
		-- 			end
		-- 		end
		-- 		delayedUpdate:SetScript("OnUpdate", nil)
		-- 	end
		-- end)

		return
	end

	A:Debug("Actionbars Init")

	for x = 1, 5 do

		local db = A["Profile"]["Options"]["Actionbars"][x]
		local size = db["Icon Size"]
		local verticalLimit = db["Vertical Limit"]
		local horizontalLimit = db["Horizontal Limit"]
		local rows = 1

		local bar = self.bars:get(x) or CreateFrame("Frame", T:frameName("ActionBar"..x), A.frameParent, "SecureHandlerStateTemplate")
		if (not bar.buttons) then
			bar.buttons = A:OrderedTable()
		end

		for i = 1, 12 do

			if i <= verticalLimit or rows <= horizontalLimit then

				local shouldIncreaseRows = rows == 1 and i > verticalLimit or (i - verticalLimit) > verticalLimit
				if shouldIncreaseRows then
					rows = rows + 1	
				end

				if rows <= horizontalLimit then

					local name = string.format("%s_ActionBar%dButton%d", A:GetName(), x, i)
					local button = bar.buttons:get(i) or LAB:CreateButton(i, name, bar, { 
						keyBoundTarget = name,
						showGrid = true
					})

					if shouldIncreaseRows then
						button:SetPoint("TOPLEFT", bar.buttons:get(rows == 1 and 1 or i - verticalLimit), "BOTTOMLEFT", 0, -1)			
					else
						button:SetPoint(i == 1 and "TOPLEFT" or "LEFT", bar.buttons:get(i - 1) or bar, i == 1 and "TOPLEFT" or "RIGHT", i == 1 and 0 or 1, 0)
					end

					button.HotKey:SetWidth(size)
					button.HotKey:SetFont(media:Fetch("font", "NotoBold"), 10, "OUTLINE")
					button.HotKey:SetTextColor(1, 1, 1)
					hooksecurefunc(button.HotKey, "SetTextColor", function(self, r, g, b)
						if r ~= 1 or g ~= 1 or b ~= 1 then
							self:SetTextColor(1, 1, 1)
						end
					end)
					button.HotKey:ClearAllPoints()
					button.HotKey:SetPoint("TOPRIGHT", button, "TOPRIGHT", -1, -3)
					hooksecurefunc(button.HotKey, "SetText", function(self, text)
						local newText = text:gsub("-", "")
						for key, new in pairs(keys) do
							if text:find(key) then
								newText = newText:gsub(key, new)
								self.shouldModify = true
							end
						end
						if self.shouldModify then
							self.shouldModify = false
							self:SetFont(media:Fetch("font", "NotoBold"), 10, "OUTLINE")
							self:SetText(newText)
						end
						self:Show()
					end)

					button.Count:SetFont(media:Fetch("font", "NotoBold"), 10, "OUTLINE")
					button.Name:SetFont(media:Fetch("font", "NotoBold"), 9, "OUTLINE")
					button.Name:SetJustifyH("CENTER")
					button.Name:ClearAllPoints()
					button.Name:SetPoint("BOTTOM", button, "BOTTOM", 1, 3)

					button:SetState(0, "action", (x - 1) * 12 + i)
					for k = 1, 14 do
						button:SetState(k, "action", (k - 1) * 12 + i)
					end
					hooksecurefunc(button, "SetNormalTexture", function(button, t)
						if t ~= nil then button:SetNormalTexture(nil) end
					end)
					--button.Border:Hide()
					button:SetSize(size, size)
					button.icon:SetTexCoord(0.133,0.867,0.133,0.867)

		            local db = {
		            	["Background"] = {
			                ["Color"] = { 0, 0, 0 },
			                ["Offset"] = {
			                    ["Top"] = 1,
			                    ["Bottom"] = 1,
			                    ["Left"] = 1,
			                    ["Right"] = 1
			                },
			                ["Enabled"] = true
		            	}
		            }

					T:Background(button, db, button, false)

					button.bg:SetBackdropBorderColor(0, 0, 0, 1)

					button.emptySlot = button.emptySlot or button:CreateTexture(nil, "BACKGROUND")
					button.emptySlot:SetBlendMode("ADD")
					button.emptySlot:SetPoint("CENTER")
					button.emptySlot:SetSize(size + 12, size + 12)
					button.emptySlot:SetTexture([[Interface\BUTTONS\UI-EmptySlot-Disabled]])
					button.emptySlot:SetDrawLayer("BACKGROUND", 1)
					button.emptySlot:SetVertexColor(1, 1, 1, 0.3)

					local captureFrame = button.captureFrame or CreateFrame("Frame", nil, button)
					captureFrame:SetFrameLevel(1)
					captureFrame:SetAllPoints()
					captureFrame:SetScript("OnEnter", function(self, userMoved)
						if bindingMode then
							capture.button = button
							capture:SetAllPoints(button)
							capture:Show()
						end
					end)

					button.captureFrame = captureFrame

					if (bar.buttons:count() < i) then
						bar.buttons:add(button)
					end
				end
			end
		end

		if (self.bars:count() < x) then
			self.bars:add(bar)
		end

		if x == 1 then
			local actionpage = "[bar:6]6;[bar:5]5;[bar:4]4;[bar:3]3;[bar:2]2;[overridebar]14;[shapeshift]13;[vehicleui]12;[possessbar]12;[bonusbar:5]11;[bonusbar:4]10;[bonusbar:3]9;[bonusbar:2]8;[bonusbar:1]7;1";
			bar:SetAttribute("_onstate-page", [[
			    self:SetAttribute("state", newstate)
        		control:ChildUpdate("state", newstate)
			  ]])
			RegisterStateDriver(bar, "page", actionpage)
		end

		bar:SetSize(size * verticalLimit + (verticalLimit - 1), size * horizontalLimit + (horizontalLimit - 1))
		bar.getMoverSize = function(self)
			return self:GetSize()
		end
		
		local position = db["Position"]
	    local x1, y1 = position["Offset X"], position["Offset Y"]
	    bar:SetPoint(position["Local Point"], A.frameParent, position["Point"], x1, y1)

	    bar.db = db
		A:CreateMover(bar, db, "ActionBar"..x)
	end

	self:SetupBindings(A["Profile"]["Options"]["Key Bindings"])
	local bindFrame = self.bindFrame or CreateFrame("Frame")
	bindFrame:RegisterEvent("UPDATE_BINDINGS")
	bindFrame:SetScript("OnEvent", function(self, ...)
		AB:SetupBindings(A["Profile"]["Options"]["Key Bindings"])
	end)

	self.bindFrame = bindFrame
end

function AB:ClearBindings()
	self.bars:foreach(function(bar)
		ClearOverrideBindings(bar)
	end)
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

function AB:SetupBindings(bindings)
	if bindings then
		for key, button in next, bindings do
			if button ~= "" then

				local action = GetBindingByKey(key)
				if action then
					A:Debug("Overriding binding for key: "..key)
				end
				
				local matches = {}
				button:gsub("%d+", function(match) table.insert(matches, match) end)
				local barId, buttonId = unpack(matches)

				local bar = self.bars:get(tonumber(barId))
				local buttonObject = bar.buttons:get(tonumber(buttonId))

				SetOverrideBindingClick(bar, true, key, button, "LEFTBUTTON")

				local newText = key:gsub("-", "")
				for k, new in pairs(keys) do
					if newText:find(k) then
						newText = newText:gsub(k, new)
					end
				end

				buttonObject.actualKey = key
				buttonObject.HotKey:SetText(newText)
				buttonObject.HotKey:SetTextColor(1, 1, 1)

				buttonObject:SetParent(bar)
				buttonObject:Show()
				buttonObject:SetAttribute("statehidden", nil)
			end
		end
	end
end

function AB:HideArt()
	-- Hidden parent frame
	local UIHider = CreateFrame("Frame")
	UIHider:Hide()
	
	ArtifactWatchBar:SetParent(UIHider)
	HonorWatchBar:SetParent(UIHider)

	MainMenuExpBar:UnregisterAllEvents()
	MainMenuExpBar:Hide()
	MainMenuExpBar:SetParent(UIHider)

	ReputationWatchBar:UnregisterAllEvents()
	ReputationWatchBar:Hide()
	ReputationWatchBar:SetParent(UIHider)
	IconIntroTracker:UnregisterAllEvents()
	IconIntroTracker:Hide()
	IconIntroTracker:SetParent(UIHider)

	MainMenuBarLeftEndCap:Hide()
	MainMenuBarRightEndCap:Hide()
	MainMenuBarTexture0:Hide()
	MainMenuBarTexture1:Hide()
	MainMenuBarTexture2:Hide()
	MainMenuBarTexture3:Hide()
	MainMenuBarBackpackButtonNormalTexture:SetTexture(nil)

	for i = 0, 3 do
		_G["CharacterBag"..i.."SlotNormalTexture"]:SetTexture(nil)
	end

	InterfaceOptionsActionBarsPanelAlwaysShowActionBars:EnableMouse(false)
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDownButton:SetScale(0.0001)
	InterfaceOptionsActionBarsPanelLockActionBars:SetScale(0.0001)
	InterfaceOptionsActionBarsPanelAlwaysShowActionBars:SetAlpha(0)
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDownButton:SetAlpha(0)
	InterfaceOptionsActionBarsPanelLockActionBars:SetAlpha(0)
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:SetAlpha(0)
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:SetScale(0.0001)

	if PlayerTalentFrame then
		PlayerTalentFrame:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	else
		hooksecurefunc("TalentFrame_LoadUI", function() PlayerTalentFrame:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED") end)
	end
end

A["modules"]["Actionbars"] = AB