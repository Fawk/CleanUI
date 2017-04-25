local A, L = unpack(select(2, ...))
local T, media = A.Tools, LibStub("LibSharedMedia-3.0")
local unpack = unpack
local select = select
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local moveableFrames = {}
local finishFrame

local function FinalizeMove()
	A.isMovingFrames = false
	for name, moveFrame in next, moveableFrames do
		moveFrame:Hide()
		moveFrame:Apply()
		moveFrame.affecting:Show()
	end
	finishFrame:Hide()
end

function A:InitMove()

	A.isMovingFrames = true

	if not finishFrame then
		finishFrame = CreateFrame("Frame", nil, A.frameParent)
		finishFrame:SetSize(200, 150)
		finishFrame:SetPoint("TOP", A.frameParent, "TOP", 0, -200)
		finishFrame:SetBackdrop(A.enum.backdrops.editboxborder)
		finishFrame:SetBackdropColor(unpack(A.color.moving.backdrop))
		finishFrame:SetBackdropBorderColor(unpack(A.colors.moving.border))
		
		finishFrame.timer = 0
		finishFrame:SetScript("OnUpdate", function(self, elapsed)
			self.timer = self.timer + elapsed
			if self.timer > 0.10 then
				if InCombatLockdown() and A.isMovingFrames then
					FinalizeMove()
				end
				self.timer = 0
			end
		end)

		local text = finishFrame:CreateFontString(nil, "OVERLAY")
		text:SetPoint("CENTER")
		text:SetFont(media:Fetch("font", "Noto"), 14, "NONE")
		text:SetText(L["Moving frames..."])

		local button = CreateFrame("Button", nil, finishFrame)
		button:SetPoint("TOP", text, "BOTTOM", 0, -20)
		button:SetSize(50, 25)
		button:SetText(L["Done moving"])
		button:SetScript("OnClick", function(self, button, down)
			FinalizeMove()
		end)
	end

	for name, moveFrame in next, moveableFrames do
		moveFrame:Show()
		moveFrame.affecting:Hide()
	end
end

function A:CreateMover(frame, db, overrideName)
	local name = overrideName or frame:GetName()
	local position, size = db["Position"], db["Size"]
	local lockedTexture = media:Fetch("texture", "locked")
	local unLockedTexture = media:Fetch("texture", "unlocked")

	local moveFrame = CreateFrame("Button", name.."_Mover", A.frameParent)
	moveFrame.affecting = frame
	moveFrame:SetBackdrop(A.enum.backdrops.editboxborder)
	moveFrame:SetBackdropColor(unpack(A.color.moving.backdrop))
	moveFrame:SetBackdropBorderColor(unpack(A.colors.moving.border))
	moveFrame:SetSize(size["Width"], size["Height"])
	moveFrame:SetPoint(position["Local Point"], select(2, frame:GetPoint()), position["Point"], position["Offset X"], position["Offset Y"])
	moveFrame:EnableMouse(true)
	moveFrame.moveAble = false
	moveFrame:SetMovable(moveFrame.moveAble)
	moveFrame:RegisterForDrag("LeftButton")
	moveFrame:SetScript("OnDragStart", moveFrame.StartMoving)
	moveFrame:SetScript("OnDragStop", moveFrame.StopMovingOrSizing)
	moveFrame.Apply = function(self)
		local point, relative, localPoint, x, y = self:GetPoint()
		self.affecting:SetPoint(point, A.frameParent, localPoint, x, y)
		db["Position"] = {
	        ["Point"] = point,
	        ["Local Point"] = localPoint,
	        ["Offset X"] = x,
	        ["Offset Y"] = y,
	        ["Relative To"] = "Parent"
		}
	end
	moveFrame:Hide()

	local text = moveFrame:CreateFontString(nil, "OVERLAY")
	text:SetFont(media:Fetch("font", "Noto"), 14, "NONE")
	text:SetPoint("CENTER")
	text:SetText(name)

	local lock = CreateFrame("Button", nil, moveFrame)
	lock:SetSize(24, 24)
	lock:SetPoint("TOPRIGHT", moveFrame, "TOPRIGHT", -3, -3)
	lock:SetScript("OnClick", function(self, button, down)
		if not down and button == "LeftButton" then
			moveFrame.moveAble = not moveFrame.moveAble
			moveFrame:SetMovable(moveFrame.moveAble)
			self.texture:SetTexture(moveFrame.moveAble and unLockedTexture or lockedTexture)
		end
	end)
	
	local texture = lock:CreateTexture(nil, "OVERLAY")
	texture:SetTexture(lockedTexture)
	texture:SetAllPoints()

	lock.texture = texture
	moveFrame.lock = lock
	moveFrame.text = text

	moveableFrames[name] = moveFrame
end

