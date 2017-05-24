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

   	frame.overrideShow = true

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

    local position, size, bindings = db["Position"], db["Size"], db["Key Bindings"]

    Units:Position(frame, position)
    frame:SetSize(size["Width"], size["Height"])
    Units:UpdateElements(frame, db)

    --[[ Bindings ]]--
    frame:RegisterForClicks("AnyUp")
    frame:SetAttribute("*type1", "target")
    frame:SetAttribute("*type2", "togglemenu")

    Units:SetKeyBindings(frame, db["Key Bindings"])

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
	
	-- this displays how to use recursive functions to traverse an encounter
	local function traverse(id,off)
	  off=off or ""
	  while id do
		local nex,ch,_,li=select(6,EJ_GetSectionInfo(id))
		print(off..li)
		if ch then
		  traverse(ch,off.."  ")
		end
		id=nex
	  end
	end
	-- 198 is the encounterID for Ragnaros
	traverse((select(4,EJ_GetEncounterInfo(2037))))
	end

A.modules["player"] = Player