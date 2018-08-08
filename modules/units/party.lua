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
    local db = A.db.profile.group[frameName:lower()]
    return Group:Init(frameName, 5, db)
end

function Party:Update(...)
    local container = Units:Get(frameName)
    container:UpdateUnits()
end

function Party:Simulate(players)
    if (UnitExists("party1")) then
        -- Present notification here saying that you cannot simulate party frames while in a party
        return
    end

    if (A.groupSimulating) then
        fakeUnits:foreach(function(unit)
            unit:Hide()
        end)

        fakeUnits:clear()
    end

    local container = Units:Get(frameName)

    fakeUnits:foreach(function(unit)
        unit:Hide()
    end)

    fakeUnits = A:OrderedTable()
    local db = container.db

    -- The player
    local player = CreateFrame("Button", T:frameName(frameName, "FakeUnitButton1"), container, 'SecureUnitButtonTemplate')
    player.unit = "player"
    player.db = db
    player.orderedElements = A:OrderedMap()
    player.Update = function(self, ...)
        Group:Update(self, UnitEvent.UPDATE_DB, container, "SIMULATE")
    end
    player:SetAttribute("unit", player.unit)
    player:SetSize(db.size.width, db.size.height)

    if (db.orientation == "HORIZONTAL") then
        if (db.growth == "Right") then
            player:SetPoint("LEFT", container, "LEFT", 0, 0)
        elseif (db.growth == "Left") then
            player:SetPoint("RIGHT", container, "RIGHT", 0, 0)
        end
    else
        if (db.growth == "Upwards") then
            player:SetPoint("BOTTOM", container, "BOTTOM", 0, 0)
        elseif (db.growth == "Downwards") then
            player:SetPoint("TOP", container, "TOP", 0, 0)
        end
    end

    local randomClass = CLASS_SORT_ORDER[math.random(1, 12)]
    A["Shared Elements"]:foreach(function(key, element)
        if (element.Simulate and db[key]) then
            element:Simulate(player, randomClass)
        end
    end)

    player:Update()
    Group:SimulateTags(player)

    fakeUnits:add(player)

    local relative = player
    for i = 2, players do 
        -- Create fake unit buttons
        local uf = CreateFrame("Button", T:frameName(frameName, "FakeUnitButton"..i), container, 'SecureUnitButtonTemplate')
        uf.db = db
        uf.orderedElements = A:OrderedMap()
        uf.Update = function(self, ...)
            Group:Update(self, UnitEvent.UPDATE_DB, container, self.unit, "SIMULATE")
        end
        uf.unit = "player"
        uf:SetAttribute("unit", uf.unit)
        uf:SetSize(size.width, size.height)

        if (db.orientation == "HORIZONTAL") then
            if (db.growth == "Right") then
                uf:SetPoint("LEFT", relative, "RIGHT", db.x, db.y)
            elseif (db.growth == "Left") then
                uf:SetPoint("RIGHT", relative, "LEFT", db.x, db.y)
            end
        else
            if (db.growth == "Upwards") then
                uf:SetPoint("BOTTOM", relative, "TOP", db.x, db.y)
            elseif (db.growth == "Downwards") then
                uf:SetPoint("TOP", relative, "BOTTOM", db.x, db.y)
            end
        end

        randomClass = CLASS_SORT_ORDER[math.random(1, 12)]
        A["Shared Elements"]:foreach(function(key, element)
            if (element.Simulate and db[key]) then
                element:Simulate(uf, randomClass)
            end
        end)

        uf:Update()
        Group:SimulateTags(uf)

        fakeUnits:add(uf)

        relative = uf
    end

    RegisterStateDriver(container, "visibility", "show")
end

A.modules:set("party", Party)