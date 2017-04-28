local A, L = unpack(select(2, ...))
local Units, units, oUF = {}, {}, A.oUF
local media = LibStub("LibSharedMedia-3.0")

for key, obj in next, {
    ["3charname"] = {
        method = [[function(u, r)
            if not u and not r then return end
            if UnitExists(r or u) then
                return string.sub(UnitName(r or u), 1, 3)
            end
        end]],
        events = "UNIT_NAME_UPDATE GROUP_ROSTER_UPDATE"
    }
} do
    oUF["Tags"]["Methods"][key] = obj.method
    oUF["Tags"]["Events"][key] = obj.events
end

 
function Units:Get(unit)
    return units[unit]
end
 
function Units:Add(object, overrideName)
    A:Debug("Adding unit:", overrideName or object:GetName())
    units[overrideName or object:GetName()] = object
end
 
function Units:UpdateElements(frame, db)
    if db then
        for name, func in next, A["Elements"] do
            if db[name] then
                if db[name]["Enabled"] then
                    if frame.EnableElement then
                        frame:EnableElement(name)
                    end
                    func(frame, db[name])
                else
                    if frame.DisableElement then
                        frame:DisableElement(name)
                    end
                end
            end
        end
        if frame.UpdateAllElements then
            frame:UpdateAllElements()
        end
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
    elseif relative:equals(parent:GetName(), "Parent") then
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

function Units:Tag(frame, name, db)  
    local tag = frame["Tags"][name] or frame:CreateFontString(nil, "OVERLAY")
    
    tag:SetFont(media:Fetch("font", db["Font"]), db["Size"], db["Outline"] == "Shadow" and "NONE" or db["Outline"])
    tag:ClearAllPoints()
    tag:SetTextColor(unpack(db["Color"]))
    
    local position = db["Position"]
    if position["Local Point"] == "ALL" then
        tag:SetAllPoints()
    else
        tag:SetPoint(position["Local Point"], self:Translate(tag, position["Relative To"]), position["Point"], position["Offset X"], position["Offset Y"])
    end

    frame:Tag(tag, db["Text"])
    frame["Tags"][name] = tag

   if not db["Enabled"] then tag:Hide() end
end

function Units:CreateStatusBorder(frame, name, db)
    if not frame["StatusBorder"] then
        frame["StatusBorder"] = {}
    end

    local border = frame["StatusBorder"][name]
    if not border then
        border = CreateFrame("Frame", A:GetName().."_"..frame:GetName().."_"..name, frame)
        border:SetBackdrop(A.enum.backdrops.editboxborder2)
        border:SetBackdropColor(0, 0, 0, 0)
        border:SetBackdropBorderColor(0, 0, 0, 0)
        border.timer = 0
        frame["StatusBorder"][name] = border
    end

    if not db["Enabled"] then
        border:SetScript("OnUpdate", nil)
        border:Hide()
    else
        border.unit = frame.unit or frame:GetAttribute("unit")
        border:SetBackdropBorderColor(unpack(db["Color"] or { 0, 0, 0, 0 }))
        border:SetFrameStrata(db["Framestrata"] or "LOW")
        border:SetFrameLevel(db["FrameLevel"])
        border:SetAllPoints()
        border:SetScript("OnUpdate", db["Condition"])
        border:Show()
        border:SetAlpha(0)
    end
end

A.Units = Units