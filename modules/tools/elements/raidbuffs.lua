local parent, ns = ...
local oUF = ns.oUF

local UpdateTime = function(self, elapsed)
	self.timeLeft = self.timeLeft - elapsed
	if(self.nextUpdate > 0) then
		self.nextUpdate = self.nextUpdate - elapsed
		return
	end
	if self.timeLeft <= 0 then
		self:Hide()
	end
end

local Update = function(self, event, unit)
	if(self.unit ~= unit) then return end
    if not unit then return end

	local buffs = self.RaidBuffs
	local tracked = buffs.Tracked
	for index = 1, (buffs.numLimit or 40) do
		local name, rank, texture, count, dtype, duration, expirationTime, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff, casterIsPlayer, nameplateShowAll = UnitAura(unit, index, "HELPFUL")
		local obj = tracked[spellID]
		if(name and obj) then
			obj.expirationTime = expirationTime
			if (obj.trackOnlyPlayer and casterIsPlayer) or not obj.trackOnlyPlayer then 
				if(duration and duration > 0) then
					obj.cd:SetCooldown(expirationTime - duration, duration)
					obj.cd:SetHideCountdownNumbers(obj.hideNumbers)
					for _,region in next, {obj.cd:GetRegions()} do
						if region:GetObjectType() == "FontString" then
							obj.cd.cooldownText = region
						end
					end
					if obj.cd.cooldownText then
						local media = LibStub("LibSharedMedia-3.0")
						obj.cd.cooldownText:SetFont(media:Fetch("font", "Noto"), 9, "OUTLINE")
					end
					if count > 0 then
						obj.count:SetText(count)
						obj.count:Show()
					end
					local timeLeft = expirationTime - GetTime()
					if(not obj.timeLeft) then
						obj.timeLeft = timeLeft
						obj:SetScript("OnUpdate", UpdateTime)
					else
						obj.timeLeft = timeLeft
					end

					obj.nextUpdate = -1
					UpdateTime(obj, 0)
				else
					obj:Hide()
				end
				obj.icon:SetTexture(texture)
				obj:Show()
			end
		elseif (not name and obj) then
            obj:Hide()
        end
	end
end

local Enable = function(self)
	local buffs = self.RaidBuffs
	if(buffs) then
		self:RegisterEvent("UNIT_AURA", Update)
		self:RegisterEvent("GROUP_ROSTER_UPDATE", Update)
	end
end

local Disable = function(self)
	local buffs = self.RaidBuffs
	if(buffs) then
		self:UnregisterEvent("UNIT_AURA", Update)
		self:UnregisterEvent("GROUP_ROSTER_UPDATE", Update)
	end
end

oUF:AddElement('RaidBuffs', Update, Enable, Disable)

