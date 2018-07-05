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
local events = { "UNIT_POWER_FREQUENT" }

function Stagger:Init(parent)
	if (select(2, UnitClass("player")) ~= "MONK" or (GetSpecialization() ~= 1)) then
		return
	end

	local db = parent.db[elementName]
	local size, texture = db["Size"], media:Fetch("statusbar", db["Texture"])

	local stagger = parent.orderedElements:get(elementName)
	if (not stagger) then
		local stagger = CreateFrame("StatusBar", T:frameName(parent:GetName(), "Stagger"), frame)
		stagger.db = db
		stagger.bg = stagger:CreateTexture(nil, "BORDER")
		stagger.bg:SetAllPoints()
		stagger.bg.multiplier = db["Background Multiplier"] or 0.3

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
		MonkStaggerBar:UnregisterEvent('UPDATE_VEHICLE_ACTION_BAR')
	end

	Stagger:Update(stagger, UnitEvent.UPDATE_DB)
	Stagger:Update(stagger, UnitEvent.UPDATE_TAGS)

	parent.orderedElements:set(elementName, stagger)
end

function Stagger:Update(...)
	
	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local parent = self:GetParent()

	local staggerValue = UnitStagger("player")

	if (event == UnitEvent.UPDATE_TAGS) then
		local tag = arg1
		tag.text = tag.format
			:replace("[stagger]", staggerValue)
	elseif (event == UnitEvent.UPDATE_DB) then
		local db = self.db or arg1
		Units:Position(self, db["Position"])

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

		self:SetMinMaxValues(0, parent.currentMaxHealth)
		self:SetValue(staggerValue)
		
		U:CreateBackground(stagger, db, true)

		if (db["Background Multiplier"] == -1) then
			self.bg:Hide()
		else
			self.bg:Show()
		end

		Units:Attach(self, db)
	end
end

A["Player Elements"]:set(elementName, Stagger)