local A, L = unpack(select(2, ...))
local Units, units = {}, A:OrderedMap()
local media = LibStub("LibSharedMedia-3.0")
local T = A.Tools

local MAX_ARENA_ENEMIES = MAX_ARENA_ENEMIES or 5
local MAX_BOSS_FRAMES = MAX_BOSS_FRAMES or 5
local MAX_PARTY_MEMBERS = MAX_PARTY_MEMBERS or 4

local hiddenParent = CreateFrame('Frame', nil, UIParent)
hiddenParent:SetAllPoints()
hiddenParent:Hide()

function Units:Get(unit)
    return units[unit]
end

function Units:Add(object, overrideName)
    A:Debug("Adding unit:", overrideName or object:GetName())
    units[overrideName or object:GetName()] = object
end

function Units:Translate(frame, relative)
    local parent, name = frame:GetParent(), frame:GetName()

    if (units[relative]) then
        return units[relative]
    elseif (A.elements.player[relative] or A.elements.shared[relative]) then
        if (frame.orderedElements and frame.orderedElements[relative]) then
            return frame.orderedElements[relative]
        elseif (parent.orderedElements and parent.orderedElements[relative]) then
            return parent.orderedElements[relative]
        end
        return parent
    elseif (relative:equals(parent:GetName(), "Parent")) then
        return parent
    elseif (relative:equals(parent:GetName(), "FrameParent")) then
        return A.frameParent
    else
        A:Debug("Could not find relative frame '", relative, "' for frame '", name or "Unknown", "' using Frameparent.")
        return A.frameParent
    end
end
 
function Units:Position(frame, db, overrideRelative)
    frame:ClearAllPoints()
    if (db.localPoint == "ALL") then
        frame:SetAllPoints()
    else
        local x, y = db.x, db.y

        if (db.relative == "FrameParent" or (db.relative == "Parent" and frame:GetParent() == A.frameParent)) then
            x = T:Scale(x)
            y = T:Scale(y)
        end

        frame:SetPoint(db.localPoint, self:Translate(frame, overrideRelative or db.relative), db.point, x, y)
    end
end

function Units:Attach(frame, db, override)
    local target = override or frame:GetParent()
    local position = db.attachedPosition
    local x = db.x
    local y = db.y

    if (not position) then
        A:Debug("No Attached Position for frame:", frame:GetName())
        return Units:Position(frame, db.position)
    end

    frame:ClearAllPoints()
    if (position == "Below") then
        frame:SetPoint("TOP", target, "BOTTOM", x, y)
    elseif (position == "Above") then
        frame:SetPoint("BOTTOM", target, "TOP", x, y)
    elseif (position == "Right") then
        frame:SetPoint("LEFT", target, "RIGHT", x, y)
    elseif (position == "Left") then
        frame:SetPoint("RIGHT", target, "LEFT", x, y)
    end
end

local function getClassPowerRelative(frame)
    for i = 1, A.elements.player:len() do
        local target = frame.orderedElements[A.elements.player(i)]
        if (A.elements.player[i].isClassPower and target and target:IsShown()) then
            return target
        end
    end
end

function Units:PlaceCastbar(bar, db)
    local parent = bar:GetParent()
    local position = db.position
    
    if (db.attached) then
        
        A:DeleteMover(bar:GetName())
        bar:ClearAllPoints()
        
        if (parent.unit == "player") then
            local relative = getClassPowerRelative(parent)
            if (relative) then
                local attachedPosition = relative.db.attachedPosition
                if (attachedPosition == db.attachedPosition) then
                    self:Attach(bar, db, relative)
                    return
                end
            end
        end

        self:Attach(bar, db)
    else
        self:Position(bar, db.position)
        A:CreateMover(bar, db, bar:GetName())
    end
end

function Units:Tag(frame, name, db)
    local tag = frame.tags[name]
    if (not tag) then
        tag = frame:CreateFontString(nil, "OVERLAY")
        tag.replaced = ""

        frame.tags[name] = tag
    end

    tag:SetFont(media:Fetch("font", "Default"), db.size, "OUTLINE")
    tag.format = db.format

    local position = {
        localPoint = db.localPoint,
        point = db.point,
        relative = db.relative,
        x = db.x,
        y = db.y
    }

    Units:Position(tag, position)

    if (db.hide) then
        tag:Hide()
    else
        tag:Show()
    end
end

function Units:RegisterEvents(frame, events, force)
    for _, event in next, events do
        local registered = frame:IsEventRegistered(event)
        if (registered and force or not registered) then
            frame:RegisterEvent(event)
        end
    end
end

function Units:UpdateMissingBar(parent, key, min, max)
    if (parent[key]) then
        parent[key]:SetMinMaxValues(0, max)
        parent[key]:SetValue(max - min)
    end
end

function Units:SetupMissingBar(parent, db, key, min, max, gradient, colorFunc, classOverride)
    if (not db) then return end
    if (not min) then min = 0 end
    if (not max) then max = 1 end

    local bar = parent[key]
    local unit = parent:GetParent()

    if (db.enabled) then
        local tex = parent:GetStatusBarTexture()
        local orientation = parent:GetOrientation()
        local reversed = parent:GetReverseFill()
        bar:SetOrientation(orientation)
        bar:SetReverseFill(reversed)
        bar:SetStatusBarTexture(tex:GetTexture())
        bar.db = db

        if (orientation == "HORIZONTAL") then
            if (reversed) then
                bar:SetPoint("TOPRIGHT", tex, "TOPLEFT")
                bar:SetPoint("BOTTOMRIGHT", tex, "BOTTOMLEFT")
            else
                bar:SetPoint("TOPLEFT", tex, "TOPRIGHT")
                bar:SetPoint("BOTTOMLEFT", tex, "BOTTOMRIGHT")
            end
        else
            if (reversed) then
                bar:SetPoint("TOPRIGHT", tex, "BOTTOMRIGHT")
                bar:SetPoint("TOPLEFT", tex, "BOTTOMLEFT")
            else
                bar:SetPoint("BOTTOMRIGHT", tex, "TOPRIGHT")
                bar:SetPoint("BOTTOMLEFT", tex, "TOPLEFT")
            end
        end
        
        bar:SetSize(parent:GetSize())

        -- Calculate value based on min and max values
        bar:SetMinMaxValues(0, max)
        bar:SetValue(max - min)

        -- Do coloring based on db
        colorFunc(A, bar, parent, min, max, gradient, classOverride)

        bar:Show()
    else
        bar:Hide()
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

local function handleFrame(baseName)
    local frame
    if(type(baseName) == 'string') then
        frame = _G[baseName]
    else
        frame = baseName
    end

    if(frame) then
        frame:UnregisterAllEvents()
        frame:Hide()

        frame:SetParent(hiddenParent)

        local health = frame.healthBar or frame.healthbar
        if(health) then
            health:UnregisterAllEvents()
        end

        local power = frame.manabar
        if(power) then
            power:UnregisterAllEvents()
        end

        local spell = frame.castBar or frame.spellbar
        if(spell) then
            spell:UnregisterAllEvents()
        end

        local altpowerbar = frame.powerBarAlt
        if(altpowerbar) then
            altpowerbar:UnregisterAllEvents()
        end

        local buffFrame = frame.BuffFrame
        if(buffFrame) then
            buffFrame:UnregisterAllEvents()
        end
    end
end

function Units:CreateBuffPool()
    A.pools:CreatePool("BUTTON", buffs, "AuraIconBarTemplate")
end

function Units:DisableBlizzard(unit)
    if(not unit) then return end

    unit = unit:lower()

    if(unit == "player") then
        handleFrame(PlayerFrame)

        PlayerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
        PlayerFrame:RegisterEvent("UNIT_ENTERING_VEHICLE")
        PlayerFrame:RegisterEvent("UNIT_ENTERED_VEHICLE")
        PlayerFrame:RegisterEvent("UNIT_EXITING_VEHICLE")
        PlayerFrame:RegisterEvent("UNIT_EXITED_VEHICLE")

        PlayerFrame:SetUserPlaced(true)
        PlayerFrame:SetDontSavePosition(true)
    elseif(unit == "pet") then
        handleFrame(PetFrame)
    elseif(unit == "target") then
        handleFrame(TargetFrame)
        handleFrame(ComboFrame)
    elseif(unit == "focus") then
        handleFrame(FocusFrame)
        handleFrame(TargetofFocusFrame)
    elseif(unit == "targettarget") then
        handleFrame(TargetFrameToT)
    elseif(unit:match("boss%d?$")) then
        local id = unit:match("boss(%d)")
        if(id) then
            handleFrame("Boss"..id.."TargetFrame")
        else
            for i = 1, MAX_BOSS_FRAMES do
                handleFrame(string.format("Boss%dTargetFrame", i))
            end
        end
    elseif(unit:match("party%d?$")) then
        local id = unit:match("party(%d)")
        if(id) then
            handleFrame("PartyMemberFrame" .. id)
        else
            for i = 1, MAX_PARTY_MEMBERS do
                handleFrame(string.format("PartyMemberFrame%d", i))
            end
        end
    elseif(unit:match("arena%d?$")) then
        local id = unit:match("arena(%d)")
        if(id) then
            handleFrame("ArenaEnemyFrame"..id)
        else
            for i = 1, MAX_ARENA_ENEMIES do
                handleFrame(string.format("ArenaEnemyFrame%d", i))
            end
        end

        Arena_LoadUI = function() end
        SetCVar("showArenaEnemyFrames", "0", "SHOW_ARENA_ENEMY_FRAMES_TEXT")
    elseif(unit:match("nameplate%d+$")) then
        local frame = C_NamePlate.GetNamePlateForUnit(unit)
        if(frame and frame.UnitFrame) then
            handleFrame(frame.UnitFrame)
        end
    end
end


A.Units = Units