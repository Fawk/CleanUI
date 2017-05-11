BINDING_HEADER_CLEANUI = GetAddOnMetadata(..., "Title")

local AddonName, Args = ...
local media = LibStub("LibSharedMedia-3.0")

local Addon = LibStub("AceAddon-3.0"):NewAddon(AddonName, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
Addon.callbacks = Addon.callbacks or LibStub("CallbackHandler-1.0")
Addon.frames, Addon["Modules"], Addon["Elements"], Addon.options = {}, {}, {}, {}
Addon.debugging = true

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

function Addon:OnInitialize()

	Addon.db = Addon.Database:CreateDatabase()

	local uiscale = GetCVar("uiscale") or 0.71
	local h, w = GetScreenHeight() or 1080, GetScreenWidth() or 1920
	SCREEN_HEIGHT = math.floor(h / uiscale)
	SCREEN_WIDTH = math.floor(w / uiscale)

	self.frameParent = CreateFrame("Frame", Addon:GetName().."_MainContainer", UIParent, 'SecureHandlerStateTemplate')
	RegisterStateDriver(self.frameParent, "visibility", "[petbattle] hide; show")
	self.frameParent:SetSize(UIParent:GetSize())
	self.frameParent:SetFrameLevel(UIParent:GetFrameLevel())
	self.frameParent:SetAllPoints(UIParent)
    
    self.hiddenFrame = CreateFrame("Frame")
    self.hiddenFrame:Hide()

	local profile = Addon["Modules"]["Profile"]

	profile:Init(Addon.db)
	profile:Load()

	Addon:Debug("Loaded")
end

function Addon:OnEnable()

	local E, T, Options = Addon.enum, Addon.Tools, Addon.Options

	local options, playerOptions, opts, barOptions = Addon:OrderedTable(), Addon:OrderedTable(), Addon:OrderedTable(), Addon:OrderedTable()
  
  local testOption = Addon:OptionBuilder()
                      :withId("TestId")
                      :withName("TestName")
                      :withType("Group")
                      :addItem("Item")
                      :addChildren(Addon:OrderedTable())
                      :build()
                      
	barOptions:add(Options:CreateGroup(O["Player.Position"], "Position", "The position of the player health bar", 1, nil, nil, 
		Options:PositionOptions({ 
			O["Player.Position.LocalPoint"],
			O["Player.Position.RelativeTo"],
			O["Player.Position.Point"],
			O["Player.Position.OffsetX"],
			O["Player.Position.OffsetY"],
		}, "player", "health bar", {{ "Player", "Player" }, { "Power", "Power" }})))
	barOptions:add(Options:CreateGroup(O["Player.Health.Size"], "Size", "The size of the player health bar", 1, nil, nil, (function() 
		local size = Addon:OrderedTable()
		size:add(Options:CreateToggle(O["Player.Health.Size.MatchWidth"], "Match width", "Match width towards relative frame", E.directions.H, 1, nil))
		size:add(Options:CreateToggle(O["Player.Health.Size.MatchHeight"], "Match height", "Match height towards relative frame", E.directions.H, 1, nil))
		size:add(Options:CreateSlider(O["Player.Health.Size.Width"], "Width", "Set the width of the player health bar", E.directions.H, 50, 500, 250, 1, nil))
		size:add(Options:CreateSlider(O["Player.Health.Size.Height"], "Height", "Set the height of the player health bar", E.directions.H, 1, 500, 100, 1, nil))
		return size
	end)()))

	playerOptions:add(Options:CreateGroup(O["Player.Size"], "Size", "The size of the player frame", 1, nil, nil, (function()
		local size = Addon:OrderedTable()
		size:add(Options:CreateSlider(O["Player.Size.Width"], "Width", "Set the width of the player frame", E.directions.H, 50, 500, 250, 1, nil))
		size:add(Options:CreateSlider(O["Player.Size.Height"], "Height", "Set the height of the player frame", E.directions.H, 1, 500, 100, 1, nil))
		return size
	end)()))
	playerOptions:add(Options:CreateGroup(O["Player.Health"], "Health", "Health bar of the player frame", 1, "dropdown", nil, barOptions))

	opts:add(Options:CreateGroup(O["Player"], "Player", "This is a collection of player options", 1, "dropdown", nil, playerOptions))
	opts:add(Options:CreateGroup(O["Minimap"], "Minimap", "This is a collection of minimap options", 1, nil, nil, (function()
       local minimapOptions = Addon:OrderedTable()
       minimapOptions:add(Options:CreateSlider(O["Minimap.Size"], "Size", "Set the size of the minimap", E.directions.H, E.minimap.min, E.minimap.max, 250, 1))
       return minimapOptions
	end)()))

	options:add(Options:CreateGroup(O["Options"], "Options", "Collection of options", 1, "dropdown", nil, opts))

	local optionsWindow = CreateFrame("Frame", "CleanUI-OptionsWindow", UIParent)
	optionsWindow:SetBackdrop(E.backdrops.buttonroundborder)
	optionsWindow:SetBackdropColor(0.10, 0.10, 0.10, 1)
	optionsWindow:SetBackdropBorderColor(0.33, 0.33, 0.33, 1)
	optionsWindow:SetSize(550, 450)
	optionsWindow:SetPoint(E.regions.C)
	optionsWindow:RegisterForDrag("LeftButton")
	optionsWindow:SetScript("OnDragStart", function(self) if self:IsMovable() then self:StartMoving() end end)
	optionsWindow:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	optionsWindow:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
	optionsWindow:SetMovable(true)

	optionsWindow:Hide()

	local optionsContainer = self.OptionsContainer
	optionsContainer:CreateOptions(optionsWindow, options)

	for modName, module in pairs(self.modules) do
		if module.Init then module:Init() end
	end

	Addon:SetStyle()
    
    local minimapConfig = Addon["Profile"]["Options"]["Minimap"]

	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetAllPoints(Minimap)
	frame:SetSize(minimapConfig.Size, minimapConfig.Size)

	--local grid = Addon.Grid:parseDBGrid("Minimap", frame)
    
    frame:Hide()

	local buildText = Addon.TextBuilder
    
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
end

function Addon:Update()
	for key, frame in pairs(self.frames) do
		frame:UpdateFrame()
	end
end

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
