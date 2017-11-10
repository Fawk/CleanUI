local A, L = unpack(select(2, ...))
local E, T, Units, media = A.enum, A.Tools, A.Units, LibStub("LibSharedMedia-3.0")
local oUF = oUF or A.oUF

local Buffs = function(frame, db)

	local growth, attached, style, size = db["Growth"], db["Attached"], db["Style"], db["Size"]
	local buffs = frame.Buffs or (function()
		local buffs = CreateFrame("Frame", T:frameName("Buffs"), frame)

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

			buffs.SetPosition = function(element, from, to)
				local sizex = (element.size or 16) + (element['spacing-x'] or element.spacing or 0)
				local sizey = (element.size or 16) + (element['spacing-y'] or element.spacing or 0)
				local anchor = element.initialAnchor or 'BOTTOMLEFT'
				local x, y = 0, 0

				if not element.bar then
					element.bar = CreateFrame("StatusBar", nil, buffs)
				end

				element.bar:ClearAllPoints()

				T:Switch(growth,
					"Upwards", function() 
						x = 0
						y = sizey * i 
						element.bar:SetPoint("LEFT", element, "RIGHT", 0, 0)
					end,
					"Downwards", function() 
						x = 0
						y = sizey * i * -1
						element.bar:SetPoint("LEFT", element, "RIGHT", 0, 0) 
					end,
					"Left", function()
						x = sizex * i * -1
						y = 0
						element.bar:SetPoint("BOTTOM", element, "TOP", 0, 0)
					end,
					"Right", function()
						x = sizex * i
						y = 0
						element.bar:SetPoint("BOTTOM", element, "TOP", 0, 0)
					end)

				for i = from, to do
					local button = element[i]
					if(not button) then break end
					button:ClearAllPoints()
					button:SetPoint(anchor, element, anchor, x, y)
				end
			end
		end)

end

A["Elements"]["Buffs"] = Buffs