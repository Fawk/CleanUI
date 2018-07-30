local AddonName, Args = ...
local media = LibStub("LibSharedMedia-3.0")

local Addon = LibStub("AceAddon-3.0"):NewAddon(AddonName, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
Addon.callbacks = Addon.callbacks or LibStub("CallbackHandler-1.0")
Addon.frames, Addon.modules, Addon.general, Addon.options = {}, Args:OrderedMap(), Args:OrderedMap(), {}
Addon.debugging = true
Addon.noop = function() end

Addon.pools = CreatePoolCollection();

Addon.OrderedTable = Args.OrderedTable
Addon.OrderedMap = Args.OrderedMap

Addon["Shared Elements"] = Args:OrderedMap()
Addon["Player Elements"] = Args:OrderedMap()

local L = LibStub("AceLocale-3.0"):GetLocale(AddonName, false)

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

function Addon:SetScale()

	local resolution = {GetScreenResolutions()}
	resolution = resolution[GetCurrentResolution()]
	local matches = {}
	resolution:gsub("%d+", function(match) table.insert(matches, match) end)
	
	local w, h = unpack(matches)
	SCREEN_HEIGHT = h
	SCREEN_WIDTH = w

	local newScale = 768 / h

	UIParent:SetScale(newScale)
end

function Addon:OnInitialize()

	self.db = self.dbProvider:New(AddonName.."_DB", self.defaults)

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

	self:Debug("Loaded")
end

function Addon:OnEnable()

	local E, T, Options, Units = self.enum, self.Tools, self.Options, self.Units

    local profile = self.modules["Profile"]

	profile:Init(self.db)
	profile:Load()

	self:SetScale()

	self:Init()
	--self:SetStyle()

    Addon:CreatePrefs(Addon["Profile"]["Options"])

	collectgarbage("collect");
	collectgarbage("collect");
end

function Addon:Init()

	self.general:foreach(function(key, module)
        if (module.Init) then
            module:Init()
        end
    end)

	self.modules:foreach(function(key, module)
		if module.Init then
	        local unit = module:Init()
            if (unit) then
            	if (unit.hasMultipleUnits) then
            		unit:InitUnits(function(self, uf)
            			Addon["Shared Elements"]:foreach(function(key, element)
	                    	element:Init(uf)
	                	end)
            		end)
            	else
	                Addon["Shared Elements"]:foreach(function(key, element)
	                    element:Init(unit)
	                end)
	            end
            end
        end
	end)
end

function Addon:UpdateDb()
    -- General
	self.general:foreach(function(key, module)
        if (module.Update) then
            module:Update(UnitEvent.UPDATE_DB)
        end
    end)

    -- Units
	self.modules:foreach(function(key, module)
    	if (module.Update) then
        	local unit = Addon.Units:Get(key:fupper())
        	if (unit) then
	        	if (unit.UpdateUnits) then
	        		unit:UpdateUnits(UnitEvent.UPDATE_DB)
	        	else
	            	if (unit.Update) then
	            		unit:Update(UnitEvent.UPDATE_DB)
	            	end
	        	end
	        end
	    end
    end)
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
