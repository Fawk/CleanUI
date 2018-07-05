
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


local important = {
    ["Boss Debuff"] = function(self, frame, db)
        local size, position, tracked, ignored = db["Size"], db["Position"], db["Tracked"], db["Ignored"]

        local debuff = frame["Boss Debuff"]
        if not debuff then
            debuff = CreateFrame("Frame", nil, frame)
            debuff:SetSize(size, size)
            Units:Position(debuff, position)

            local icon = debuff:CreateTexture(nil, "OVERLAY")
            icon:SetAllPoints()

            debuff.icon = icon
            debuff:Hide()
        end

        for spellId, aura in next, GetUnitAuras(frame.unit, "HARMFUL") do
            if tracked[spellId] and not ignored[spellId] then
                debuff.expirationTime = aura.expirationTime
                debuff.cd:SetCooldown(expirationTime - duration, duration)
                debuff.cd:SetHideCountdownNumbers(db["Hide Cooldown Numbers"])
                for _,region in next, {debuff.cd:GetRegions()} do
                    if region:GetObjectType() == "FontString" then
                        debuff.cd.cooldownText = region
                    end
                end
                if debuff.cd.cooldownText then
                    debuff.cd.cooldownText:SetFont(media:Fetch("font", "Noto"), db["Cooldown Numbers Text Size"], "OUTLINE")
                end
                if count > 0 then
                    debuff.count:SetText(count)
                    debuff.count:Show()
                end
                local timeLeft = expirationTime - GetTime()
                if(not debuff.timeLeft) then
                    debuff.timeLeft = timeLeft
                    debuff:SetScript("OnUpdate", UpdateTime)
                else
                    debuff.timeLeft = timeLeft
                end

                debuff.nextUpdate = -1
                UpdateTime(debuff, 0)
            else
                debuff:Hide()
            end
            
            debuff.icon:SetTexture(texture)
            debuff:Show()
        end
    end,
    ["Raid Buffs"] = function(frame, db)   
	
		local function buffButton(frame, position, size, spellId, obj, unit)

			local buff = CreateFrame("Frame", A:GetName().."_UnitBuff_"..GetSpellInfo(spellId).."_"..unit, frame)

			Units:Position(buff, position)
			buff:SetSize(size, size)
			buff:SetFrameStrata("HIGH")

			local cd = CreateFrame("Cooldown", "$parentCooldown", buff, "CooldownFrameTemplate")
			cd:SetAllPoints(buff)
			cd:SetReverse(true)

			local icon = buff:CreateTexture(nil, "BORDER")
			icon:SetAllPoints(buff)

			local count = buff:CreateFontString(nil, "OVERLAY")
			count:SetFontObject(NumberFontNormal)
			count:SetPoint("BOTTOMRIGHT", buff, "BOTTOMRIGHT", -1, 0)
			buff.hideNumbers = obj["Hide Countdown Numbers"]
			buff.trackOnlyPlayer = obj["Own Only"]
			buff.cdTextSize = obj["Cooldown Numbers Text Size"]
			buff.icon = icon
			buff.count = count
			buff.cd = cd

			buff:Hide()
			
			return buff
		end

        local tracked = db["Tracked"]
        
        local buffs = frame["RaidBuffs"]
        if not buffs then
            buffs = {}
        end

        for spellId,_ in next, buffs do	
            if not tracked[spellId] then
				for caster, buff in next, buffs[spellId] do
					buff:Hide()
				end
				table.remove(buffs, spellId)
            end
        end

        for spellId, obj in next, tracked do
            if not buffs[spellId] then
				buffs[spellId] = {}
            end
        end
        
        local auras = GetUnitAuras(frame.unit, "HELPFUL")
        if T:tcount(auras) == 0 then
            for spellId, obj in next, buffs do
				for unit, buff in next, obj do
					buff:Hide()
				end
            end
        end
        
        for spellId, buff in next, buffs do
            if not auras[spellId] and buffs[spellId] then
				for unit, buff in next, buffs[spellId] do
					buff:Hide()
				end
            end
        end
		
		local function visibility(obj, aura)
		
			obj.cd:SetCooldown(aura.expirationTime - aura.duration, aura.duration)
			obj.cd:SetHideCountdownNumbers(obj.hideNumbers or false)
			for _,region in next, {obj.cd:GetRegions()} do
				if region:GetObjectType() == "FontString" then
					obj.cd.cooldownText = region
				end
			end
			if obj.cd.cooldownText then
				obj.cd.cooldownText:SetFont(media:Fetch("font", "NotoBold"), obj.cdTextSize, "OUTLINE")
                obj.cd.cooldownText:ClearAllPoints()
                obj.cd.cooldownText:SetPoint("CENTER", 2, 0)
			end
			if aura.count and aura.count > 0 then
				obj.count:SetText(aura.count)
				obj.count:Show()
			end
			local timeLeft = aura.expirationTime - GetTime()
			if(not obj.timeLeft) then
				obj.timeLeft = timeLeft
				obj:SetScript("OnUpdate", UpdateTime)
			else
				obj.timeLeft = timeLeft
			end

			obj.nextUpdate = -1
			UpdateTime(obj, 0)

			obj.icon:SetTexture(aura.texture)
			obj:Show()
		end
        
        for spellId, auraObj in next, auras do
            for caster, aura in next, auraObj do
                local obj = tracked[spellId]
    			
    			if obj then
    				
                    local size, position = tracked[spellId]["Size"], tracked[spellId]["Position"]

    				local playerObj = buffs[spellId]["player"]
                    if not playerObj then
                        playerObj = buffButton(frame, position, size, spellId, obj, "player")
                        buffs[spellId]["player"] = playerObj
                    end

    				if playerObj.trackOnlyPlayer and aura.caster == "player" then
    					visibility(playerObj, aura)
    				elseif not playerObj.trackOnlyPlayer then
                        if aura.caster ~= "player" then
                            if not obj[aura.caster] then
                                buffs[spellId][aura.caster] = buffButton(frame, position, size, spellId, obj, aura.caster)
                            end
                            visibility(buffs[spellId][aura.caster], aura)
                        end
    				end
    			end
            end
        end
        
        frame["Raid Buffs"] = buffs
    end
}
