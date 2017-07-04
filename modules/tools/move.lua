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

		if moveFrame.affecting.OldShow then
			moveFrame.affecting.Show = moveFrame.affecting.OldShow
		end
	end
	finishFrame:Hide()
    A.Database:Save()
end

function A:InitMove()

	A.isMovingFrames = true

	if not finishFrame then
		finishFrame = CreateFrame("Frame", nil, A.frameParent)
		finishFrame:SetSize(200, 150)
		finishFrame:SetPoint("TOP", A.frameParent, "TOP", 0, -200)
		finishFrame:SetBackdrop(A.enum.backdrops.editboxborder)
		finishFrame:SetBackdropColor(unpack(A.colors.moving.backdrop))
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
		text:SetFont(media:Fetch("font", "NotoBold"), 12, "NONE")
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
		moveFrame.affecting:SetParent(moveFrame.hiddenFrame)
		moveFrame.affecting:ClearAllPoints()
		moveFrame.affecting:SetPoint("TOPLEFT", moveFrame, "TOPLEFT", 0, 0)

		if moveFrame.affecting.overrideShow then
			moveFrame.affecting.OldShow = moveFrame.affecting.Show
			moveFrame.affecting.Show = moveFrame.affecting.Hide
		end

		moveFrame:SetSize(moveFrame.affecting:GetSize())
	end
end

function A:CreateMover(frame, db, overrideName)
	local name = overrideName or frame:GetName()
	local position, size = db["Position"], db["Size"]
	local lockedTexture = media:Fetch("texture", "locked")
	local unLockedTexture = media:Fetch("texture", "unlocked")

	if not size then
		if frame.getMoverSize then
			local w, h = frame:getMoverSize()
			size = {
				["Width"] = w,
				["Height"] = h
			}
		else
			size = { Width = frame:GetWidth(), Height = frame:GetHeight() }
		end
	end
    
    if type(size) == "number" then
        size = {
            ["Width"] = size, 
            ["Height"] = size
        }
    end

	local moveFrame = CreateFrame("Button", name.."_Mover", A.frameParent)
	moveFrame.affecting = frame
	moveFrame:SetBackdrop(A.enum.backdrops.editboxborder)
	moveFrame:SetBackdropColor(unpack(A.colors.moving.backdrop))
	moveFrame:SetBackdropBorderColor(unpack(A.colors.moving.border))
	moveFrame:SetSize(size["Width"], size["Height"])

	local hiddenFrame = CreateFrame("Frame", nil, moveFrame)
	hiddenFrame:SetSize(moveFrame:GetSize())
	hiddenFrame:SetPoint("TOPLEFT", moveFrame, "TOPLEFT", 0, 0)
	hiddenFrame:Hide()
	
	moveFrame.hiddenFrame = hiddenFrame

	for i = 1, 5 do
		if frame:GetPoint(i) then
			moveFrame:SetPoint(frame:GetPoint(i))
		end
	end

	moveFrame:EnableMouse(true)
	moveFrame.moveAble = true
	moveFrame:SetMovable(moveFrame.moveAble)
	moveFrame:RegisterForDrag("LeftButton")

    moveFrame:SetScript("OnMouseDown", function(self, button)
        if self.moveAble then
            self:StartMoving()
        end
    end)

    moveFrame:SetScript("OnMouseUp", function(self, button)
        if self.moveAble then
            self:StopMovingOrSizing()
        end   
    end)  

	moveFrame.Apply = function(self)
		local lp, relative, p, x, y = self:GetPoint()
		self.affecting:SetParent(A.frameParent)

        if A["Profile"]["Options"][name] then
            local position = {
                ["Point"] = p,
                ["Local Point"] = lp,
                ["Offset X"] = x,
                ["Offset Y"] = y,
                ["Relative To"] = "Parent"
            }
            local obj = {}
            for k,v in next, A["Profile"]["Options"][name] do
                obj[k] = v
            end
            obj["Position"] = position
			
			self.affecting:ClearAllPoints()
			self.affecting:SetAllPoints(self)
           
			A.Database:Prepare(name, obj)
        else
            A:Debug("Database entry for moveable frame: "..name.." does not exist, please add!")
        end
        
	end
	moveFrame:Hide()

	local text = moveFrame:CreateFontString(nil, "OVERLAY")
	text:SetFont(media:Fetch("font", "NotoBold"), 12, "NONE")
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

SLASH_CLEANUI1 = '/cui'
function SlashCmdList.CLEANUI(msg, editbox)
    if msg == "move" then
       A:InitMove() 
    end
    
    if msg == "finish" then
       FinalizeMove() 
    end
end

