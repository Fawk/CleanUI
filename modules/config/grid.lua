local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local E = A.enum

local function isSamePreset(frame, key)
	if frame and frame.currentPreset then
		return frame.currentPreset:GetName() == key
	end
	return false
end

local Keys = {
	["Gold"],
	["Item Level"],
}

local function getMoneyString()
	local m = GetMoney()
	local g, s, c = floor(abs(m / 10000)), floor(abs(mod(m / 100, 100))), floor(abs(mod(m, 100)))
	return string.format("%dg %ds %dc", g, s, c)
end

local function getIlvl()
	return select(2, GetAverageItemLevel())
end

local templates = {
	Text = function(frame, options)
		local ret, prev = {}, nil
		for text, next in options do
			local value = frame:CreateFontString(nil, "OVERLAY")
			value:SetFont(media:Fetch("font", "FrancophilSans"), text.size, "NONE")
			local points = text.points
			if points and type(points) == "table" then
				if points.lp and points.relative then
					local relative = points.relative
					if relative == "parent" then
						relative = frame
					else if relative == "prev" then
						if prev == nil then
							relative = frame
						else
							relative = prev
						end
					end
					value:SetPoint(points.lp, relative, points.p and points.p or points.lp, points.x or 0, points.y or 0)
				else
					if points.all then
						value:SetAllPoints(frame)
					else
						for point, next in points do
							value:SetPoint(point)
						end
					end
				end
			end
			prev = value
			table.insert(ret, value)
		end
		return unpack(ret)
	end,
}

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

			local desc = A:TextBuilder()
							:withSize(11)
							:withLocalPoint("CENTER")
							:withRelative("parent")
							:withOffsetY(-10)
							:build()

			local value = A:TextBuilder()
							:withSize(14)
							:withLocalPoint(E.regions.T)
							:withPoint(E.regions.B)
							:withRelative(desc)
							:withOffsetY(-3)
							:build()

			local test = A:TextBuilder(ilvl, 14)
							:alignTop()
							:alignBottom()
							:relative(desc)
							:offsetY(-3)
							:build()

			local test2 = A:TextBuilder(ilvl, 14)
							:atTop(true)
							:y(-5)
							:build()

			local desc, value = templates.Text(
				ilvl,
				{
					size = 11,
					points = { lp = "CENTER", relative = "parent", y = -10 } 
				},
				{
					size = 14,
					points = { lp = "TOP", p = "BOTTOM", relative = "prev", y = -3 } 
				}
			)
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
		init = function(frame, key)

			if frame.currentPreset and isSamePreset(frame, key) then
				frame.currentPreset.value:SetText(getMoneyString())
				return
			else
				frame.currentPreset:Hide()
			end

			local gold = CreateFrame("Frame", key, frame)
			gold:SetAllPoints(frame)

			local desc = A:TextBuilder(gold, 12):atTop(true):y(-5):build()
			local value = A:TextBuilder(gold, 12):alignWith(desc):atTop(true):againstBottom(true):y(-3):build()

			desc:SetText(L["Gold"])
			value:SetText(getMoneyString())

			gold.value = value
			frame.currentPreset = gold

			gold:RegisterEvent("PLAYER_MONEY")
			gold:SetScript("OnEvent", function(self, event, ...)
				self.value:SetText(getMoneyString())
			end)

		end
	},
	["Order Resources"] = { -- CurrencyId: 1220
		local _,amount,texture,_,_,totalMax = GetCurrencyInfo(1120)
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
		local _,amount,texture = GetCurrencyInfo(1171)
	},
	["Seal of Broken Faith"] = { -- Display current amount and limit this week e.g: 5/6 (3/3) - CurrencyId: 1273
		local _,amount,texture,earned,weeklyMax,totalMax = GetCurrencyInfo(1273)
		apply = function(frame)

			local _,amount,texture,earned,weeklyMax,totalMax = GetCurrencyInfo(1273)

			local seal = CreateFrame("Frame", "Seal of Broken Faith", frame)

			local desc, value = templates.Text(
				seal,
				{
					size = 12,
					points = { lp "CENTER", relative = "parent", y = 3 }
				},
				{
					size = 12,
					points = { lp = "TOP", p = "BOTTOM", relative = "prev", y = -3}
				}
			)

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

function Grid:Build(grid)
	for row in next, grid.rows do
		for column in next, row 
			
			if not grid.parent then
				grid.parent = grid.previousButton.previousGrid.parent
			end
			
			local button = CreateButton("Button", nil, grid.parent)
			
			if column.rows do
				button:SetScript("OnClick", function(selfObj, button, down)
					if button == "LeftButton" and not down then
						grid.previousButton.previousGrid = grid
						column.previousButton = grid.previousButton
						self:Build(column)
					end
				end)
			end

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
					end
				end)
			end
		end
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
		self.singleLevel = true
	end
	return self:Build(grid)
end