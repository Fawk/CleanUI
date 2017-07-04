local A, L = unpack(select(2, ...))
local LBG = LibStub("LibButtonGlow-1.0")
local I = {}
local builtText = A.TextBuilder

local function createAlphaAnimation(ag, from, to, duration, onFinished)
	local a = ag:CreateAnimation("Alpha")
	a:SetFromAlpha(from)
	a:SetToAlpha(to)
	a:SetDuration(duration)
	a:SetScript("OnFinished", onFinished)
end

local functions = {
	activeBuffWithStackAndCountdown = function(spellId) 
		return ([[
			return function(icon)
				local exists = false
				for i = 1, 40 do
					local name,_,_,count,_,duration,_,_,_,_,spellID = UnitAura("player", index, "HELPFUL")
					if name and duration and duration > 0 and %d == spellID then
						exists = true
						if icon.countdown then
							icon.countdown:SetText(duration)
						end
						if icon.stack and count and count > 0 then
							icon:evaluteStacks(count, duration)
							icon.stack:SetText(count)
						end
					end
				end
				return exists
			end
		]]):format(spellId)
	end,
	cooldownWithCountdown = function(spellId)
		return ([[
			return function(icon)
				print(icon) -- Does this print out icon?
				local start, duration = GetSpellCooldown(%d)
				if start > 0 and duration > 0 then
					local time = GetTime()
					local current = duration - time + start
					if current > 0.05 then
						if icon.countdown then
							icon.countdown:SetText(duration)
						end
						return true
					end
				end
				return false
			end
		]]):format(spellId)
	end,
	trackCharges = function(spellId)
		return ([[
			return function(icon)
				local charges, maxCharges, start, duration = GetSpellCharges(%d)
				if charges and maxCharges > 1 then
					icon.stack:SetText(charges)
				end
			end
		]]):format(spellId)
	end,
}

local presets = {
	glow = function(icon)
		LBG.ShowOverlayGlow(icon)
	end,
	fadeIn = function(icon)
		local ag = icon:CreateAnimationGroup()
		local a = createAlphaAnimation(ag, 0, 1, 0.5, function(self, called)
			icon:SetAlpha(1) 
		end)
		a:SetSmoothing("IN")
		icon.fadeIn = ag
		icon.oldShow = icon.Show
		icon.Show = function(self)
			local alpha = self:GetAlpha()
			if alpha >= 1 then return end
			if self.ag:IsPlaying() then return end
			self.ag:Play()
		end
	end,
	fadeOut = function(icon)
		local ag = icon:CreateAnimationGroup()
		local a = createAlphaAnimation(ag, 1, 0, 0.5, function(self, called)
			icon:SetAlpha(0)
		end)
		a:SetSmoothing("OUT")
		icon.fadeOut = ag
		icon.oldHide = icon.Hide
		icon.Hide = function(self)
			local alpha = self:GetAlpha()
			if alpha <= 0 then return end
			if self.ag:IsPlaying() then return end
			self.ag:Play()
		end
	end,
	blink = function(icon)
		local ag = icon:CreateAnimationGroup()
		local aIn = createAlphaAnimation(ag, 0, 1, 0.5, nil)
		local aOut = createAlphaAnimation(ag, 1, 0, 0.5, nil)
		aOut:SetOrder(1)
		aIn:SetOrder(2)
		ag:SetLooping("REPEAT")
		icon.blink = ag
		ag:Play()
	end
end
}

local function evaluateOptions(icon)
	local o = icon.options
	for _,effect in next, o do
		if presets[effect] then
			presets[effect](icon)
		end
	end
end

local function createIcon(parent, name, size, texture, priority, condition, options)
	local icon = CreateFrame("Frame", A:GetName().."_InfoField_"..name, parent)
	icon:SetSize(size - 1, size - 1)
	icon:SetBackdrop({
	    bgFile = media:Fetch("statusbar", "Default"),
        tile = true,
        tileSize = 1,
        insets = {
            top = -1,
            bottom = -1,
            left = -1,
            right = -1
        }
    })
    icon:SetBackdropColor(0, 0, 0)
	icon.texture = icon:CreateTexture(nil, "OVERLAY")
	icon.texture:SetTexture(texture)
	icon.texture:SetTexCoord(0.133,0.867,0.133,0.867)

	icon.countdown = buildText(icon, 12):outline():alignAll():build()
	icon.stack = buildText(icon, 10):outline():atBottomRight():x(-3):y(3):build()

	icon.priority = priority
	icon.condition = assert(loadstring(condition))()
	icon.options = options

	evaluateOptions(icon)

	icon.timer = 0
	icon:SetScript("OnUpdate", function(self, elapsed)
		self.timer = self.timer + elapsed
		if self.timer > 0.03 then
			if self:condition(self) then
				if self.preShow then
					self:preShow()
				end
				self:Show()
				if self.postShow then
					self:postShow()
				end
			else
				if self.preHide then
					self:preHide()
				end
				self:Hide()
			end
			self.timer = 0
		end
	end)

	frame.groups[priority]:add(icon)
end

local function alreadyCreated(groups, id)
	for groupId, group in next, groups do
		for i = 1, group:size() do
			if group:get(i).id == id then
				return true
			end
		end
	end
	return false
end

local function Update(field, db)

	if not db["Enabled"] then
		field:Hide()
		field:SetScript("OnUpdate", nil)
		collectgarbage(field)
		A["Field"] = nil
		return
	end

	local w, h = nil, nil
	if db["Orientation"] == "HORIZONTAL" then
		w = db["Size"] * db["Limit"]
		h = db["Size"]
	else
		w = db["Size"]
		h = db["Size"] * db["Limit"]
	end
	field:SetSize(w, h)

	local position = db["Position"]
	field:SetPoint(position["Local Point"], A.frameParent, position["Point"], position["Offset X"], position["Offset Y"])

	for _,preset in next, db["Presets"] do
		if not alreadyCreated(preset.id) then
			local name,_,texture = GetSpellInfo(preset.spellId)
			local icon = createIcon(field, name, preset.size, texture, preset.priority, preset.condition, preset.options)
			field.groups[preset.priority]:add(icon)
		end
	end

	local anchor = field
	for groupdId, group in next, field.groups do
		for i = 1, group:size() do
			local icon = group:get(i)
			if db["Orientation"] == "HORIZONTAL" then
				if db["Direction"] == "Right" then
					icon:SetPoint("LEFT", anchor, anchor == field and "LEFT" or "RIGHT", 0, 0)
				else
					icon:SetPoint("RIGHT", anchor, anchor == field and "RIGHT" or "LEFT", 0, 0)
				end
			else
				if db["Direction"] == "Upwards" then
					icon:SetPoint("BOTTOM", anchor, anchor == field and "BOTTOM" or "TOP", 0, 0)
				else
					icon:SetPoint("TOP", anchor, anchor == field and "TOP" or "BOTTOM", 0, 0)
				end
			end
			anchor =  icon
		end
	end

end

function I:Init()

	local db = A["Profile"]["Options"]["Info Field"]
	if not db["Enabled"] then return end

	local field = A["Info Field"]
	if not field then
		field = CreateFrame("Frame", nil, A.frameParent)

		field.groups = {}
		for i = 1, tonumber(db["Limit"]) do
			field.groups[i] = A:OrderedTable()
		end

		field.timer = 0
		field:SetScript("OnUpdate", function(self, elapsed)
			self.timer = self.timer + elapsed
			if self.timer > 0.03 then
				Update(self, db)
				self.timer = 0
			end
		end)

		A["Info Field"] = field
	end

end

