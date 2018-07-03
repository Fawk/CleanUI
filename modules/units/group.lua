local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")
local CC = A.modules.clickcast
local initFrame = CreateFrame("Frame")

local directions = {
	["Left"] = "RIGHT",
	["Right"] = "LEFT",
	["Upwards"] = "BOTTOM",
	["Downwards"] = "TOP"
}

local Group = {}

function Group:GetMoverSize(container, maxMembers, db)
	local ox, oy = 0, 0
	local size = db["Size"]
	local background = db["Background"]
	if (background and background["Enabled"]) then
		local offset = background["Offset"]
		local top, bottom, left, right = offset["Top"], offset["Bottom"], offset["Left"], offset["Right"]
		local x, y = 0, 0
		if (top < 0) then y = y + top end
		if (bottom < 0) then y = y + bottom end
		if (left < 0) then x = x + left end
		if (right < 0) then x = x + right end
		ox = x < 0 and x * -1 or 0
		oy = y < 0 and y * -1 or 0
	end

	local width, height, maxColumns = size["Width"], size["Height"], db["Max Columns"]
	if (maxColumns) then
		width = maxColumns * width
		height = (maxMembers / maxColumns) * height
	else
		if (db["Orientation"] == "VERTICAL") then
			height = ((height * maxMembers) + (db["Offset Y"] * (maxMembers - 1)) + oy)
		else
			width = ((size["Width"] * maxMembers) + (db["Offset X"] * (maxMembers - 1))) + ox
		end
	end

    return width, height
end

function Group:Init(name, maxMembers, db)
    local container = Units:Get(frameName) or CreateFrame("Frame", T:frameName(name.."Container"), A.frameParent, "SecureHandlerBaseTemplate, SecureHandlerShowHideTemplate, SecureHandlerStateTemplate, SecureHandlerAttributeTemplate")
	container.hasMultipleUnits = true
	container.init = false
	container.db = db
	container.name = name
	container.maxMembers = maxMembers
    container.InitUnits = function(self, initFunc)
    	self.initFunc = initFunc
        self:UpdateUnits()
	end
	container.UpdateUnits = function(self)
        for i = 1, maxMembers do
            local uf = self.header:GetAttribute("child"..i)
            if (uf and self.initFunc) then
	            if (not uf.init) then
	            	uf.init = true
	            	uf.db = db
					uf:RegisterForClicks("AnyUp")
                	uf.unit = uf:GetAttribute("unit")
	            	uf.GetDbName = function(self) 
	            		return name 
	            	end

					Group:Update(uf, UnitEvent.UPDATE_DB, self)
	            	self:initFunc(uf)
	            end

                uf:Update(UnitEvent.UPDATE_DB, self)
                self.init = true
            end
        end
    end

    container:SetAttribute("UpdateSize", ([[
        self:SetWidth(%d)
        self:SetHeight(%d)
    ]]):format(Group:GetMoverSize(container, maxMembers, db)))

	container:Execute([[ 
		if (not this) then this = self end
		this:RunAttribute("UpdateSize")
	]])

    container:RegisterEvent("GROUP_ROSTER_UPDATE")
    container:RegisterEvent("UNIT_EXITED_VEHICLE")
    container:SetScript("OnEvent", function(self, event) 
        Units:DisableBlizzardRaid()
        T:RunNowOrAfterCombat(function()
            self:Execute([[ this:RunAttribute("UpdateSize") ]])
        end)
    	Group:UpdateHeader(self)
        self:UpdateUnits()
    end)

    RegisterStateDriver(container, "visibility", db["Visibility"])

	local header = container.header or CreateFrame("Frame", T:frameName(name.."Header"), A.frameParent, "SecureGroupHeaderTemplate")
    header:SetParent(container)
    header:SetAllPoints()

	container.header = header

    self:UpdateHeader(container)

    initFrame:SetScript("OnUpdate", function(self, elapsed)
    	if (not container.init) then
			container:UpdateUnits()
		else
			initFrame:SetScript("OnUpdate", nil)
		end
    end)

    Units:Add(container, name)
    Units:Position(container, db["Position"])

    A:CreateMover(container, db, name)

    Units:DisableBlizzard(name)

    return container
end

local points = {
	["Down Then Right"] = { "LEFT", "TOP" },
	["Down Then Left"] 	= { "RIGHT", "TOP" },
	["Up Then Right"] 	= { "LEFT", "BOTTOM" },
	["Up Then Left"] 	= { "RIGHT", "BOTTOM" },
	["Right Then Down"]	= { "TOP", "LEFT" },
	["Right Then Up"]	= { "BOTTOM", "LEFT" },
	["Left Then Down"] 	= { "TOP", "RIGHT" },
	["Left Then Up"] 	= { "BOTTOM", "RIGHT" }
}

function Group:UpdateHeader(container)
	local db, header, maxMembers = container.db, container.header, container.maxMembers

 	local groupBy, groupingOrder, sortingMethod, maxColumns, unitsPerColumn
	if (db["Group By"] == "Role") then
		groupBy, groupingOrder = "ASSIGNEDROLE", "TANK,HEALER,DAMAGER"
	elseif (db["Group By"] == "Class") then
		groupBy, groupingOrder = "CLASS", "DEATHKNIGHT,DEMONHUNTER,DRUID,HUNTER,MAGE,MONK,PALADIN,PRIEST,ROGUE,SHAMAN,WARLOCK,WARRIOR"
	else
		groupBy, groupingOrder = "GROUP", "1,2,3,4,5,6,7,8"
	end

	if (db["Sort Alphabetically"]) then
		sortingMethod = "NAME"
	else
		sortingMethod = "INDEX"
	end

	local limit = db["Max Columns"]
	local orientation = db["Orientation"]
	local growth = db["Growth Direction"]
	local sortingDir = db["Sorting Direction"]
	local size = db["Size"]

	local point, columnAnchorPoint, columnSpacing = nil, nil, 0
	if (limit) then
		maxColumns = limit
		unitsPerColumn = maxMembers / limit
		point, columnAnchorPoint = unpack(points[growth])
	else
		if (orientation == "HORIZONTAL") then
			point = "TOP"
			columnAnchorPoint = directions[growth]
			maxColumns = maxMembers
			unitsPerColumn = 1
			columnSpacing = db["Offset X"]
		else
			point = directions[growth]
			columnAnchorPoint = "LEFT"
			maxColumns = 1
			unitsPerColumn = maxMembers
			columnSpacing = db["Offset Y"]
		end
	end

	local clickCastString = CC:GetInitString("", db["Clickcast"])
	local initialConfigFunction = ([[
		local header = self:GetParent()
		local frames = table.new()
		table.insert(frames, self)
		self:GetChildList(frames)
		for i = 1, #frames do
			local frame = frames[i]
			frame:SetWidth(%d)
			frame:SetHeight(%d)
			RegisterUnitWatch(frame)
			%s
		end
	]]):format(size["Width"], size["Height"], clickCastString)

    header:SetAttribute("showPlayer", db["Show Player"])
    header:SetAttribute("showSolo", false)
    header:SetAttribute("show"..container.name, true)
    header:SetAttribute("yOffset", db["Offset Y"])
    header:SetAttribute("xOffset", db["Offset X"])
    header:SetAttribute("maxColumns", maxColumns)
    header:SetAttribute("unitsPerColumn", unitsPerColumn)
    header:SetAttribute("point", point)
    header:SetAttribute("columnAnchorPoint", columnAnchorPoint)
    header:SetAttribute("columnSpacing", columnSpacing)
    header:SetAttribute("groupBy", groupBy)
    header:SetAttribute("groupingOrder", groupingOrder)
    header:SetAttribute("sortingMethod", sortingMethod)
    header:SetAttribute("sortingDir", sortingDir)
    header:SetAttribute("template", "SecureUnitButtonTemplate")
    header:SetAttribute("initialConfigFunction", initialConfigFunction)

	RegisterAttributeDriver(header, 'state-visibility', db["Visibility"])
end

function Group:Update(...)
	local this = self
    local self, event, arg2, arg3, arg4, arg5 = ...

    if (not self.super) then
    	A:SetUnitMeta(self)
    	this:Update(self, UnitEvent.UPDATE_IDENTIFIER)
	end

	self.super:Update(...)

    -- Update player specific things based on the event
    if (event == UnitEvent.UPDATE_DB) then
        
        local db = self.db
        Group:UpdateHeader(arg2)

     	local size = db["Size"]
        self:SetSize(size["Width"], size["Height"])

        if (not self.orderedElements) then
    		self.orderedElements = A:OrderedMap()
    	end

    	if (not self.Update) then
		    self.Update = function(self, ...)
		        Group:Update(self, ...)
		    end
    	end

    	U:CreateBackground(self, db)

        self.orderedElements:foreach(function(key, obj)
            obj:Update(event, db[key])
        end)
    end
end

A.Group = Group