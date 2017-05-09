local A, L = unpack(select(2, ...))
local T, media = A.Tools, LibStub("LibSharedMedia-3.0")
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
local tW = 24
local startOffset = 16
local barWidth = ( tW * #timeStamps ) + ( startOffset * 2 )
local buildText = A.TextBuilder
local blacklist = {}

local bar = CreateFrame("Frame", nil, A.frameParent)
bar:SetSize(barWidth, tW + 5)
bar:SetPoint("CENTER")
bar:SetBackdrop(A.enum.backdrops.buttonroundborder)
bar:SetBackdropColor(unpack(A.colors.backdrop.light))
bar:SetBackdropBorderColor(unpack(A.colors.border.target))

for i = 1, #timeStamps do
	local offset = startOffset + (tW * (i - 1))
	local text = buildText(bar, 13):atLeft():againstLeft():x(offset):build()
	text:SetSize(tW, tW)
	text:SetTextColor(0.43, 0.43, 0.43)
	text:SetText(format("%s", timeStamps[i] > 60 and (timeStamps[i] / 60).."m" or timeStamps[i]))
end

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

local function getFirst(tbl)
	for i in next, tbl do return i end
end

local function cycleGroups()

	local groups = {}
	for spellId, icon in next, active do
		if icon.group ~= -1 then
			local group = groups[icon.group] or { current = spellId, icons = {} }
			group.icons[spellId] = icon
			tinsert(groups, group)
		end
	end

	for _,group in next, groups do

		local icon = group.icons[group.current]
		local nextId = next(group.icons, group.current)
		local nextIcon = group.icons[nextId]

		if not nextIcon then
			nextIcon = group.icons[getFirst(group.icons)]
		end

		if icon and nextIcon then
			local iconAlpha = icon:GetAlpha()
			local nextIconAlpha = nextIcon:GetAlpha()
			print(iconAlpha)
			
			if icon == nextIcon then
				if not icon.fadingOut then
					if iconAlpha < 1 then
						icon:SetAlpha(iconAlpha + 0.07)
					else
						icon.fadingOut = true
					end
				else
					if iconAlpha > 0 then
						icon:SetAlpha(iconAlpha - 0.07)
					else
						icon.fadingOut = false
					end
				end
			else
				if iconAlpha > 0 then
					icon:SetAlpha(iconAlpha - 0.07)
					nextIcon:SetAlpha(nextIconAlpha + 0.07)
				end

				if iconAlpha >= 1 then
					group.current = nextId
				end
			end
		end
	end
end

local function changeGroup(index, icon)
	icon.group = index
end

local interval = 0.05
local count = 0
local function Update(self, elapsed)

	count = count + elapsed

	if count >= interval then

		for x = 1, numSpells do

			local spellType, spellId = GetSpellBookItemInfo(x, "spell")
			local texture = select(3, GetSpellInfo(spellId))
			local start, duration = GetSpellCooldown(spellId)

			if start ~= 0 and duration ~= 0 and duration > 1.5 and not blacklist[spellId] then

				local icon = active[spellId]
				if not icon then
					
					icon = CreateFrame("Frame", nil, bar)
					icon:SetSize(tW, tW)
					icon.endGroup = icon:CreateAnimationGroup()
					icon.endGroup:SetScript("OnFinished", function(self, requested) 
						icon:SetAlpha(0) 
						icon.hidden = true 
					end)
					icon:SetSize(tW, tW)
					icon:SetScale(1, 1)

					local alpha = icon.endGroup:CreateAnimation("Alpha")
					alpha:SetFromAlpha(1)
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

				local time = GetTime()
				local current = duration - time + start

				for i = 1, #timeStamps do

				    local stamp = timeStamps[i]
				    local next = timeStamps[i + 1] or timeStamps[#timeStamps]
				    local group = (i - 1) <= 0 and 1 or i

				    if current >= stamp and current <= next then
				        local diff = next - stamp
				        local offset = startOffset + ( tW / 2 + ( tW * ( i - 1 ) ) )
				        local tdiff = ( ( current - stamp ) / diff )
				        local x = offset + ( tdiff * tW ) - ( tW / 2 )

				        if icon.hidden then
				        	icon.hidden = false
				        	icon:SetAlpha(1)
				        end

				        changeGroup(group, icon)
			        	icon:SetPoint("LEFT", bar, "LEFT", x, 0)
						
						if current < .05 then
							current = 0
							icon:SetPoint("LEFT", bar, "LEFT", startOffset, 0)
							icon.endGroup:Play()
							changeGroup(-1, icon)
						end 
				    end
				end
			end
		end

		cycleGroups()

		count = 0
	end
end

local eventFrame = CreateFrame("Frame", nil)
eventFrame:SetScript("OnEvent", Event)

eventFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
eventFrame:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_LOGIN")

local updateFrame = CreateFrame("Frame", nil)
updateFrame:SetScript("OnUpdate", Update)