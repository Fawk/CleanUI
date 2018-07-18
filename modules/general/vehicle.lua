local A, L = unpack(select(2, ...))
local V, T, U = { name = "Vehicle Leave Button" }, A.Tools, A.Utils
local buildText = A.TextBuilder
local media = LibStub("LibSharedMedia-3.0")

function V:Init()
    local db = A["Profile"]["Options"][self.name]
    local size = db["Size"]
    
    local vehicle = A.frames.vehicleLeaveButton or (function()
        local vehicle = CreateFrame("Button", T:frameName(self.name), A.frameParent, "SecureActionButtonTemplate")
        vehicle:SetAttribute("type1", "macro")
        vehicle:SetAttribute("macrotext1", '/run if UnitOnTaxi("player") then TaxiRequestEarlyLanding() else VehicleExit() end')
        vehicle:RegisterEvent("UNIT_ENTERED_VEHICLE")
        vehicle:RegisterEvent("UNIT_EXITED_VEHICLE")
        vehicle:RegisterEvent("TAXIMAP_CLOSED")
        vehicle:RegisterEvent("PLAYER_ENTERING_WORLD")
        vehicle:RegisterEvent("VEHICLE_UPDATE")
        vehicle:SetScript("OnEvent", function(self, event, ...)
            local unit = ...
            if unit and unit ~= "player" then return end;
            T:delayedCall(function()
                T:RunNowOrAfterCombat(function()
                    if UnitOnTaxi("player") or CanExitVehicle() then
                        self:Show()
                    elseif not UnitOnTaxi("player") or not CanExitVehicle() then
                        self:Hide()
                    end
                end)
            end, 0.2)
        end)

        vehicle.emptySlot = vehicle:CreateTexture(nil, "BACKGROUND")
        vehicle.emptySlot:SetBlendMode("ADD")
        vehicle.emptySlot:SetPoint("CENTER")
        vehicle.emptySlot:SetSize(size + 16, size + 16)
        vehicle.emptySlot:SetTexture([[Interface\BUTTONS\UI-EmptySlot-Disabled]])
        vehicle.emptySlot:SetDrawLayer("BACKGROUND", 1)
        vehicle.emptySlot:SetVertexColor(1, 1, 1, 0.3)

        vehicle.leaveButtonTexture = vehicle:CreateTexture(nil, "BACKGROUND")
        vehicle.leaveButtonTexture:SetBlendMode("ADD")
        vehicle.leaveButtonTexture:SetPoint("CENTER")
        vehicle.leaveButtonTexture:SetSize(size, size)
        vehicle.leaveButtonTexture:SetTexture(media:Fetch("widget", "cui-vehicle-leavebutton"))
        vehicle.leaveButtonTexture:SetDrawLayer("BACKGROUND", 2)

        return vehicle
    end)()

    local position = db["Position"]
    vehicle:SetSize(size, size)
    local x, y = position["Offset X"], position["Offset Y"]

    vehicle:SetPoint(position["Local Point"], A.frameParent, position["Point"], x, y)

    U:CreateBackground(vehicle, db, false)

    vehicle.db = db

    A:CreateMover(vehicle, db, self.name)

    if not UnitOnTaxi("player") and not CanExitVehicle() then
        vehicle:Hide()
    end

    A.frames.vehicleLeaveButton = vehicle
end

A.general.vehicle = V