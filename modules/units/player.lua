local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local GetSpecializationInfo, GetSpecialization = GetSpecializationInfo, GetSpecialization
local InCombatLockdown = InCombatLockdown

local Player = {}
local frameName = "Player"
 
function Player:Init()

	local db = A["Profile"]["Options"][frameName]

    oUF:RegisterStyle(frameName, function(frame, unit, notHeader)
        Player:Setup(frame, db)
    end)
    oUF:SetActiveStyle(frameName)

    local frame = Units:Get(frameName) or oUF:Spawn(frameName, frameName)
    Units:Add(frame)

    A:CreateMover(frame, db)
end
-- https://jsfiddle.net/859zu65s/
function Player:Setup(frame, db)
    self:Update(frame, db)
    return frame
end
 
function Player:Update(frame, db)
	if not db["Enabled"] then return end

	if InCombatLockdown() then
		T:RunAfterCombat(function()
			self.Update(frame, db)
		end)
		return
    end

    local position, size = db["Position"], db["Size"]

    Units:Position(frame, position)
    frame:SetSize(size["Width"], size["Height"])
    Units:UpdateElements(frame, db)

    --[[ Bindings ]]--
    frame:RegisterForClicks("AnyUp")
    frame:SetAttribute("*type1", "target")
    frame:SetAttribute("*type2", "togglemenu")

    Units:SetupClickcast(frame, db["Clickcast"])
    Units:SetupKeybindings(frame, db["Key Bindings"])
	
	--[[ Background ]]--
	local background = frame.Background or CreateFrame("Frame", nil, frame)
	if db["Background"] and db["Background"]["Enabled"] then
		local offset = db["Background"]["Offset"]
		background:SetBackdrop({
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
		background:SetBackdropColor(unpack(db["Background"]["Color"]))
		background:SetPoint("CENTER", frame, "CENTER", 0, 0)
		background:SetSize(frame:GetSize())
		background:SetFrameStrata("LOW")
		background:SetFrameLevel(1)
		background:Show()
	else
		background:Hide()
	end

	frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", function(self, ...) Units:UpdateElements(self, db) end)

    --[[ Tags ]]--
    if not frame["Tags"] then
        frame["Tags"] = {}
    end

    --[[ Name ]]--
    Units:Tag(frame, "Name", db["Tags"]["Name"], 5)

    --[[ Custom ]]--
    for name, custom in next, db["Tags"]["Custom"] do
        Units:Tag(frame, name, custom)
    end
end

A.modules["player"] = Player