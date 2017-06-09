local A, L = unpack(select(2, ...))
local Units, units, oUF = {}, {}, A.oUF
local media = LibStub("LibSharedMedia-3.0")
local T = A.Tools

for key, obj in next, {
    ["3charname"] = {
        method = [[function(u, r)
            if not u and not r then return end
            if UnitExists(r or u) then
                return string.utf8sub(UnitName(r or u), 1, 3)
            end
        end]],
        events = "UNIT_NAME_UPDATE GROUP_ROSTER_UPDATE"
    }
} do
    oUF["Tags"]["Methods"][key] = obj.method
    oUF["Tags"]["Events"][key] = obj.events
end

 
function Units:Get(unit)
    return units[unit]
end
 
function Units:Add(object, overrideName)
    A:Debug("Adding unit:", overrideName or object:GetName())
    units[overrideName or object:GetName()] = object
end
 
function Units:UpdateElements(frame, db)
    if db then
        for name, func in next, A["Elements"] do
            if db[name] then
                if db[name]["Enabled"] then
                    if frame.EnableElement then
                        frame:EnableElement(name)
                    end
                    func(frame, db[name])
                else
                    if frame.DisableElement then
                        frame:DisableElement(name)
                    end
                end
            end
        end
        if frame.UpdateAllElements then
            frame:UpdateAllElements()
        end
    end
end

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

local function GetUnitAuras(unit, filter)
    local auras = {}    
    for index = 1, 40 do
        local name, rank, texture, count, dtype, duration, expirationTime, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff, casterIsPlayer, nameplateShowAll = UnitAura(unit, index, filter)
        if name and duration and duration > 0 then
            auras[spellID] = {
                name = name,
                dtype = dtype,
                duration = duration,
                count = count,
                texture = texture,
                caster = caster,
                isBossDebuff = isBossDebuff,
                expirationTime = expirationTime,
                casterIsPlayer = casterIsPlayer
            }
        end
    end
    return auras
end

local important = {
    ["BossDebuff"] = function(self, frame, db)
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
                    local media = LibStub("LibSharedMedia-3.0")
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
    ["RaidBuffs"] = function(frame, db)   
	
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
				for unit, buff in next, buffs[spellId] do
					buff:Hide()
				end
				table.remove(buffs, spellId)
            end
        end

        for spellId, obj in next, tracked do
            local size, position, ignored = obj["Size"], obj["Position"]

            if not buffs[spellId] then
				buffs[spellId] = {
					player = buffButton(frame, position, size, spellId, obj, "player")
				}
				for i = 1, 5 do
					buffs[spellId]["party"..i] = buffButton(frame, position, size, spellId, obj, "party"..i)
				end
				for i = 1, 40 do
					buffs[spellId]["raid"..i] = buffButton(frame, position, size, spellId, obj, "raid"..i)
				end
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
			obj.cd:SetHideCountdownNumbers(obj.hideNumbers)
			for _,region in next, {obj.cd:GetRegions()} do
				if region:GetObjectType() == "FontString" then
					obj.cd.cooldownText = region
				end
			end
			if obj.cd.cooldownText then
				local media = LibStub("LibSharedMedia-3.0")
				obj.cd.cooldownText:SetFont(media:Fetch("font", "NotoBold"), obj.cdTextSize, "OUTLINE")
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
        
        for spellId, aura in next, auras do
            local obj = buffs[spellId]
			
			if obj then
				
				local playerObj = obj["player"]
				
				if playerObj.trackOnlyPlayer and aura.caster == "player" then
					visibility(playerObj, aura)
				elseif not playerObj.trackOnlyPlayer then
					for unit, buff in next, obj do 
						if unit ~= "player" then
							if unit == aura.caster then
								visibility(buff, aura)
							end
						end
					end
				end
			end
        end
        
        frame["RaidBuffs"] = buffs
    end
}

function Units:UpdateImportantElements(frame, db)
    if db then
        for name, element in next, db do
            if type(element) == "table" and element["Important"] and element["Enabled"] then
                important[name](frame, element)
            end
        end
    end
end
 
function Units:Translate(frame, relative)
    local parent, name = frame:GetParent(), frame:GetName()
    if units[relative] then
        return units[relative]
    elseif A["Elements"][relative] then
        return frame[relative] and frame[relative] or parent[relative]
    elseif A["Elements"][name] then
        A:Debug("Could not find relative frame '", relative, "' for element '", name or "Unknown", "', using parent.")
        return parent
    elseif relative:equals(parent:GetName(), "Parent") then
        return parent
    else
        A:Debug("Could not find relative frame '", relative, "' for frame '", name or "Unknown", "' using Frameparent.")
        return A["Frameparent"]
    end
end
 
function Units:Position(frame, db)
    frame:ClearAllPoints()
    if db["Local Point"] == "ALL" then
        frame:SetAllPoints()
    else
        frame:SetPoint(db["Local Point"], self:Translate(frame, db["Relative To"]), db["Point"], db["Offset X"], db["Offset Y"])
    end
end
 
function Units:SetKeyBindings(frame, db)
    if db and frame.unit then
        for _,binding in next, db do
            frame:SetAttribute(binding.type, binding.action:gsub("@unit", "@"..frame.unit))
        end
    end
end

function Units:Tag(frame, name, db)  
    local tag = frame["Tags"][name] or frame:CreateFontString(nil, "OVERLAY")
    
    tag:SetFont(media:Fetch("font", db["Font"]), db["Size"], db["Outline"] == "Shadow" and "NONE" or db["Outline"])
    tag:ClearAllPoints()
    tag:SetTextColor(unpack(db["Color"]))
    
    local position = db["Position"]
    if position["Local Point"] == "ALL" then
        tag:SetAllPoints()
    else
        tag:SetPoint(position["Local Point"], self:Translate(tag, position["Relative To"]), position["Point"], position["Offset X"], position["Offset Y"])
    end

    frame:Tag(tag, db["Text"])
    frame["Tags"][name] = tag

   if not db["Enabled"] then tag:Hide() end
end

function Units:CreateStatusBorder(frame, name, db)
    if not frame["StatusBorder"] then
        frame["StatusBorder"] = {}
    end

    local border = frame["StatusBorder"][name]
    if not border then
        border = CreateFrame("Frame", frame:GetName().."_"..name, frame)
        border:SetBackdrop(A.enum.backdrops.editboxborder2)
        border:SetBackdropColor(0, 0, 0, 0)
        border:SetBackdropBorderColor(0, 0, 0, 0)
        border.timer = 0
        frame["StatusBorder"][name] = border
    end

    if not db["Enabled"] then
        border:SetScript("OnUpdate", nil)
        border:Hide()
    else
        border.unit = frame.unit or frame:GetAttribute("unit")
        border:SetBackdropBorderColor(unpack(db["Color"] or { 0, 0, 0, 0 }))
        border:SetFrameStrata(db["Framestrata"] or "LOW")
        border:SetFrameLevel(db["FrameLevel"])
        border:SetAllPoints()
        border:SetScript("OnUpdate", db["Condition"])
        border:SetAlpha(0)
        border:Show()
    end
end

local function HideFrame(frame)
	if InCombatLockdown() then return end
	
    if frame.UnregisterAllEvents then
		frame:UnregisterAllEvents()
		frame:SetParent(A.hiddenFrame)
	else
		frame.Show = frame.Hide
	end

	frame:Hide()
    
	local compact = _G[frame:GetName().."_GetSetting"]("IsShown")
	if compact and compact ~= "0" then
		_G[frame:GetName().."_GetSetting"]("IsShown", "0")
	end
end

function Units:DisableBlizzardRaid()
	if CompactRaidFrameManager_UpdateShown then
		if not CompactRaidFrameManager.hookedHide then
			hooksecurefunc("CompactRaidFrameManager_UpdateShown", function(self) HideFrame(self) end)
			CompactRaidFrameManager:HookScript('OnShow', function(self) HideFrame(self) end)
			CompactRaidFrameManager.hookedHide = true
		end
		CompactRaidFrameContainer:UnregisterAllEvents()

		HideFrame(CompactRaidFrameManager)
	end
end

A.Units = Units