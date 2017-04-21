local A, L = unpack(select(2, ...))
local Units, units, oUF = {}, {}, A.oUF
 
function Units:Get(unit)
    return units[unit]
end
 
function Units:Add(object)
    units[object:GetName()] = object
end
 
function Units:UpdateElements(frame, db)
    if db then
        for name in next, oUF:GetRegisteredElements() do
            if db[name] then
                if db[name]["Enabled"] then
                    frame:EnableElement(name)
                    A["Elements"][name](frame, db[name])
                else
                    frame:DisableElement(name)
                end
            end
        end
        frame:UpdateAllElements()
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
    frame:RegisterForClicks("AnyUp")
    if db then
        for _,binding in next, db do
            frame:SetAttribute(binding.type, binding.action)
        end
    end
end

A.Units = Units