local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local CreateFrame = CreateFrame
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsDead = UnitIsDead
local UnitIsConnected = UnitIsConnected
local UnitClass = UnitClass
local UnitInRange = UnitInRange

string.replace = function(self, t, r)
   local format = t:gsub("%[", "%%["):gsub("%]", "%%]")
   return self:gsub(format, r)
end

local elementName = "Health"

local NewHealth = CreateFrame("StatusBar", T:frameName(elementName), A.frameParent)
A["Shared Elements"]:add(NewHealth)

function NewHealth:Init(parent)

	local db = A["Profile"]["Options"][parent:GetName()][elementName]

	local health = parent.orderedElements:getChildByKey("key", elementName)
	if (not health) then

		self:SetParent(parent)
		self:SetFrameStrata("LOW")
		self.bg = self:CreateTexture(nil, "BACKGROUND")

		self.tags = A:OrderedTable()

		self:RegisterEvent("UNIT_HEALTH_FREQUENT")
	    self:RegisterEvent("UNIT_MAXHEALTH")
	    self:SetScript("OnEvent", self.Update)
	end

	self:Update(UnitEvent.UPDATE_DB, db)
	self:Update(UnitEvent.UPDATE_TEXTS)
	self:Update("UNIT_HEALTH_FREQUENT")

	parent.orderedElements:add({ key = elementName, element = self })
end

function NewHealth:Disable(parent)
	self:Hide()
	self:UnregisterAllEvents()
	parent.orderedElements:remove(self)
end

function NewHealth:Update(...)
	local parent = self:GetParent()
	local event, arg1, arg2, arg3, arg4, arg5 = ...

	if (event == "UNIT_HEALTH_FREQUENT" or event == "UNIT_MAXHEALTH") then
		parent:Update(UnitEvent.UPDATE_HEALTH)
	  	self:SetValue(parent.currentHealth)
	  	self:SetMinMaxValues(0, parent.currentMaxHealth)
	elseif (event == UnitEvent.UPDATE_TEXTS) then
		parent:Update(UnitEvent.UPDATE_HEALTH)
		self.tags:foreach(function(tag)
			tag:SetText(tag.format
				:replace("[hp]", parent.currentHealth)
			    :replace("[maxhp]", parent.currentMaxHealth)
			    :replace("[perhp]", math.floor(parent.currentHealth / parent.currentMaxHealth * 100 + .5))
			)
		end)
	elseif (event == UnitEvent.UPDATE_DB) then
		
		local db = arg1

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

		self:SetStatusBarColor(.5, 1, .5, 1)
		self.bg:SetVertexColor(.5 * .3, .5 * .3, .5 * .3, 1)

		self.tags:foreach(function(tag)
			tag:Hide()
		end)

		local tags = db["Tags"] or {}
		for _,tag in next, tags do
			self.tags:add(tag)
		end
	end
end

function Health(frame, db)

	local health = frame.Health or (function()

		local health = CreateFrame("StatusBar", frame:GetName().."_Health", frame)
		health:SetFrameStrata("LOW")
		health.frequentUpdates = true
		health.bg = health:CreateTexture(nil, "BACKGROUND")

		local function Gradient(unit)
			local r1, g1, b1 = unpack(A.colors.health.low)
			local r2, g2, b2 = unpack(A.colors.health.medium)
			local r3, g3, b3 = unpack(unit and oUF.colors.class[select(2, UnitClass(unit))] or A.colors.backdrop.light)
			return r1, g1, b1, r2, g2, b2, r3, g3, b3
		end

		health.PostUpdate = function(self, unit, min, max)
			
			local r, g, b, t, a
			local colorType = db["Color By"]
			local mult = db["Background Multiplier"]
			
			if colorType == "Class" then
				health.colorClass = true
				r, g, b = unpack(oUF.colors.class[select(2, UnitClass(unit))] or A.colors.backdrop.default)
			elseif colorType == "Health" then
				health.colorHealth = true
			elseif colorType == "Custom" then
				t = db["Custom Color"]
			elseif colorType == "Gradient" then
				r, g, b = oUF.ColorGradient(min, max, Gradient(unit))
			end
			
			if t then
				r, g, b = unpack(t)
			end

			self.colorClassNPC = true

			if r then
				self:SetStatusBarColor(r, g, b, a or 1)
				self.bg:SetVertexColor(r * mult, g * mult, b * mult, a or 1)
			end
		end

		return health

	end)()

	Units:Position(health, db["Position"])

	local texture = media:Fetch("statusbar", db["Texture"])
	local size = db["Size"]

	health:SetOrientation(db["Orientation"])
	health:SetReverseFill(db["Reversed"])
	health:SetStatusBarTexture(texture)
	health:SetWidth(size["Match width"] and frame:GetWidth() or size["Width"])
	health:SetHeight(size["Match height"] and frame:GetHeight() or size["Height"])
	health.bg:ClearAllPoints()
	health.bg:SetAllPoints()
	health.bg:SetTexture(texture)

	if frame.PostHealth then
		frame:PostHealth(health)
	end

	frame.Health = health
end

A["Elements"]:add({ name = "Health", func = Health })