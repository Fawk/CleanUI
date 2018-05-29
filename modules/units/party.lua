local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local GetSpecializationInfo, GetSpecialization = GetSpecializationInfo, GetSpecialization
local InCombatLockdown = InCombatLockdown
local CreateFrame = CreateFrame
local GetNumGroupMembers = GetNumGroupMembers

local init = false

local Party = {}
local frameName = "Party"

Party.updateFuncs = A:OrderedTable()

local function SetTagColor(frame, tag, color)
	if frame["Tags"][tag] then
		frame["Tags"][tag].text:SetTextColor(unpack(color))
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

    local initString = [[
          self:SetWidth(%d);
          self:SetHeight(%d);
    ]]

    for _,binding in next, db["Clickcast"] do
        initString = initString..'\nself:SetAttribute("'..binding.type..'","'..binding.action..'");'
    end

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
        "oUF-initialConfigFunction", (initString):format(size["Width"], size["Height"])
    )

    local partyContainer = Units:Get(frameName) or CreateFrame("Frame", A:GetName().."_"..frameName.."Container", A.frameParent, "SecureHandlerBaseTemplate, SecureHandlerShowHideTemplate, SecureHandlerStateTemplate, SecureHandlerAttributeTemplate")
    partyContainer.db = db

    RegisterStateDriver(partyContainer, "visibility", "[@party1,exists] show; hide")

    partyContainer:Execute([[
        Holder = self
    ]])
    
    partyContainer:SetAttribute("UpdateSize", ([[
        local x, y, width, height = %d, %d, %d, %d
        local w, h = width * 5 + (x * 4), height
        if %s == "VERTICAL" then
            w = width
            h = height * 5 + (y * 4)
        end
        self:SetWidth(w)
        self:SetHeight(h)
    ]]):format(db["Offset X"], db["Offset Y"], size["Width"], size["Height"], db["Orientation"]))

    partyContainer.getMoverSize = function(self)
        if db["Orientation"] == "VERTICAL" then
            return size["Width"], (size["Height"] * 5 + (db["Offset Y"] * 4))
        else
            return (size["Width"] * 5 + (db["Offset X"] * 4)), size["Height"]
        end
    end

    partyContainer:SetAttribute("_onshow", partyContainer:GetAttribute("UpdateSize"))
    partyContainer:SetAttribute("_onhide", partyContainer:GetAttribute("UpdateSize"))

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
    partyContainer:RegisterEvent("PLAYER_LOGIN")
    partyContainer:SetScript("OnEvent", function(self, event) 
        Units:DisableBlizzardRaid()
        T:RunNowOrAfterCombat(function()
            self:Execute([[ Holder:RunAttribute("UpdateSize") ]])
        end)
        self:UpdateUnits()
    end)

    partyContainer:UpdateUnits()

    partyContainer.Update = function(self, elapsed)
        for i = 1, 5 do
            local uf = partyHeader:GetAttribute("child"..i)
            if uf and uf.unit then
                if not uf.init then
                    uf.init = true
                    uf:RegisterForClicks("AnyUp")
                    uf.unit = uf:GetAttribute("unit")
                    Party:Update(uf, db)
                end
                Visibility(uf)
				Units:UpdateImportantElements(uf, db)
            end
        end
    end

    self.updateFuncs:add(partyContainer.Update)

    Units:Add(partyContainer, frameName)

    Units:Position(partyContainer, db["Position"])
    partyContainer:Execute([[ Holder:RunAttribute("UpdateSize") ]])
    A:CreateMover(partyContainer, db, "Party")

    partyHeader:SetParent(partyContainer)
    partyHeader:SetAllPoints()
    
    Units:DisableBlizzardRaid()
end

function Party:Trigger(db)
    for i = 1, self.updateFuncs:count() do
        local updateFunc = self.updateFuncs:get(i)
        if updateFunc then updateFunc() end
    end
end
 
function Party:Update(frame, db)
    if not db["Enabled"] then return end

    T:RunNowOrAfterCombat(function() 
        Units:SetupClickcast(frame, db["Clickcast"])
    end)

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
            if self and self.unit and UnitExists("target") and GetUnitName(self.unit, true) == GetUnitName("target", true) then
                self:SetAlpha(1)
            else
                self:SetAlpha(0)
            end
        end
    })

    self.updateFuncs:add(frame["StatusBorder"]["Targeted"]["Condition"])

    --[[ Background ]]--
    U:CreateBackground(frame, db)

    local ignored = {
        [80354] = true,     -- Temporal Displacement
        [57723] = true,     -- Exhaustion
        [57724] = true,     -- Sated
        [160455] = true,    -- Fatigued
        [97821] = true,     -- Void-Touched
        [123981] = true,    -- Perdition
        [113942] = true,    -- Demonic Gateway
        [233375] = true,    -- Gaze of Aman'Thul
        [95809] = true,     -- Insanity
        [71041] = true      -- Dungeon Deserter
    }

    Units:CreateStatusBorder(frame, "Debuff", {
        ["Enabled"] = db["Show Debuff Border"],
        ["FrameLevel"] = 6,
        ["Condition"] = function(self, elapsed) 
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
        end
    })

    self.updateFuncs:add(frame["StatusBorder"]["Debuff"]["Condition"])
end

A.modules["party"] = Party