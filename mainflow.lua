BINDING_HEADER_CLEANUI = GetAddOnMetadata(..., "Title")

local AddonName, Args = ...
local media = LibStub("LibSharedMedia-3.0")

local Addon = LibStub("AceAddon-3.0"):NewAddon(AddonName, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
Addon.callbacks = Addon.callbacks or LibStub("CallbackHandler-1.0")
Addon.frames, Addon["Modules"] = {}, {}
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

	local drawerWidth = 200

	local test = CreateFrame("Button", "TESTBUTTONWOO", UIParent)
	test:SetSize(200, 600)
	test:SetBackdrop(E.backdrops.editbox)
	test:SetBackdropColor(unpack(E.colors.backdrop))
	test:SetBackdropBorderColor(unpack(E.colors.backdropborder))
	test:SetPoint(E.regions.L, UIParent, E.regions.L, -190, 0)
	test:SetClampedToScreen(false)

	test.ag = test:CreateAnimationGroup()
	test.isOpen = false

	test.open = test.ag:CreateAnimation("Translation")
	test.open:SetOffset(200, 0)
	test.open:SetDuration(0.3)
	test.open:SetOrder(1)
	test.open:SetScript("OnFinished", function(self, req)
		test.isOpen = true
		test:ClearAllPoints()
		test:SetPoint(E.regions.L)
		test.ag:Stop()
		test.close:SetOrder(1)
		self:SetOrder(2)
	end)
	test.close = test.ag:CreateAnimation("Translation")
	test.close:SetOffset(-190, 0)
	test.close:SetDuration(0.3)
	test.close:SetOrder(2)
	test.close:SetScript("OnFinished", function(self, req)
		test.isOpen = false
		test:ClearAllPoints()
		test:SetPoint(E.regions.L, UIParent, E.regions.L, -190, 0)
		test.ag:Stop()
		test.open:SetOrder(1)
		self:SetOrder(2)
	end)

	test.time = 0
	test:SetScript("OnUpdate", function(self, elapsed)
		self.time = self.time + elapsed
		if self.time > 0.3 then
			if not self.ag:IsPlaying() and self.forceClose and self.isOpen and not self:IsMouseOver() then
				self.ag:Play()
			end
			self.time = 0
		end
	end)

	test.ag:SetScript("OnPause", function(self)
		self:Finish()
	end)

	test:SetScript("OnLeave", function(self, arg)
		if arg then
			if self.isOpen then
				self.ag:Play()
			else
				self.forceClose = true
			end
		end
	end)

	test:SetScript("OnEnter", function(self, arg)
		if arg then
			if not self.open:IsPlaying() and not self.isOpen then
				self.ag:Play()
			end
		end
	end)


	Addon:SetStyle()

	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetPoint("CENTER")
	frame:SetSize(500, 500)

	local grid = Addon.Grid:parseDBGrid("Test", frame)

	local buildText = Addon.TextBuilder

	local function constructControl(type, desc, optionsParent, relative)
		local control = CreateFrame(type, nil, optionsParent)
		local builder = buildText(optionsParent, 12):alignWith(relative):atTopLeft()

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