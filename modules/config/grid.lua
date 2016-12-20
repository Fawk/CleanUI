local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")

local templates = {
	["Single text"] = function(frame, size, points)
		local value = frame:CreateFontString(nil, "OVERLAY")
		value:SetFont(media:Fetch("font", "FrancophilSans"), size, "NONE")
		if points and type(points) == "table" then
			if points.lp and points.relative then
				value:SetPoint(points.lp, points.relative == "parent" and frame or points.relative, points.p and points.p or points.lp, points.x or 0, points.y or 0)
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
		return value
	end,
	["Double text"] = function(frame, size1, points1, size2, points2)
		local first = templates["Single text"](frame, size1, points1)
		if points2.relative and points.relative == "first" then points2.relative = first end
		local second = templates["Single text"](frame, size2, points2)
		return first, second
	end
}

local presets = {
	["Item Level"] = {
		apply = function(frame)

			local preset = frame.currentPreset
			if preset and preset:GetName() == "Item Level" then
				presets[preset:GetName()]:update(frame, select(2, GetAverageItemLevel()))
				return
			end

			local ilvl = CreateFrame("Frame", "Item Level", frame)
			ilvl:SetAllPoints(frame)

			local desc, value = template["Double text"](
				ilvl,
				11, { lp = "CENTER", relative = "parent", y = -10 },
				14, { lp = "TOP", p = "BOTTOM", relative = "first", y = -3 }
			)
			desc:SetText("Item Level")
			value:SetText(tostring(select(2, GetAverageItemLevel())))

			ilvl.value = value
			frame.currentPreset = ilvl

			ilvl:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
			ilvl:RegisterEvent("PLAYER_ENTERING_WORLD")
			ilvl:RegisterEvent("ZONE_CHANGED")
			ilvl:RegisterEvent("ZONE_CHANGED_INDOORS")
			ilvl:RegisterEvent("ZONE_CHANGED_NEW_AREA")

			ilvl:SetScript("OnEvent", function(self, event, ...)
				presets[self:GetName()]:update(ilvl:GetParent(), select(2, GetAverageItemLevel()))
			end)
		end,
		update = function(frame, ilvl)
			local value = frame.currentPreset.value
			value:SetText(tostring(ilvl))
		end
	},
	["Gold"] = {

	},
	["Order Hall Resources"] = {

	},
	["Artifact Power"] = { -- Display artifact level and min/max and percentage

	},
	["Artifact Knowledge"] = {

	},
	["Seal of Broken Faith"] = { -- Display current amount and limit this week e.g: 5/6 (3/3)

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