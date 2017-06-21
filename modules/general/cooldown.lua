local A, L = unpack(select(2, ...))
local T, media = A.Tools, LibStub("LibSharedMedia-3.0")
local Cooldown = {}
local unpack = unpack
local select = select
local tostring = tostring
local tinsert = table.insert
local tremove = table.remove
local format = string.format
local CreateFrame = CreateFrame
local GetTime = GetTime
local timeStamps = { 0, 1, 10, 30, 60, 120, 300 }
local active = {}
local numSpells = 0
local tW = 32
local startOffset = 16
local barWidth = ( tW * #timeStamps ) + ( startOffset * 2 )
local buildText = A.TextBuilder
local blacklist = {
    [125439] = true -- Revive Battle Pets
}
local bar

local function GetNumSpells()
	local r = 0
	for i = 1, GetNumSpellTabs() do
		r = r + select(4, GetSpellTabInfo(i))
	end
	return r
end

local function Event()
	numSpells = GetNumSpells()
end

local function handleGroupCycles()
	local groups = {}
	for i = 1, #timeStamps do
		for spellId, icon in next, active do
			if icon.group == i then
				local groupId = math.ceil(i / 3)
				local group = groups[groupId]
				if not group then
					group = { icons = {} }
					groups[groupId] = group
				end
				tinsert(group.icons, icon)
			end
		end
	end

	for groupId, group in pairs(groups) do

		local playing = nil

		for i, icon in next, group.icons do
			icon.fadeIn:SetScript("OnFinished", function(self, called)
				icon.fadeOut:Play()
			end)
			icon.fadeOut:SetScript("OnFinished", function(self, called)
				icon:SetAlpha(0)
				local index, nextIcon = next(group.icons, i)
				if nextIcon then
					nextIcon.fadeIn:Play()
				else
					if #group.icons > 1 then
						group.icons[1].fadeIn:Play()
					else
						icon.fadeIn:Play()
					end
				end
			end)
			if icon.fadeIn:IsPlaying() or icon.fadeOut:IsPlaying() then
				playing = icon
			end
		end

		if not playing then
			group.icons[1].fadeIn:Play()
			playing = group.icons[1]
		end
	end
end

local interval = 0.03
local count = 0
local function Update(self, elapsed)

	count = count + elapsed

	if count >= interval then

		for x = 1, numSpells do

			local spellType, spellId = GetSpellBookItemInfo(x, "spell")
			local texture = select(3, GetSpellInfo(spellId))
			local start, duration = GetSpellCooldown(spellId)

            if start == 0 and active[spellId] and active[spellId]:GetAlpha() > 0 then
                active[spellId]:SetPoint("LEFT", bar, "LEFT", startOffset, 0)
				active[spellId].endGroup:Play()
				active[spellId].fadeIn:Stop()
				active[spellId].fadeOut:Stop()
				active[spellId] = nil
            end

			if start ~= 0 and duration ~= 0 and (duration > 1.5 or active[spellId]) and not blacklist[spellId] then

				if active[spellId] and duration < 1.5 and not active[spellId].durationFixed then
					local newDuration = active[spellId].current / 20
					if newDuration < 0.06 then
						newDuration = 0.06
					end
					duration = newDuration
					active[spellId].durationFixed = true
				end

				local icon = active[spellId]
				if not icon then
					
					icon = CreateFrame("Frame", nil, bar)
					icon:SetSize(tW, tW)
					icon.fadeIn = icon:CreateAnimationGroup()
					icon.fadeOut = icon:CreateAnimationGroup()
					icon.endGroup = icon:CreateAnimationGroup()
					icon.endGroup:SetScript("OnFinished", function(self, requested) 
						icon:SetAlpha(0)
						icon.hidden = true
					end)
					icon:SetSize(tW, tW)
					icon:SetScale(1, 1)
					icon:SetFrameLevel(1)
					icon:SetAlpha(0.5)

					local fadeOutA = icon.fadeOut:CreateAnimation("Alpha")
					fadeOutA:SetFromAlpha(0.5)
					fadeOutA:SetToAlpha(0)
					fadeOutA:SetDuration(0.5)
					fadeOutA:SetSmoothing("OUT")

					local fadeInA = icon.fadeIn:CreateAnimation("Alpha")
					fadeInA:SetFromAlpha(0)
					fadeInA:SetToAlpha(0.5)
					fadeInA:SetDuration(0.5)
					fadeInA:SetSmoothing("IN")

					local alpha = icon.endGroup:CreateAnimation("Alpha")
					alpha:SetFromAlpha(0.5)
					alpha:SetToAlpha(0)
					alpha:SetDuration(1)
					alpha:SetSmoothing("OUT")

					local scale = icon.endGroup:CreateAnimation("Scale")
					scale:SetScale(1.3, 1.3)
					scale:SetDuration(1)
					scale:SetSmoothing("OUT")

					icon.texture = icon:CreateTexture(nil, "OVERLAY")
					icon.texture:SetTexture(texture)
					icon.texture:SetAllPoints()
					icon.texture:SetTexCoord(0.133,0.867,0.133,0.867);

					active[spellId] = icon
				end

				if icon.endGroup:IsPlaying() then
					icon.endGroup:Stop()
				end

				local time = GetTime()
				local current = duration - time + start

				for i = 1, #timeStamps do

				    local stamp = timeStamps[i]
				    local next = timeStamps[i + 1] or timeStamps[#timeStamps]

				    if current >= stamp and current <= next then
				        local diff = next - stamp
				        local offset = startOffset + ( tW / 2 + ( tW * ( i - 1 ) ) )
				        local tdiff = ( ( current - stamp ) / diff )
				        local x = offset + ( tdiff * tW ) - ( tW / 2 )

			        	icon.current = current
			        	icon.group = i

				        if icon.hidden then
				        	icon.hidden = false
				        	icon:SetAlpha(0.5)
				        end

				        --if not icon.hidden and not icon.cycleGroup:IsPlaying() then
				        	--icon.cycleGroup:Play()
				        --end

			        	icon:SetPoint("LEFT", bar, "LEFT", x, 0)
			
						if current < .05 then
							current = 0
							icon:SetPoint("LEFT", bar, "LEFT", startOffset, 0)
							icon.endGroup:Play()
							icon.fadeIn:Stop()
							icon.fadeOut:Stop()
							active[spellId] = nil
						end 
				    end
				end

				handleGroupCycles()
			end
		end

		count = 0
	end
end

function Cooldown:Init()

	local db = A["Profile"]["Options"]["Cooldown bar"]
	local position = db["Position"]

	if not bar then
		bar = CreateFrame("Frame", nil, A.frameParent)
		bar:SetBackdrop({
			bgFile = media:Fetch("statusbar", "Default2"),
			tile = false,
		})
		bar:SetBackdropColor(unpack(A.colors.backdrop.light))
		bar:SetBackdropBorderColor(unpack(A.colors.border.target))
	end

	bar:SetSize(barWidth, tW + 5)
	bar:SetPoint(position["Local Point"], A.frameParent, position["Point"], position["Offset X"], position["Offset Y"])

	A:CreateMover(bar, db, "Cooldown bar")

	for i = 1, #timeStamps do
		local offset = startOffset + (tW * (i - 1))
		local text = buildText(bar, 11):outline():atLeft():againstLeft():x(offset):build()
		text:SetSize(tW, tW)
		text:SetTextColor(1, 1, 1)
		text:SetText(format("%s", timeStamps[i] > 60 and (timeStamps[i] / 60).."m" or timeStamps[i]))
		text:SetDrawLayer("OVERLAY", 1)
	end

	local eventFrame = CreateFrame("Frame", nil)
	eventFrame:SetScript("OnEvent", Event)

	eventFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	eventFrame:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
	eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	eventFrame:RegisterEvent("PLAYER_LOGIN")

	local updateFrame = CreateFrame("Frame", nil)
	updateFrame:SetScript("OnUpdate", Update)
end

A.modules["Cooldown"] = Cooldown