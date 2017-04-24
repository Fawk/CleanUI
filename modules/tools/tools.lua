local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")

A:Debug("Loading tools")

local T = {}
local P = { parent = T }
P.__index = P

local Table = {}
local FontString = {}
local Desc = {}
local Controls = {}
local Backdrops = {}
local Textures = {}

setmetatable(Table, P)
setmetatable(FontString, P)
setmetatable(Desc, P)
setmetatable(Controls, P)
setmetatable(Backdrops, P)
setmetatable(Textures, P)

function Table:shallowCopy(from, to)
    for k,v in pairs(from) do
        to[k] = v
    end
end
function Table:count(tbl)
	local i = 0
	for k,v in pairs(tbl) do i=i+1 end
	return i
end
function Table:first(tbl)
    for k,v in pairs(tbl) do return v end
end
function Table:last(tbl)
    local l
    for k,v in pairs(tbl) do l = v end
    return l
end
function Table:orderedWidgets(n, options)
	local opt = A:OrderedTable()
	for _,option in pairs(options) do
		opt:add({ option[1], option[2] })
	end
	return opt
end

function Table:merge(t1, t2)
    for k,v in pairs(t2) do
    	if type(v) == "table" then
    		if type(t1[k] or false) == "table" then
    			self:merge(t1[k] or {}, t2[k] or {})
    		else
    			t1[k] = v
    		end
    	else
    		if t1[k] ~= v then
    			t1[k] = v
    		end
    	end
    end
    return t1
end

function FontString:setByRegionNumAndGet(num, parent, lp, r, p, x, y)
	local count = 1
	local r
	for i = 1, parent:GetNumRegions() do
		local region = select(i, parent:GetRegions())
		if region:GetObjectType() == "FontString" then
			if num == 0 then
				r = region
			elseif num == count then
				region:SetPoint(lp, r or parent, p, x or 0, y or 0)
				return region
			end
			count = count + 1
		end
	end
	if num == 0 then
		r:SetPoint(lp, r or parent, p, x or 0, y or 0)
		return r
	end
	local region = select(count, parent:GetRegions())
	if not region then A:Debug("Could not find a FontString object on region: [", parent:GetName(), "]") return nil end
	region:SetPoint(lp, r or parent, p, x or 0, y or 0)
	return region
end
function FontString:setFirstInRegionAndGet(parent, lp, r, p, x, y)
	return self:setByRegionNumAndGet(1, parent, lp, r, p, x, y)
end   	
function FontString:setLastInRegionAndGet(parent, lp, r, p, x, y)
	return self:setByRegionNumAndGet(0, parent, lp, r, p, x, y)
end

function FontString:setColors(tbl, r, g, b, a)
	for _,fs in pairs(tbl) do
		fs:SetTextColor(r, g, b, a)
	end
end

function Controls:setEnabled(tbl, enabled)
	for _,control in pairs(tbl) do
		if enabled then
			control:Enable()
		else
			control:Disable()
		end
	end
end

function Backdrops:setColors(tbl, r, g, b, a, r2, g2, b2, a2)
	for _,frame in pairs(tbl) do
		frame:SetBackdropColor(r, g, b, a)
		frame:SetBackdropBorderColor(r2, g2, b2, a2)
	end
end

function Textures:setColors(tbl, r, g, b, a)
	for _,texture in pairs(tbl) do
		texture:SetVertexColor(r, g, b, a)
	end
end

function Desc:Set(regions, owner, title, desc, dependencies)
	for _,region in pairs(regions) do
		region:SetScript("OnEnter", function(self, motion)
			GameTooltip:SetOwner(owner)
			GameTooltip:AddLine(title, 1, 0.75, 0)
			GameTooltip:AddLine(desc, 1, 1, 1, true)
			GameTooltip:Show()
		end)

		region:SetScript("OnLeave", function(self, motion)
			GameTooltip:Hide()
		end)
	end
end

function Tools:Tag(frame, name, db)
	
	local tag = frame["Tags"][name] or frame:CreateFontString(nil, "OVERLAY")
    
    tag:SetFont(media:Fetch("font", db["Font"]), db["Size"], db["Outline"] == "Shadow" and "NONE" or db["Outline"])
    tag:ClearAllPoints()
    tag:SetAllPoints()
    tag:SetTextColor(unpack(db["Color"]))
    
    local position = db["Position"]
    if position["Local Point"] == "ALL" then
    	tag:SetAllPoints()
    else
    	tag:SetPoint(position["Local Point"], position["Relative To"], position["Point"], position["Offset X"], position["Offset Y"])
    end

    frame:Tag(tag, db["Text"])
    frame["Tags"][name] = tag
end

T.Desc = Desc
T.Table = Table
T.FontString = FontString
T.Controls = Controls
T.Backdrops = Backdrops
T.Textures = Textures
A.Tools = T