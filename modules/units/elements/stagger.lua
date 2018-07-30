local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local GetSpecialization = GetSpecialization
local UnitClass = UnitClass
local UnitStagger = UnitStagger

--[[ Locals ]]
local elementName = "Stagger"
local Stagger = { isClassPower = true }
local events = { "UNIT_POWER_FREQUENT", "PLAYER_ENTERING_WORLD", 'UNIT_DISPLAYPOWER' }

local function notValid(frame)
	if (select(2, UnitClass("player")) ~= "MONK" or (GetSpecialization() ~= 1)) then
		return true
	end
end

function Stagger:Init(parent)
	if (select(2, UnitClass("player")) ~= "MONK") then
		return
	end

	local db = parent.db[elementName]
	local texture = media:Fetch("statusbar", db["Texture"])

	local stagger = parent.orderedElements:get(elementName)
	if (not stagger) then
		stagger = CreateFrame("StatusBar", T:frameName(parent:GetName(), elementName), parent)
		stagger.db = db
		stagger.bg = stagger:CreateTexture(nil, "BORDER")
		stagger.bg:SetAllPoints()

		stagger:SetStatusBarTexture(texture)
		stagger.bg:SetTexture(texture)

	   	stagger.Update = function(self, ...)
	   		Stagger:Update(self, ...)
	   	end

	   	local mult = db["Background Multiplier"]
		local r, g, b, a = unpack(db["Colors"]["Low"])
		
		stagger:SetStatusBarColor(r, g, b, a)
		stagger.bg:SetVertexColor(r * mult, g * mult, b * mult, a)

		local tagEventFrame = parent.tagEventFrame
	   	if (tagEventFrame) then
	   		Units:RegisterEvents(tagEventFrame, events)	
	   	end

	   	Units:RegisterEvents(stagger, events, true)
	    stagger:SetScript("OnEvent", function(self, event, ...)
	    	self:Update(event, ...)
		end)

		MonkStaggerBar:UnregisterEvent('PLAYER_ENTERING_WORLD')
		MonkStaggerBar:UnregisterEvent('PLAYER_SPECIALIZATION_CHANGED')
		MonkStaggerBar:UnregisterEvent('UNIT_DISPLAYPOWER')

		if (notValid()) then
			local frame = CreateFrame("Frame")
	   		frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	   		frame:SetScript("OnEvent", function(self, event, ...)
	   			if (notValid()) then return end
		    	Stagger:Init(parent)
		    	frame:SetScript("OnEvent", nil)
				stagger:SetScript("OnUpdate", function(self, elapsed)
					self:Update("OnUpdate")
				end)
			end)
	   	end
	end

	self:Update(stagger, UnitEvent.UPDATE_DB)

	parent.orderedElements:set(elementName, stagger)
end

function Stagger:Update(...)
	
	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local parent = self:GetParent()
	local db = self.db 

	if (notValid()) then
		self:Hide()
		return
	else
		self:Show()
	end

	local staggerValue = UnitStagger("player")

	if (event == UnitEvent.UPDATE_TAGS) then
		local tag = arg1
		tag:AddReplaceLogic("[stagger]", staggerValue)
	elseif (event == UnitEvent.UPDATE_DB) then
		local texture = media:Fetch("statusbar", db["Texture"])
		local size = db["Size"]

		self:SetOrientation(db["Orientation"])
		self:SetReverseFill(db["Reversed"])
		self:SetStatusBarTexture(texture)
		self:SetWidth(size["Match width"] and parent:GetWidth() or size["Width"])
		self:SetHeight(size["Match height"] and parent:GetHeight() or size["Height"])
		
		self.bg:ClearAllPoints()
		self.bg:SetAllPoints()
		self.bg:SetTexture(texture)

		if (db["Background Multiplier"] == -1) then
			self.bg:Hide()
		else
			self.bg:Show()
		end

		self:SetMinMaxValues(0, parent.currentMaxHealth)
		
		U:CreateBackground(self, db, false)

		Units:Attach(self, self.db)
	else
		self:SetMinMaxValues(0, parent.currentMaxHealth)
		self:SetValue(staggerValue)

		local r, g, b, a
		local low = db["Colors"]["Low"]
		local medium = db["Colors"]["Medium"]
		local high = db["Colors"]["High"]
		local mult = db["Background Multiplier"]

		local perc = (staggerValue / parent.currentMaxHealth) * 100
		if (perc > 60) then
			r, g, b, a = unpack(high)
		elseif (perc > 30) then
			r, g, b, a = unpack(medium)
		else
			r, g, b, a = unpack(low)
		end

		self:SetStatusBarColor(r, g, b, a)
		self.bg:SetVertexColor(r * mult, g * mult, b * mult, a)
	end
end

A["Player Elements"]:set(elementName, Stagger)