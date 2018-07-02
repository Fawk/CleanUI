local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF
local GetSpecializationInfo, GetSpecialization = GetSpecializationInfo, GetSpecialization
local InCombatLockdown = InCombatLockdown

local TargetTarget = {}
local frameName = "Target of Target"
 
function TargetTarget:Init()

	local db = A["Profile"]["Options"][frameName]

    Units:RegisterStyle(frameName, function(frame) 
        TargetTarget:Update(frame, db)
    end)

    local frame = Units:Get(frameName) or oUF:Spawn("targettarget", frameName)
    frame.db = db
    Units:Add(frame, frameName)

    A:CreateMover(frame, db)
end

function TargetTarget:Setup(frame, db)
	T:RunNowOrAfterCombat(function()
		self:Update(frame, db)
	end)
    return frame
end
 
function TargetTarget:Trigger()
	local frame = Units:Get(frameName)
	if frame then
		if frame.Buffs then frame.Buffs:ForceUpdate() end
		if frame.Debuffs then frame.Debuffs:ForceUpdate() end
	end
end

function TargetTarget:Update(frame, db)
	if not db or not db["Enabled"] then return end

    local position, size = db["Position"], db["Size"]

    Units:Position(frame, position)
    frame:SetSize(size["Width"], size["Height"])
    Units:UpdateElements(frame, db)

    --[[ Bindings ]]--
    frame:RegisterForClicks("AnyUp")
    frame:SetAttribute("*type1", "target")
    frame:SetAttribute("*type2", "togglemenu")

    Units:SetupClickcast(frame, db["Clickcast"])
	
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

    --[[ Tags ]]--
    if not frame["Tags"] then
        frame["Tags"] = {}
    end

    --[[ Name ]]--
    Units:Tag(frame, "Name", db["Tags"]["Name"])

    --[[ Custom ]]--
    for name, custom in next, db["Tags"]["Custom"] do
        Units:Tag(frame, name, custom)
    end
end

A.modules["Target of Target"] = TargetTarget