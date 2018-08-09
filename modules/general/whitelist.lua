local AddonName = ...
local A, L = unpack(select(2, ...))
local buildCheckbox = A.CheckBoxBuilder
local buildDropdown = A.DropdownBuilder
local buildEditbox = A.EditBoxBuilder
local buildButton = A.ButtonBuilder
local buildText = A.TextBuilder
local buildNumber = A.NumberBuilder

local media = LibStub("LibSharedMedia-3.0")

local E = A.enum
local T = A.Tools

local Whitelist = {}

-- Let's implement something here

function Whitelist:GetOptions(enabled, extraClick, order)

    local config = {
        enabled = enabled,
        canToggle = true,
        type = "group",
        order = order,
        placement = function(self)
            self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
        end,
        onClick = function(self)
            extraClick(self)
            --Whitelist:ToggleWhitelistWindow(self)
        end,
        children = {}
    }

    return config
end

A.general.whitelist = Whitelist