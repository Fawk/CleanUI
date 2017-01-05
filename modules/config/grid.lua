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

			local desc = TextBuilder()
							:withSize(11)
							:withLocalPoint("CENTER")
							:withRelative("parent")
							:withOffsetY(-10)
							:build()

			local value = TextBuilder()
							:withSize(14)
							:withLocalPoint(E.regions.T)
							:withPoint(E.regions.B)
							:withRelative(desc)
							:withOffsetY(-3)
							:build()

			local test = TextBuilder(ilvl, 14)
							:alignTop()
							:alignBottom()
							:relative(desc)
							:offsetY(-3)
							:build()

			local function TextBuilder(parent, size)
				local object = {
					size = size
					parent = parent
				}
				function object:build()
					local text = self.parent:CreateFontString(nil, "OVERLAY")
					text:SetFont(media:Fetch("font", "FrancophilSans"), self.size, "NONE")

					if self.alignAll then
						text:SetAllPoints()
					else
						local lp, p, x, y = 
							   (self.atTop and E.regions.T 
							or (self.atBottom and E.regions.B 
							or (self.atLeft and E.regions.L 
							or (self.atRight and E.regions.R 
							or (self.atTopLeft and E.regions.TL
							or (self.atTopRight and E.regions.TR
							or (self.atBottomLeft and E.regions.BL
							or (self.atBottomRight and E.regions.BR)))))))),
							   (self.againstTop and E.regions.T 
							or (self.againstBottom and E.regions.B 
							or (self.againstLeft and E.regions.L 
							or (self.againstRight and E.regions.R 
							or (self.againstTopLeft and E.regions.TL
							or (self.againstTopRight and E.regions.TR
							or (self.againstBottomLeft and E.regions.BL
							or (self.againstBottomRight and E.regions.BR)))))))),
							   self.noOffsets and 0 or (self.x ~= nil and self.x or 0),
							   self.noOffsets and 0 or (self.y ~= nil and self.y or 0)

						if not lp and p then
							lp = p
						elseif not p and lp then
							p = lp
						end

						if lp and p then
							text:SetPoint(lp, p, self.alignWith or parent, x, y)
						else
							if self.top then
								local x, y = unpack(self.top)
								text:SetPoint(E.regions.T, x or 0, y or 0)
							end
							if self.bottom then
								local x, y = unpack(self.bottom)
								text:SetPoint(E.regions.B, self.x or 0, self.y or 0)
							end
							if self.left then
								local x, y = unpack(self.left)
								text:SetPoint(E.regions.L, self.x or 0, self.y or 0)
							end
							if self.right then
								local x, y = unpack(self.right)
								text:SetPoint(E.regions.R, self.x or 0, self.y or 0)
							end
							if self.topRight then
								local x, y = unpack(self.topRight)
								text:SetPoint(E.regions.TR, self.x or 0, self.y or 0)
							end
							if self.topLeft then
								local x, y = unpack(self.topLeft)
								text:SetPoint(E.regions.TL, self.x or 0, self.y or 0)
							end
							if self.bottomRight then
								local x, y = unpack(self.bottomRight)
								text:SetPoint(E.regions.BR, self.x or 0, self.y or 0)
							end
							if self.bottomLeft then
								local x, y = unpack(self.bottomLeft)
								text:SetPoint(E.regions.BL, self.x or 0, self.y or 0)
							end
						end
					end
					
					return text
				end
				function object:top(x, y)
					self.top = { x, y }
					return self
				end
				function object:bottom(x, y)
					self.bottom = { x, y }
					return self
				end
				function object:left(x, y)
					self.left = { x, y }
					return self
				end
				function object:right(x, y)
					self.right = { x, y }
					return self
				end
				function object:topRight(x, y)
					self.topRight = { x, y }
					return self
				end
				function object:topLeft(x, y)
					self.topLeft = { x, y }
					return self
				end
				function object:bottomRight(x, y)
					self.bottomRight = { x, y }
					return self
				end
				function object:bottomLeft(x, y)
					self.bottomLeft = { x, y }
					return self
				end
				function object:alignAll()
					self.alignAll = true
					return self
				end
				function object:alignWith(relative)
					object.alignWith = relative
					return self
				end
				function object:atTop()
					object.atTop = boolean
					return self
				end
				function object:atBottom()
					object.atBottom = true
					return self
				end
				function object:atLeft()
					object.atLeft = true
					return self
				end
				function object:atRight()
					object.atRight = true
					return self
				end
				function object:atTopRight()
					object.atTopRight = true
					return self
				end
				function object:atTopLeft()
					object.atTopLeft = true
					return self
				end
				function object:atBottomRight()
					object.atBottomRight = true
					return self
				end
				function object:atBottomLeft()
					object.atBottomLeft = true
					return self
				end
				function object:againstTop()
					object.againstTop = true
					return self
				end
				function object:againstBottom()
					object.againstBottom = true
					return self
				end
				function object:againstLeft()
					object.againstLeft = true
					return self
				end
				function object:againstRight()
					object.againstRight = true
					return self
				end
				function object:againstTopRight()
					object.againstTopRight = true
					return self
				end
				function object:againstTopLeft()
					object.againstTopLeft = true
					return self
				end
				function object:againstBottomRight()
					object.againstBottomRight = true
					return self
				end
				function object:againstBottomLeft()
					object.againstBottomLeft = true
					return self
				end
				function object:noOffsets()
					object.noOffsets = true
				end
				function object:x(offset)
					self.x = offset
					return self
				end
				function object:y(offset)
					self.y = offset
					return self
				end

				return object
			end

			local test2 = TextBuilder(ilvl, 14)
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

			local desc = TextBuilder(gold, 12):atTop(true):y(-5):build()
			local value = TextBuilder(gold, 12):alignWith(desc):atTop(true):againstBottom(true):y(-3):build()

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

local function section(column, parent, grid)
	local frame = CreateFrame("Button", nil, parent)
	if column.children and not column.children:isEmpty() then
		frame:SetScript("OnClick", function(self, button, down)
			if button == "LeftButton" and not down then
				grid:update(column, parent)
			end
		end)
	end
	if type(column.data) == "string" then
		for key, init in pairs(presets) do
			if key == column.data then
				init(frame, )
			end
		end
	else
		column.data:apply(frame)
	end
end

local function iterate(rows, parent, created)
	if not rows:isEmpty() then
		for row in next, rows do
			local columns = row.columns
			if not columns:isEmpty() then
				if columns:isSize(1) then
					section(columns:get(1), parent, created)
				else
					for column in next, columns do
						section(column, parent, created)
					end
				end
			end
		end
	end
end

local function update(column, parent)
	iterate(column.children, parent, self)
end

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