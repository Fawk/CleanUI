local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local UnitClass = UnitClass
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local SPELL_POWER_SOUL_SHARDS = SPELL_POWER_SOUL_SHARDS

--[[ Locals ]]
local elementName = "Soul Shards"
local SoulShards = { isClassPower = true }
local events = { "UNIT_POWER_FREQUENT", "PLAYER_ENTERING_WORLD", "UNIT_MAXPOWER", "UPDATE_VEHICLE_ACTION_BAR" }
local MAX_SOUL_SHARDS = 5

function SoulShards:Init(parent)
	if (select(2, UnitClass("player")) ~= "WARLOCK") then
		return
	end

	local db = parent.db[elementName]

	local shards = parent.orderedElements:get(elementName)
	if (not shards) then
		shards = CreateFrame("Frame", T:frameName(parentName, elementName), parent)
		shards.buttons = {}
		shards.db = db

		for i = 1, MAX_SOUL_SHARDS do
			local shard = CreateFrame("StatusBar", T:frameName(parentName, "Soul Shard"..i), parent)
			shard.bg = shard:CreateTexture(nil, "BORDER")
			shard.bg:SetAllPoints()
			shards.buttons[i] = shard
		end

		shards.Update = function(self, ...)
			SoulShards:Update(self, ...)
		end

		Units:RegisterEvents(shards, events)
		shards:SetScript("OnEvent", function(self, ...)
			SoulShards:Update(self, ...)
		end)
	end

	self:Update(shards, UnitEvent.UPDATE_DB)
	self:Update(shards, "UNIT_POWER_FREQUENT")

	parent.orderedElements:set(elementName, shards)
end

function SoulShards:Update(...)
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
			width = width + (x * (MAX_SOUL_SHARDS - 1))
		else
			height = height + (y * (MAX_SOUL_SHARDS - 1))
		end
		
		self:SetSize(width, height)
		U:CreateBackground(self, db, false)

		local r, g, b = unpack(A.colors.power[SPELL_POWER_SOUL_SHARDS])
		local texture = media:Fetch("statusbar", db["Texture"])

		for i = 1, MAX_SOUL_SHARDS do
			local shard = self.buttons[i]
			shard:SetOrientation(orientation)
			shard:SetReverseFill(db["Reversed"])
			shard:SetStatusBarTexture(texture)
			shard:SetStatusBarColor(r, g, b)
			shard:SetMinMaxValues(0, 10)

			if (orientation == "HORIZONTAL") then
	            if (i == 1) then
	                shard:SetPoint("LEFT", self, "LEFT", 0, 0)
	            else
	                shard:SetPoint("LEFT", self.buttons[i-1], "RIGHT", x, 0)
	            end
	            width = width / MAX_SOUL_SHARDS
	        else
	            if (i == 1) then
	                shard:SetPoint("TOP", self, "TOP", 0, 0)
	            else
	                shard:SetPoint("TOP", self.buttons[i-1], "BOTTOM", 0, -y)
	            end
	            height = height / MAX_SOUL_SHARDS
	        end

			shard.bg:SetTexture(texture)
			shard.bg:SetVertexColor(r * .33, g * .33, b * .33)

			shard:SetSize(width, height)
		end

		if (not db["Attached"]) then
			A:CreateMover(self, db, elementName)
		else
			A:DeleteMover(elementName)
		end

		Units:Attach(self, db)
	else
		local mod = UnitPowerDisplayMod(SPELL_POWER_SOUL_SHARDS)
		local current = UnitPower("player", SPELL_POWER_SOUL_SHARDS)
		local nomod = UnitPower("player", SPELL_POWER_SOUL_SHARDS, true)

		for i = 1, MAX_SOUL_SHARDS do
			local shard = self.buttons[i]
			if (mod) then
				if ((i * mod) <= nomod) then
					shard:SetValue(mod)
				else
					local rest = (i * mod) - nomod
					if (rest < mod) then
						shard:SetValue(mod - rest)
					else
						shard:SetValue(0)
					end
				end
			else
				if (i <= current) then
					shard:SetValue(mod)
				else
					shard:SetValue(0)
				end
			end
		end
	end
end

A["Player Elements"]:set(elementName, SoulShards)