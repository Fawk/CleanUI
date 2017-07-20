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

function string.equals(self, ...)
   local match = false
   for _,value in next, { ... } do
      if type(value) ~= "string" and false or self == value then
         match = true
      end
   end
   return match
end

function T:tcount(tbl)
	local i = 0
	for k,v in pairs(tbl) do i=i+1 end
	return i
end

function T:frameName(...)
	local t = A:GetName()
	for _,n in pairs({...}) do
		t = t.."_"..n
	end
	return t
end

function T:HookSetPoint(frame, position, w, h)
	
	hooksecurefunc(frame, "SetPoint", function(self, lp, r, p, x, y)
		if lp ~= position["Local Point"] or p ~= position["Point"] or r ~= A.frameParent then
			self:ClearAllPoints()
			self:SetPoint(position["Local Point"], A.frameParent, position["Point"], position["Offset X"], position["Offset Y"])
			self:SetSize(w, h)
		end
	end)

	frame:ClearAllPoints()
	frame:SetParent(A.frameParent)
	frame:SetPoint(position["Local Point"], A.frameParent, position["Point"], position["Offset X"], position["Offset Y"])
end

function T:FadeIn(frame, seconds)
	local seconds = seconds or 1
	frame.timer = frame.timer or 0
    local f = CreateFrame("Frame")
    f:SetScript("OnUpdate", function(self, elapsed)
        frame.timer = frame.timer + elapsed
        if frame.timer > .01 then
            if frame:GetAlpha() >= 1 then
                self:SetScript("OnUpdate", nil)
            else
            	local alpha = frame:GetAlpha() + ((100 / ((seconds * 1000) * .01)) / 100)
            	if alpha > 1 then
            		alpha = 1
    			end
                frame:SetAlpha(alpha) 
            end
            frame.timer = 0
        end
    end)
end

function T:FadeOut(frame, seconds)
	local seconds = seconds or 1
	frame.timer = frame.timer or 0
    local f = CreateFrame("Frame")
    f:SetScript("OnUpdate", function(self, elapsed)
        frame.timer = frame.timer + elapsed
        if frame.timer > .01  then
            if frame:GetAlpha() <= 0 then
                self:SetScript("OnUpdate", nil)
            else
            	local alpha = frame:GetAlpha() - ((100 / ((seconds * 1000) * .01)) / 100)
            	if alpha < 0 then
            		alpha = 0
    			end
                frame:SetAlpha(alpha) 
            end
            frame.timer = 0
        end
    end)
end

function T:RunAfterCombat(func)
	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_REGEN_ENABLED")
	f:SetScript("OnEvent", function(self, event, ...)
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		func()
	end)
end

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

T.Desc = Desc
T.Table = Table
T.FontString = FontString
T.Controls = Controls
T.Backdrops = Backdrops
T.Textures = Textures
A.Tools = T