local parent, ns = ...
local oUF = ns.oUF

local Update = function(self, event, unit)
	if(self.unit ~= unit) then return end

	local buffs = self.RaidBuffs
	local tracked = buffs.Tracked

	for index = 1, (buffs.numLimit or 40) do
		local name, rank, texture, count, dtype, duration, expirationTime, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff, casterIsPlayer, nameplateShowAll = UnitAura(unit, index, "HELPFUL")
		local obj = tracked[spellID]
		if(name and obj) then
			if (obj.trackOnlyPlayer and casterIsPlayer) or not obj.trackOnlyPlayer then 
				if(duration and duration > 0) then
					obj.cd:SetCooldown(expirationTime - duration, duration)
					obj.cd:Show()
				else
					obj.cd:Hide()
				end
				obj.count:SetText(count and count or "")
				obj:Show()
			end
		end
	end
end

local Enable = function(self)
	local buffs = self.RaidBuffs
	if(buffs) then
		self:RegisterEvent("UNIT_AURA", Update)

	end
end

local Disable = function(self)
	local buffs = self.RaidBuffs
	if(buffs) then
		self:UnregisterEvent("UNIT_AURA", Update)

	end
end

oUF:AddElement('RaidBuffs', nil, Enable, Disable)

