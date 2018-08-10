local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")

local E = A.enum

local rand = math.rand

A:Debug("Loading tools")

local GetScreenHeight = GetScreenHeight
local GetScreenWidth = GetScreenWidth

local T = {}

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

function T:rand(...)
    local r = rand(1, select(#, ...))
    return select(r, ...)
end

function string.explode(self, sep)
   local t = {}
   local i = 1
   for str in string.gmatch(self, "([^"..sep.."]+)") do
      t[i] = str
      i = i + 1
   end
   return t
end

function string.escape(self)
   return (self:gsub('%%', '%%%%')
            :gsub('^%^', '%%^')
            :gsub('%$$', '%%$')
            :gsub('%(', '%%(')
            :gsub('%)', '%%)')
            :gsub('%.', '%%.')
            :gsub('%[', '%%[')
            :gsub('%]', '%%]')
            :gsub('%*', '%%*')
            :gsub('%+', '%%+')
            :gsub('%-', '%%-')
            :gsub('%?', '%%?'))
end

function string.trim(self)
    local from = self:match"^%s*()"
    return from > #self and "" or self:match(".*%S", from)
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

function string.anyMatch(self, ...)
	local match
	for _,value in next, { ... } do
		local m = self:match(value)
		if (m) then
			match = m
		end
	end
	return match
end

function T:anyOf(x, ...)
	for _,arg in next, { ... } do
		if (x == arg) then return true end
	end
	return false
end

function string.replace(self, t, r)
    local format = t:gsub("%[", "%%["):gsub("%]", "%%]")
    while (self:match(format)) do
        self = self:gsub(format, r)
    end
    return self
end

function string.fupper(self)
    return self:sub(1, 1):upper()..self:sub(2)
end

function T:unpackColor(color)
	return color.r, color.g, color.b, color.a
end

function T:tcount(tbl)
	local i = 0
	for k,v in pairs(tbl) do i=i+1 end
	return i
end

function T:contains(tbl, value)
	for k,v in next, tbl do
		if (v == value) then
			return true
		end
	end
	return false
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

function T:PositionClassPowerIcon(parent, icon, orientation, width, height, max, i, x, y)
	icon:ClearAllPoints()
    if (orientation == "HORIZONTAL") then
        if (i == 1) then
            icon:SetPoint("LEFT", parent, "LEFT", 0, 0)
        else
            icon:SetPoint("LEFT", parent.buttons[i-1], "RIGHT", x, 0)

            if (i == max and (((width * i) + x) < parent:GetWidth())) then
                width = width + (parent:GetWidth() - ((width * i) + (i - x)))
            end
        end
    else
        if (i == 1) then
            icon:SetPoint("TOP", parent, "TOP", 0, 0)
        else
            icon:SetPoint("TOP", parent.buttons[i-1], "BOTTOM", 0, -y)

            if (i == max and (((height * i) + y) < parent:GetWidth())) then
                height = height + (parent:GetWidth() - ((height * i) + (i - y)))
            end
        end
    end

    return width, height
end

function T:TranslatePosition(frame, lp, relative, p, x, y, anchor)
	local anchor = anchor or "TOPLEFT"
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
		localPoint = anchor,
		point = anchor,
		relative = "FrameParent",
		x = newX,
		y = newY
	}
end

function T:PlaceFrame(frame, align, parent, relative, x, y)
    if (align == "Right Of") then
        frame:SetPoint("LEFT", relative, parent == relative and "LEFT" or "RIGHT", x, 0)
    elseif (align == "Left Of") then
        frame:SetPoint("RIGHT", relative, parent == relative and "RIGHT" or "LEFT", -x, 0)
    elseif (align == "Above") then
        frame:SetPoint("BOTTOM", relative, parent == relative and "BOTTOM" or "TOP", 0, y)
    else
        frame:SetPoint("TOP", relative, parent == relative and "TOP" or "BOTTOM", 0, -y)
    end
end

function T:FadeIn(frame, seconds)
	local seconds = seconds or 1
	frame.timer = frame.timer or 0
    local f = CreateFrame("Frame")
    f:SetScript("OnUpdate", function(self, elapsed)
        frame.timer = frame.timer + elapsed
        if frame.timer > .01 then
            if frame:GetAlpha() >= 1 then
                f:SetScript("OnUpdate", nil)
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
    local f = CreateFrame("Frame")
    f.timer = 0
    local step = (1 - frame:GetAlpha()) / (GetFramerate() * seconds)
    f:SetScript("OnUpdate", function(self, elapsed)
    	self.timer = self.timer + elapsed
    	if (self.timer > step) then
	        if frame:GetAlpha() <= 0 then
	            f:SetScript("OnUpdate", nil)
	        else
	        	local alpha = frame:GetAlpha() - step
	        	if alpha < 0 then
	        		alpha = 0
				end
	            frame:SetAlpha(alpha) 
	        end
	        self.timer = 0
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
    f:SetScript("OnUpdate", function(self, elapsed)
        self.timer = (self.timer or 0) + elapsed
        if (self.timer >= delay) then
            func()
            f:SetScript("OnUpdate", nil)
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

function T:Scale(x)
	if (A.ratio) then
		return A.ratio * x
	else
		return x
	end
end

function T:short(value, decimals, hardSet)
    local decimals = decimals or 0
    if (value > 1e9) then
        return string.format("%."..decimals.."f", value/1e9).."B"
    elseif (value > 1e6) then
        return string.format("%."..decimals.."f", value/1e6).."M"
    elseif (value > 1e3) then
        return string.format("%."..decimals.."f", value/1e3).."K"
    else
    	decimals = hardSet and decimals or 0
        return string.format("%."..decimals.."f", value)
    end
end

function T:timeShort(value)
    local decimals = decimals or 0
    if (value > 3600) then
        return string.format("%.0f".."h", math.ceil(value / 3600))
    elseif (value > 120) then
        return string.format("%.0f".."m", math.ceil(value / 60))
    elseif (value > 60) then
    	return string.format("%d:%d", math.ceil(value / 60), value - 60)
    else
        return string.format("%.1f", value)	
    end
end

A.Tools = T