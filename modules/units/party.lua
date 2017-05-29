local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local GetSpecializationInfo, GetSpecialization = GetSpecializationInfo, GetSpecialization
local InCombatLockdown = InCombatLockdown
local CreateFrame = CreateFrame
local GetNumGroupMembers = GetNumGroupMembers

local Party = {}
local frameName = "Party"

local function SetTagColor(frame, tag, color)
	if frame["Tags"][tag] then
		frame["Tags"][tag]:SetTextColor(unpack(color))
	end
end

local function Visibility(uf)
    local r, g, b
    if UnitIsDeadOrGhost(uf.unit) then
        r, g, b = unpack(A.colors.health.dead)
        if UnitIsDead(uf.unit) then
            SetTagColor(uf, "Name", A.colors.text.dead)
        else
            SetTagColor(uf, "Name", A.colors.text.ghost)
        end
    elseif not UnitIsConnected(uf.unit) then
        r, g, b = unpack(A.colors.health.disconnected)
        SetTagColor(uf, "Name", A.colors.text.disconnected)
    else
        SetTagColor(uf, "Name", A.colors.text.default)
    end
    
    if UnitName(uf.unit, true) == UnitName("player", true) then
        uf:SetAlpha(1)
    else
        local inRange, checkedRange = UnitInRange(uf.unit)
        if checkedRange and not inRange then
            uf:SetAlpha(0.5)
        else
            uf:SetAlpha(1) 
        end
    end
    
    if r then
        if uf.Health then
            uf.Health:SetStatusBarColor(r, g, b)
        end
    end
end
 
function Party:Init()

	local db = A["Profile"]["Options"][frameName]
    local maxColumns, unitsPerColumn = 5, 1

    local size, point, anchorPoint = db["Size"], "BOTTOM", "TOP"

    if db["Orientation"] == "VERTICAL" then
        maxColumns = 5
        unitsPerColumn = 1
    else
        maxColumns = 1
        unitsPerColumn = 5
        point = "LEFT"
        anchorPoint = "RIGHT"
    end

    oUF:RegisterStyle(frameName, function(frame, unit, notHeader)
        Party:Update(frame, db)
    end)
    oUF:SetActiveStyle(frameName)
-- https://jsfiddle.net/gb3ka3re/
    local partyHeader = oUF:SpawnHeader(
        A:GetName().."_"..frameName.."Header",
        nil,
        "party",
        "showPlayer",         db["Show Player"],
        "showSolo",           false,
        "showParty",          true,
        "point",              point,
        "yOffset",            db["Offset Y"],
        "xOffset",            db["Offset X"],
        "maxColumns",         maxColumns,
        "unitsPerColumn",     unitsPerColumn,
        "columnAnchorPoint",  anchorPoint,
        "groupBy", "ASSIGNEDROLE",
        "groupingOrder", "TANK,HEALER,DAMAGER",
        "oUF-initialConfigFunction", ([[
          self:SetWidth(%d)
          self:SetHeight(%d)
        ]]):format(size["Width"], size["Height"])
    )

    local partyContainer = Units:Get(frameName)
    if not partyContainer then
        
        partyContainer = CreateFrame("Frame", A:GetName().."_"..frameName.."Container", A.frameParent)
        
        partyContainer.UpdateSize = function(self, db) 
            local x, y = db["Offset X"], db["Offset Y"]
            local w, h = size["Width"] * 5 + (x * 4), size["Height"]
            if db["Orientation"] == "VERTICAL" then
                w = size["Width"]
                h = size["Height"] * 5 + (y * 4)
            end
            if InCombatLockdown() then
                T:RunAfterCombat(function() 
                    partyContainer:SetSize(w, h)
                end)
            else
                self:SetSize(w, h)
            end
        end

        partyContainer.UpdateUnits = function()
            for i = 1, 5 do
                local uf = partyHeader:GetAttribute("child"..i)
                if uf then
                    uf:RegisterForClicks("AnyUp")
                    uf.unit = uf:GetAttribute("unit")
                    Party:Update(uf, db)
                end
            end
        end

        partyContainer:RegisterEvent("GROUP_ROSTER_UPDATE")
        partyContainer:RegisterEvent("UNIT_EXITED_VEHICLE")
        partyContainer:SetScript("OnEvent", function(self, event) 
            Units:DisableBlizzardRaid()
            self:UpdateSize(db)
            self:UpdateUnits()
        end)
    
        partyContainer:UpdateUnits()
    
        partyContainer.timer = 0
        partyContainer:SetScript("OnUpdate", function(self, elapsed)
            self.timer = self.timer + elapsed
            if self.timer > 0.10 then
                for i = 1, 5 do
                    local uf = partyHeader:GetAttribute("child"..i)
                    if uf and uf.unit then
                        Visibility(uf)
						Units:UpdateImportantElements(uf, db)
                    end
                end
                self.timer = 0
            end
        end)

        Units:Add(partyContainer, frameName)
    end


    --local f = CreateFrame("Frame", A:GetName().."_Keybindings", A.frameParent)
    --f:SetSize(250, 500)
    --f:SetPoint("CENTER")
    --f:SetBackdrop(E.backdrops.buttonroundborder)
    --f:SetBackdropColor(unpack(A.colors.backdrop.default))
    --f:SetBackdropBorderColor(unpack(A.colors.border.target))

    --A.options["Keybindings"]:Init(f, "player", db["Key Bindings"])

    Units:Position(partyContainer, db["Position"])
    partyContainer:UpdateSize(db)
    A:CreateMover(partyContainer, db, "Party")

    partyHeader:SetParent(partyContainer)
    partyHeader:SetAllPoints()
    
    Units:DisableBlizzardRaid()
end
 
function Party:Update(frame, db)
    if not db["Enabled"] then return end

    local bindings = db["Key Bindings"]

    if InCombatLockdown() then
        T:RunAfterCombat(function() 
            Units:SetKeyBindings(frame, bindings)
        end)
    else
        Units:SetKeyBindings(frame, bindings)
    end
    Units:UpdateElements(frame, db)

    --[[ Tags ]]--
    if not frame["Tags"] then
        frame["Tags"] = {}
    end

    --[[ Name ]]--
    Units:Tag(frame, "Name", db["Tags"]["Name"])

    --[[ Custom ]]--
    for name, custom in next, db["Tags"]["Custom"] do
        Units:Tag(frame, name, custom)
    end

    Units:CreateStatusBorder(frame, "Targeted", {
        ["Enabled"] = db["Highlight Target"],
        ["FrameLevel"] = 5,
        ["Color"] = A.colors.border.target, 
        ["Condition"] = function(self, elapsed)
            self.timer = self.timer + elapsed
            if self.timer > 0.05 then
                if self and self.unit and UnitExists("target") and GetUnitName(self.unit, true) == GetUnitName("target", true) then
                    self:SetAlpha(1)
                else
                    self:SetAlpha(0)
                end
                self.timer = 0
            end
        end
    })

    local ignored = {
        [80354] = true,     -- Temporal Displacement
        [57723] = true,     -- Exhaustion
        [57724] = true,     -- Sated
        [160455] = true,    -- Fatigued
        [97821] = true,     -- Void-Touched
        [123981] = true,    -- Perdition
        [113942] = true,    -- Demonic Gateway
        [233375] = true,    -- Gaze of Aman'Thul
        [95809] = true      -- Insanity 
    }
    Units:CreateStatusBorder(frame, "Debuff", {
        ["Enabled"] = db["Show Debuff Border"],
        ["FrameLevel"] = 6,
        ["Condition"] = function(self, elapsed) 
            self.timer = self.timer + elapsed
            if self.timer > 0.05 then
                local debuffs, count = {}, 0
                for k,v in next, db["Debuff Order"] do
                    debuffs[v] = false
                    count = count + 1
                end
                for index = 1, 40 do
                    if self and self.unit then
                        name,_,_,_,dtype,duration,_,_,_,_,spellID = UnitAura(self.unit, index, "HARMFUL")
                        if name and not ignored[spellID] then
                            if(duration and duration > 0) then
                                debuffs[dtype or "Physical"] = true
                            end
                        end
                    end
                end

                local active = 0
                for i = count, 1, -1 do
                    local name = db["Debuff Order"][i]
                    if debuffs[name] then
                        self:SetBackdropBorderColor(unpack(A.colors.debuff[name]))
                        active = 1
                    end
                end

                self:SetAlpha(active)
                self.timer = 0
            end
        end
    })
end

A.modules["party"] = Party