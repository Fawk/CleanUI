local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")

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
		apply = function(frame)

			local function update(f)
				local value = f.currentPreset.value
				value:SetText(getMoneyString())
			end

			local preset = frame.currentPreset
			if preset and preset:GetName() == "Gold" then
				update(frame)
				return
			end

			local gold = CreateFrame("Frame", "Gold", frame)
			gold:SetAllPoints(frame)

			local desc, value = templates.Text(
				gold, 
				{
					size = 12,
					points = { lp = "CENTER", relative = "parent" }
				},
				{
					size = 12,
					points = { lp = "BOTTOM", p = "TOP", relative = "prev", y = -3 }
				}
			)
			desc:SetText("Gold")
			value:SetText(getMoneyString())

			gold.value = value
			frame.currentPreset = gold

			gold:RegisterEvent("PLAYER_MONEY")
			gold:SetScript("OnEvent", function(self, event, ...)
				update(self:GetParent())
			end)

		end,
		update = function(frame)
			local value = frame.currentPreset.value
			value:SetText(getMoneyString())
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
	if type(column.data) == "string" and presets[column.data] then
		presets[column.data]:apply(frame)
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
	local back = CreateFrame("Button", nil, parent)
	back:SetScript("OnClick", function(self, button down)
		if button == "LeftButton" and not down then
			self:update(column, parent)
		end
	end)
	iterate(column.children, parent, self)
end

-- options = { 
--   data = {
--      parent = Frame,
--      rows = {
--	       {
--	          columns = {
--               children = { grid },
--	             data = {
--					apply = function(frame)
--                  	local stuff = CreateFrame("Frame", nil, frame)
--                      -- do stuff
--					end
--               }
--            }
--         }
--      }
--   }
--}
-- 
--
--
--

function Grid:Create(options)
	assert(type(options) == "table")

	local data, created = options.data, { update = update }
	iterate(data.rows, data.parent, created)

	return created
end