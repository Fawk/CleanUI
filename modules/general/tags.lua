local AddonName = ...
local A, L = unpack(select(2, ...))
local buildCheckbox = A.CheckBoxBuilder
local buildDropdown = A.DropdownBuilder
local buildEditbox = A.EditBoxBuilder
local buildButton = A.ButtonBuilder
local buildText = A.TextBuilder
local buildNumber = A.NumberBuilder

local media = LibStub("LibSharedMedia-3.0")

local E = A.enum
local T = A.Tools
local CREATE_NEW = "Create new tag"

local Tags = {}

local function createElementTable(unitName)
	local tbl = {}
	tbl[unitName] = unitName
	if (unitName == "Player") then
		A["Player Elements"]:foreach(function(key, _)
			tbl[key] = key
		end)
	end
	A["Shared Elements"]:foreach(function(key, _)
		tbl[key] = key
	end)
	return tbl
end

local function getKeys(db)
	local keys = { 
		[CREATE_NEW] = { name = CREATE_NEW, order = 1 } 
	}
	for k,_ in next, db do keys[k] = k end
	return keys
end

local function getSecondKey(keys)
	local i = 1
	for k,_ in next, keys do 
		if (i == 2) then
			return k
		end
		i = i + 1
	end
end

function Tags:ToggleTagsWindow(group)

	local previousEditedTag

	if (A.tagsWindow) then
		previousEditedTag = A.tagsWindow.tagDropdown:GetValue()
		A.tagsWindow:Hide()
		A.tagsWindow = nil
	end

	local parent = CreateFrame("Frame", T:frameName(group.parent.name, "Tags"), A.frameParent)
	parent:SetPoint("TOPLEFT", group, "TOPRIGHT", 200, 0)
	parent:SetSize(250, 100)

	local keys = getKeys(group.db)
	local name = previousEditedTag or getSecondKey(keys)
	local item = group.db[name]

	if (not item) then
		name = getSecondKey(keys)
		item = group.db[name]
	end

	if (not name) then
		name = ""
		item = {
			["Format"] = "",
			["Size"] = 10,
			["Local Point"] = "TOPLEFT",
			["Point"] = "TOPLEFT",
			["Offset X"] = 0,
			["Offset Y"] = 0
		}
	end

	local nameTextBox, formatTextBox, size, localPointDropdown, pointDropdown, relativeToDropdown, deleteButton, hideButton, offsetX, offsetY
	local tagDropdown = buildDropdown(parent)
			:atTopLeft()
			:addItems(keys)
			:size(150, 20)
			:fontSize(10)
			:backdrop(E.backdrops.editboxborder, { 0.1, 0.1, 0.1, 1 }, { .3, .3, .3, 1 })
			:firstItemIsSpecialColor({ .5, .5, 1, 1 })
			:onItemClick(function(self, ...)
				local item, dropdown, mouseButton = ...
				if (item.name == CREATE_NEW) then
					nameTextBox:SetValue("")
					formatTextBox:SetValue("")
					size:SetValue(10)
					relativeToDropdown:SetValue(group.parent.name)
					offsetX:SetValue(0)
					offsetY:SetValue(0)
				else
					local defaultNameTag = A.actualDefaults.profile[group.parent.name].tags["Name"]
					if (A.profiler:IsDefault() and item.name == "Name" and defaultNameTag) then
						deleteButton:Hide()
						hideButton:Show()

						if (defaultNameTag.hide) then
							hideButton.text:SetText("Show")
						else
							hideButton.text:SetText("Hide")
						end
					else
						deleteButton:Show()
						hideButton:Hide()
					end

					local db = group.db[item.name]

					nameTextBox:SetValue(item.name)
					formatTextBox:SetValue(db["Format"])
					size:SetValue(db["Size"])
					localPointDropdown:SetValue(db["Local Point"])
					pointDropdown:SetValue(db["Point"])
					relativeToDropdown:SetValue(db["Relative To"])
					offsetX:SetValue(db["Offset X"])
					offsetY:SetValue(db["Offset Y"])
				end
			end)
			:build()

	tagDropdown:SetValue(name)

	parent.tagDropdown = tagDropdown

	nameTextBox = buildEditbox(parent)
			:below(tagDropdown)
			:size(150, 20)
			:build()

	nameTextBox:SetValue(name)

	nameTextBox.title = buildText(nameTextBox, 10)
			:leftOf(nameTextBox)
			:x(-20)
			:outline()
			:build()

	nameTextBox.title:SetText("Name")

	formatTextBox = buildEditbox(parent)
			:below(nameTextBox)
			:size(150, 20)
			:build()

	formatTextBox:SetValue(item["Format"])

	formatTextBox.title = buildText(formatTextBox, 10)
			:leftOf(formatTextBox)
			:x(-20)
			:outline()
			:build()

	formatTextBox.title:SetText("Format")

	size = buildNumber(parent, 10)
			:alignWith(formatTextBox)
			:atTopRight()
			:againstBottomRight()
			:size(70, 20)
			:min(1)
			:max(36)
			:stepValue(1)
			:build()

	size:SetValue(item["Size"])

	size.title = buildText(size, 10)
			:leftOf(size)
			:x(-100)
			:outline()
			:build()

	size.title:SetText("Size")

	localPointDropdown = buildDropdown(parent)
			:alignWith(size)
			:atTopRight()
			:againstBottomRight()
			:size(150, 20)
			:fontSize(10)
			:addItems(A.Tools.points)
			:backdrop(E.backdrops.editboxborder, { 0.1, 0.1, 0.1, 1 }, { .3, .3, .3, 1 })
			:build()

	localPointDropdown:SetValue(item["Local Point"])

	localPointDropdown.title = buildText(localPointDropdown, 10)
			:leftOf(localPointDropdown)
			:x(-20)
			:outline()
			:build()

	localPointDropdown.title:SetText("Local Point")

	pointDropdown = buildDropdown(parent)
			:below(localPointDropdown)
			:size(150, 20)
			:fontSize(10)
			:addItems(A.Tools.points)
			:backdrop(E.backdrops.editboxborder, { 0.1, 0.1, 0.1, 1 }, { .3, .3, .3, 1 })
			:build()

	pointDropdown:SetValue(item["Point"])

	pointDropdown.title = buildText(pointDropdown, 10)
			:leftOf(pointDropdown)
			:x(-20)
			:outline()
			:build()

	pointDropdown.title:SetText("Point")

	relativeToDropdown = buildDropdown(parent)
			:below(pointDropdown)
			:size(150, 20)
			:fontSize(10)
			:addItems(createElementTable(group.parent.name))
			:backdrop(E.backdrops.editboxborder, { 0.1, 0.1, 0.1, 1 }, { .3, .3, .3, 1 })
			:build()

	relativeToDropdown:SetValue(item["Relative To"])

	relativeToDropdown.title = buildText(relativeToDropdown, 10)
			:leftOf(relativeToDropdown)
			:x(-20)
			:outline()
			:build()

	relativeToDropdown.title:SetText("Relative To")

	offsetX = buildNumber(parent)
			:alignWith(relativeToDropdown)
			:atTopRight()
			:againstBottomRight()
			:x(-1)
			:size(70, 20)
			:min(-GetScreenWidth())
			:max(GetScreenWidth())
			:stepValue(1)
			:build()

	offsetX:SetValue(item["Offset X"])

	offsetX.title = buildText(offsetX, 10)
			:leftOf(offsetX)
			:x(-100)
			:outline()
			:build()

	offsetX.title:SetText("Offset X")

	offsetY = buildNumber(parent, 10)
			:below(offsetX)
			:size(70, 20)
			:min(-GetScreenHeight())
			:max(GetScreenHeight())
			:stepValue(1)
			:build()

	offsetY:SetValue(item["Offset Y"])

	offsetY.title = buildText(offsetY, 10)
			:leftOf(offsetY)
			:x(-100)
			:outline()
			:build()

	offsetY.title:SetText("Offset Y")

	deleteButton = buildButton(parent)
			:below(offsetY)
			:x(-40)
			:backdrop(E.backdrops.editboxborder, { 0.1, 0.1, 0.1, 1 }, { .3, .3, .3, 1 })
			:size(50, 20)
			:onClick(function(self, b, d)
				local selected = tagDropdown:GetValue()
				if (selected ~= CREATE_NEW) then
					group.db[selected] = nil

					A.dbProvider:Save()
					GameTooltip:Hide()
					A:UpdateDb()
					Tags:ToggleTagsWindow(group)
				end
			end)
			:build()

	deleteButton.text = buildText(deleteButton, 10)
			:atCenter()
			:build()

	deleteButton.text:SetText("Delete")
	deleteButton.text:SetTextColor(1, .5, .5, 1)

	hideButton = buildButton(parent)
		:below(offsetY)
		:x(-40)
		:backdrop(E.backdrops.editboxborder, { 0.1, 0.1, 0.1, 1 }, { .3, .3, .3, 1 })
		:size(50, 20)
		:onClick(function(self, b, d)
			group.db[selected]["Hide"] = self.text:GetText() == "Hide"
			A.dbProvider:Save()
			GameTooltip:Hide()
			A:UpdateDb()
			Tags:ToggleTagsWindow(group)
		end)
		:build()

	hideButton.text = buildText(hideButton, 10)
			:atCenter()
			:build()

	hideButton.text:SetText("Hide")
	hideButton.text:SetTextColor(1, .5, .5, 1)

	hideButton:Hide()

	local defaultNameTag = A.defaults["Profiles"]["Default"]["Options"][group.parent.name]["Tags"]["Name"]
	if (A.profiler:IsDefault() and selected == "Name" and defaultNameTag) then
		deleteButton:Hide()
		hideButton:Show()

		if (defaultNameTag["Hide"]) then
			hideButton.text:SetText("Show")
		else
			hideButton.text:SetText("Hide")
		end
	end

	local saveButton = buildButton(parent)
			:rightOf(deleteButton)
			:backdrop(E.backdrops.editboxborder, { 0.1, 0.1, 0.1, 1 }, { .3, .3, .3, 1 })
			:size(50, 20)
			:onClick(function(self, b, d)

				local name = nameTextBox:GetValue()
				local format = formatTextBox:GetValue()
				local size = size:GetValue()
				local localPoint = localPointDropdown:GetValue()
				local point = pointDropdown:GetValue()
				local relativeTo = relativeToDropdown:GetValue()
				local ox = offsetX:GetValue()
				local oy = offsetY:GetValue()

				local obj = {
					["Format"] = format,
					["Size"] = size,
					["Local Point"] = localPoint,
					["Point"] = point,
					["Relative To"] = relativeTo,
					["Offset X"] = ox,
					["Offset Y"] = oy,
				}

				local selected = tagDropdown:GetValue()
				if (selected == CREATE_NEW) then
					group.db[name] = obj
				else
					parent.previousEditedTag = selected
					group.db[selected] = nil
					group.db[name] = obj
				end

				-- Save to db
				A.dbProvider:Save()
				GameTooltip:Hide()
				A:UpdateDb()
				Tags:ToggleTagsWindow(group)
			end)
			:build()

	saveButton.text = buildText(saveButton, 10)
			:atCenter()
			:build()

	saveButton.text:SetText("Save")

	tagDropdown:SimulateClickOnActiveItem()
	tagDropdown:Close()

	A.tagsWindow = parent
end

function Tags:GetOptions(enabled, extraClick, order)

	local config = {
		enabled = enabled,
		canToggle = true,
		type = "group",
		order = order,
		placement = function(self)
			self:SetPoint("TOPLEFT", self.previous, "BOTTOMLEFT", 0, -5)
		end,
		onClick = function(self)
			extraClick(self)
			Tags:ToggleTagsWindow(self)
		end,
		children = {}
	}

	return config
end

A.general:set("tags", Tags)