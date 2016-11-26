local Units, elements, units = {}, {}, {}
 
function Units:GetFrame(unit)
    return units[unit]
end
 
function Units:AddFrame(object)
    units[object:GetName()] = object
end
 
function Units:UpdateElements(frame, db)
    for name in next, oUF:GetRegisteredElements() do
        if db[name] and db[name]["Enabled"] then
            frame:EnableElement(name)
            elements[name](frame, db[name])
        else
            frame:DisableElement(name)
        end
    end
    frame:UpdateAllElements()
end
 
function Units:Translate(frame, relative)
    if units[relative] then
        return units[relative]
    elseif elements[relative] then
        return frame[relative]
    elseif elements[frame:GetName()] then
        A:Debug("Could not find relative frame '", relative, "' for element '", frame:GetName() or "Unknown", "', using parent.")
        return frame:GetParent()
    else
        A:Debug("Could not find relative frame '", relative, "' for frame '", frame:GetName() or "Unknown", "' using Frameparent.")
        return A["Frameparent"]
    end
end
 
function Units:Position(frame, db)
    frame:ClearAllPoints()
    frame:SetPoint(db["Local Point"], self:Translate(frame, db["Relative To"]), db["Point"], db["Offset X"], db["Offset Y"])
end
 
function Units:SetKeyBindings(frame, db)
    frame:RegisterForClicks("AnyUp")
    for binding in next, db do
        frame:SetAttribute(binding.type, binding.action)
    end
end

A.Units = Units