local A, L = unpack(select(2, ...))
local E, T, U, Units, media = A.enum, A.Tools, A.Utils, A.Units, LibStub("LibSharedMedia-3.0")
local CC = A.general["clickcast"]
local updateFrames = {}
local UnitExists = UnitExists

local Group = {}

function Group:GetMoverSize(container, maxMembers, db)
	local ox, oy = 0, 0
	local background = db.background
	if (background and background.enabled) then
		local offset = background.offset
		local top, bottom, left, right = offset.top, offset.bottom, offset.left, offset.right
		local x, y = 0, 0
		if (top < 0) then y = y + top end
		if (bottom < 0) then y = y + bottom end
		if (left < 0) then x = x + left end
		if (right < 0) then x = x + right end
		ox = x < 0 and x * -1 or 0
		oy = y < 0 and y * -1 or 0
	end

	local width, height, maxColumns = db.size.width, db.size.height, db.maxColumns
	if (maxColumns) then
		width = maxColumns * width
		height = (maxMembers / maxColumns) * height
	else
		if (db.orientation == "VERTICAL") then
			height = ((height * maxMembers) + (db.y * (maxMembers - 1)) + oy)
		else
			width = ((db.size.width * maxMembers) + (db.x * (maxMembers - 1))) + ox
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
	container.GetUnits = function(self)
		return { this.header:GetChildren() }
	end
	container.UpdateUnits = function(self, event, ...)
		if (A.groupSimulating) then
			A.modules[A.groupSimulating:lower()]:Simulate(self.maxMembers)
		else
			local this = self

			local uf = select(1, this.header:GetChildren())
			if (uf and uf.init) then
				for i = 1, this.header:GetNumChildren() do
		            local uf = select(i, this.header:GetChildren())
		            if (uf and uf.init and uf.Update) then
	            		uf:Update(event, this, uf.unit)
	            	else
	            		local updateFrame = updateFrames[i]
	            		if (not updateFrame) then
	            			updateFrame = CreateFrame("Frame")
	            		end

	            		if (not updateFrame.updating) then
	            			updateFrame.updating = true
			            	updateFrame:SetScript("OnUpdate", function(self, elapsed)
			            		if (not self.success) then
			            			local uf = select(i, this.header:GetChildren())
			            			if (uf) then
						            	if (not uf.init and this.initFunc) then
							            	uf.init = true
							            	uf.db = db
											uf:RegisterForClicks("AnyUp")
						                	uf.unit = uf:GetAttribute("unit")
							            	uf.GetDbName = function(self)
							            		return name 
							            	end

											Group:Update(uf, UnitEvent.UPDATE_DB, this, uf.unit)
											Group:Update(uf, UnitEvent.UPDATE_TAGS, this, uf.unit)

											this:initFunc(uf)
							            end
							            self.success = true
							            self.updating = false
							            updateFrame:SetScript("OnUpdate", nil)
			            			end
			            		end
			            	end)
			            end
		           	end
		        end
			else
				for i = 1, this.header:GetNumChildren() do
		            local uf = select(i, this.header:GetChildren())
				    
				    if (not uf or not uf.init) then
					    local updateFrame = updateFrames[i]
		        		if (not updateFrame) then
		        			updateFrame = CreateFrame("Frame")
		        		end

		        		if (not updateFrame.updating) then
		        			updateFrame.updating = true
			            	updateFrame:SetScript("OnUpdate", function(self, elapsed)
			            		if (not self.success) then
			            			local uf = select(i, this.header:GetChildren())
			            			if (uf) then
						            	if (not uf.init and this.initFunc) then
							            	uf.init = true
							            	uf.db = db
											uf:RegisterForClicks("AnyUp")
						                	uf.unit = uf:GetAttribute("unit")
							            	uf.GetDbName = function(self)
							            		return name 
							            	end

											Group:Update(uf, UnitEvent.UPDATE_DB, this, uf.unit)
											Group:Update(uf, UnitEvent.UPDATE_TAGS, this, uf.unit)

											this:initFunc(uf)
							            end
							            self.success = true
							            self.updating = false
							            updateFrame:SetScript("OnUpdate", nil)
			            			end
			            		end
			            	end)
			            end
			        else
			        	uf:Update(event, this, uf.unit)
			        end
		        end
			end
	    end
    end
    container.getMoverSize = function(self)
        return Group:GetMoverSize(self, self.maxMembers, self.db)
    end

    container:SetAttribute("UpdateSize", ([[
        self:SetWidth(%d)
        self:SetHeight(%d)
    ]]):format(container:getMoverSize()))

	container:Execute([[ 
		if (not this) then this = self end
		this:RunAttribute("UpdateSize")
	]])

    RegisterStateDriver(container, "visibility", db.visibility)

	local header = container.header or CreateFrame("Frame", T:frameName(name.."Header"), A.frameParent, "SecureGroupHeaderTemplate")
    header:SetParent(container)
    header:SetAllPoints()

	container.header = header

    container:RegisterEvent("GROUP_ROSTER_UPDATE")
    container:RegisterEvent("UNIT_EXITED_VEHICLE")
    container:RegisterEvent("PLAYER_ENTERING_WORLD")
    container:RegisterEvent("PLAYER_LOGIN")
    container:SetScript("OnEvent", function(self, event) 
        Units:DisableBlizzardRaid()
        T:RunNowOrAfterCombat(function()
            self:Execute([[ this:RunAttribute("UpdateSize") ]])
        end)

        self:UpdateUnits(UnitEvent.UPDATE_GROUP)
    end)

    Units:Add(container, name)

    self:UpdateHeader(container)

    Units:Position(container, db.position)

    A:CreateMover(container, db, name)

    Units:DisableBlizzard(name)

    return container
end

local directions = {
	["Left"] = "RIGHT",
	["Right"] = "LEFT",
	["Upwards"] = "BOTTOM",
	["Downwards"] = "TOP"
}

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
	if (db.groupBy == "Role") then
		groupBy, groupingOrder = "ASSIGNEDROLE", "TANK,HEALER,DAMAGER"
	elseif (db.groupBy == "Class") then
		groupBy, groupingOrder = "CLASS", "DEATHKNIGHT,DEMONHUNTER,DRUID,HUNTER,MAGE,MONK,PALADIN,PRIEST,ROGUE,SHAMAN,WARLOCK,WARRIOR"
	else
		groupBy, groupingOrder = "GROUP", "1,2,3,4,5,6,7,8"
	end

	if (db.sortAlphabetically) then
		sortingMethod = "NAME"
	else
		sortingMethod = "INDEX"
	end

	local limit = db.maxColumns
	local orientation = db.orientation
	local growth = db.growth
	local sortingDir = db.sortDirection

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
			columnSpacing = db.x
		else
			point = directions[growth]
			columnAnchorPoint = "LEFT"
			maxColumns = 1
			unitsPerColumn = maxMembers
			columnSpacing = db.y
		end
	end

	local clickCastString = CC:GetInitString("", db.clickcast)
	local initialConfigFunction = ([[
		local header = self:GetParent()
		local frames = table.new()
		table.insert(frames, self)
		self:GetChildList(frames)
		for i = 1, #frames do
			local frame = frames[i]
			frame:SetWidth(%d)
			frame:SetHeight(%d)
			frame:SetAttribute('*type1', 'target')
			frame:SetAttribute('*type2', 'togglemenu')
			RegisterUnitWatch(frame)
			%s
		end
	]]):format(db.size.width, db.size.height, clickCastString)

    header:SetAttribute("showPlayer", db.showPlayer)
    header:SetAttribute("showSolo", false)
    header:SetAttribute("show"..container.name, true)
    header:SetAttribute("yOffset", db.y)
    header:SetAttribute("xOffset", db.x)
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

	RegisterAttributeDriver(header, 'state-visibility', db.visibility)
end

function Group:SimulateTags(frame)
    -- for i = 1, frame.tags:len() do 
    --     for x = 1, frame.orderedElements:len() do
    --         frame.orderedElements[x]:Update(UnitEvent.UPDATE_TAGS, frame.tags[i], "UNIT_HEALTH", "player")
    --     end
    --     A:FormatTag(tag)
    --     tag:SetText(tag.replaced)
    -- end
end

function Group:Update(...)
	local this = self
    local self, event, arg2, arg3, arg4, arg5 = ...
    local db = self.db
    
    local simulating = arg4 == "SIMULATE"
    if (simulating) then
    	A.groupSimulating = arg2.name
    end

    if (not self.super) then
    	A:SetUnitMeta(self)
	end
	
	self.super:Update(self, UnitEvent.UPDATE_IDENTIFIER)

	local unit = self.unit or arg3

	if (not UnitExists(unit)) then
		return
	end

	self.super:Update(...)

    -- Update player specific things based on the event
    if (event == UnitEvent.UPDATE_DB) then

        if (not simulating) then
        	Group:UpdateHeader(arg2)
        end

        if (not InCombatLockdown()) then
            self:SetSize(db.size.width, db.size.height)
            A.general.clickcast:Setup(self, db.clickcast)
        end

        if (not self.tags) then
            self.tags = A:OrderedMap()
        end

        for i = 1, self.tags:len() do
            if (not db.tags.list[self.tags(i)]) then
                if (self.tags[i]) then
                    self.tags[i]:Hide()
                end
                self.tags[i] = nil
            end
        end

        for name,tag in next, db.tags.list do
            Units:Tag(self, name, tag)
        end

        if (not self.orderedElements) then
    		self.orderedElements = A:OrderedMap()
    	end

    	if (not self.Update) then
		    self.Update = function(self, ...)
		        Group:Update(self, ...)
		    end
    	end

    	U:CreateBackground(self, db)

    	if (not simulating) then
            for i = 1, self.orderedElements:len() do
                self.orderedElements[i]:Update(event, unit)
            end

			self:ForceTagUpdate()
	    end
    elseif (event == UnitEvent.UPDATE_GROUP) then
    	if (not simulating) then

            for i = 1, self.orderedElements:len() do
                self.orderedElements[i]:Update(event, unit)
            end

			self:ForceTagUpdate()
	    end
    end
end

A.Group = Group