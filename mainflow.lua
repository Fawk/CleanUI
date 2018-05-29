local AddonName, Args = ...
local media = LibStub("LibSharedMedia-3.0")

local Addon = LibStub("AceAddon-3.0"):NewAddon(AddonName, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
Addon.callbacks = Addon.callbacks or LibStub("CallbackHandler-1.0")
Addon.frames, Addon.modules, Addon.general, Addon.options = {}, {}, {}, {}
Addon.debugging = true

Addon.OrderedTable = Args.OrderedTable

Addon["Elements"] = Args:OrderedTable()
Addon["Shared Elements"] = Args:OrderedTable()

Addon.oUF = Args.oUF or oUF
local oUF = Addon.oUF

local L = LibStub("AceLocale-3.0"):GetLocale(AddonName, false)

local O = {
	["Minimap"] = 0,
	["Minimap.Size"] = 0,
	["Player"] = 0,
	["Target"] = 0,
	["Player.Position"] = 0,
	["Player.Position.LocalPoint"] = 0,
	["Player.Position.Point"] = 0,
	["Player.Position.RelativeTo"] = 0,
	["Player.Position.OffsetX"] = 0,
	["Player.Position.OffsetY"] = 0,
	["Player.Size"] = 0,
	["Player.Size.Width"] = 0,
	["Player.Size.Height"] = 0,
	["Player.Health"] = 0,
	["Player.Health.Size"] = 0,
	["Player.Health.Size.MatchWidth"] = 0,
	["Player.Health.Size.MatchHeight"] = 0,
	["Player.Health.Size.Width"] = 0,
	["Player.Health.Size.Height"] = 0,
	["Options"] = 0,
}	

do
	local function gen()
	   return math.floor(math.random() * 100000)
	end

	local keys = {}

	for k,v in pairs(O) do
		local key = gen()
		while (keys[key]) do
			key = gen()
		end
		keys[key] = true
		O[k] = key
	end
end

Args[1] = Addon
Args[2] = L
Args[3] = O

_G[AddonName] = Args

function Addon:Debug(...)
	if self.debugging then
		local str = ""
		for _,v in pairs({ ... }) do
			if type(v) == "number" then
				str = string.format("%s %d", str, v)
			elseif type(v) == "string" then
				str = string.format("%s %s", str, v)
			else
				str = string.format("%s %s", str, tostring(v))
			end
		end
		print("|cFFFFBB00"..AddonName.."|r:"..str)
	end
end

function Addon:DebugTable ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

Addon:Debug("Created mainflow")

local function setScale()
	local resolution = {GetScreenResolutions()}
	resolution = resolution[GetCurrentResolution()]
	local matches = {}
	resolution:gsub("%d+", function(match) table.insert(matches, match) end)
	
	local w, h = unpack(matches)
	SCREEN_HEIGHT = h
	SCREEN_WIDTH = w
	UIParent:SetScale(768 / h)
end

function Addon:OnInitialize()

	self.db = self.dbProvider:New(AddonName.."_DB", self.defaults)

	local uiscale = GetCVar("uiscale") or 0.71
	local h, w = GetScreenHeight() or 1080, GetScreenWidth() or 1920
	SCREEN_HEIGHT = math.floor(h / uiscale)
	SCREEN_WIDTH = math.floor(w / uiscale)

	setScale()

	self.frameParent = CreateFrame("Frame", Addon:GetName().."_MainContainer", UIParent, 'SecureHandlerStateTemplate')
	RegisterStateDriver(self.frameParent, "visibility", "[petbattle] hide; show")
	self.frameParent:SetSize(UIParent:GetSize())
	self.frameParent:SetFrameLevel(UIParent:GetFrameLevel())
	self.frameParent:SetAllPoints(UIParent)
	--self.frameParent:SetScale(UIParent:GetScale())
    
    self.hiddenFrame = CreateFrame("Frame")
    self.hiddenFrame:Hide()

	self:Debug("Loaded")
end

function Addon:OnEnable()

	local E, T, Options, Units = self.enum, self.Tools, self.Options, self.Units

	setScale()

    -- local functions = {
    --     "SetQuestCurrency",
    --     "SetQuestLogCurrency",
    --     "SetQuestItem",
    --     "SetQuestLogSpecialItem",
    -- }

    -- UnitIsQuestBoss

    -- title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory, isHidden = GetQuestLogTitle(questIndex)

    -- for _,func in next, functions do
    --     hooksecurefunc(GameTooltip, func, function(self, ...)
    --         print(func, self, unpack({ ... }))
    --     end)
    -- end

    -- local f = CreateFrame("Frame")
    -- f:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
    -- f:SetScript("OnEvent", function(self, event, ...)
    --     print(event, unpack({...}))
    --     print(GameTooltip:GetUnit())
    -- end)

	-- local options, playerOptions, opts, barOptions = Addon:OrderedTable(), Addon:OrderedTable(), Addon:OrderedTable(), Addon:OrderedTable()
  
 --  local testOption = Addon:OptionBuilder()
 --                      :withId("TestId")
 --                      :withName("TestName")
 --                      :withType("Group")
 --                      :addItem("Item")
 --                      :addChildren(Addon:OrderedTable())
 --                      :build()
                      
	-- barOptions:add(Options:CreateGroup(O["Player.Position"], "Position", "The position of the player health bar", 1, nil, nil, 
	-- 	Options:PositionOptions({ 
	-- 		O["Player.Position.LocalPoint"],
	-- 		O["Player.Position.RelativeTo"],
	-- 		O["Player.Position.Point"],
	-- 		O["Player.Position.OffsetX"],
	-- 		O["Player.Position.OffsetY"],
	-- 	}, "player", "health bar", {{ "Player", "Player" }, { "Power", "Power" }})))
	-- barOptions:add(Options:CreateGroup(O["Player.Health.Size"], "Size", "The size of the player health bar", 1, nil, nil, (function() 
	-- 	local size = Addon:OrderedTable()
	-- 	size:add(Options:CreateToggle(O["Player.Health.Size.MatchWidth"], "Match width", "Match width towards relative frame", E.directions.H, 1, nil))
	-- 	size:add(Options:CreateToggle(O["Player.Health.Size.MatchHeight"], "Match height", "Match height towards relative frame", E.directions.H, 1, nil))
	-- 	size:add(Options:CreateSlider(O["Player.Health.Size.Width"], "Width", "Set the width of the player health bar", E.directions.H, 50, 500, 250, 1, nil))
	-- 	size:add(Options:CreateSlider(O["Player.Health.Size.Height"], "Height", "Set the height of the player health bar", E.directions.H, 1, 500, 100, 1, nil))
	-- 	return size
	-- end)()))

	-- playerOptions:add(Options:CreateGroup(O["Player.Size"], "Size", "The size of the player frame", 1, nil, nil, (function()
	-- 	local size = Addon:OrderedTable()
	-- 	size:add(Options:CreateSlider(O["Player.Size.Width"], "Width", "Set the width of the player frame", E.directions.H, 50, 500, 250, 1, nil))
	-- 	size:add(Options:CreateSlider(O["Player.Size.Height"], "Height", "Set the height of the player frame", E.directions.H, 1, 500, 100, 1, nil))
	-- 	return size
	-- end)()))
	-- playerOptions:add(Options:CreateGroup(O["Player.Health"], "Health", "Health bar of the player frame", 1, "dropdown", nil, barOptions))

	-- opts:add(Options:CreateGroup(O["Player"], "Player", "This is a collection of player options", 1, "dropdown", nil, playerOptions))
	-- opts:add(Options:CreateGroup(O["Minimap"], "Minimap", "This is a collection of minimap options", 1, nil, nil, (function()
 --       local minimapOptions = Addon:OrderedTable()
 --       minimapOptions:add(Options:CreateSlider(O["Minimap.Size"], "Size", "Set the size of the minimap", E.directions.H, E.minimap.min, E.minimap.max, 250, 1))
 --       return minimapOptions
	-- end)()))

	-- options:add(Options:CreateGroup(O["Options"], "Options", "Collection of options", 1, "dropdown", nil, opts))

	-- local optionsWindow = CreateFrame("Frame", "CleanUI-OptionsWindow", UIParent)
	-- optionsWindow:SetBackdrop(E.backdrops.buttonroundborder)
	-- optionsWindow:SetBackdropColor(0.10, 0.10, 0.10, 1)
	-- optionsWindow:SetBackdropBorderColor(0.33, 0.33, 0.33, 1)
	-- optionsWindow:SetSize(550, 450)
	-- optionsWindow:SetPoint(E.regions.C)
	-- optionsWindow:RegisterForDrag("LeftButton")
	-- optionsWindow:SetScript("OnDragStart", function(self) if self:IsMovable() then self:StartMoving() end end)
	-- optionsWindow:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	-- optionsWindow:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
	-- optionsWindow:SetMovable(true)

	-- optionsWindow:Hide()

	-- local optionsContainer = self.OptionsContainer
	-- optionsContainer:CreateOptions(optionsWindow, options)

    local profile = self.modules["Profile"]

	profile:Init(self.db)
	profile:Load()

	for modName, module in pairs(self.modules) do
		if module.Init then 
	            local unit = module:Init() 
            if (unit) then
                unit:Update(UnitEvent.UPDATE_IDENTIFIER)
                Units:Add(unit)
                Addon["Shared Elements"]:foreach(function(element)
                    element:Init(unit)
                end)
            end
        end
	end

	self:SetStyle()

	local buildText = self.TextBuilder
    
	local function constructControl(type, desc, optionsParent, relative)
		local control = CreateFrame(type, nil, optionsParent)
		local builder = buildText(optionsParent, 0.3):alignWith(relative):atTopLeft()

		if relative == optionsParent then
			builder:againstTopLeft()
		else
			builder:againstBottomLeft()
		end

		local text = builder:build()
		text:SetText(desc)

		control:SetPoint(E.regions.T, text, E.regions.B, 0, 0)

		return control
	end

    Addon:ConstructPreferences(Addon["Profile"]["Options"])

	collectgarbage("collect");
end

function Addon:Update()
	for key, module in pairs(self.modules) do
		if module.Trigger then module:Trigger() end
	end
end

function Addon:UpdateDb()
    -- General
    for key, module in next, self.general do
        if (module.Update) then
            module:Update(UnitEvent.UPDATE_DB)
        end
    end

    -- Units
    for key, module in next, self.modules do
        if (module.Update) then
            module:Update(UnitEvent.UPDATE_DB)
        end
    end
end

local frame = CreateFrame("Frame")
frame.collect = 0
frame:SetScript("OnUpdate", function(self, elapsed)
	Addon:Update()
    self.collect = self.collect + elapsed
    if self.collect > 3 then
        self.collect = 0
    	collectgarbage("collect");
    end
end)


function Addon:OnDisable()

end

function Addon:DebugWindow(tbl, titleText)
	local buildText = Addon.TextBuilder
	local buildButton = Addon.ButtonBuilder
	local buildFrame = Addon.FrameBuilder

	local bd = Addon.enum.backdrops.buttonroundborder
	local parent = buildFrame(UIParent):atCenter():size(800, 600):backdrop(bd, { .10, .10, .10 }, { .33, .33, .33 }):build()
    parent:RegisterForDrag("LeftButton", "RightButton")
    parent:EnableMouse(true)
    parent:SetMovable(true)
    parent:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" and not self.isMoving then
            self:StartMoving();
            self.isMoving = true;
        end
    end)
    parent:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" and self.isMoving then
            self:StopMovingOrSizing();
            self.isMoving = false;
        end
    end)

    local title = buildText(parent, 14):atTopRight():y(-3):x(-3):build()
    title:SetText(titleText)
    
	local anchor = buildFrame(parent):atTopLeft():size(30, 20):build()

	local function sub(tbl, frame)
		for k,v in pairs(tbl) do

			local key = buildButton(frame):atTopLeft():againstBottomRight():y(frame.count and frame.count * -50 or 0):onClick(function(self, button, down)
				if self.children then     
                    local parent = self:GetParent()
					if self.children:IsShown() then
                        self.text:SetTextColor(1, 1, 1)
						self.children:Hide()
					else
                        for i = 1, parent:GetNumChildren() do
                            local child = select(i, parent:GetChildren())
                            if child.children and child.children:IsShown() then
                                child.text:SetTextColor(1, 1, 1)
                                child.children:Hide()
                            end
                        end
                        if self.text then
                            self.text:SetTextColor(1, 0.3, 0.3)
                        end
						self.children:Show()
					end
				end
			end):build()
        
            if frame.count then
                frame.count = frame.count + 1
            end
        
			key:SetSize(80, 20)
			key.text = buildText(key, 14):atLeft():build()
			if type(v) == "table" then
				key.text:SetText(k.." => ")
				local children = buildFrame(key):atTopLeft():againstBottomRight():size(30, 20):build()
                children.count = 0
				key.children = children
                children:Hide()
				sub(v, children)
			else
				key.text:SetText(string.format("%s => %s", k, tostring(v)))
			end
		end
	end

	sub(tbl, anchor)
end
