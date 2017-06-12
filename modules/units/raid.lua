local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local GetSpecializationInfo, GetSpecialization = GetSpecializationInfo, GetSpecialization
local InCombatLockdown = InCombatLockdown
local CreateFrame = CreateFrame
local GetNumGroupMembers = GetNumGroupMembers

local Raid = {}
local frameName = "Raid"

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
            uf:SetAlpha(0.3)
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

function Raid:Init()

	local db = A["Profile"]["Options"][frameName]
    local maxColumns, unitsPerColumn = 5, 1

    local size, point, anchorPoint = db["Size"], "LEFT", "TOP"

    if db["Orientation"] == "VERTICAL" then
        maxColumns = 5
        unitsPerColumn = 1
    else
        maxColumns = 1
        unitsPerColumn = 5
        point = "LEFT"
        anchorPoint = "TOP"
    end

    oUF:RegisterStyle(frameName, function(frame, unit, notHeader)
        Raid:Update(frame, db)
    end)
    oUF:SetActiveStyle(frameName)

    local raidHeader = oUF:SpawnHeader(
        A:GetName().."_"..frameName.."Header",
        nil,
        "raid",
        "showPlayer",         db["Show Player"],
        "showSolo",           false,
        "showParty",          false,
        "showRaid",           true,
        "yOffset",            db["Offset Y"],
        "xOffset",            db["Offset X"],
        'point', point,
        'maxColumns', 8,
        'unitsPerColumn', 5,
        'columnAnchorPoint', anchorPoint,
        "columnSpacing", db["Offset Y"],
        "groupBy", "ASSIGNEDROLE",
        "groupingOrder", "TANK,HEALER,DAMAGER",
        "sortMethod", "NAME",
        "oUF-initialConfigFunction", ([[
          self:SetWidth(%d)
          self:SetHeight(%d)
        ]]):format(size["Width"], size["Height"])
    )

    local raidContainer = Units:Get(frameName)
    if not raidContainer then
        
        raidContainer = CreateFrame("Frame", A:GetName().."_"..frameName.."Container", A.frameParent)
        
        raidContainer.UpdateSize = function(self, db) 
            local numGroupMembers = GetNumGroupMembers()
            local x, y = db["Offset X"], db["Offset Y"]
            local w = size["Width"] * 5 + (x * 4)
            local h = size["Height"] * 8 + (y * 7)
            if InCombatLockdown() then
                T:RunAfterCombat(function() 
                    raidContainer:SetSize(w, h)
                end)
            else
                self:SetSize(w, h)
            end
        end

        raidContainer.UpdateUnits = function(self)
            for i = 1, 40 do
                local uf = raidHeader:GetAttribute("child"..i)
                if not uf then break end
                uf:RegisterForClicks("AnyUp")
                uf.unit = uf:GetAttribute("unit")
                Raid:Update(uf, db)
            end
        end

        raidContainer:RegisterEvent("GROUP_ROSTER_UPDATE")
        raidContainer:RegisterEvent("UNIT_EXITED_VEHICLE")
        raidContainer:SetScript("OnEvent", function(self, event) 
            Units:DisableBlizzardRaid()
            self:UpdateSize(db)
            self:UpdateUnits()
        end)
    
        raidContainer:UpdateUnits()
    
        raidContainer.timer = 0
        raidContainer:SetScript("OnUpdate", function(self, elapsed)
            self.timer = self.timer + elapsed
            if self.timer > 0.10 then
                for i = 1, 40 do
                    local uf = raidHeader:GetAttribute("child"..i)
                    if uf and uf.unit then
                        Visibility(uf)
                        Units:UpdateImportantElements(uf, db)
                    end
                end
                self.timer = 0
            end
        end)

        Units:Add(raidContainer, frameName)
    end

    Units:Position(raidContainer, db["Position"])
    raidContainer:UpdateSize(db)
    A:CreateMover(raidContainer, db, "Raid")

    raidHeader:SetParent(raidContainer)
    raidHeader:SetAllPoints()
end
 
function Raid:Update(frame, db)
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

        --[[ Background ]]--
    local background = frame.Background or CreateFrame("Frame", nil, frame)
    if db["Background"] and db["Background"]["Enabled"] then
        local offset = db["Background"]["Offset"]
        background:SetBackdrop({
            bgFile = media:Fetch("statusbar", "Default"),
            tile = true,
            tileSize = 16,
            insets = {
                top = offset["Top"],
                bottom = offset["Bottom"],
                left = offset["Left"],
                right = offset["Right"],
            }
        })
        background:SetBackdropColor(unpack(db["Background"]["Color"]))
        background:SetPoint("CENTER", frame, "CENTER", 0, 0)
        background:SetSize(frame:GetSize())
        background:SetFrameStrata("LOW")
        background:SetFrameLevel(1)
        background:Show()
    else
        background:Hide()
    end

    local ignored = {
        [80354] = true,     -- Temporal Displacement
        [57723] = true,     -- Exhaustion
        [57724] = true,     -- Sated
        [160455] = true,    -- Fatigued
        [97821] = true,     -- Void-Touched
        [123981] = true,    -- Perdition
        [113942] = true,    -- Demonic Gateway
        [233375] = true     -- Gaze of Aman'Thul
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
                                if dtype then
                                    debuffs[dtype] = true
                                end
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

A.modules["raid"] = Raid
