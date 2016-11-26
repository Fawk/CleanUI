local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")

A:Debug("Loading enums")

local enum = {
    colors = {
        backdrop = { 0.10, 0.10, 0.10, 1 },
        backdroplight = { 0.13, 0.13, 0.13, 1 },
        backdropborder = { 0.33, 0.33, 0.33, 1 }
    },
    regions = {
        T = "TOP",
        L = "LEFT",
        R = "RIGHT",
        B = "BOTTOM",
        BL = "BOTTOMLEFT",
        TL = "TOPLEFT",
        BR = "BOTTOMRIGHT",
        TR = "TOPRIGHT",
        C = "CENTER"
    },
    directions = {
        U = "UP",
        D = "DOWN",
        L = "LEFT",
        R = "RIGHT",
        H = "HORIZONTAL",
        V = "VERTICAL",
        C = "CENTER"
    },
    backdrops = {
        editbox = { bgFile = [[Interface\BUTTONS\WHITE8X8]], tile = true, tileSize = 1 },
        editboxborder = { bgFile = [[Interface\BUTTONS\WHITE8X8]], tile = true, tileSize = 1, edgeFile = media:Fetch("border", "test-border"), edgeSize = 2, insets = { top = 1, bottom = 1, left = 1, right = 1 } },
        optiongroupborder = { bgFile = [[Interface\BUTTONS\WHITE8X8]], tile = true, tileSize = 1, edgeFile = media:Fetch("border", "test-border"), edgeSize = 2, insets = { top = -5, bottom = -5, left = -5, right = -5 } },
        buttonroundborder = { bgFile = [[Interface\BUTTONS\WHITE8X8]], tile = true, tileSize = 1, edgeFile = media:Fetch("border", "cui-round-border2"), edgeSize = 3, insets = { top = 1, bottom = 1, left = 1, right = 1 } },
        slider = {},
        dropdown = {}
    },
    textures = {
        colordisabled = media:Fetch("widget", "cui-color-disabled")
    },
    minimap = {
        min = 150,
        max = 300,
    },
    optionheight = {
        slider = 55,
        dropdown = 50,
        toggle = 30,
    },
    unitoffset = {
        min = -500,
        max = 500
    }
}

enum.optionLists = {
    regions = (function()
        local r = {}
        for _,region in pairs(enum.regions) do
            table.insert(r, { region, region })
        end
        table.insert(r, { "ALL", "ALL" })
        return r
    end)()
}
 
A.enum = enum