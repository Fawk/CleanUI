local A, L = unpack(select(2, ...))

--[[ Blizzard ]]
local SPELL_POWER_ALTERNATE_POWER = SPELL_POWER_ALTERNATE_POWER
local CreateFrame = CreateFrame
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax

--[[ Lua ]]
local unpack = unpack
local format = string.format

--[[ Locals ]]
local E = A.enum
local T = A.Tools
local U = A.Utils
local Units = A.Units
local media = LibStub("LibSharedMedia-3.0")
local buildText = A.TextBuilder
local events = { "UNIT_POWER_FREQUENT", "UNIT_MAXPOWER", "PLAYER_ENTERING_WORLD", "UNIT_DISPLAYPOWER", "UPDATE_VEHICLE_ACTIONBAR" }
local elementName = "altpower"

local AlternativePower = {}

function AlternativePower:Init(parent)
	local db = parent.db[elementName]

	if (not db.enabled) then
		return
	end

	local altpower = parent.orderedElements[elementName]
	if (not altpower) then
		altpower = CreateFrame("StatusBar", A:GetName().."_AltPowerBar", parent)
		altpower.db = db
		altpower.value = buildText(altpower, 10):shadow():atCenter():build()
		altpower.value:SetText("")
		altpower.bg = altpower:CreateTexture(nil, "BACKGROUND")
		altpower.noTags = true

		PlayerPowerBarAlt:UnregisterAllEvents()
		PlayerPowerBarAlt:SetAlpha(0)

		altpower.Update = function(self, ...)
			AlternativePower:Update(self, ...)
		end

		Units:RegisterEvents(altpower, events)
		altpower:SetScript("OnEvent", function(self, event, ...)
			self:Update(event, ...)
		end)

		A:CreateMover(altpower, db, elementName)
		Units:Position(altpower, db.position)

		altpower:Hide()
	end

	altpower:Update(UnitEvent.UPDATE_DB)

	parent.orderedElements[elementName] = altpower
end

function AlternativePower:Update(...)
	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local parent = self:GetParent()
	local db = self.db

	local mult = db.mult
	local r, g, b, a = T:unpackColor(db.color)

	if (not db.enabled) then
		Units:RegisterEvents(PlayerPowerBarAlt, events)
		PlayerPowerBarAlt:SetAlpha(100)

		self:Hide()
		return
	end

	if (event == UnitEvent.UPDATE_DB) then

		local texture = media:Fetch("statusbar", db.texture)

		self:SetSize(db.size.matchWidth and parent:GetWidth() or db.size.width, db.size.matchHeight and parent:GetHeight() or db.size.height)
		self:SetStatusBarTexture(texture)
		self.bg:SetTexture(texture)
		self.bg:SetAllPoints()

		U:CreateBackground(self, db, false)
	else
		local value = UnitPower("player", SPELL_POWER_ALTERNATE_POWER)
		local max = UnitPowerMax("player", SPELL_POWER_ALTERNATE_POWER)

		self:SetMinMaxValues(0, max)
		self:SetValue(value)
		self.value:SetText(format("%d / %d", value, max))
	end

	if (mult == -1) then
		self.bg:Hide()
	else
		self.bg:SetVertexColor(r * mult, g * mult, b * mult)
	end
	
	self:SetStatusBarColor(r, g, b, a)
end

A.elements.player[elementName] = AlternativePower