local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")

A:Debug("Loading enums")

local defaultBg = media:Fetch("background", "bg")

local enum = {
    colors = {
        backdrop = { 0.10, 0.10, 0.10, 1 },
        backdrophalfalpha = { .10, .10, .10, .5 },
        backdrop75alpha = { .10, .10, .10, .75 },
        backdrop25alpha = { .10, .10, .10, .25 },
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
        editbox = { 
            bgFile = media:Fetch("background", "bg"), 
            tile = true, 
            tileSize = 1
        },
        editboxborder = { 
            bgFile = media:Fetch("background", "bg"), 
            tile = true, 
            tileSize = 1, 
            edgeFile = media:Fetch("background", "bg"), 
            edgeSize = 1, 
            insets = { top = 1, bottom = 1, left = 1, right = 1 } 
        },
        editboxborder2 = { 
            bgFile = media:Fetch("background", "bg"), 
            tile = true, 
            tileSize = 1, 
            edgeFile = media:Fetch("background", "bg"), 
            edgeSize = 4, 
            insets = { top = 5, bottom = 5, left = 5, right = 5 } 
        },
        editboxborder3 = { 
            bgFile = media:Fetch("background", "bg"), 
            tile = true, 
            tileSize = 1, 
            edgeFile = media:Fetch("background", "bg"), 
            edgeSize = 2, 
            insets = { top = 3, bottom = 3, left = 3, right = 3 } 
        },
        optiongroupborder = { 
            bgFile = media:Fetch("background", "bg"), 
            tile = true, 
            tileSize = 1, 
            edgeFile = media:Fetch("background", "bg"), 
            edgeSize = 2, 
            insets = { top = -5, bottom = -5, left = -5, right = -5 } 
        },
        buttonroundborder = { 
            bgFile = media:Fetch("background", "bg"), 
            tile = true, 
            tileSize = 1, 
            edgeFile = media:Fetch("border", "cui-round-border2"), 
            edgeSize = 3, 
            insets = { top = 1, bottom = 1, left = 1, right = 1 } 
        },
        statusborder = {
            bgFile = media:Fetch("background", "bg"),
            tile = true,
            tileSize = 16,
            insets  = { top = -1, bottom = -1, left = -1, right = -1 }
        },
        statusborder2 = {
            bgFile = media:Fetch("background", "bg"),
            tile = true,
            tileSize = 16,
            edgeFile = media:Fetch("border", "cui-round-border2"), 
            edgeSize = 3, 
            insets  = { top = -2, bottom = -2, left = -2, right = -2 }
        },
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