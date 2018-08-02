local A, L = unpack(select(2, ...))
local GetScreenWidth = GetScreenWidth
local GetScreenHeight = GetScreenHeight
local CreateFrame = CreateFrame
local UnitClass = UnitClass
local GetSpecialization = GetSpecialization

local buildText = A.TextBuilder
local buildButton = A.ButtonBuilder
local buildDropdown = A.DropdownBuilder
local buildGroup = A.GroupBuilder
local buildEditBox = A.EditBoxBuilder
local buildColor = A.ColorBuilder
local buildToggle = A.ToggleBuilder
local buildNumber = A.NumberBuilder

local X = {}

local function tcount(t)
    local count = 0
    for k,v in next, t do
        count = count + 1
    end
    return count
end

local function printTable(t)
    for k,v in next, t do print(k,v) end
end

local media = LibStub("LibSharedMedia-3.0")

local bdColor = { 39/255, 37/255, 37/255, 1 }
local transparent = { 0, 0, 0, 0 }

local function createDropdownTable(...)
    local tbl = {}
    for _,v in next, {...} do
        tbl[v] = v
    end
    return tbl
end


function X:HandleChildren(children, visible, once)
    if (not children) then return end
    children:foreach(function(child)
        if (not once) then
            X:HandleChildren(child.children, visible)
        end
        if (not visible) then 
            child:Hide()
        else
            child:Show()
        end
    end)
end

local hideOrShow = function(widget, visible)
    if (visible) then
        widget:Show()
    else
        widget:Hide()
    end
end

local handleChildrenTwoLevels = function(self, visible)
    self.children:foreach(function(child)
        if (child.children) then
            child.children:foreach(function(c)
                hideOrShow(c, visible)
            end)
        end
        hideOrShow(child, visible)
    end)
end

local hideParentChildrenAndShowSelf = function(self)
    self.parent.children:foreach(function(child)
        if (self ~= child) then
            child.open = false
        end
        X:HandleChildren(child.children, false)
    end)

    if (not self.open) then
        X:HandleChildren(self.children, true, true)
        self.open = true
    else
        self.open = false
    end
  
    if (A.clickCastWindow) then
        A.clickCastWindow:Hide()
    end
    if (A.tagsWindow) then
        A.tagsWindow:Hide()
    end
end

local genericOnClick = function(self)
    hideParentChildrenAndShowSelf(self, false)
    handleChildrenTwoLevels(self, true)
end

local genericEnabled = function(self) return self.parent:enabled() and self.db["Enabled"] end
local onlyParent = function(self) return self.parent:enabled() end
local genericGetValue = function(self) return self.db end
local genericSetValue = function(self, value) self.parent.db[self.name] = value end

local function positionSetting(order, previous, relativeTable)
    local tbl = {
        type = "group",
        onClick = hideParentChildrenAndShowSelf,
        order = 3,
        placement = function(self)
            self.title:ClearAllPoints()
            self.title:SetPoint("TOPLEFT", previous and self.previous.last.title or self.previous.title, "BOTTOMLEFT", 0, -20)
            self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
        end,
        children = {
            ["Point"] = {
                type = "dropdown",
                order = 1,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                    self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                end,
                values = A.Tools.points,
                get = genericGetValue,
                set = genericSetValue,
                width = 200,
                height = 20
            },
            ["Local Point"] = {
                type = "dropdown",
                order = 2,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                    self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                end,
                values = A.Tools.points,
                get = genericGetValue,
                set = genericSetValue,
                width = 200,
                height = 20
            },
            ["Relative To"] = {
                type = "dropdown",
                order = 3,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                    self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                end,
                values = relativeTable,
                get = genericGetValue,
                set = genericSetValue,
                width = 200,
                height = 20
            },
            ["Offset X"] = {
                type = "number",
                order = 4,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                end,
                step = 1,
                decimals = false,
                min = -GetScreenWidth(),
                max = GetScreenWidth(),
                get = genericGetValue,
                set = genericSetValue,
                width = 50,
                height = 20
            },
            ["Offset Y"] = {
                type = "number",
                order = 5,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                end,
                step = 1,
                decimals = false,
                min = -GetScreenHeight(),
                max = GetScreenHeight(),
                get = genericGetValue,
                set = genericSetValue,
                width = 50,
                height = 20
            }
        }
    }
    return tbl
end

local function backgroundSetting(order)
    local tbl = {
        enabled = genericEnabled,
        canToggle = true,
        onClick = genericOnClick,
        type = "group",
        order = order,
        placement = function(self)
            self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
        end,
        children = {
            ["Color"] = {
                type = "color",
                order = 1,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("LEFT", self.parent, "RIGHT", 100, 0)
                    self:SetPoint("LEFT", self.title, "RIGHT", 88, 0)
                end,
                get = genericGetValue,
                set = genericSetValue,
                width = 20,
                height = 20
            },
            ["Edge Size"] = {
                type = "number",
                order = 2,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                    self:SetPoint("LEFT", self.title, "RIGHT", 65, 0)
                end,
                step = 1,
                decimals = false,
                min = 1,
                max = 100,
                get = genericGetValue,
                set = genericSetValue,
                width = 50,
                height = 20
            },
            ["Match width"] = {
                type = "toggle",
                order = 3,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                end,
                get = genericGetValue,
                set = genericSetValue,
                width = 50,
                height = 20
            },
            ["Match height"] = {
                type = "toggle",
                order = 4,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                end,
                get = genericGetValue,
                set = genericSetValue,
                width = 50,
                height = 20                               
            },
            ["Width"] = {
                enabled = function(self) 
                    return not self.parent.db["Match width"]
                end,
                type = "number",
                order = 5,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                end,
                width = 50,
                height = 20,
                step = 2,
                decimals = false,
                min = 1,
                max = GetScreenWidth(),
                get = genericGetValue,
                set = genericSetValue
            },
            ["Height"] = {
                enabled = function(self) 
                    return not self.parent.db["Match height"]
                end,
                type = "number",
                order = 6,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                end,
                width = 50,
                height = 20,
                step = 2,
                decimals = false,
                min = 1,
                max = GetScreenHeight(),
                get = genericGetValue,
                set = genericSetValue   
            },
            ["Offset"] = {
                canToggle = false,
                onClick = genericOnClick,
                type = "group",
                order = 7,
                placement = function(self)
                    self:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -20)
                end,
                children = {
                    ["Top"] = {
                        type = "number",
                        order = 1,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("LEFT", self.parent.title, "RIGHT", 27, 0)
                            self:SetPoint("LEFT", self.title, "RIGHT", 30, 0)
                        end,
                        step = 1,
                        decimals = false,
                        min = -100,
                        max = 100,
                        get = genericGetValue,
                        set = genericSetValue,
                        width = 50,
                        height = 20
                    },
                    ["Bottom"] = {
                        type = "number",
                        order = 2,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                        end,
                        step = 1,
                        decimals = false,
                        min = -100,
                        max = 100,
                        get = genericGetValue,
                        set = genericSetValue,
                        width = 50,
                        height = 20
                    },
                    ["Left"] = {
                        type = "number",
                        order = 3,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                        end,
                        step = 1,
                        decimals = false,
                        min = -100,
                        max = 100,
                        get = genericGetValue,
                        set = genericSetValue,
                        width = 50,
                        height = 20
                    },
                    ["Right"] = {
                        type = "number",
                        order = 4,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                        end,
                        step = 1,
                        decimals = false,
                        min = -100,
                        max = 100,
                        get = genericGetValue,
                        set = genericSetValue,
                        width = 50,
                        height = 20
                    }
                }
            }
        }
    }
    return tbl
end

local function castBarSetting(order)
    local tbl = {
        enabled = genericEnabled,
        canToggle = true,
        onClick = hideParentChildrenAndShowSelf,
        type = "group",
        order = order,
        placement = function(self)
            self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
        end,
        children = {
            ["Color By"] = {
                type = "dropdown",
                order = 1,
                placement = function(self)
                    self:SetPoint("LEFT", self.parent, "RIGHT", 120, 0)
                end,
                values = createDropdownTable("Class", "Health", "Power", "Custom"),
                get = genericGetValue,
                set = genericSetValue,
                width = 200,
                height = 20
            },
            ["Custom Color"] = {
                enabled = function(self)
                    return self.parent:enabled() and self.parent.db["Color By"] == "Custom"
                end,
                type = "color",
                order = 2,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", -8, 0)
                end,
                get = genericGetValue,
                set = genericSetValue,
                width = 20,
                height = 20
            },
            ["Background Multiplier"] = {
                type = "number",
                order = 3,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                    self:SetPoint("LEFT", self.title, "RIGHT", 5, 0)
                end,
                min = -1,
                max = 1,
                width = 50,
                heigth = 20,
                step = 0.1,
                decimals = true,
                get = genericGetValue,
                set = genericSetValue
            },
            ["Orientation"] = {
                type = "dropdown",
                order = 4,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                    self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                end,
                values = createDropdownTable("HORIZONTAL", "VERTICAL"),
                get = genericGetValue,
                set = genericSetValue,
                width = 200,
                height = 20
            },
            ["Reversed"] = {
                type = "toggle",
                order = 5,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", -8, 0)
                end,
                get = genericGetValue,
                set = genericSetValue,
                width = 50,
                height = 20
            },
            ["Texture"] = {
                type = "dropdown",
                order = 6,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                    self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                end,
                values = media:List("statusbar"),
                get = genericGetValue,
                set = genericSetValue,
                width = 200,
                height = 20
            },
            ["Attached"] = {
                type = "toggle",
                order = 7,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", -8, 0)
                end,
                get = genericGetValue,
                set = genericSetValue,
                width = 50,
                height = 20
            },
            ["Attached Position"] = {
                enabled = function(self)
                    return self.parent:enabled() and self.parent.db["Attached"]
                end,
                type = "dropdown",
                order = 8,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                    self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                end,
                values = createDropdownTable("Below", "Above", "Left", "Right"),
                get = genericGetValue,
                set = genericSetValue,
                width = 200,
                height = 20
            },
            ["Size"] = {
                enabled = onlyParent,
                type = "group",
                order = 9,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -20)
                    self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                end,
                children = {
                    ["Match width"] = {
                        type = "toggle",
                        order = 1,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("LEFT", self.title, "RIGHT", 65, 0)
                        end,
                        get = genericGetValue,
                        set = genericSetValue,
                        width = 50,
                        height = 20
                    },
                    ["Match height"] = {
                        type = "toggle",
                        order = 2,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                        end,
                        get = genericGetValue,
                        set = genericSetValue,
                        width = 50,
                        height = 20                               
                    },
                    ["Width"] = {
                        enabled = function(self) 
                            return not self.parent.db["Match width"]
                        end,
                        type = "number",
                        order = 3,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("LEFT", self.title, "RIGHT", 104, 0)
                        end,
                        width = 50,
                        height = 20,
                        step = 2,
                        decimals = false,
                        min = 1,
                        max = GetScreenWidth(),
                        get = genericGetValue,
                        set = genericSetValue
                    },
                    ["Height"] = {
                        enabled = function(self) 
                            return not self.parent.db["Match height"]
                        end,
                        type = "number",
                        order = 4,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                        end,
                        width = 50,
                        height = 20,
                        step = 2,
                        decimals = false,
                        min = 1,
                        max = GetScreenHeight(),
                        get = genericGetValue,
                        set = genericSetValue   
                    }
                }
            },
            ["Background"] = backgroundSetting(10),
            ["Time"] = {                 
                enabled = genericEnabled,
                onClick = hideParentChildrenAndShowSelf,
                canToggle = true,
                type = "group",
                order = 11,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -20)
                    self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                end,
                children = {
                    ["Font Size"] = {
                        enabled = onlyParent,
                        type = "number",
                        order = 1,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("LEFT", self.title, "RIGHT", 50, 0)
                        end,
                        width = 50,
                        height = 20,
                        step = 1,
                        decimals = false,
                        min = 1,
                        max = 100,
                        get = genericGetValue,
                        set = genericSetValue
                    },
                    ["Format"] = {
                        enabled = onlyParent,
                        type = "text",
                        order = 2,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                        end,
                        width = 50,
                        height = 20,
                        get = genericGetValue,
                        set = genericSetValue   
                    },
                    ["Position"] = positionSetting(3, false, createDropdownTable("Parent"))
                }
            },
            ["Name"] = {
                enabled = genericEnabled,
                onClick = hideParentChildrenAndShowSelf,
                canToggle = true,
                type = "group",
                order = 12,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -20)
                    self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                end,
                children = {
                    ["Font Size"] = {
                        enabled = onlyParent,
                        type = "number",
                        order = 1,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("LEFT", self.title, "RIGHT", 50, 0)
                        end,
                        width = 50,
                        height = 20,
                        step = 1,
                        decimals = true,
                        min = 1,
                        max = 100,
                        get = genericGetValue,
                        set = genericSetValue
                    },
                    ["Format"] = {
                        enabled = onlyParent,
                        type = "text",
                        order = 2,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                        end,
                        width = 50,
                        height = 20,
                        get = genericGetValue,
                        set = genericSetValue   
                    },
                    ["Position"] = positionSetting(3, false, createDropdownTable("Parent"))
                }
            },
            ["Icon"] = {
                enabled = genericEnabled,
                onClick = hideParentChildrenAndShowSelf,
                canToggle = true,
                type = "group",
                order = 13,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -20)
                    self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                end,
                children = {
                    ["Position"] = {
                        type = "dropdown",
                        order = 1,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                        end,
                        values = createDropdownTable("TOP", "BOTTOM", "LEFT", "RIGHT"),
                        get = genericGetValue,
                        set = genericSetValue,
                        width = 200,
                        height = 20
                    },
                    ["Size"] = {
                        enabled = onlyParent,
                        onClick = hideParentChildrenAndShowSelf,
                        type = "group",
                        order = 2,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -20)
                            self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                        end,
                        children = {
                            ["Size"] = {
                                enabled = function(self)
                                    return self.parent:enabled() and not self.parent.db["Match width"] and not self.parent.db["Match height"]
                                end,
                                type = "number",
                                order = 1,
                                placement = function(self)
                                    self.title:ClearAllPoints()
                                    self.title:SetPoint("LEFT", self.parent.title, "RIGHT", 50, 0)
                                    self:SetPoint("LEFT", self.title, "RIGHT", 50, 0)
                                end,
                                width = 50,
                                height = 20,
                                step = 1,
                                decimals = false,
                                min = 1,
                                max = 100,
                                get = genericGetValue,
                                set = genericSetValue
                            },
                            ["Match width"] = {
                                type = "toggle",
                                order = 2,
                                placement = function(self)
                                    self.title:ClearAllPoints()
                                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                    self:SetPoint("LEFT", self.title, "RIGHT", 65, 0)
                                end,
                                get = genericGetValue,
                                set = genericSetValue,
                                width = 50,
                                height = 20
                            },
                            ["Match height"] = {
                                type = "toggle",
                                order = 3,
                                placement = function(self)
                                    self.title:ClearAllPoints()
                                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                                end,
                                get = genericGetValue,
                                set = genericSetValue,
                                width = 50,
                                height = 20                               
                            }
                        }
                    },
                    ["Background"] = backgroundSetting(3)
                }
            },
            ["Missing Bar"] = {
                enabled = genericEnabled,
                onClick = hideParentChildrenAndShowSelf,
                canToggle = true,
                type = "group",
                order = 14,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -20)
                    self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                end,
                children = {
                    ["Custom Color"] = {
                        enabled = function(self)
                            return self.parent:enabled() and self.parent.db["Color By"] == "Custom"
                        end,
                        order = 1,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("LEFT", self.title, "RIGHT", 88, 0)
                        end,
                        type = "color",
                        get = genericGetValue,
                        set = genericSetValue,
                        width = 20,
                        height = 20
                    },
                    ["Color By"] = {
                        type = "dropdown",
                        order = 2,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                        end,
                        values = createDropdownTable("Class", "Health", "Power", "Custom"),
                        get = genericGetValue,
                        set = genericSetValue,
                        width = 200,
                        height = 20
                    }
                }
            }
        }
    }
    return tbl
end

local function standardUnit(unit, order)
    
    local tbl = {
        enabled = genericEnabled,
        canToggle = true,
        onClick = hideParentChildrenAndShowSelf,
        type = "group",
        order = order,
        placement = function(self)
            self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
        end,
        children = {
            ["Health"] = {
                enabled = genericEnabled,
                canToggle = true,
                onClick = genericOnClick,
                type = "group",
                order = 1,
                placement = function(self)
                    self:SetPoint("LEFT", self.parent, "RIGHT", 100, 0)
                end,
                children = {
                    ["Color By"] = {
                        type = "dropdown",
                        order = 1,
                        placement = function(self)
                            self:SetPoint("LEFT", self.parent, "RIGHT", 120, 0)
                        end,
                        values = createDropdownTable("Class", "Health", "Gradient", "Custom"),
                        get = genericGetValue,
                        set = genericSetValue,
                        width = 200,
                        height = 20
                    },
                    ["Custom Color"] = {
                        enabled = function(self)
                            return self.parent:enabled() and self.parent.db["Color By"] == "Custom"
                        end,
                        type = "color",
                        order = 2,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                            self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", -8, 0)
                        end,
                        get = genericGetValue,
                        set = genericSetValue,
                        width = 20,
                        height = 20
                    },
                    ["Background Multiplier"] = {
                        type = "number",
                        order = 3,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("LEFT", self.title, "RIGHT", 5, 0)
                        end,
                        min = -1,
                        max = 1,
                        width = 50,
                        heigth = 20,
                        step = 0.1,
                        decimals = true,
                        get = genericGetValue,
                        set = genericSetValue
                    },
                    ["Orientation"] = {
                        type = "dropdown",
                        order = 4,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                        end,
                        values = createDropdownTable("HORIZONTAL", "VERTICAL"),
                        get = genericGetValue,
                        set = genericSetValue,
                        width = 200,
                        height = 20
                    },
                    ["Reversed"] = {
                        type = "toggle",
                        order = 5,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", -8, 0)
                        end,
                        get = genericGetValue,
                        set = genericSetValue,
                        width = 50,
                        height = 20
                    },
                    ["Texture"] = {
                        type = "dropdown",
                        order = 6,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                        end,
                        values = media:List("statusbar"),
                        get = genericGetValue,
                        set = genericSetValue,
                        width = 200,
                        height = 20
                    },
                    ["Position"] = positionSetting(7, false, createDropdownTable(unit, "Power")),
                    ["Size"] = {
                        enabled = onlyParent,
                        type = "group",
                        order = 8,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.last.title, "BOTTOMLEFT", 0, -20)
                            self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                        end,
                        children = {
                            ["Match width"] = {
                                type = "toggle",
                                order = 1,
                                placement = function(self)
                                    self.title:ClearAllPoints()
                                    self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                                    self:SetPoint("LEFT", self.title, "RIGHT", 65, 0)
                                end,
                                get = genericGetValue,
                                set = genericSetValue,
                                width = 50,
                                height = 20
                            },
                            ["Match height"] = {
                                type = "toggle",
                                order = 2,
                                placement = function(self)
                                    self.title:ClearAllPoints()
                                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                                end,
                                get = genericGetValue,
                                set = genericSetValue,
                                width = 50,
                                height = 20                               
                            },
                            ["Width"] = {
                                enabled = function(self) 
                                    return not self.parent.db["Match width"]
                                end,
                                type = "number",
                                order = 3,
                                placement = function(self)
                                    self.title:ClearAllPoints()
                                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                    self:SetPoint("LEFT", self.title, "RIGHT", 104, 0)
                                end,
                                width = 50,
                                height = 20,
                                step = 2,
                                decimals = false,
                                min = 1,
                                max = GetScreenWidth(),
                                get = genericGetValue,
                                set = genericSetValue
                            },
                            ["Height"] = {
                                enabled = function(self) 
                                    return not self.parent.db["Match height"]
                                end,
                                type = "number",
                                order = 4,
                                placement = function(self)
                                    self.title:ClearAllPoints()
                                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                                end,
                                width = 50,
                                height = 20,
                                step = 2,
                                decimals = false,
                                min = 1,
                                max = GetScreenHeight(),
                                get = genericGetValue,
                                set = genericSetValue   
                            }
                        }
                    },
                    ["Missing Health Bar"] = {
                        enabled = genericEnabled,
                        canToggle = true,
                        type = "group",
                        order = 9,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.last.title, "BOTTOMLEFT", 0, -20)
                            self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                        end,
                        children = {
                            ["Custom Color"] = {
                                enabled = function(self)
                                    return self.parent:enabled() and self.parent.db["Color By"] == "Custom"
                                end,
                                order = 1,
                                placement = function(self)
                                    self.title:ClearAllPoints()
                                    self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                                    self:SetPoint("LEFT", self.title, "RIGHT", 88, 0)
                                end,
                                type = "color",
                                get = genericGetValue,
                                set = genericSetValue,
                                width = 20,
                                height = 20
                            },
                            ["Color By"] = {
                                type = "dropdown",
                                order = 2,
                                placement = function(self)
                                    self.title:ClearAllPoints()
                                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                    self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                end,
                                values = createDropdownTable("Class", "Health", "Gradient", "Custom"),
                                get = genericGetValue,
                                set = genericSetValue,
                                width = 200,
                                height = 20
                            }
                        }
                    }
                }
            },
            ["Power"] = {
                enabled = genericEnabled,
                canToggle = true,
                onClick = genericOnClick,
                type = "group",
                order = 2,
                placement = function(self)
                    self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                end,
                children = {
                    ["Color By"] = {
                        type = "dropdown",
                        order = 1,
                        placement = function(self)
                            self:SetPoint("LEFT", self.parent, "RIGHT", 100, 0)
                        end,
                        values = createDropdownTable("Class", "Power", "Gradient", "Custom"),
                        get = genericGetValue,
                        set = genericSetValue,
                        width = 200,
                        height = 20
                    },
                    ["Custom Color"] = {
                        enabled = function(self)
                            return self.parent:enabled() and self.parent.db["Color By"] == "Custom"
                        end,
                        type = "color",
                        order = 2,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                            self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", -8, 0)
                        end,
                        get = genericGetValue,
                        set = genericSetValue,
                        width = 20,
                        height = 20
                    },
                    ["Background Multiplier"] = {
                        type = "number",
                        order = 3,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("LEFT", self.title, "RIGHT", 5, 0)
                        end,
                        min = -1,
                        max = 1,
                        step = 0.1,
                        width = 50,
                        height = 20,
                        decimals = true,
                        get = genericGetValue,
                        set = genericSetValue
                    },
                    ["Orientation"] = {
                        type = "dropdown",
                        order = 4,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                        end,
                        values = createDropdownTable("HORIZONTAL", "VERTICAL"),
                        get = genericGetValue,
                        set = genericSetValue,
                        width = 200,
                        height = 20
                    },
                    ["Reversed"] = {
                        type = "toggle",
                        order = 5,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", -8, 0)
                        end,
                        get = genericGetValue,
                        set = genericSetValue,
                        width = 50,
                        height = 20
                    },
                    ["Texture"] = {
                        type = "dropdown",
                        order = 6,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                        end,
                        values = media:List("statusbar"),
                        get = genericGetValue,
                        set = genericSetValue,
                        width = 200,
                        height = 20
                    },
                    ["Position"] = positionSetting(7, false, createDropdownTable(unit, "Health")),
                    ["Size"] = {
                        enabled = function(self) return self.parent:enabled() end,
                        type = "group",
                        order = 8,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.last.title, "BOTTOMLEFT", 0, -20)
                            self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                        end,
                        children = {
                            ["Match width"] = {
                                type = "toggle",
                                order = 1,
                                placement = function(self)
                                    self.title:ClearAllPoints()
                                    self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                                    self:SetPoint("LEFT", self.title, "RIGHT", 65, 0)
                                end,
                                get = genericGetValue,
                                set = genericSetValue,
                                width = 50,
                                height = 20
                            },
                            ["Match height"] = {
                                type = "toggle",
                                order = 2,
                                placement = function(self)
                                    self.title:ClearAllPoints()
                                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                                end,
                                get = genericGetValue,
                                set = genericSetValue,
                                width = 50,
                                height = 20                               
                            },
                            ["Width"] = {
                                enabled = function(self) 
                                    return not self.parent.db["Match width"]
                                end,
                                type = "number",
                                order = 3,
                                placement = function(self)
                                    self.title:ClearAllPoints()
                                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                    self:SetPoint("LEFT", self.title, "RIGHT", 104, 0)
                                end,
                                step = 2,
                                decimals = false,
                                min = 1,
                                max = GetScreenWidth(),
                                get = genericGetValue,
                                set = genericSetValue,
                                width = 50,
                                height = 20
                            },
                            ["Height"] = {
                                enabled = function(self) 
                                    return not self.parent.db["Match height"]
                                end,
                                type = "number",
                                order = 4,
                                placement = function(self)
                                    self.title:ClearAllPoints()
                                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                                end,
                                step = 2,
                                decimals = false,
                                min = 1,
                                max = GetScreenHeight(),
                                get = genericGetValue,
                                set = genericSetValue,
                                width = 50,
                                height = 20
                            }
                        }
                    },
                    ["Missing Power Bar"] = {
                        enabled = genericEnabled,
                        canToggle = true,
                        type = "group",
                        order = 9,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.last.title, "BOTTOMLEFT", 0, -20)
                            self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                        end,
                        children = {
                            ["Custom Color"] = {
                                enabled = function(self)
                                    return self.parent:enabled() and self.parent.db["Color By"] == "Custom"
                                end,
                                type = "color",
                                order = 1,
                                placement = function(self)
                                    self.title:ClearAllPoints()
                                    self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                                    self:SetPoint("LEFT", self.title, "RIGHT", 88, 0)
                                end,
                                get = genericGetValue,
                                set = genericSetValue,
                                width = 20,
                                height = 20
                            },
                            ["Color By"] = {
                                type = "dropdown",
                                order = 2,
                                placement = function(self)
                                    self.title:ClearAllPoints()
                                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                    self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                end,
                                values = createDropdownTable("Class", "Power", "Gradient", "Custom"),
                                get = genericGetValue,
                                set = genericSetValue,
                                width = 150,
                                height = 20
                            }
                        }
                    }
                }
            },
            ["Castbar"] = castBarSetting(3),
            ["Buffs"] = {
                enabled = genericEnabled,
                canToggle = true,
                onClick = genericOnClick,
                type = "group",
                order = 4,
                placement = function(self)
                    self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                end,
                children = {}
            },
            ["Debuffs"] = {
                enabled = genericEnabled,
                canToggle = true,
                onClick = genericOnClick,
                type = "group",
                order = 5,
                placement = function(self)
                    self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                end,
                children = {}
            },
            ["Background"] = backgroundSetting(6),
            ["Size"] = {
                enabled = function(self) return self.parent:enabled() end,
                onClick = genericOnClick,
                type = "group",
                order = 7,
                placement = function(self)
                   self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                end,
                children = {
                    ["Width"] = {
                        enabled = onlyParent,
                        type = "number",
                        order = 1,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("LEFT", self.parent.title, "RIGHT", 100, 0)
                            self:SetPoint("LEFT", self.title, "RIGHT", 104, 0)
                        end,
                        width = 50,
                        height = 20,
                        step = 2,
                        decimals = false,
                        min = 1,
                        max = GetScreenWidth(),
                        get = genericGetValue,
                        set = genericSetValue
                    },
                    ["Height"] = {
                        enabled = onlyParent,
                        type = "number",
                        order = 2,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                        end,
                        width = 50,
                        height = 20,
                        step = 2,
                        decimals = false,
                        min = 1,
                        max = GetScreenHeight(),
                        get = genericGetValue,
                        set = genericSetValue   
                    }
                }
            },
            ["Heal Prediction"] = {
                enabled = genericEnabled,
                canToggle = true,
                onClick = genericOnClick,
                type = "group",
                order = 8,
                placement = function(self)
                   self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                end,
                children = {
                    ["Texture"] = {
                        type = "dropdown",
                        order = 1,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                        end,
                        values = media:List("statusbar"),
                        get = genericGetValue,
                        set = genericSetValue,
                        width = 200,
                        height = 20
                    },
                    ["Max Overflow"] = {
                        enabled = function(self) 
                            return not self.parent.db["Match width"]
                        end,
                        type = "number",
                        order = 2,
                        placement = function(self)
                            self.title:ClearAllPoints()
                            self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                            self:SetPoint("LEFT", self.title, "RIGHT", 104, 0)
                        end,
                        width = 50,
                        height = 20,
                        step = 0.1,
                        decimals = true,
                        min = 1,
                        max = 10,
                        get = genericGetValue,
                        set = genericSetValue
                    },
                    ["Colors"] = {
                        enabled = onlyParent,
                        canToggle = false,
                        onClick = genericOnClick,
                        type = "group",
                        order = 3,
                        placement = function(self)
                           self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                        end,
                        children = {
                            ["My Heals"] = {
                                enabled = onlyParent,
                                type = "color",
                                order = 1,
                                placement = function(self)
                                    self.title:ClearAllPoints()
                                    self.title:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", -8, 0)
                                end,
                                get = genericGetValue,
                                set = genericSetValue,
                                width = 20,
                                height = 20
                            },
                            ["All Heals"] = {
                                enabled = onlyParent,
                                type = "color",
                                order = 2,
                                placement = function(self)
                                    self.title:ClearAllPoints()
                                    self.title:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", -8, 0)
                                end,
                                get = genericGetValue,
                                set = genericSetValue,
                                width = 20,
                                height = 20
                            },
                            ["Absorb"] = {
                                enabled = onlyParent,
                                type = "color",
                                order = 3,
                                placement = function(self)
                                    self.title:ClearAllPoints()
                                    self.title:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", -8, 0)
                                end,
                                get = genericGetValue,
                                set = genericSetValue,
                                width = 20,
                                height = 20
                            },
                            ["Heal Absorb"] = {
                                enabled = onlyParent,
                                type = "color",
                                order = 4,
                                placement = function(self)
                                    self.title:ClearAllPoints()
                                    self.title:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", -8, 0)
                                end,
                                get = genericGetValue,
                                set = genericSetValue,
                                width = 20,
                                height = 20
                            }
                        }
                    }
                }
            },
            ["Tags"] = A.general:get("tags"):GetOptions(function(self) 
                return self.parent:enabled() 
            end, hideParentChildrenAndShowSelf, 9)
        }
    }

    return tbl
end

local function barSetting(order, previous)
    local tbl = {
        enabled = onlyParent,
        canToggle = false,
        onClick = hideParentChildrenAndShowSelf,
        type = "group",
        order = order,
        placement = function(self)
            if (previous) then
                self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -10)
            else
                self:SetPoint("TOPLEFT", self.parent, "BOTTOMLEFT", 50, 0)
            end
        end,
        children = {
            ["Orientation"] = {
                type = "dropdown",
                order = 1,
                placement = function(self)
                    self.title:ClearAllPoints()
                    self.title:SetPoint("LEFT", self.parent.title, "RIGHT", 30, 0)
                    self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                end,
                values = createDropdownTable("HORIZONTAL", "VERTICAL"),
                get = genericGetValue,
                set = genericSetValue,
                width = 200,
                height = 20
            },
            ["X Spacing"] = {
                enabled = onlyParent,
                type = "number",
                order = 2,
                placement = function(self)
                    self:ClearAllPoints()
                    self.title:ClearAllPoints()
                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", -4, 0)
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                end,
                width = 50,
                height = 20,
                step = 1,
                decimals = false,
                min = 0,
                max = 100,
                get = genericGetValue,
                set = genericSetValue
            },
            ["Y Spacing"] = {
                enabled = onlyParent,
                type = "number",
                order = 3,
                placement = function(self)
                    self:ClearAllPoints()
                    self.title:ClearAllPoints()
                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                end,
                width = 50,
                height = 20,
                step = 1,
                decimals = false,
                min = 0,
                max = 100,
                get = genericGetValue,
                set = genericSetValue
            },
            ["Limit"] = {
                enabled = onlyParent,
                type = "number",
                order = 4,
                placement = function(self)
                    self:ClearAllPoints()
                    self.title:ClearAllPoints()
                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                end,
                width = 50,
                height = 20,
                step = 1,
                decimals = false,
                min = 0,
                max = 12,
                get = genericGetValue,
                set = genericSetValue
            },
            ["Size"] = {
                enabled = onlyParent,
                type = "number",
                order = 5,
                placement = function(self)
                    self:ClearAllPoints()
                    self.title:ClearAllPoints()
                    self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                    self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                end,
                width = 50,
                height = 20,
                step = 2,
                decimals = false,
                min = 0,
                max = 100,
                get = genericGetValue,
                set = genericSetValue
            }
        }
    }

    return tbl
end

local function getChildrenInOrder(children)
    local tbl = {}
    for k,v in next, children do
        if (v.order) then
            tbl[v.order] = { k, v }
        end
    end

    if (#tbl > 0) then
        local c = 0
        return function()
            c = c + 1
            if(tbl[c]) then
                return unpack(tbl[c])
            end
        end
    else
        return function() end
    end
end

function X:CreateGroup(name, parent, setting, db)

    local group = buildGroup(parent)
            :onClick(function(self, button, down)
                if (not down) then
                    if (setting.canToggle and button == "RightButton") then
                        if (setting.special) then
                            if (not setting.special(self)) then 
                                return
                            end
                        end

                        self.db["Enabled"] = not self:enabled()
                        if (not self:enabled()) then
                            self.title:SetTextColor(1, .2, .2, 1)
                        else
                            self.title:SetTextColor(1, 1, 1, 1)
                        end

                        X:UpdateWidgetStates()
                        A.dbProvider:Save()
                        A:UpdateDb()
                    end

                    if (setting.onClick and button == "LeftButton") then
                        setting.onClick(self)
                    end
                end
            end)
            :build()

    group.name = name
    group.db = db
    group.enabled = setting.enabled
    group.special = setting.special
    group.set = setting.set
    group.get = setting.get

    group.placement = function(self)
        setting.placement(self)
        self.children:foreach(function(child)
            child:placement()
        end)
    end

    if (not group.enabled) then
        group.enabled = function(self) return true end
    end

    local child
    for childName, childSetting in getChildrenInOrder(setting.children) do
        child = X:CreateChild(childName, group, childSetting, db[childName])
        group:addChild(child)
    end

    group.last = child

    group:SetActive(group:enabled())

    return group
end

function X:CreateChild(name, parent, setting, db)

    local type = setting.type

    local child, childBuilder
    if (type == "group") then
        child = X:CreateGroup(name, parent, setting, db)
        -- What needs to be done here?
    else
        if (type == "dropdown") then
            childBuilder = buildDropdown(parent)
                    :addItems(setting.values)
                    :size(setting.width, setting.height)
                    :fontSize(11)
                    :selectedButtonTextHorizontalAlign("RIGHT")
                    :rightOfButton()
        elseif (type == "text") then
            childBuilder = buildEditBox(parent)
                    :size(setting.width, setting.height)
                    :fontSize(setting.textSize or 11)
        elseif (type == "number") then
            childBuilder = buildNumber(parent)
                    :min(setting.min)
                    :max(setting.max)
                    :stepValue(setting.step)
                    :allowDecimals(setting.decimals)
                    :fontSize(setting.textSize or 11)
                    :size(setting.width, setting.height)
        elseif (type == "toggle") then
            childBuilder = buildToggle(parent)
                    :size(setting.width, setting.height)
                    :texts("ON", "OFF")
        elseif (type == "color") then
            childBuilder = buildColor(parent)
                    :size(setting.width, setting.height)
        end
    end

    if (not child) then
        child = childBuilder
            :onValueChanged(function(self, widget, value)
                widget:set(value)
                X:UpdateWidgetStates()
                A.dbProvider:Save()
                A:UpdateDb()
            end)
            :build()

        child.name = name
        child.db = db
        child.enabled = setting.enabled
        child.special = setting.special
        child.placement = setting.placement
        child.set = setting.set
        child.get = setting.get
    end

    if (not child.enabled) then
        child.enabled = function(self) 
            return self.parent:enabled()
        end
    end

    child.title = buildText(child, setting.titleSize or 11)
            :atLeft()
            :outline()
            :build()

    child.title:SetText(name)

    if (not child:enabled()) then
        child.title:SetTextColor(1, .2, .2, 1)
    else
        child.title:SetTextColor(1, 1, 1, 1)
    end

    child:SetActive(child:enabled())
    child:SetValue(db)

    child:SetSize(setting.width or child.title:GetWidth(), setting.height or 20)

    return child
end

function A:CreatePrefs(db)

    local prefs = {
        ["General"] = {
            type = "group",
            order = 1,
            onClick = hideParentChildrenAndShowSelf,
            placement = function(self)
                self:SetPoint("TOPLEFT", self.parent, "TOPLEFT", 10, 0)
            end,
            children = {
                ["Actionbars"] = {
                    enabled = genericEnabled,
                    canToggle = true,
                    onClick = hideParentChildrenAndShowSelf,
                    type = "group",
                    order = 1,
                    placement = function(self)
                        self:SetPoint("LEFT", self.parent, "RIGHT", 50, 0)
                    end,
                    children = {
                        ["Show Grid"] = {
                            type = "toggle",
                            order = 1,
                            placement = function(self)
                                self.title:ClearAllPoints()
                                self.title:SetPoint("LEFT", self.parent.title, "RIGHT", 40, 0)
                                self:SetPoint("LEFT", self.title, "RIGHT", 40, 0)
                            end,
                            get = genericGetValue,
                            set = genericSetValue,
                            width = 50,
                            height = 20
                        },
                        ["Bars"] = {
                            enabled = onlyParent,
                            canToggle = false,
                            onClick = hideParentChildrenAndShowSelf,
                            type = "group",
                            order = 2,
                            placement = function(self)
                                self:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                            end,                        
                            children = {
                                ["Bar1"] = barSetting(1),
                                ["Bar2"] = barSetting(2, true),
                                ["Bar3"] = barSetting(3, true),
                                ["Bar4"] = barSetting(4, true),
                                ["Bar5"] = barSetting(5, true),
                            }
                        }
                    }
                }
            }
        },
        ["Units"] = {
            type = "group",
            order = 2,
            onClick = hideParentChildrenAndShowSelf,
            placement = function(self)
                self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, 0)
            end,
            children = {
                ["Player"] = {
                    enabled = genericEnabled,
                    canToggle = true,
                    onClick = hideParentChildrenAndShowSelf,
                    type = "group",
                    order = 1,
                    placement = function(self)
                        self:SetPoint("LEFT", self.parent, "RIGHT", 50, 0)
                    end,
                    children = {
                        ["Health"] = {
                            enabled = genericEnabled,
                            canToggle = true,
                            onClick = genericOnClick,
                            type = "group",
                            order = 1,
                            placement = function(self)
                                self:SetPoint("LEFT", self.parent, "RIGHT", 100, 0)
                            end,
                            children = {
                                ["Color By"] = {
                                    type = "dropdown",
                                    order = 1,
                                    placement = function(self)
                                        self:SetPoint("LEFT", self.parent, "RIGHT", 120, 0)
                                    end,
                                    values = createDropdownTable("Class", "Health", "Gradient", "Custom"),
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 200,
                                    height = 20
                                },
                                ["Custom Color"] = {
                                    enabled = function(self)
                                        return self.parent:enabled() and self.parent.db["Color By"] == "Custom"
                                    end,
                                    type = "color",
                                    order = 2,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                                        self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", -8, 0)
                                    end,
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 20,
                                    height = 20
                                },
                                ["Background Multiplier"] = {
                                    type = "number",
                                    order = 3,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                        self:SetPoint("LEFT", self.title, "RIGHT", 5, 0)
                                    end,
                                    min = -1,
                                    max = 1,
                                    width = 50,
                                    heigth = 20,
                                    step = 0.1,
                                    decimals = true,
                                    get = genericGetValue,
                                    set = genericSetValue
                                },
                                ["Orientation"] = {
                                    type = "dropdown",
                                    order = 4,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                        self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                    end,
                                    values = createDropdownTable("HORIZONTAL", "VERTICAL"),
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 200,
                                    height = 20
                                },
                                ["Reversed"] = {
                                    type = "toggle",
                                    order = 5,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                        self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", -8, 0)
                                    end,
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 50,
                                    height = 20
                                },
                                ["Texture"] = {
                                    type = "dropdown",
                                    order = 6,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                        self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                    end,
                                    values = media:List("statusbar"),
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 200,
                                    height = 20
                                },
                                ["Position"] = positionSetting(7, false, createDropdownTable("Player", "Power")),
                                ["Size"] = {
                                    type = "group",
                                    order = 8,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.last.title, "BOTTOMLEFT", 0, -20)
                                        self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                    end,
                                    children = {
                                        ["Match width"] = {
                                            type = "toggle",
                                            order = 1,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "RIGHT", 65, 0)
                                            end,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 50,
                                            height = 20
                                        },
                                        ["Match height"] = {
                                            type = "toggle",
                                            order = 2,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                                            end,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 50,
                                            height = 20                               
                                        },
                                        ["Width"] = {
                                            enabled = function(self) 
                                                return not self.parent.db["Match width"]
                                            end,
                                            type = "number",
                                            order = 3,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "RIGHT", 104, 0)
                                            end,
                                            width = 50,
                                            height = 20,
                                            step = 2,
                                            decimals = false,
                                            min = 1,
                                            max = GetScreenWidth(),
                                            get = genericGetValue,
                                            set = genericSetValue
                                        },
                                        ["Height"] = {
                                            enabled = function(self) 
                                                return not self.parent.db["Match height"]
                                            end,
                                            type = "number",
                                            order = 4,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                                            end,
                                            width = 50,
                                            height = 20,
                                            step = 2,
                                            decimals = false,
                                            min = 1,
                                            max = GetScreenHeight(),
                                            get = genericGetValue,
                                            set = genericSetValue   
                                        }
                                    }
                                },
                                ["Missing Health Bar"] = {
                                    enabled = genericEnabled,
                                    canToggle = true,
                                    type = "group",
                                    order = 9,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.last.title, "BOTTOMLEFT", 0, -20)
                                        self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                    end,
                                    children = {
                                        ["Custom Color"] = {
                                            enabled = function(self)
                                                return self.parent:enabled() and self.parent.db["Color By"] == "Custom"
                                            end,
                                            order = 1,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "RIGHT", 88, 0)
                                            end,
                                            type = "color",
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 20,
                                            height = 20
                                        },
                                        ["Color By"] = {
                                            type = "dropdown",
                                            order = 2,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                            end,
                                            values = createDropdownTable("Class", "Health", "Gradient", "Custom"),
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 200,
                                            height = 20
                                        }
                                    }
                                }
                            }
                        },
                        ["Power"] = {
                            enabled = genericEnabled,
                            canToggle = true,
                            onClick = genericOnClick,
                            type = "group",
                            order = 2,
                            placement = function(self)
                                self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                            end,
                            children = {
                                ["Color By"] = {
                                    type = "dropdown",
                                    order = 1,
                                    placement = function(self)
                                        self:SetPoint("LEFT", self.parent, "RIGHT", 100, 0)
                                    end,
                                    values = createDropdownTable("Class", "Power", "Gradient", "Custom"),
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 200,
                                    height = 20
                                },
                                ["Custom Color"] = {
                                    enabled = function(self)
                                        return self.parent:enabled() and self.parent.db["Color By"] == "Custom"
                                    end,
                                    type = "color",
                                    order = 2,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                                        self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", -8, 0)
                                    end,
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 20,
                                    height = 20
                                },
                                ["Background Multiplier"] = {
                                    type = "number",
                                    order = 3,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                        self:SetPoint("LEFT", self.title, "RIGHT", 5, 0)
                                    end,
                                    min = -1,
                                    max = 1,
                                    step = 0.1,
                                    width = 50,
                                    height = 20,
                                    decimals = true,
                                    get = genericGetValue,
                                    set = genericSetValue
                                },
                                ["Orientation"] = {
                                    type = "dropdown",
                                    order = 4,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                        self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                    end,
                                    values = createDropdownTable("HORIZONTAL", "VERTICAL"),
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 200,
                                    height = 20
                                },
                                ["Reversed"] = {
                                    type = "toggle",
                                    order = 5,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                        self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", -8, 0)
                                    end,
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 50,
                                    height = 20
                                },
                                ["Texture"] = {
                                    type = "dropdown",
                                    order = 6,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                        self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                    end,
                                    values = media:List("statusbar"),
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 200,
                                    height = 20
                                },
                                ["Position"] = positionSetting(7, false, createDropdownTable("Player", "Health")),
                                ["Size"] = {
                                    type = "group",
                                    order = 8,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.last.title, "BOTTOMLEFT", 0, -20)
                                        self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                    end,
                                    children = {
                                        ["Match width"] = {
                                            type = "toggle",
                                            order = 1,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "RIGHT", 65, 0)
                                            end,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 50,
                                            height = 20
                                        },
                                        ["Match height"] = {
                                            type = "toggle",
                                            order = 2,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                                            end,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 50,
                                            height = 20                               
                                        },
                                        ["Width"] = {
                                            enabled = function(self) 
                                                return not self.parent.db["Match width"]
                                            end,
                                            type = "number",
                                            order = 3,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "RIGHT", 104, 0)
                                            end,
                                            step = 2,
                                            decimals = false,
                                            min = 1,
                                            max = GetScreenWidth(),
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 50,
                                            height = 20
                                        },
                                        ["Height"] = {
                                            enabled = function(self) 
                                                return not self.parent.db["Match height"]
                                            end,
                                            type = "number",
                                            order = 4,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                                            end,
                                            step = 2,
                                            decimals = false,
                                            min = 1,
                                            max = GetScreenHeight(),
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 50,
                                            height = 20
                                        }
                                    }
                                },
                                ["Missing Power Bar"] = {
                                    enabled = genericEnabled,
                                    canToggle = true,
                                    type = "group",
                                    order = 9,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.last.title, "BOTTOMLEFT", 0, -20)
                                        self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                    end,
                                    children = {
                                        ["Custom Color"] = {
                                            enabled = function(self)
                                                return self.parent:enabled() and self.parent.db["Color By"] == "Custom"
                                            end,
                                            type = "color",
                                            order = 1,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.parent.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "RIGHT", 88, 0)
                                            end,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 20,
                                            height = 20
                                        },
                                        ["Color By"] = {
                                            type = "dropdown",
                                            order = 2,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                            end,
                                            values = createDropdownTable("Class", "Power", "Gradient", "Custom"),
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 200,
                                            height = 20
                                        }
                                    }
                                }
                            }
                        },
                        ["Castbar"] = castBarSetting(3),
                        ["Alternative Power"] = {
                            enabled = genericEnabled,
                            canToggle = true,
                            onClick = genericOnClick,
                            type = "group",
                            order = 4,
                            placement = function(self)
                                self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                            end,
                            children = {}
                        },
                        ["Runes"] = {
                            enabled = function(self)
                                return self.parent:enabled() and self:special()
                            end,
                            special = function(self)
                                return select(2, UnitClass("player")) == "DEATHKNIGHT"
                            end,
                            canToggle = true,
                            onClick = genericOnClick,
                            type = "group",
                            order = 5,
                            placement = function(self)
                                self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                            end,
                            children = {}
                        },
                        ["Combat Indicator"] = {
                            enabled = genericEnabled,
                            canToggle = true,
                            onClick = genericOnClick,
                            type = "group",
                            order = 6,
                            placement = function(self)
                                self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                            end,
                            children = {}
                        },
                        ["Stagger"] = {
                            enabled = function(self)
                                return self.parent:enabled() and self:special()
                            end,
                            special = function(self)
                                return select(2, UnitClass("player")) == "MONK" and GetSpecialization() == 1
                            end,
                            canToggle = true,
                            onClick = genericOnClick,
                            type = "group",
                            order = 7,
                            placement = function(self)
                                self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                            end,
                            children = {}
                        },
                        ["Buffs"] = {
                            enabled = genericEnabled,
                            canToggle = true,
                            onClick = genericOnClick,
                            type = "group",
                            order = 8,
                            placement = function(self)
                                self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                            end,
                            children = {}
                        },
                        ["Debuffs"] = {
                            enabled = genericEnabled,
                            canToggle = true,
                            onClick = genericOnClick,
                            type = "group",
                            order = 9,
                            placement = function(self)
                                self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                            end,
                            children = {}
                        },
                        ["Background"] = backgroundSetting(10),
                        ["Size"] = {
                            enabled = onlyParent,
                            onClick = genericOnClick,
                            type = "group",
                            order = 11,
                            placement = function(self)
                               self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                            end,
                            children = {
                                ["Width"] = {
                                    enabled = onlyParent,
                                    type = "number",
                                    order = 1,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("LEFT", self.parent.title, "RIGHT", 100, 0)
                                        self:SetPoint("LEFT", self.title, "RIGHT", 104, 0)
                                    end,
                                    width = 50,
                                    height = 20,
                                    step = 2,
                                    decimals = false,
                                    min = 1,
                                    max = GetScreenWidth(),
                                    get = genericGetValue,
                                    set = genericSetValue
                                },
                                ["Height"] = {
                                    enabled = onlyParent,
                                    type = "number",
                                    order = 2,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                        self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                                    end,
                                    width = 50,
                                    height = 20,
                                    step = 2,
                                    decimals = false,
                                    min = 1,
                                    max = GetScreenHeight(),
                                    get = genericGetValue,
                                    set = genericSetValue   
                                }
                            }
                        },
                        ["Heal Prediction"] = {
                            enabled = genericEnabled,
                            canToggle = true,
                            onClick = genericOnClick,
                            type = "group",
                            order = 12,
                            placement = function(self)
                               self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
                            end,
                            children = {
                                ["Texture"] = {
                                    type = "dropdown",
                                    order = 1,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("LEFT", self.parent.title, "RIGHT", 50, 0)
                                        self:SetPoint("LEFT", self.title, "LEFT", 0, 0)
                                    end,
                                    values = media:List("statusbar"),
                                    get = genericGetValue,
                                    set = genericSetValue,
                                    width = 200,
                                    height = 20
                                },
                                ["Max Overflow"] = {
                                    enabled = function(self) 
                                        return not self.parent.db["Match width"]
                                    end,
                                    type = "number",
                                    order = 2,
                                    placement = function(self)
                                        self.title:ClearAllPoints()
                                        self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                        self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", -5, 0)
                                    end,
                                    width = 50,
                                    height = 20,
                                    step = 0.1,
                                    decimals = true,
                                    min = 1,
                                    max = 10,
                                    get = genericGetValue,
                                    set = genericSetValue
                                },
                                ["Colors"] = {
                                    enabled = onlyParent,
                                    canToggle = false,
                                    onClick = genericOnClick,
                                    type = "group",
                                    order = 3,
                                    placement = function(self)
                                       self:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -20)
                                    end,
                                    children = {
                                        ["My Heals"] = {
                                            enabled = onlyParent,
                                            type = "color",
                                            order = 1,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.parent, "BOTTOMLEFT", 0, -5)
                                                self:SetPoint("LEFT", self.title, "RIGHT", 110, 0)
                                            end,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 20,
                                            height = 20
                                        },
                                        ["All Heals"] = {
                                            enabled = onlyParent,
                                            type = "color",
                                            order = 2,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                                            end,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 20,
                                            height = 20
                                        },
                                        ["Absorb"] = {
                                            enabled = onlyParent,
                                            type = "color",
                                            order = 3,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                                            end,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 20,
                                            height = 20
                                        },
                                        ["Heal Absorb"] = {
                                            enabled = onlyParent,
                                            type = "color",
                                            order = 4,
                                            placement = function(self)
                                                self.title:ClearAllPoints()
                                                self.title:SetPoint("TOPLEFT", self.previous.title, "BOTTOMLEFT", 0, -10)
                                                self:SetPoint("TOPRIGHT", self.previous, "BOTTOMRIGHT", 0, 0)
                                            end,
                                            get = genericGetValue,
                                            set = genericSetValue,
                                            width = 20,
                                            height = 20
                                        }
                                    }
                                }
                            }
                        },
                        ["Tags"] = A.general:get("tags"):GetOptions(function(self) 
                            return self.parent:enabled() 
                        end, hideParentChildrenAndShowSelf, 13),
                    }
                },
                ["Target"] = standardUnit("Target", 2),
                ["Target of Target"] = standardUnit("Target of Target", 3),
                ["Pet"] = standardUnit("Pet", 4)
            }
        },
        ["Group"] = {
            type = "group",
            order = 3,
            onClick = hideParentChildrenAndShowSelf,
            placement = function(self)
                self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, 0)
            end,
            children = {
                ["Party"] = {
                    enabled = genericEnabled,
                    canToggle = true,
                    onClick = hideParentChildrenAndShowSelf,
                    type = "group",
                    order = 1,
                    placement = function(self)
                        self:SetPoint("LEFT", self.parent, "RIGHT", 50, 0)
                    end,
                    children = {
                        ["Clickcast"] = A.general:get("clickcast"):GetOptions(genericEnabled, hideParentChildrenAndShowSelf, 1),
                    }
                },
                ["Raid"] = {
                    enabled = genericEnabled,
                    canToggle = true,
                    type = "group",
                    order = 2,
                    placement = function(self)

                    end,
                    children = {}
                }
            }
        }
    }

    local parent = CreateFrame("Frame", nil, A.frameParent)
    parent:SetSize(1, 1)
    parent:SetPoint("TOPLEFT", 0, -300)
    parent.children = A:OrderedTable()

    X.UpdateWidgetStates = function(self, widgets)
        local iterator = widgets or parent.children
        iterator:foreach(function(widget)
            if (widget.children) then
                X:UpdateWidgetStates(widget.children)
            end

            local enabled = widget:enabled()

            widget:SetActive(enabled)

            if (not enabled) then
                widget.title:SetTextColor(1, .2, .2, 1)
            else
                widget.title:SetTextColor(1, 1, 1, 1)
            end
        end)
    end

    -- Iterate prefs
    for name, setting in getChildrenInOrder(prefs) do
        
        local type = setting.type
        local widget

        if (type == "group") then
            widget = X:CreateGroup(name, parent, setting, db)

            widget.title = buildText(widget, 11)
                    :atLeft()
                    :outline()
                    :build()

            widget.title:SetText(name)

            widget:SetWidth(widget.title:GetWidth())

            X:HandleChildren(widget.children, false)
        else
            widget = X:CreateChild(name, parent, setting, db)
        end

        parent.children:add(widget)
    end

    parent.children:foreach(function(widget)
        widget:placement()
    end)
end
