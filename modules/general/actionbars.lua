local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local CreateFrame = CreateFrame
local LAB = LibStub("LibActionButton-1.0")

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
		local bar = CreateFrame("Frame", "Baaaaar", A.frameParent, "SecureHandlerStateTemplate")
		bar.buttons = {}
		for i = 1, 12 do
			local button = LAB:CreateButton(i, string.format("%s_ActionBar%dButton%d", A:GetName(), x, i), bar, { showGrid = true })
			button:SetBackdrop(E.backdrops.statusborder)
			button:SetBackdropColor(0, 0, 0)
			button:SetPoint("LEFT", bar.buttons[i - 1] or bar, i == 1 and "LEFT" or "RIGHT", 0, 0)
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
					self:SetText(newText)
				end
			end)

			button.NormalTexture:SetTexture(nil)

			button:SetState(0, "action", (x - 1) * 12 + i)
			for k = 1, 14 do
				button:SetState(k, "action", (k - 1) * 12 + i)
			end
			--button:SetNormalTexture(nil)
			--button.Border:Hide()
			table.insert(bar.buttons, button)
		end
		table.insert(self.bars, bar)
		bar:SetPoint("TOP", self.bars[x - 1] or A.frameParent, x == 1 and "TOP" or "BOTTOM", 0, 0)
		local w, h = bar.buttons[1]:GetSize()
		bar:SetSize(w * #bar.buttons, h)
	end

	self:SetupBindings(A["Profile"]["Options"]["Key Bindings"])

end

function AB:ClearBindings()
	for _,bar in next, self.bars do
		ClearOverrideBindings(bar)
	end
end

function AB:SetupBindings(bindings)
	for key, button in next, bindings do
		local action = GetBindingByKey(key)
		if action then
			A:Debug("Overriding binding for key: "..key)
		end
		
		local matches = {}
		button:gsub("%d", function(match) table.insert(matches, match) end)
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
	end
end

A["modules"]["Actionbars"] = AB