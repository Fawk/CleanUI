local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local CreateFrame = CreateFrame

local function Update(frame, previous, current, amount)

	local orientation, reversed, width, height = frame.Health:GetOrientation(), frame.Health:GetReverseFill(), frame.Health:GetWidth(), frame.Health:GetHeight()
	
	if amount == 0 then 
		current:Hide()
		return previous
	end
	
	current:ClearAllPoints()
	
	if orientation == "HORIZONTAL" then
		current:SetWidth(width)
		if reversed then
			current:SetPoint("TOPRIGHT", previous, "TOPLEFT")
			current:SetPoint("BOTTOMRIGHT", previous, "BOTTOMLEFT")
		else
			current:SetPoint("TOPLEFT", previous, "TOPRIGHT")
			current:SetPoint("BOTTOMLEFT", previous, "BOTTOMRIGHT")	
		end
	else
		current:SetHeight(height)
		if reversed then
			current:SetPoint("TOPLEFT", previous, "BOTTOMLEFT")
			current:SetPoint("TOPRIGHT", previous, "BOTTOMRIGHT")
		else
			current:SetPoint("BOTTOMLEFT", previous, "TOPLEFT")
			current:SetPoint("BOTTOMRIGHT", previous, "TOPRIGHT")		
		end
	end
	
	current:SetOrientation(orientation)
	current:SetReverseFill(reversed)
	
	return current:GetStatusBarTexture()
end

local function HealPredictionPostUpdate(self, unit, my, all, absorb, healAbsorb)
	local frame = self.parent or self.__owner
	local previous = frame.Health:GetStatusBarTexture()

	previous = Update(frame, previous, self.myBar, my)
	previous = Update(frame, previous, self.otherBar, all)
	previous = Update(frame, previous, self.absorbBar, absorb)
	previous = Update(frame, previous, self.healAbsorbBar, healAbsorb)
end

function HealPrediction(frame, db)

	local texture = media:Fetch("statusbar", db["Texture"] or "Default2")

	local healPrediction = frame.HealPrediction or (function()
		
		local healPrediction, my, all, absorb, healAbsorb = {}, CreateFrame("StatusBar", nil, frame), CreateFrame("StatusBar", nil, frame), CreateFrame("StatusBar", nil, frame), CreateFrame("StatusBar", nil, frame)
		
		my:SetStatusBarTexture(texture)
		my:SetStatusBarColor(unpack(A.colors.healPrediction.my))
		my:Hide()
		
		all:SetStatusBarTexture(texture)
		all:SetStatusBarColor(unpack(A.colors.healPrediction.all))
		all:Hide()
		
		absorb:SetStatusBarTexture(texture)
		absorb:SetStatusBarColor(unpack(A.colors.healPrediction.absorb))
		absorb:Hide()
		
		healAbsorb:SetStatusBarTexture(texture)
		healAbsorb:SetStatusBarColor(unpack(A.colors.healPrediction.healAbsorb))
		healAbsorb:Hide()
		
		if frame.Health then
			my:SetParent(frame.Health)
			all:SetParent(frame.Health)
			absorb:SetParent(frame.Health)
			healAbsorb:SetParent(frame.Health)
		end
		
		healPrediction.myBar = my
		healPrediction.otherBar = all
		healPrediction.absorbBar = absorb
		healPrediction.healAbsorbBar = healAbsorb
		healPrediction.PostUpdate = HealPredictionPostUpdate
		
		return healPrediction

	end)()
	
	healPrediction.maxOverflow = db["MaxOverflow"]
	healPrediction.frequentUpdates = db["FrequentUpdates"]
	
	healPrediction.myBar:SetStatusBarTexture(texture)
	healPrediction.otherBar:SetStatusBarTexture(texture)
	healPrediction.absorbBar:SetStatusBarTexture(texture)
	healPrediction.healAbsorbBar:SetStatusBarTexture(texture)
	
	frame.HealPrediction = healPrediction
end

A["Elements"]["HealPrediction"] = HealPrediction