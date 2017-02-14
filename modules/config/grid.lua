local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local E = A.enum
local buildText = A.TextBuilder
local buildButton = A.ButtonBuilder

print("Creating grid")

local function isSamePreset(frame, key)
	if frame and frame.currentPreset then
		return frame.currentPreset:GetName() == key
	end
	return false
end

local function getMoneyString()
	local m = GetMoney()
	local g, s, c = floor(abs(m / 10000)), floor(abs(mod(m / 100, 100))), floor(abs(mod(m, 100)))
	return string.format("%dg %ds %dc", g, s, c)
end

local function getIlvl()
	return select(2, GetAverageItemLevel())
end

local presets = {
	["Item Level"] = {
		apply = function(frame)

			local function update(f)
				local value = f.currentPreset.value
				value:SetText(getIlvl())
			end

			local preset = frame.currentPreset
			if preset and preset:GetName() == "Item Level" then
				update(frame)
				return
			end

			local ilvl = CreateFrame("Frame", "Item Level", frame)
			ilvl:SetAllPoints(frame)

			local desc = buildText(ilvl, 30):atTop():y(-5):build()
			local value = buildText(ilvl, 20):alignWith(desc):atTop():againstBottom():y(-3):build()

			desc:SetText("Item Level")
			value:SetText(getIlvl())

			ilvl.value = value
			frame.currentPreset = ilvl

			ilvl:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
			ilvl:RegisterEvent("PLAYER_ENTERING_WORLD")
			ilvl:RegisterEvent("ZONE_CHANGED")
			ilvl:RegisterEvent("ZONE_CHANGED_INDOORS")
			ilvl:RegisterEvent("ZONE_CHANGED_NEW_AREA")

			ilvl:SetScript("OnEvent", function(self, event, ...)
				update(self:GetParent())
			end)
		end,
		update = function(frame, ilvl)
			local value = frame.currentPreset.value
			value:SetText(tostring(ilvl))
		end
	},
	["Gold"] = {
		getView = function(self, frame)
			local gold = CreateFrame("Frame", nil, frame)
			gold:SetAllPoints(frame)

			local desc = buildText(gold, 30):atCenter():y(3):build()
			local value = buildText(gold, 20):alignWith(desc):atTop():againstBottom():y(-3):build()

			desc:SetText(L["Gold"])
			value:SetText(getMoneyString())

			gold.value = value
			frame.currentPreset = gold

			gold:RegisterEvent("PLAYER_MONEY")
			gold:SetScript("OnEvent", function(self, event, ...)
				self.value:SetText(getMoneyString())
			end)

			frame.content = gold
			frame.content:Show()

			return "Gold", {}, nil
		end
	},
	["Order Resources"] = { -- CurrencyId: 1220
		apply = function(frame)
			local _,amount,texture,_,_,totalMax = GetCurrencyInfo(1120)
		end
	},
	["Artifact Power"] = { -- Display artifact level and min/max and percentage
		--
		--	 Artifact Level
		--         28
		--      573k/889k
		--        64.4%
		--
	},
	["Artifact Knowledge"] = { -- CurrencyId: 1171
		apply = function(frame)
			local _,amount,texture = GetCurrencyInfo(1171)
		end
	},
	["Seal of Broken Faith"] = { -- Display current amount and limit this week e.g: 5/6 (3/3) - CurrencyId: 1273
		apply = function(frame)

			local _,amount,texture,earned,weeklyMax,totalMax = GetCurrencyInfo(1273)

			local seal = CreateFrame("Frame", "Seal of Broken Faith", frame)

			local desc = buildText(seal, 12):alignWith(seal):atCenter():y(3):build()
			local value = buildText(seal, 12):alignWith(desc):atTop():againstBottom():y(-3):build()

			seal:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
			seal:SetScript("OnEvent", function(self, event, ...)
				update(self:GetParent())
			end)

		end,
		update = function(frame)
			local _,amount,texture,earned,weeklyMax,totalMax = GetCurrencyInfo(1273)
			local value = frame.currentPreset.value
			value:SetText(string.format("%d/%d (%d/%d)", amount, totalMax, earned, weeklyMax))
		end
	}
}

local Grid = {}

-- grid = { 
--     parent = Frame,
--     previousButton = Button,
--     rows = {
--         column = {
--             rows = { ... },
--             previousButton = Button,
--             getView = function() return "Name" end
--         },
--         column = {
--             getView = function() return ... end
--         }
--     }
-- }
-- 
--
--
--

local function createDropdown(container, column, grid)
	if grid == nil or column == nil then return end

	local name, options = column:getView()

	if grid.dropdown and grid.dropdown:IsShown() then
		grid.dropdown:Hide()
	end

	if name == nil or options == nil then return end

	local dropdown = CreateFrame("Frame", nil, UIParent)
	dropdown:SetBackdrop(E.backdrops.buttonroundborder)
	dropdown:SetBackdropBorderColor(0, 0, 0, 1)
	dropdown:SetBackdropColor(0.2, 0.2, 0.2, 1)
	dropdown:SetFrameStrata("HIGH")
	dropdown:SetFrameLevel(2)
	dropdown:SetWidth(250)

	local height, cachedPresets = 25, {}

	local activeTitle = buildText(dropdown, 12):atTop():againstTop():build()
	activeTitle:SetHeight(25)
	activeTitle:SetText(name)

	local optionsField = CreateFrame("Frame", nil, dropdown)
	optionsField:SetSize(dropdown:GetWidth(), 1)
	optionsField:SetPoint("TOP", activeTitle, "BOTTOM", 0, 0)
	for k, option in next, options do
		-- Add options and height
	end
	height = height + optionsField:GetHeight()

	local relative = optionsField
	for key, preset in next, presets do
		if key ~= name then
			local buttonBuilder = buildButton(dropdown):alignWith(relative):onClick(function(self, button, down) 
				-- Change the content of the column in the grid
				print("Change content of column and grid to: ", key)

				container.content:Hide()

				if presets[key] then
					presets[key]:getView(container)
				end

				dropdown:Hide()
				grid:Replace(name, key)
			end)

			buttonBuilder:alignConditional(function(self) 
				self:atTop()
				if relative == optionsField then
					self:againstTop()
				else
					self:againstBottom()
				end
			end)
			
			local button = relative == optionsField and buttonBuilder:atTop():againstTop():build() or buttonBuilder:atTop():againstBottom():build()

			button:SetSize(dropdown:GetWidth(), 25)
			button:SetBackdrop(E.backdrops.buttonroundborder)
			button:SetBackdropBorderColor(0, 0, 0, 1)
			button:SetBackdropColor(0.5, 0.5, 0.5, 1)
			button:SetFrameLevel(3)

			local nameText = buildText(button, 12):alignAll():build()
			nameText:SetText(key)
			
			height = height + 25
			relative = button
		end
	end

	dropdown:SetHeight(height)
	local cx, cy = GetCursorPosition()
	dropdown:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", (cx / 0.71) - 10, (cy / 0.71) + 10)

	dropdown.count = 0
	dropdown:SetScript("OnUpdate", function(self, elapsed)
		self.count = self.count + elapsed
		if self.count > 0.5 then
			if not self:IsMouseOver() then
				self:Hide()
			end
			self.count = 0
		end
	end)

	grid.dropdown = dropdown
end

function Grid:Build(grid)

	local rowAnchor = grid.parent

	for rid, row in next, grid.rows do

		local width = grid.parent:GetWidth() / #row

		local rowFrame = CreateFrame("Frame", nil, grid.parent)
		rowFrame:SetPoint("TOPLEFT", rowAnchor, rid == 1 and "TOPLEFT" or "BOTTOMLEFT")
		rowFrame:SetSize(width, width)

		local relative = rowFrame

		for cid, column in next, row do
			
			if not grid.parent then
				grid.parent = grid.previousButton.previousGrid.parent
			end
			
			local button = CreateFrame("Button", nil, rowFrame)
			button:SetPoint("TOPLEFT", relative, cid == 1 and "TOPLEFT" or "TOPRIGHT")
			button:SetSize(width, width)
			button:SetBackdrop({ bgFile = E.backdrops.editbox.bgFile, insets = { top = 3, right = 3, bottom = 3, left = 3 }})
			button:SetBackdropColor(0.05, 0.05, 0.05, 0.8)
			button:RegisterForClicks("AnyUp")
			button.content = CreateFrame("Frame", "CONTENT", button)
			button.content:SetSize(width, width)
			button.content:SetAllPoints()

			if column.rows then
				button:SetScript("OnClick", function(selfObj, button, down)
					if button == "LeftButton" and not down then
						grid.previousButton.previousGrid = grid
						column.previousButton = grid.previousButton
						self:Build(column)
					end
				end)
			end

			local name, options, view = column:getView()
			local text = buildText(button.content, 14):alignAll():build()
			text:SetText(name)

			if grid.singleLevel then
				button:SetScript("OnClick", function(selfObj, button, down)
					if button == "RightButton" then
						-- Display dropdown containing current template options and a list of other possible choices of template
						-- E.g.
						--
						-- [X] Gold
						-- 
						-- Custom format: [Textbox]
						-- Display icons: [Checkbox]
						--
						-- --------------------------------
						--
						-- [ ] Item Level
						-- [ ] Artifact Power
						-- [ ] Artifact Knowledge
						-- [ ] Order Resources
						-- ...
						createDropdown(selfObj, column, grid)
					end
				end)
			end

			relative = button
		end

		rowAnchor = rowFrame
	end
end

function Grid:GeneratePreviousButton(previousGrid, parent)
	local back, gridObj = CreateFrame("Button", nil, parent), self
	back.previousGrid = previousGrid
	back:SetScript("OnClick", function(selfObj, button, down)
		if button == "LeftButton" and not down then
			gridObj:Build(selfObj.previousGrid)
		end
	end)
	return back
end

function Grid:Create(grid, isSingleLevel)
	assert(type(grid) == "table")
	if not isSingleLevel then
		self.previousButton = self:GeneratePreviousButton(nil, grid.parent)
	else
		grid.singleLevel = true
	end
	return self:Build(grid)
end

A.Grid = Grid