local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")
local CC = A.modules.clickcast
local Group = A.Group

--[[ Blizzard ]]
local CreateFrame = CreateFrame
local UnitExists = UnitExists

-- [[ Locals ]]
local Party = {}
local frameName = "Party"
local fakeUnits = A:OrderedTable()

function Party:Init()
    local db = A["Profile"]["Options"][frameName]
    return Group:Init(frameName, 5, db)
end

function Party:Update(...)
    local container = Units:Get(frameName)
    container:UpdateUnits()
end

local powerType = {
    ["WARRIOR"] = "RAGE",
    ["DEATHKNIGHT"] = "RUNIC_POWER",
    ["DRUID"] = "MANA",
    ["MAGE"] = "MANA",
    ["WARLOCK"] = "MANA",
    ["PRIEST"] = "MANA",
    ["MONK"] = "ENERGY",
    ["ROGUE"] = "ENERGY",
    ["DEMONHUNTER"] = "FURY",
    ["HUNTER"] = "FOCUS",
    ["PALADIN"] = "MANA",
    ["SHAMAN"] = "MANA",
}

local function randomClass()
    local class = CLASS_SORT_ORDER[math.random(1, 12)]

    OldUnitClass = UnitClass
    UnitClass = function(u)
        return "", class, 0
    end
    OldUnitPowerType = UnitPowerType
    UnitPowerType = function(u)
        return powerType[class]
    end
end

local function resetClass()
    UnitClass = OldUnitClass
    UnitPowerType = OldUnitPowerType
end

function Party:Simulate(players)
    if (UnitExists("party1")) then
        -- Present notification here saying that you cannot simulate party frames while in a party
        return
    end

    local container = Units:Get(frameName)

    fakeUnits:foreach(function(unit)
        unit:Hide()
    end)

    fakeUnits = A:OrderedTable()
    local db = container.db
    local size = db["Size"]

    -- The player
    local player = CreateFrame("Button", T:frameName(frameName, "FakeUnitButton1"), container, 'SecureUnitButtonTemplate')
    player.unit = "player"
    player:SetAttribute("unit", player.unit)
    player:SetSize(size["Width"], size["Height"])

    if (db["Orientation"] == "HORIZONTAL") then
        if (db["Growth Direction"] == "Right") then
            player:SetPoint("LEFT", container, "LEFT", 0, 0)
        elseif (db["Growth Direction"] == "Left") then
            player:SetPoint("RIGHT", container, "RIGHT", 0, 0)
        end
    else
        if (db["Growth Direction"] == "Upwards") then
            player:SetPoint("BOTTOM", container, "BOTTOM", 0, 0)
        elseif (db["Growth Direction"] == "Downwards") then
            player:SetPoint("TOP", container, "TOP", 0, 0)
        end
    end

    self:Update(player, db)

    local powerType = UnitPowerType("player")
    local currentHealth, maxHealth = UnitHealth("player"), UnitHealthMax("player")
    local currentPower, maxPower = UnitPower("player", powerType), UnitPowerMax("player", powerType)
    
    local randomHealth = math.random(0, maxHealth)
    local randomPower = math.random(0, maxPower)

    player.Health:SetMinMaxValues(0, maxHealth)
    player.Power:SetMinMaxValues(0, maxPower)
    
    player.Health:SetValue(randomHealth)
    player.Power:SetValue(randomPower)

    player.Health:PostUpdate("player", randomHealth, maxHealth)
    player.Power:PostUpdate("player", randomPower, maxPower)

    local nameTag = db["Tags"]["Name"] 
    player.name = player:CreateFontString(nil, "OVERLAY")
    
    player.name:SetFont(media:Fetch("font", nameTag["Font"]), nameTag["Size"], nameTag["Outline"] == "SHADOW" and "NONE" or nameTag["Outline"])
    player.name:SetTextColor(unpack(nameTag["Color"]))

    if nameTag["Outline"] == "SHADOW" then
        player.name:SetShadowColor(0, 0, 0)
        player.name:SetShadowOffset(1, -1)
    end

    local text = nameTag["Text"]

    local tag = text:match("%b[]"):sub(2,-2)
    local tagFunc = oUF.Tags.Methods[tag]

    player.name:SetText(tagFunc("player"))

    Units:Position(player.name, nameTag["Position"])

    fakeUnits:add(player)

    local relative = player
    for i = 2, players do 
        -- Create fake unit buttons
        local uf = CreateFrame("Button", T:frameName(frameName, "FakeUnitButton"..i), container, 'SecureUnitButtonTemplate')
        
        uf.unit = "player"
        uf:SetAttribute("unit", uf.unit)
        uf:SetSize(size["Width"], size["Height"])

        if (db["Orientation"] == "HORIZONTAL") then
            if (db["Growth Direction"] == "Right") then
                uf:SetPoint("LEFT", relative, "RIGHT", db["Offset X"], db["Offset Y"])
            elseif (db["Growth Direction"] == "Left") then
                uf:SetPoint("RIGHT", relative, "LEFT", db["Offset X"], db["Offset Y"])
            end
        else
            if (db["Growth Direction"] == "Upwards") then
                uf:SetPoint("BOTTOM", relative, "TOP", db["Offset X"], db["Offset Y"])
            elseif (db["Growth Direction"] == "Downwards") then
                uf:SetPoint("TOP", relative, "BOTTOM", db["Offset X"], db["Offset Y"])
            end
        end

        self:Update(uf, db)

        uf.Health:SetMinMaxValues(0, maxHealth)
        uf.Power:SetMinMaxValues(0, maxPower)

        randomHealth = math.random(0, maxHealth)
        randomPower = math.random(0, maxPower)
        
        uf.Health:SetValue(randomHealth)
        uf.Power:SetValue(randomPower)

        -- Need to implement a Simulate for each element so that blizzard functions can be overridden
        randomClass()

        uf.Health:PostUpdate("player", randomHealth, maxHealth)
        uf.Power:PostUpdate("player", randomPower, maxPower)

        uf.name = uf:CreateFontString(nil, "OVERLAY")
    
        uf.name:SetFont(media:Fetch("font", nameTag["Font"]), nameTag["Size"], nameTag["Outline"] == "SHADOW" and "NONE" or nameTag["Outline"])
        uf.name:SetTextColor(unpack(nameTag["Color"]))

        if nameTag["Outline"] == "SHADOW" then
            uf.name:SetShadowColor(0, 0, 0)
            uf.name:SetShadowOffset(1, -1)
        end

        local OldUnitName = UnitName
        UnitName = function(u)
            return "Party"..i
        end

        local text = nameTag["Text"]

        local tag = text:match("%b[]"):sub(2,-2)
        local tagFunc = oUF.Tags.Methods[tag]

        uf.name:SetText(tagFunc("player"))

        Units:Position(uf.name, nameTag["Position"])

        UnitName = OldUnitName
        resetClass()

        fakeUnits:add(uf)

        relative = uf
    end

    RegisterStateDriver(container, "visibility", "show")
end

A.modules["party"] = Party