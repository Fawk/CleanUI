local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF

local Buffs = function(frame, db)

	local growth, attached, style, size = db["Growth"], db["Attached"], db["Style"], db["Size"]
	local buffs = frame.Buffs or (function()
		local buffs = CreateFrame("Frame", T:frameName(A:GetName(), "Buffs"), frame)

		return buffs
	end)()

	if attached ~= false then
		buffs:SetPoint(T.reversedPoints[attached], frame, attached, 0, 0)
	else
		A:CreateMover(buffs, db, "Buffs")
		Units:Position(buffs, db["Position"])
	end

	T:Switch(style, 
		"Icon", function()
			local width = size["Width"]
			local height = size["Height"]
		end,
		"Bar", function()
			local width = size["Match width"] and frame:GetWidth() or size["Width"]
			local height = size["Match height"] and frame:GetHeight() or size["Height"]
		end)

end

A["Elements"]["Buffs"] = Buffs