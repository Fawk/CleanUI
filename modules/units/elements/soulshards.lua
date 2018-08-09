local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local UnitClass = UnitClass
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local SPELL_POWER_SOUL_SHARDS = Enum.PowerType.SoulShards

--[[ Locals ]]
local elementName = "soulShards"
local SoulShards = { isClassPower = true }
local events = { "UNIT_POWER_FREQUENT", "PLAYER_ENTERING_WORLD", "UNIT_MAXPOWER" }
local MAX_SOUL_SHARDS = 5

function SoulShards:Init(parent)
	if (select(2, UnitClass("player")) ~= "WARLOCK") then
		return
	end

	local db = parent.db[elementName]

	local shards = parent.orderedElements[elementName]
	if (not shards) then
		shards = CreateFrame("Frame", parentName.."_"..elementName, parent)
		shards.buttons = {}
		shards.db = db
		shards.noTags = true

		for i = 1, MAX_SOUL_SHARDS do
			local shard = CreateFrame("StatusBar", parent:GetName().."_Soul Shard"..i, shards)
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

	parent.orderedElements[elementName] = shards
end

function SoulShards:Update(...)
	local self, event, arg1, arg2, arg3, arg4, arg5 = ...
	local db = self.db

	if (event == UnitEvent.UPDATE_DB) then
		
		local orientation = db.orientation
		local width = db.size.matchWidth and parent:GetWidth() or db.size.width
		local height = db.size.matchHeight and parent:GetHeight() or db.size.height
		local x = db.x
		local y = db.y

		if (orientation == "HORIZONTAL") then
			width = width + (x * (MAX_SOUL_SHARDS - 1))
		else
			height = height + (y * (MAX_SOUL_SHARDS - 1))
		end
		
		self:SetSize(width, height)
		U:CreateBackground(self, db, false)

		local r, g, b = unpack(A.colors.power[SPELL_POWER_SOUL_SHARDS])
		local texture = media:Fetch("statusbar", db.texture)

		if (orientation == "HORIZONTAL") then
			width = math.floor((width - x) / MAX_SOUL_SHARDS)
		else
	        height = math.floor((height - y) / MAX_SOUL_SHARDS)
		end

		for i = 1, MAX_SOUL_SHARDS do
			local shard = self.buttons[i]
			shard:SetOrientation(orientation)
			shard:SetReverseFill(db.reversed)
			shard:SetStatusBarTexture(texture)
			shard:SetStatusBarColor(r, g, b)
			shard:SetMinMaxValues(0, 10)

			width, height = T:PositionClassPowerIcon(self, shard, orientation, width, height, MAX_SOUL_SHARDS, i, x, y)

			shard.bg:SetTexture(texture)
			shard.bg:SetVertexColor(r * .33, g * .33, b * .33)

			shard:SetSize(width, height)
		end

		if (not db.attached) then
			A:CreateMover(self, db, elementName)
		else
			A:DeleteMover(elementName)
			Units:Attach(self, db)
		end
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

A.elements.player[elementName] = SoulShards