local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")

local presets = {
	["Item Level"] = function(frame)
		local ilvl = CreateFrame("Frame", nil, frame)
		ilvl:SetAllPoints(frame)

		local desc = ilvl:CreateFontString(nil, "OVERLAY")
		desc:SetFont(media:Fetch("font", "FrancophilSans"), 11, "NONE")
		desc:SetText("Item Level")
		desc:SetPoint("CENTER", frame, "CENTER", 0, -10)
	end
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
		presets[column.data](frame)
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