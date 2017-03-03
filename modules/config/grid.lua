local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local E = A.enum
local buildText = A.TextBuilder
local buildButton = A.ButtonBuilder
local GetEquippedArtifactInfo = _G.C_ArtifactUI.GetEquippedArtifactInfo
local GetCostForPointAtRank = _G.C_ArtifactUI.GetCostForPointAtRank
local format = string.format
local ts = tostring
local select = select
local tinsert = table.insert

A:Debug("Creating grid")

local OldCreateFrame = CreateFrame
local function CreateFrame(type, name, parent)
	local frame = OldCreateFrame(type, name, parent)
	function frame:delayedCall(func, delta)
		self.timer = 0
	    self:SetScript("OnUpdate", function(self, elapsed)
	        self.timer = self.timer + elapsed
	        if self.timer > delta then
	        	func()
	            self.timer = 0
	            self:SetScript("OnUpdate", nil)
	        end
	    end)
	end
	return frame
end

local function getValue(v)
    if v > 1000 then
        if v > 1000000 then
            return format("%.1f", v/1000000).."M"
        end
        return format("%.1f", v/1000).."k"
    end
    return ts(v)
end

local function getPerc(v)
    return format("%.1f", v*100).."%"
end

local function getMoneyString()
	local m = GetMoney()
	local g, s, c = getValue(floor(abs(m / 10000))), floor(abs(mod(m / 100, 100))), floor(abs(mod(m, 100)))
	return format("%sg %ds %dc", g, s, c)
end

local function getIlvl()
	return select(2, GetAverageItemLevel())
end

local presets = {
	["Item Level"] = {
		getView = function(self, frame)

			local ilvl = CreateFrame("Frame", nil, frame)
			ilvl:SetAllPoints(frame)

			local desc = buildText(ilvl, 0.8):atTop():y(-5):build()
			local value = buildText(ilvl, 0.5):below(desc):y(-3):build()

			desc:SetText("Item Level")
			value:SetText(getIlvl())

			ilvl.value = value
			ilvl:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
			ilvl:RegisterEvent("PLAYER_ENTERING_WORLD")
			ilvl:RegisterEvent("ZONE_CHANGED")
			ilvl:RegisterEvent("ZONE_CHANGED_INDOORS")
			ilvl:RegisterEvent("ZONE_CHANGED_NEW_AREA")
			ilvl:SetScript("OnEvent", function(self, event, ...)
				self.value:SetText(getIlvl())
			end)

			frame.content = ilvl
			frame.content:Show()
		end,
	},
	["Gold"] = {
		getView = function(self, frame)
			local gold = CreateFrame("Frame", nil, frame)
			gold:SetAllPoints(frame)

			local desc = buildText(gold, 0.5):atCenter():y(3):build()
			local value = buildText(gold, 0.9):below(desc):y(-3):build()

			desc:SetText(L["Gold"])
			value:SetText(getMoneyString())

			gold.value = value
			gold:RegisterEvent("PLAYER_MONEY")
			gold:SetScript("OnEvent", function(self, event, ...)
				self.value:SetText(getMoneyString())
			end)

			frame.content = gold
			frame.content:Show()
		end
	},
	["Order Resources"] = { -- CurrencyId: 1220
		getView = function(self, frame)
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
		getView = function(self, frame)
            
            local function getArtifactInfo()
                local _,_,_,_,current,rank = GetEquippedArtifactInfo()
                if not current or not rank then
                   return nil
                end
                local max = GetCostForPointAtRank(rank)
                return current, max, rank
            end

            local ap = CreateFrame("Frame", nil, frame)
			ap:SetAllPoints(frame)

			local desc = buildText(ap, 0.8):atTop():y(-10):build()
            local rankText = buildText(ap, 0.2):below(desc):y(-3):build()
			local value = buildText(ap, 0.7):below(rankText):y(-3):build()
            local perc = buildText(ap, 0.5):below(value):y(-3):build()

			ap.value = value
			ap.rank = rankText
			ap.perc = perc
			ap:RegisterEvent("ARTIFACT_XP_UPDATE")
			ap:SetScript("OnEvent", function(self, event, ...)
                local c, m, r = getArtifactInfo()
                self.rank:SetText(r)
                self.value:SetText(getValue(c).."/"..getValue(m))
                self.perc:SetText(getPerc(c/m))
			end)
			
			desc:SetText(L["Artifact Level"])
            ap:delayedCall(function(self)
                local current, max, rank = getArtifactInfo()
                self.rank:SetText(rank)
                self.value:SetText(getValue(current).."/"..getValue(max))
                self.perc:SetText(getPerc(current/max))
            end, 1)

			frame.content = ap
			frame.content:Show()
		end
	},
	["Artifact Knowledge"] = { -- CurrencyId: 1171
		getView = function(self, frame)
			local _,amount,texture = GetCurrencyInfo(1171)
		end
	},
	["Seal of Broken Faith"] = { -- Display current amount and limit this week e.g: 5/6 (3/3) - CurrencyId: 1273
		getView = function(self, frame)

			local _,amount,texture,earned,weeklyMax,totalMax = GetCurrencyInfo(1273)

			local seal = CreateFrame("Frame", "Seal of Broken Faith", frame)

			local desc = buildText(seal, 0.3):alignWith(seal):atCenter():y(3):build()
			local value = buildText(seal, 0.3):below(desc):y(-3):build()

			desc:SetText(L["Seals"])
			value:SetText(format("%d/%d (%d/%d)", amount, totalMax, earned, weeklyMax))

			seal:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
			seal:SetScript("OnEvent", function(self, event, ...)
				update(self:GetParent())
			end)

		end
	}
}

local Grid = {}

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
function A:CreateDropdown(column)
	local grid = column.grid

	if grid == nil or column == nil then return end

	local name, options = column.view, {}

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

	local activeTitle = buildText(dropdown, 0.3):atTop():againstTop():build()
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

				column.content:Hide()

				if presets[key] then
					presets[key]:getView(column)
				end

				dropdown:Hide()
				local updatedGrid = grid:singleLayerReplace(A:ColumnBuilder():withView(key):build(), column.index)

				if grid.dbKey then
					A["Profile"]["Options"]["Grids"][dbKey] = A.Grid:composeDb(updatedGrid)
				end
			end)

			buttonBuilder:atTop()
			if relative == optionsField then
				buttonBuilder:againstTop()
			else
				buttonBuilder:againstBottom()
			end
			
			local button = buttonBuilder:build()

			button:SetSize(dropdown:GetWidth(), 25)
			button:SetBackdrop(E.backdrops.buttonroundborder)
			button:SetBackdropBorderColor(0, 0, 0, 1)
			button:SetBackdropColor(0.5, 0.5, 0.5, 1)
			button:SetFrameLevel(3)

			local nameText = buildText(button, 0.3):alignAll():build()
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

function Grid:composeDBGrid(grid)
	local s = { isSingleLevel = grid.isSingleLevel, rows = {} }
	for rowId = 1, grid.rows:count() do
		local row, newRow = grid.rows:get(rowId), { columns = {} }
		for columnId = 1, row.columns:count() do
			local column = row.columns:get(columnId)
			local newColumn = {
				view = type(column.view) == "function" and (function(container) return column:view(container) end) or column.view
			}
			tinsert(newRow.columns, newColumn)
		end
		tinsert(s.rows, newRow)
	end
	return s
end

function Grid:parseDBGrid(key, parent)
	local grid = A["Profile"]["Options"]["Grids"][key]
	local g = A:GridBuilder(parent, grid.isSingleLevel, key)
	for _,row in next, grid.rows do
		local rowBuilder = A:RowBuilder()
		for _,column in next, row.columns do
			rowBuilder:addColumn(A:ColumnBuilder()
				:withView(type(column) == "function" and (function(container) return column(container) end) or column):build())
		end
		g:addRow(rowBuilder:build())
	end
	return g:build(function(gg) A.Grid:Build(gg) end)
end

function Grid:Build(grid)
	for rowId = 1, grid.rows:count() do

		local row = grid.rows:get(rowId)
		local width = grid.parent:GetWidth() / row.columns:count()

		for columnId = 1, row.columns:count() do
			
			local column = row.columns:get(columnId)

			if not grid.parent then
				grid.parent = grid.previousButton.previousGrid.parent
			end

			column:SetBackdrop({ bgFile = E.backdrops.editbox.bgFile, insets = { top = 3, right = 3, bottom = 3, left = 3 }})
			column:SetBackdropColor(0.05, 0.05, 0.05, 0.8)
			column:RegisterForClicks("AnyUp")
			column.content = CreateFrame("Frame", nil, column)
			column.content:SetAllPoints()

			-- if column.rows then
			-- 	column:SetScript("OnClick", function(selfObj, button, down)
			-- 		if button == "LeftButton" and not down then
			-- 			grid.previousButton.previousGrid = grid
			-- 			column.previousButton = grid.previousButton
			-- 			self:Build(column)
			-- 		end
			-- 	end)
			-- end

			if type(column.view) == "function" then
				local name, options = column:view()
			else
				presets[column.view]:getView(column)
			end
			-- local text = buildText(column.content, 14):alignAll():build()
			-- text:SetText(name)
		end
	end
end

function Grid:GeneratePreviousButton(previousGrid, parent)
	local back, grid = CreateFrame("Button", nil, parent), self
	back.previousGrid = previousGrid
	back:SetScript("OnClick", function(self, button, down)
		if button == "LeftButton" and not down then
			grid:Build(self.previousGrid)
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