local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local CreateFrame = CreateFrame
local LAB = LibStub("LibActionButton-1.0")
local buildText = A.TextBuilder
local bindingMode = false

local AB = {
	bars = {}
}

local keys = {
	["SHIFT"] = "s",
	["CTRL"] = "c",
	["ALT"] = "a"
}

function AB:Init()

	A:Debug("Actionbars Init")

	for x = 1, 4 do
		local bar = CreateFrame("Frame", T:frameName("ActionBar"..x), A.frameParent, "SecureHandlerStateTemplate")
		bar.buttons = {}
		for i = 1, 12 do
			local name = string.format("%s_ActionBar%dButton%d", A:GetName(), x, i)
			local button = LAB:CreateButton(i, name, bar, { 
				keyBoundTarget = name,
				showGrid = true
			})

			button:SetPoint("LEFT", bar.buttons[i - 1] or bar, i == 1 and "LEFT" or "RIGHT", i == 1 and 0 or 1, 0)
			hooksecurefunc(button.HotKey, "SetText", function(self, text)
				local newText = text
				for key, new in pairs(keys) do
					if text:find(key) then
						newText = newText:gsub(key, new)
						self.shouldModify = true
					end
				end
				if self.shouldModify then
					self.shouldModify = false
					self:SetFont(media:Fetch("font", "NotoBold"), 11, "OUTLINE")
					self:SetText(newText)
				end
				self:Show()
			end)

			button.Count:SetFont(media:Fetch("font", "NotoBold"), 11, "OUTLINE")
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
			button:SetSize(32, 32)
			button.icon:SetTexCoord(0.133,0.867,0.133,0.867)

            local db = {
            	["Background"] = {
	                ["Color"] = { 0, 0, 0 },
	                ["Offset"] = {
	                    ["Top"] = -1,
	                    ["Bottom"] = -1,
	                    ["Left"] = -1,
	                    ["Right"] = -1
	                },
	                ["Enabled"] = true
            	}
            }

			T:Background(button, db, button, false)
			button.emptySlot = button.emptySlot or button:CreateTexture(nil, "BACKGROUND")
			button.emptySlot:SetBlendMode("ADD")
			button.emptySlot:SetPoint("CENTER")
			button.emptySlot:SetSize(48, 48)
			button.emptySlot:SetTexture([[Interface\BUTTONS\UI-EmptySlot-Disabled]])
			button.emptySlot:SetDrawLayer("BACKGROUND", 1)
			button.emptySlot:SetVertexColor(1, 1, 1, 0.3)
			table.insert(bar.buttons, button)
		end
		table.insert(self.bars, bar)

		local w, h = bar.buttons[1]:GetSize()
		bar:SetSize(w * #bar.buttons + #bar.buttons, h)
		
		local position = A["Profile"]["Options"]["Actionbars"][x]["Position"]
		bar:SetPoint(position["Local Point"], A.frameParent, position["Point"], position["Offset X"], position["Offset Y"])

		A:CreateMover(bar, A["Profile"]["Options"]["Actionbars"][x], "ActionBar"..x)
	end

	self:SetupBindings(A["Profile"]["Options"]["Key Bindings"])

end

function AB:ClearBindings()
	for _,bar in next, self.bars do
		ClearOverrideBindings(bar)
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

			local capture = CreateFrame("Frame", nil, window)

			self.bindingWindow =  window
		end
		self.bindingWindow:Show()
	else
		A:Debug("Stopped binding...")
		self.bindingWindow:Hide()
	end
end

function AB:SetupBindings(bindings)
	if bindings then
		for key, button in next, bindings do
			local action = GetBindingByKey(key)
			if action then
				A:Debug("Overriding binding for key: "..key)
			end
			
			local matches = {}
			button:gsub("%d+", function(match) table.insert(matches, match) end)
			local barId, buttonId = unpack(matches)

			local bar = self.bars[tonumber(barId)]
			local buttonObject = bar.buttons[tonumber(buttonId)]

			SetOverrideBindingClick(bar, true, key, A:GetName().."_"..button, "LEFTBUTTON")

			local newText = key
			for k, new in pairs(keys) do
				if newText:find(k) then
					newText = newText:gsub(k, new)
				end
			end

			buttonObject.HotKey:SetText(newText)

			buttonObject:SetParent(bar)
			buttonObject:Show()
			buttonObject:SetAttribute("statehidden", nil)
		end
	end
end

A["modules"]["Actionbars"] = AB