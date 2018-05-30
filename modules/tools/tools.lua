    local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")

A:Debug("Loading tools")

local GetScreenHeight = GetScreenHeight
local GetScreenWidth = GetScreenWidth

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

function T:getWords(input)
    local matches = {}
    for m in input:gmatch("[a-zA-Z0-9%(%)]+") do table.insert(matches, m) end
    return unpack(matches)
end

function T:rgbToHex(rgb)
    local hexadecimal = ''

    for key, value in pairs(rgb) do
        if value < 1 then value = value * 255 end
        local hex = ''

        while(value > 0)do
            local index = math.fmod(value, 16) + 1
            value = math.floor(value / 16)
            hex = string.sub('0123456789ABCDEF', index, index) .. hex           
        end

        if(string.len(hex) == 0)then
            hex = '00'

        elseif(string.len(hex) == 1)then
            hex = '0' .. hex
        end

        hexadecimal = hexadecimal .. hex
    end

    return hexadecimal
end

function T:split(s, delimiter)
  local result = { }
  local from  = 1
  local delim_from, delim_to = string.find( s, delimiter, from  )
  while delim_from do
    table.insert( result, string.sub( s, from , delim_from-1 ) )
    from  = delim_to + 1
    delim_from, delim_to = string.find( s, delimiter, from  )
  end
  table.insert( result, string.sub( s, from  ) )
  return result
end

function string.equals(self, ...)
   local match = false
   for _,value in next, { ... } do
      if type(value) ~= "string" and false or self == value then
         match = true
      end
   end
   return match
end

function string.replace(self, t, r)
   local format = t:gsub("%[", "%%["):gsub("%]", "%%]")
   return self:gsub(format, r)
end

function string.fupper(self)
    return self:sub(1, 1):upper()..self:sub(2)
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

function T:timeString(time)
	if time > 3600 then
		return string.format("%.0f%s", time/3600, "h")
	elseif time > 60 then
		return string.format("%.0f%s", time/60, "m")
	end
	return string.format("%.1f%s", time, "s")
end

T.reversedPoints = {
	["LEFT"] = "RIGHT",
	["RIGHT"] = "LEFT",
	["TOPLEFT"] = "TOPRIGHT",
	["TOPRIGHT"] = "TOPLEFT",
	["TOP"] = "BOTTOM",
	["BOTTOM"] = "TOP",
	["BOTTOMLEFT"] = "BOTTOMRIGHT",
	["BOTTOMRIGHT"] = "BOTTOMLEFT"
}

T.points = {
	["LEFT"] = "LEFT",
	["RIGHT"] = "RIGHT",
	["TOPLEFT"] = "TOPLEFT",
	["TOPRIGHT"] = "TOPRIGHT",
	["TOP"] = "TOP",
	["BOTTOM"] = "BOTTOM",
	["BOTTOMLEFT"] = "BOTTOMLEFT",
	["BOTTOMRIGHT"] = "BOTTOMRIGHT",
	["CENTER"] = "CENTER"
}

function T:Background(frame, db, anchor, isBackdrop)
	if db["Background"] and db["Background"]["Enabled"] then

		local target = isBackdrop and frame or (anchor.bg or (function() 
			local f = CreateFrame("Frame", nil, frame)
			f:SetFrameStrata("LOW")
			f:SetFrameLevel(2)
			f:SetPoint("CENTER", anchor or frame, "CENTER")
			local width, height = anchor:GetSize()
			if not width then
				width, height = frame:GetSize()
			end
			f:SetSize(width, height)
			anchor.bg = f
			return anchor.bg
		end)())

		local offset = db["Background"]["Offset"]
		if not target:GetBackdrop() then
			target:SetBackdrop({
				bgFile = media:Fetch("statusbar", "Default"),
				tile = true,
				tileSize = 16,
				insets = {
					top = offset["Top"],
					bottom = offset["Bottom"],
					left = offset["Left"],
					right = offset["Right"],
				}
			})
		end
		target:SetBackdropColor(unpack(db["Background"]["Color"]))
	else
		target:SetBackdrop(nil)
	end
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

function T:TranslatePosition(frame, lp, relative, p, x, y, anchor)
	local achor = anchor or "TOPLEFT"
	local top, left, bottom, right, newX, newY = frame:GetTop() or 0, frame:GetLeft() or 0, frame:GetBottom() or 0, frame:GetRight() or 0
	local screenWidth, screenHeight = GetScreenWidth(), GetScreenHeight()

	if anchor == "TOPLEFT" then
		newX = left
		newY = -(screenHeight - top)
	elseif anchor == "TOPRIGHT" then
		newX = -(screenWidth - right)
		newY = -(screenHeight - top)
	elseif anchor == "BOTTOMLEFT" then
		newX = left
		newY = -bottom
	elseif anchor == "BOTTOMRIGHT" then
		newX = -(screenWidth - right)
		newY = -bottom
	elseif anchor == "LEFT" then
		newX = left
		newY = 0
	elseif anchor == "RIGHT" then
		newX = -(screenWidth - right)
		newY = 0
	elseif anchor == "TOP" then
		newX = 0
		newY = -(screenHeight - top)
	elseif anchor == "BOTTOM" then
		newX = 0
		newY = -bottom
	elseif anchor == "CENTER" then
		newX = 0
		newY = 0
	else
		newX = left
		newY = -(screenHeight - top)
		anchor = "TOPLEFT"
	end

	frame:SetPoint(anchor, relative, anchor, newX, newY)

	return {
		["Local Point"] = anchor,
		["Point"] = anchor,
		["Relative To"] = "FrameParent",
		["Offset X"] = newX,
		["Offset Y"] = newY
	}
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

function T:RunNowOrAfterCombat(func)
	if not InCombatLockdown() then
		func()
	else
		local f = CreateFrame("Frame")
		f:RegisterEvent("PLAYER_REGEN_ENABLED")
		f:SetScript("OnEvent", function(self, event, ...)
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			func()
		end)
	end
end

function T:delayedCall(func, delay)
    local f = CreateFrame("Frame")
    f.timer = 0
    f:SetScript("OnUpdate", function(self, elapsed)
        self.timer = self.timer + elapsed
        if self.timer >= delay then
            func()
            self:SetScript("OnUpdate", nil)
            self:Hide()
        end
    end)
end

function T:Switch(m, ...)
	local t = {...}
	for i,v in next, t do
		if v == m then
			t[next(t, i)]()
			return
		end
	end
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