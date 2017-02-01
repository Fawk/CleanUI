local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local E = A.enum

function TextBuilder(parent, size)
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

A.TextBuilder = TextBuilder