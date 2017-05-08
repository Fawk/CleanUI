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
local groups = {}

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
	groups[tostring(i)] = { children = {}, running = false }
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

local function cycleChildrenAlpha(group)
	if group.running then return end

	local first = getFirst(group.children)
	if not first then
		group.running = false
		return
	else
		first = active[first]
	end

	-- Start fading in one icon at a time in a loop
	group.running = true
	for spellId in next, group.children do
		local spell = active[spellId]
		spell:SetAlpha(0)
		spell.fadeIn:SetScript("OnFinished", function(self, requested)
			if not requested then
				local nextSpellId = next(group.children, spellId)
				if nextSpellId then
					active[nextSpellId].fadeIn:Play()
				else
					first.fadeIn:Play()
				end
				spell.fadeOut:Play()
			end
		end)
	end

	first.fadeIn:Play()
end

local function addToGroup(group, spellId)
	if not group.children[spellId] then
		group.children[spellId] = true
	end
end

local function removeFromGroup(group, spellId)
	for s in next, group.children do
		if s == spellId then
			tremove(group.children, s)
		end 
	end
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

			if start ~= 0 and duration ~= 0 and duration > 1.5 then

				local icon = active[spellId]
				if not icon then
					
					icon = CreateFrame("Frame", nil, bar)
					icon:SetSize(tW, tW)
					icon.endGroup = icon:CreateAnimationGroup()
					icon.cycleGroup = icon:CreateAnimationGroup()
					icon:SetAlpha(1)
					icon:SetSize(tW, tW)
					icon:SetScale(1, 1)

					local fadeIn = icon.cycleGroup:CreateAnimation("Alpha")
					local fadeOut = icon.cycleGroup:CreateAnimation("Alpha")

					fadeIn:SetDuration(0.5)
					fadeIn:SetChange(1)
					fadeIn:SetSmoothing("IN")

					fadeOut:SetDuration(0.5)
					fadeOut:SetChange(-1)
					fadeOut:SetSmoothing("OUT")

					icon.fadeIn = fadeIn
					icon.fadeOut = fadeOut

					local alpha = icon.endGroup:CreateAnimation("Alpha")
					alpha:SetChange(-1)
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
				    local group = groups[tostring(i)]

				    if current >= stamp and current <= next then
				        local diff = next - stamp
				        local offset = startOffset + ( tW / 2 + ( tW * ( i - 1 ) ) )
				        local tdiff = ( ( current - stamp ) / diff)
				        local x = offset + ( tdiff * tW ) - (tW / 2)

				        addToGroup(group, spellId)
			        	icon:SetPoint("LEFT", bar, "LEFT", x, 0)
			        	cycleChildrenAlpha(group)
						
						if current < .05 then
							icon:SetPoint("LEFT", bar, "LEFT", startOffset, 0)
							if icon.fadeIn:IsRunning() then
								icon.fadeIn:Finish()
							else
								icon.fadeOut:Finish()
								icon.fadeIn:Play()
								icon.fadeIn:Finish()
							end
							icon.endGroup:Play()
							removeFromGroup(group, spellId)
						end 
				    end
				end
			end
		end

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