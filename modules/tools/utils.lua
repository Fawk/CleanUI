local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local E = A.enum

local object = {}

function object:center(x, y)
	self.c = { x, y }
	return self
end
function object:top(x, y)
	self.t = { x, y }
	return self
end
function object:bottom(x, y)
	self.b = { x, y }
	return self
end
function object:left(x, y)
	self.l = { x, y }
	return self
end
function object:right(x, y)
	self.r = { x, y }
	return self
end
function object:topRight(x, y)
	self.tr = { x, y }
	return self
end
function object:topLeft(x, y)
	self.tl = { x, y }
	return self
end
function object:bottomRight(x, y)
	self.br = { x, y }
	return self
end
function object:bottomLeft(x, y)
	self.bl = { x, y }
	return self
end
function object:alignAll()
	self.alignAllPoints = true
	return self
end
function object:alignWith(relative)
	self.aw = relative
	return self
end
function object:atCenter()
	self.atC = true
	return self
end
function object:atTop()
	self.atT = true
	return self
end
function object:atBottom()
	self.atB = true
	return self
end
function object:atLeft()
	self.atL = true
	return self
end
function object:atRight()
	self.atR = true
	return self
end
function object:atTopRight()
	self.atTR = true
	return self
end
function object:atTopLeft()
	self.atTL = true
	return self
end
function object:atBottomRight()
	self.atBR = true
	return self
end
function object:atBottomLeft()
	self.atBL = true
	return self
end
function object:againstCenter()
	self.againstC = true
	return self
end
function object:againstTop()
	self.againstT = true
	return self
end
function object:againstBottom()
	self.againstB = true
	return self
end
function object:againstLeft()
	self.againstL = true
	return self
end
function object:againstRight()
	self.againstR = true
	return self
end
function object:againstTopRight()
	self.againstTR = true
	return self
end
function object:againstTopLeft()
	self.againstTL = true
	return self
end
function object:againstBottomRight()
	self.againstBR = true
	return self
end
function object:againstBottomLeft()
	self.againstBL = true
	return self
end
function object:noOffsets()
	self.zeroOffsets = true
end
function object:x(offset)
	self.xo = offset
	return self
end
function object:y(offset)
	self.yo = offset
	return self
end
function object:below(relative)
	self:alignWith(relative)
	self:atTop()
	self:againstBottom()
	return self
end
function object:above(relative)
	self:alignWith(relative)
	self:atBottom()
	self:againstTop()
	return self
end
function object:alignConditional(condition)
	condition(self)
	return self
end

local condition = {}

function condition:if(statement)
	
	return self
end
function condition:then(action)

	return self
end
function condition:or(action)

	return self
end
function condition:eval()
	
	return self.obj
end

condition.__index = condition

function object:alignWithCondition()
	local c = {
		obj = self
	}
	setmetatable(c, condition)
	return c
end

object.__index = object

local points = {
	["atC"] = E.regions.C,
	["atT"] = E.regions.T,
	["atB"] = E.regions.B,
	["atL"] = E.regions.L,
	["atR"] = E.regions.R,
	["atTL"] = E.regions.TL,
	["atTR"] = E.regions.TR,
	["atBL"] = E.regions.BL,
	["atBR"] = E.regions.BR,
	["againstC"] = E.regions.C,
	["againstT"] = E.regions.T,
	["againstB"] = E.regions.B,
	["againstL"] = E.regions.L,
	["againstR"] = E.regions.R,
	["againstTL"] = E.regions.TL,
	["againstTR"] = E.regions.TR,
	["againstBL"] = E.regions.BL,
	["againstBR"] = E.regions.BR
}

local function setPoints(o, frame)

	frame:ClearAllPoints()

	if o.alignAllPoints then
		frame:SetAllPoints()
	else

		local lp, p = nil, nil
		for point, region in next, points do
			if o[point] then 
				if string.sub(point, 0, 2) == "at" then
					lp = region
				else
					p = region
				end
			end
		end

		local x, y = o.zeroOffsets and 0 or (o.xo ~= nil and o.xo or 0), o.zeroOffsets and 0 or (o.yo ~= nil and o.yo or 0)

		if not lp and p then
			lp = p
		elseif not p and lp then
			p = lp
		end

		if lp and p then
			frame:SetPoint(lp, o.aw or o.parent, p, x, y)
		else
			if o.c then
				x, y = unpack(o.c)
				frame:SetPoint(E.regions.C, x or 0, y or 0)
			end
			if o.t then
				x, y = unpack(o.t)
				frame:SetPoint(E.regions.T, x or 0, y or 0)
			end
			if o.b then
				x, y = unpack(o.b)
				frame:SetPoint(E.regions.B, x or 0, y or 0)
			end
			if o.l then
				x, y = unpack(o.l)
				frame:SetPoint(E.regions.L, x or 0, y or 0)
			end
			if o.r then
				x, y = unpack(o.r)
				frame:SetPoint(E.regions.R, x or 0, y or 0)
			end
			if o.tr then
				x, y = unpack(o.tr)
				frame:SetPoint(E.regions.TR, x or 0, y or 0)
			end
			if o.tl then
				x, y = unpack(o.tr)
				frame:SetPoint(E.regions.TL, x or 0, y or 0)
			end
			if o.br then
				x, y = unpack(o.br)
				frame:SetPoint(E.regions.BR, x or 0, y or 0)
			end
			if o.bl then
				x, y = unpack(o.bl)
				frame:SetPoint(E.regions.BL, x or 0, y or 0)
			end
		end
	end
end

local function TextBuilder(parent, size)
	local o = {
		size = size,
		parent = parent
	}

	setmetatable(o, object)

	function o:build()
		local text = self.parent:CreateFontString(nil, "OVERLAY")
		text:SetFont(media:Fetch("font", "FrancophilSans"), self.size, "NONE")
		setPoints(self, text)
		return text
	end

	return o
end

local function ButtonBuilder(parent)
	local o = {
		parent = parent
	}

	setmetatable(o, object)
	o.button = CreateFrame("Button", nil, parent)

	function o:build()
		setPoints(self, self.button)
		return self.button
	end

	function o:onClick(func)
		self.button:SetScript("OnClick", func)
		return self
	end

	return o
end

local function EditBoxBuilder(parent)
	local o = {
		parent = parent
	}

	setmetatable(o, object)
	o.textbox = CreateFrame("EditBox", nil, parent)

	function o:build()
		setPoints(self, self.textbox)
		return self.textbox
	end

end

local function mapGrid(grid, parent, rowFunc, columnFunc)
	for rowId, row in next, grid do
		for columnId, column in next, row do

		end
	end
end

A.TextBuilder = TextBuilder
A.ButtonBuilder = ButtonBuilder
A.EditBoxBuilder = EditBoxBuilder