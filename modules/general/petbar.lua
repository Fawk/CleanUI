local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local U = A.Utils
local CreateFrame = CreateFrame
local buildText = A.TextBuilder
local bindingMode = false
local capture = CreateFrame("Frame", "KeyBinder", A.frameParent)
local _G = _G
local GetPetActionInfo = GetPetActionInfo
local PetActionButton_StartFlash = PetActionButton_StartFlash
local PetActionButton_StopFlash = PetActionButton_StopFlash
local AutoCastShine_AutoCastStart = AutoCastShine_AutoCastStart
local AutoCastShine_AutoCastStop = AutoCastShine_AutoCastStop
local PetHasActionBar = PetHasActionBar
local HidePetActionBar = HidePetActionBar
local PetActionBar_ShowGrid = PetActionBar_ShowGrid
local PetActionBar_UpdateCooldowns = PetActionBar_UpdateCooldowns
local PetActionBar_Update = PetActionBar_Update

local PetBar = {}

local function UpdatePet(unit, event)
    if event == "UNIT_AURA" and unit ~= "pet" then return end

    if event == "PET_BAR_UPDATE_COOLDOWN" then
        PetActionBar_UpdateCooldowns();
        return
    end

    PetActionBar_Update()
end

function PetBar:Init()

    local bar = CreateFrame("Frame", T:frameName("PetBar"), A.frameParent, "SecureHandlerStateTemplate")

    local db = A["Profile"]["Options"]["Pet Bar"]
    local size = db["Icon Size"]
    local verticalLimit = db["Vertical Limit"]
    local horizontalLimit = db["Horizontal Limit"]
    local rows = 1

    for i=1, NUM_PET_ACTION_SLOTS, 1 do
        
        local buttonName = "PetActionButton" .. i;
        local button = _G[buttonName];
        local petActionIcon = _G[buttonName.."Icon"];
        local autoCastableTexture = _G[buttonName.."AutoCastable"];
        local autoCastShine = _G[buttonName.."Shine"];
        local cooldown = _G[buttonName.."Cooldown"];
        button:SetAttribute("showgrid", 1);
        button:ClearAllPoints()
        button:SetParent(bar)

        autoCastShine:SetSize(size, size)
        autoCastableTexture:SetSize(size * 2, size * 2)
        cooldown:SetSize(size, size)
        cooldown:ClearAllPoints()
        cooldown:SetPoint("CENTER")

        local text = cooldown:GetRegions()
        text:SetFont(media:Fetch("font", "Default"), 10, "OUTLINE")
        text:SetJustifyH("CENTER")
        text:SetTextColor(1, 1, 1)
        text:Show()

        if i <= verticalLimit or rows <= horizontalLimit then

            local shouldIncreaseRows = rows == 1 and i > verticalLimit or (i - verticalLimit) > verticalLimit
            if shouldIncreaseRows then
                rows = rows + 1
            end

            if rows <= horizontalLimit then

                if shouldIncreaseRows then
                    button:SetPoint("TOPLEFT",  _G["PetActionButton"..(rows == 1 and 1 or i - verticalLimit)], "BOTTOMLEFT", 0, -1)          
                else
                    button:SetPoint(i == 1 and "TOPLEFT" or "LEFT", _G["PetActionButton"..(i - 1)] or bar, i == 1 and "TOPLEFT" or "RIGHT", i == 1 and 0 or 1, 0)
                end

                button.HotKey:SetWidth(size)
                button.HotKey:SetFont(media:Fetch("font", "NotoBold"), 10, "OUTLINE")
                button.HotKey:SetTextColor(1, 1, 1)
                hooksecurefunc(button.HotKey, "SetTextColor", function(self, r, g, b)
                    if r ~= 1 or g ~= 1 or b ~= 1 then
                        self:SetTextColor(1, 1, 1)
                    end
                end)
                button.HotKey:ClearAllPoints()
                button.HotKey:SetPoint("TOPRIGHT", button, "TOPRIGHT", -1, -3)
                hooksecurefunc(button.HotKey, "SetText", function(self, text)
                    local newText = text:gsub("-", "")
                    for key, new in pairs((keys or {})) do
                        if text:find(key) then
                            newText = newText:gsub(key, new)
                            self.shouldModify = true
                        end
                    end
                    if self.shouldModify then
                        self.shouldModify = false
                        self:SetFont(media:Fetch("font", "NotoBold"), 10, "OUTLINE")
                        self:SetText(newText)
                    end
                    self:Show()
                end)

                button.Count:SetFont(media:Fetch("font", "NotoBold"), 10, "OUTLINE")
                button.Name:SetFont(media:Fetch("font", "NotoBold"), 9, "OUTLINE")
                button.Name:SetJustifyH("CENTER")
                button.Name:ClearAllPoints()
                button.Name:SetPoint("BOTTOM", button, "BOTTOM", 1, 3)

                _G[buttonName.."NormalTexture2"]:SetTexture(nil)

                hooksecurefunc(button, "SetNormalTexture", function(button, t)
                    if t ~= nil then button:SetNormalTexture(nil) end
                end)

                button:SetSize(size, size)
                button.icon:SetTexCoord(0.133,0.867,0.133,0.867)

                U:CreateBackground(button, db, false)
                button.emptySlot = button.emptySlot or button:CreateTexture(nil, "BACKGROUND")
                button.emptySlot:SetBlendMode("ADD")
                button.emptySlot:SetPoint("CENTER")
                button.emptySlot:SetSize(size + 16, size + 16)
                button.emptySlot:SetTexture([[Interface\BUTTONS\UI-EmptySlot-Disabled]])
                button.emptySlot:SetDrawLayer("BACKGROUND", 1)
                button.emptySlot:SetVertexColor(1, 1, 1, 0.3)

                local captureFrame = CreateFrame("Frame", nil, button)
                captureFrame:SetFrameLevel(1)
                captureFrame:SetAllPoints()
                captureFrame:SetScript("OnEnter", function(self, userMoved)
                    if bindingMode then
                        capture.button = button
                        capture:SetAllPoints(button)
                        capture:Show()
                    end
                end)

                button.captureFrame = captureFrame
            end
        end
    end

    PetActionBarFrame.showgrid = 1;
    PetActionBar_ShowGrid();
    --bar:HookScript('OnEnter', 'Bar_OnEnter');
    --bar:HookScript('OnLeave', 'Bar_OnLeave');

    bar:RegisterEvent('SPELLS_CHANGED');
    bar:RegisterEvent('PLAYER_CONTROL_GAINED');
    bar:RegisterEvent('PLAYER_ENTERING_WORLD');
    bar:RegisterEvent('PLAYER_CONTROL_LOST');
    bar:RegisterEvent('PET_BAR_UPDATE');
    bar:RegisterEvent('UNIT_PET');
    bar:RegisterEvent('UNIT_FLAGS');
    bar:RegisterEvent('UNIT_AURA');
    bar:RegisterEvent('PLAYER_FARSIGHT_FOCUS_CHANGED');
    bar:RegisterEvent('PET_BAR_UPDATE_COOLDOWN');

    bar:SetScript("OnEvent", UpdatePet)

    bar:SetSize(size * verticalLimit + (verticalLimit - 1), size * horizontalLimit + (horizontalLimit - 1))
    bar.getMoverSize = function(self)
        return self:GetSize()
    end

    RegisterStateDriver(bar, "visibility", "[@pet,exists] show; hide")
    
    local position = db["Position"]
    local x, y = position["Offset X"], position["Offset Y"]

    bar:SetPoint(position["Local Point"], A.frameParent, position["Point"], x, y)

    bar.db = db

    A:CreateMover(bar, db, "PetBar")
end

A.general.petbar = PetBar