local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local Group = A.Group

local Raid = {}
local frameName = "Raid"

local Raid = {}

function Raid:Init()
    local db = A.db.profile.group[frameName:lower()]
    Units:DisableBlizzardRaid()
    return Group:Init(frameName, 40, db)
end

function Raid:Update(...)
    local container = Units:Get(frameName)
    container:UpdateUnits()
end

function Raid:Simulate(players)

end

A.modules.raid = Raid