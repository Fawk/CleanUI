local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local CreateFrame = CreateFrame

local function RaidBuffs(frame, db)
	
	local buffs = frame.RaidBuffs or { numLimit = nil, Tracked = {} }
	buffs.numLimit = db["Limit"]

	for spellId, obj in next, buffs["Tracked"] do	
		if not db["Tracked"][spellId] then
			buffs["Tracked"][spellId]:Hide()
			table.remove(buffs["Tracked"], spellId)
		end
	end

	for spellId, obj in next, db["Tracked"] do
		if not buffs["Tracked"][spellId] then
			
			local position = obj["Position"]

			local buff = CreateFrame("Frame", nil, frame)
			buff:SetPoint(position["Local Point"], frame, position["Point"], position["Offset X"], position["Offset Y"])

			local cd = CreateFrame("Cooldown", "$parentCooldown", buff, "CooldownFrameTemplate")
			cd:SetAllPoints(buff)

			local icon = buff:CreateTexture(nil, "BORDER")
			icon:SetAllPoints(buff)

			local count = buff:CreateFontString(nil, "OVERLAY")
			count:SetFontObject(NumberFontNormal)
			count:SetPoint("BOTTOMRIGHT", buff, "BOTTOMRIGHT", -1, 0)

			buff.trackOnlyPlayer = obj["Own Only"]
			buff.icon = icon
			buff.count = count
			buff.cd = cd

			buff:Hide()
		
			buffs["Tracked"][spellId] = buff
		end
	end

	frame.RaidBuffs = buffs
end

A["Elements"]["RaidBuffs"] = RaidBuffs