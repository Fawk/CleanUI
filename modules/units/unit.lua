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

    elseif (event == UnitEvent.UPDATE_BUFFS) then

    elseif (event == UnitEvent.UPDATE_DEBUFF) then
    
    elseif (event == UnitEvent.UPDATE_CLICKCAST) then
        if arg2 and self.id and self:CanChangeAttribute() then
            for _,binding in next, arg2 do
                local f, t = binding.action:gsub("@unit", "@mouseover")
                self:SetAttribute(binding.type, f)
            end
        end
        if (self.OnClickCast) then
            self:OnClickCast(arg2)
        end
    end

    if (self.AfterUpdate) then
        self:AfterUpdate(...)
    end
end

function Unit:GetId()
    return self.id
end

