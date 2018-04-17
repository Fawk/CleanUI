local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local CreateFrame = CreateFrame

local Unit = {}

function Unit:Init()

end

function Unit:Update(...)
    local event, arg2, arg3, arg4, arg5 = ...
    
    if (event == UnitEvent.UPDATE_IDENTIFIER) then
        local previous = self.id
        self.id = arg2
        if (self.OnIdentifier) then
            self:OnIdentifier(previous)
        end
    elseif (event == UnitEvent.UPDATE_HEALTH) then

    elseif (event == UnitEvent.UPDATE_POWER) then

    elseif (event == UnitEvent.UPDATE_BUFFS)      = 3,
    UnitEvent.UPDATE_DEBUFF     = 4,
    UnitEvent.UPDATE_CLICKCAST  = 5,

    if (self.AfterUpdate) then
        self:AfterUpdate(...)
    end
end

function Unit:GetId()
    return self.id
end

