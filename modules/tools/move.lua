local A, L = unpack(select(2, ...))
local T, media = A.Tools, LibStub("LibSharedMedia-3.0")
local unpack = unpack
local select = select
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local moveableFrames = {}
local finishFrame
local grid

local function FinalizeMove()
	for name, moveFrame in next, moveableFrames do
		moveFrame:Hide()
		moveFrame:Apply()
	end
	finishFrame:Hide()
	grid:Hide()
    A.dbProvider:Save()
	A.isMovingFrames = false
end

function A:UpdateMoveableFrames()
	for name, moveFrame in next, moveableFrames do
		local db = moveFrame.affecting.db
		if (db) then
			local p = db["Position"]

			moveFrame:ClearAllPoints()
			moveFrame.affecting:ClearAllPoints()
			moveFrame.affecting:SetPoint(p["Local Point"], A.frameParent, p["Point"], p["Offset X"], p["Offset Y"])
		end
	end
end

function A:InitMove()

	if InCombatLockdown() then return end

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

	if not grid then
		grid = CreateFrame("Frame", T:frameName("MoveGrid"), A.frameParent)
		grid:SetPoint("CENTER")
		grid:SetSize(A.frameParent:GetSize())
		grid:SetFrameStrata("HIGH")
		grid:SetFrameLevel(100)
		grid.vertical = grid:CreateTexture(nil, "OVERLAY")
		grid.vertical:SetSize(1, grid:GetHeight())
		grid.vertical:SetTexture(1,1,1,1)
		grid.vertical:SetPoint("CENTER")
		grid.horizontal = grid:CreateTexture(nil, "OVERLAY")
		grid.horizontal:SetSize(grid:GetWidth(), 1)
		grid.horizontal:SetTexture(1,1,1,1)
		grid.horizontal:SetPoint("CENTER")
	end

	finishFrame:Show()
	grid:Show()

	for name, moveFrame in next, moveableFrames do
		
		moveFrame:Show()
        moveFrame:ClearAllPoints()

        local lp, r, p, x, y = moveFrame.affecting:GetPoint()

        moveFrame:SetPoint(lp, A.frameParent, p, x, y)
		moveFrame.affecting:ClearAllPoints()
		moveFrame.affecting:SetPoint("TOPLEFT", moveFrame, "TOPLEFT", 0, 0)

	end
end

function A:CreateMover(frame, db, overrideName)
	local name = overrideName or frame:GetName()
	local position, size = db["Position"], db["Size"]
	local lockedTexture = media:Fetch("texture", "locked")
	local unLockedTexture = media:Fetch("texture", "unlocked")

    if type(size) == "number" then
        size = {
            ["Width"] = size, 
            ["Height"] = size
        }
    end

	if frame.getMoverSize then
		local w, h = frame:getMoverSize()
		size = {
			["Width"] = w,
			["Height"] = h
		}
	end

	if not size then
		size = { Width = frame:GetWidth(), Height = frame:GetHeight() }
	end

	local moveFrame = CreateFrame("Button", A:GetName().."_"..name.."_Mover", A.frameParent)
	moveFrame.affecting = frame
	moveFrame:SetBackdrop(A.enum.backdrops.editboxborder)
	moveFrame:SetBackdropColor(unpack(A.colors.moving.backdrop))
	moveFrame:SetBackdropBorderColor(unpack(A.colors.moving.border))
	moveFrame:SetSize(size["Width"], size["Height"])
	moveFrame:SetFrameLevel(8)

    local lp, r, p, x, y = frame:GetPoint(1)
    if lp ~= nil then
    	moveFrame:SetPoint(lp, A.frameParent, p, x, y)
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

        local position = T:TranslatePosition(self.affecting, lp, A.frameParent, p, x, y, db["Position"]["Anchor"])
        --A:Debug(name, position["Local Point"], position["Point"], position["Offset X"], position["Offset Y"])
        db["Position"] = position
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

function A:DeleteMover(name)
	if (moveableFrames[name]) then
		table.remove(moveableFrames, name)
	end
end

SLASH_CLEANUI1 = '/cui'
function SlashCmdList.CLEANUI(msg, editbox)
    local command, arg1, arg2, arg3, arg4, arg5 = T:getWords(msg)
	
    if command == "bind" then
		A["modules"]["Actionbars"]:BindingMode()
	end

    if command == "move" then
       A:InitMove() 
    end
    
    if command == "finish" then
       FinalizeMove() 
    end

    if command == "copyProfile" then
        A["modules"]["Profile"]:Copy(arg1)
    end

    if command == "renameProfile" then
        A["modules"]["Profile"]:Rename(arg1, arg2)
    end

    if command == "changeProfile" then
        A["modules"]["Profile"]:Change(arg1)
    end

    if command == "simulateParty" then
    	A["modules"].party:Simulate(arg1 or 5)
    end

    if command == "simulateRaid" then
    	A["modules"].raid:Simulate(arg1 or 40)
    end

    if command == "db" then
    	local f = A["Profile"]["Options"][arg1]
    	if (f) then
    		if (arg2) then
    			f = f[arg2]
	    		if (f and arg3) then
	    			f = f[arg3]
	    		end
    		end
    	end
    	A:DebugTable(f)
    end

    if command == "printProfile" then
    	local p = A.modules["Profile"]
    	if arg1 then
    		print(arg1, A.db["Profiles"][arg1])
    	else
    		print(p:GetActive(), A["Profile"])
    	end
    end
end

