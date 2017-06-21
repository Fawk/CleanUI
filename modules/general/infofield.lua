local A, L = unpack(select(2, ...))

local I = {}

local function createIcon(parent, anchor, name, size, texture, priority, condition, options)
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

	icon.priority = priority
	icon.condition = loadstring(condition)
	icon.options = options

	icon.timer = 0
	icon:SetScript("OnUpdate", function(self, elapsed)
		self.timer = self.timer + elapsed
		if self.timer > 0.03 then
			if self:condition() then
				self:Show()
			else
				self:Hide()
			end
			self.timer = 0
		end
	end)

	frame.groups[priority]:add(icon)
end

local exampleCondition = [[
	return function()
		local exists = false
		for i = 1, 40 do
			local name,_,_,_,_,duration,_,_,_,_,spellID = UnitAura("player", index, "HELPFUL")
			if name and duration and duration > 0 and 198068 == spellID then -- Power of the Dark Side
				exists = true
			end
		end
		return exists
	end
]]

function I:Init()

	local db = A["Profile"]["Options"]["Info Field"]

	local field = A["Info Field"]
	if not field then
		field = CreateFrame("Frame", nil, A.frameParent)

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

		field.groups = {}
		for i = 1, tonumber(db["Limit"]) do
			field.groups[i] = A:OrderedTable()
		end

		A["Info Field"] = field
	end



end

