local A, L = unpack(select(2, ...))
local LBG = LibStub("LibButtonGlow-1.0")
local I = {}
local buildText = A.TextBuilder
local media = LibStub("LibSharedMedia-3.0")

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
					local name,_,_,count,_,duration,expires,_,_,_,spellID = UnitAura("player", i, "HELPFUL")
					if name and duration and duration > 0 and %d == spellID then
						exists = true
						if icon.countdown then
							icon.countdown:SetText(math.floor(expires - GetTime()))
						end
						if icon.stack and count and count > 1 then
							--icon:evaluteStacks(count, duration)
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
				local s = %d
				local start, duration = GetSpellCooldown(s)
				if start > 0 and duration > 1.5 and (IsSpellKnown(s) or IsSpellKnown(s, true)) then
					local time = GetTime()
					local current = duration - time + start
					if current > 0.05 then
						if icon.countdown then
							icon.countdown:SetText(math.floor(current + 0.5))
						end
						return true
					end
				end
				return false
			end
		]]):format(spellId)
	end,
	trackSpellCount = function(spellId)
		return ([[
			return function(icon)
				local s = %d
				local numCasts = GetSpellCount(GetSpellInfo(s))
				if numCasts and numCasts > 0 then
					icon.stack:SetText(numCasts)
					return true
				end
				return false
			end
		]]):format(spellId)
	end,
	trackSpellCountAndSetTimer = function(spellId, timer)
		return ([[
			return function(icon)
				local s, t = %d, %d
				local numCasts = GetSpellCount(GetSpellInfo(s))
				icon.combat = InCombatLockdown()
				if numCasts and numCasts > 0 then
					if icon.combat then
						icon.combatTimer = GetTime() + t -- Fix this, should be combatTimer set after going out of combat and then reset upon entering combat again
					end
					icon.countdown:SetText(not icon.combat and (math.floor(icon.combatTimer - GetTime())) or "")
					icon.stack:SetText(numCasts)
					return true
				end
				return false
			end
		]]):format(spellId, timer)
	end
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
}

local function evaluateOptions(icon)
	local o = icon.options
	for _,effect in next, o do
		if presets[effect] then
			presets[effect](icon)
		end
	end
end

local function createIcon(parent, id, spellId, timer, size, priority, condition, options)
	local name,_,texture = GetSpellInfo(spellId)

	local icon = CreateFrame("Frame", A:GetName().."_InfoField_"..name, parent)
	icon.id = id
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
	icon.texture:SetPoint("CENTER")
	icon.texture:SetSize(size - 1, size - 1)

	icon.countdown = buildText(icon, 11):outline():atCenter():x(1):build()
	icon.stack = buildText(icon, 10):outline():atBottomRight():x(-3):y(3):build()

	icon.priority = priority

	local predefined
	string.gsub(condition, "func:%w+", function(a) 
		predefined = string.sub(a, 6)
	end)

	if predefined then
		icon.condition = assert(loadstring(functions[predefined](spellId, timer)))()
	else
		icon.condition = assert(loadstring(condition))()
	end
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
				self:SetAlpha(1)
				if self.postShow then
					self:postShow()
				end
			else
				if self.preHide then
					self:preHide()
				end
				self:SetAlpha(0)
			end
			self.timer = 0
		end
	end)

	return icon
end

local function alreadyCreated(groups, id)
	for groupId, group in next, groups do
		for i = 1, group:count() do
			local icon = group:get(i)
			if icon and icon.id == id then
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
		if not alreadyCreated(field.groups, preset.id) then
			local icon = createIcon(field, preset.id, preset.spellId, preset.timer or 0, preset.size, preset.priority, preset.condition, preset.options)
			field.groups[preset.priority]:add(icon)
		end
	end

	local anchor = field
	for groupId, group in next, field.groups do
		for i = 1, group:count() do
			local icon = group:get(i)
			if icon and icon:GetAlpha() > 0 then
				if db["Orientation"] == "HORIZONTAL" then
					if db["Direction"] == "Right" then
						icon:SetPoint("LEFT", anchor, anchor == field and "LEFT" or "RIGHT", anchor == field and 0 or 3, 0)
					else
						icon:SetPoint("RIGHT", anchor, anchor == field and "RIGHT" or "LEFT",  anchor == field and 0 or -3, 0)
					end
				else
					if db["Direction"] == "Upwards" then
						icon:SetPoint("BOTTOM", anchor, anchor == field and "BOTTOM" or "TOP", 0, anchor == field and 0 or 3)
					else
						icon:SetPoint("TOP", anchor, anchor == field and "TOP" or "BOTTOM", 0, 0, anchor == field and 0 or -3)
					end
				end
				anchor = icon
			end
		end
	end

end

function I:Init()

	local db = A["Profile"]["Options"]["Info Field"]
	if not db["Enabled"] then return end

	local field = A["Info Field"]
	if not field then
		field = CreateFrame("Frame", A:GetName().."_InfoField", A.frameParent)

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

	A:CreateMover(field, db, "Info Field")
end

A["modules"]["Info Field"] = I
