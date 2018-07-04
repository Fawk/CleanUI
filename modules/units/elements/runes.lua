local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")

-- [[ Blizzard ]]
local UnitClass = UnitClass
local CreateFrame = CreateFrame
local GetSpecialization = GetSpecialization
local GetRuneCooldown = GetRuneCooldown

-- [[ Locals ]]
local elementName = "Runes"
local Runes = { isClassPower = true }
local MAX_RUNES = 6

local function pairsByKeys (t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
		table.sort(a, f)
		local i = 0
		local iter = function ()
			i = i + 1
			if a[i] == nil then return nil
			else return a[i], t[a[i]]
		end
	end
	return iter
end

local function tfirst(t)
	for k,v in pairsByKeys(t) do
		return k
	end
end

local function tfirstValue(t)
	return #t > 1 and t[1] or nil
end

local function orderRunes(parent, orientation)
	local readyRunes, notReadyRunes = {}, {}
	local db = parent.db
	local orientation = db["Orientation"]
	local x = db["X Spacing"]
	local y = db["Y Spacing"]

	for i = 1, MAX_RUNES do
		local rune = parent.buttons[i]
		local start,_,runeReady = GetRuneCooldown(i)
		if (runeReady) then
			table.insert(readyRunes, i)
		else
			if (notReadyRunes[start]) then
				notReadyRunes[start+1] = i
			else
				notReadyRunes[start] = i
			end
		end
		rune:ClearAllPoints()
	end

	for i, realIndex in pairs(readyRunes) do
		local rune = parent.buttons[realIndex]
		if (orientation == "HORIZONTAL") then
			if (i == 1) then
				rune:SetPoint("LEFT", parent, "LEFT", 0, 0)
			else
				rune:SetPoint("LEFT", parent.buttons[readyRunes[i-1]], "RIGHT", x, 0)
			end
		else
			if (i == 1) then
				rune:SetPoint("TOP", parent, "TOP", 0, 0)
			else
				rune:SetPoint("TOP", parent.buttons[readyRunes[i-1]], "BOTTOM", 0, -y)
			end
		end
	end

	local oldIndex = parent.realIndex

	local first = tfirst(notReadyRunes)
	local prev = first
	for i, realIndex in pairsByKeys(notReadyRunes) do
		local rune = parent.buttons[realIndex]
		if (i == first) then
			parent.realIndex = realIndex
		end
		if (#readyRunes > 0) then
			if (orientation == "HORIZONTAL") then
				if (i == first) then
					rune:SetPoint("LEFT", parent.buttons[readyRunes[#readyRunes]], "RIGHT", x, 0)
				else
					rune:SetPoint("LEFT", parent.buttons[notReadyRunes[prev]], "RIGHT", x, 0)
				end
			else
				if (i == first) then
					rune:SetPoint("TOP", parent.buttons[readyRunes[#readyRunes]], "BOTTOM", 0, -y)
				else
					rune:SetPoint("TOP", parent.buttons[notReadyRunes[prev]], "BOTTOM", 0, -y)
				end
			end
		else
			if (orientation == "HORIZONTAL") then
				if (i == first) then
					rune:SetPoint("LEFT", parent, "LEFT", 0, 0)
				else
					rune:SetPoint("LEFT", parent.buttons[notReadyRunes[prev]], "RIGHT", x, 0)
				end
			else
				if (i == first) then
					rune:SetPoint("TOP", parent, "TOP", 0, 0)
				else
					rune:SetPoint("TOP", parent.buttons[notReadyRunes[prev]], "BOTTOM", 0, -y)
				end
			end
		end
		prev = i
	end

	if (#readyRunes > 0) then
		parent.realIndex = tfirstValue(readyRunes)
	end
end

function Runes:Init(parent)
	if (select(2, UnitClass("player")) ~= "DEATHKNIGHT") then
		return
	end

	local db = parent.db[elementName]

	local runes = parent.orderedElements:get(elementName)
	if (not runes) then
		runes = CreateFrame("Frame", T:frameName(parentName, elementName), parent)
		runes.buttons = {}
		runes.db = db

		for i = 1, MAX_RUNES do
			local rune = CreateFrame("StatusBar", T:frameName(parentName, "Rune"..i), parent)
			rune.bg = rune:CreateTexture(nil, "BORDER")
			rune.bg:SetAllPoints()
			runes.buttons[i] = rune
		end

		runes.Update = function(self, ...)
			Runes:Update(self, ...)
		end

		runes:RegisterEvent("PLAYER_TALENT_UPDATE")

		runes:SetScript("OnUpdate", function(self, elapsed)
			Runes:Update(self, "UPDATE")
		end)
		runes:SetScript("OnEvent", function(self, ...)
			Runes:Update(self, UnitEvent.UPDATE_DB, ...)
		end)
	end

	self:Update(runes, UnitEvent.UPDATE_DB)

	parent.orderedElements:set(elementName, runes)
end

function Runes:Update(...)
	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local db = self.db

	if (event == UnitEvent.UPDATE_DB) then
		
		local size = db["Size"]
		local orientation = db["Orientation"]
		local width = size["Width"]
		local height = size["Height"]
		local x = db["X Spacing"]
		local y = db["Y Spacing"] 

		if (orientation == "HORIZONTAL") then
			width = (width * MAX_RUNES) + (x * MAX_RUNES)
		else
			height = (height * MAX_RUNES) + (y * MAX_RUNES)
		end
		
		self:SetSize(width, height)

		local r, g, b = unpack(A.colors.power.runes[GetSpecialization()])
		local texture = media:Fetch("statusbar", db["Texture"])

		for i = 1, MAX_RUNES do
			local rune = self.buttons[i]
			rune:SetSize(size["Width"], size["Height"])
			rune:SetOrientation(orientation)
			rune:SetReverseFill(db["Reversed"])
			rune:SetStatusBarTexture(texture)
			rune:SetStatusBarColor(r, g, b)

			rune.bg:SetTexture(texture)
			rune.bg:SetVertexColor(r * .33, g * .33, b * .33)

			U:CreateBackground(rune, db, true)
			rune:SetBackdropBorderColor(0, 0, 0, 0)
		end

		if (not db["Attached"]) then
			A:CreateMover(self, db, elementName)
		else
			A:DeleteMover(elementName)
		end

		Units:Position(self, db["Position"])
	else
		for i = 1, MAX_RUNES do
			local rune = self.buttons[i]

			local start, duration, runeReady = GetRuneCooldown(i)
			local minValue, maxValue = rune:GetMinMaxValues()
			if (not runeReady and start and start ~= 0) then
				if (min ~= 0 or maxValue ~= duration) then
					rune:SetMinMaxValues(0, duration)
				end
				rune:SetValue(GetTime() - start)
			else
				rune:SetValue(duration)
			end
		end

		orderRunes(self, db)
	end
end

A["Player Elements"]:set(elementName, Runes)