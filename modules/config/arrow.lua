
function CreateArrow(options)

	local quadrants = {
		left = false,
		right = false,
		top = false,
		bottom = false
	}

	local aX, aY, texture = unpack(options)
	local cX, cY = GetCursorPosition()
	local adj = 0
	local nX, nY = cX - aX, cY - aY

	if nX < 0 then 
		quadrants.left = true 
		nX = nX * -1
	end
	if nX >= 0 then 
		quadrants.right = true 
	end
	if nY < 0 then 
		quadrants.bottom = true 
		nY = nY * -1
	end
	if nY >= 0 then 
		quadrants.top = true 
	end

	if quadrants.top then
		if quadrants.left then
			adj = 90
		elseif quadrants.right then
			adj = 0
		end
	elseif quadrants.bottom then
		if quadrants.left then
			adj = 180
		elseif quadrants.right then
			adj = 270
		end
	end

	local h = math.sqrt(math.pow(nX, 2) + math.pow(nY, 2))
	local deg = math.cos(nX / h) + adj
	local rad = math.rad(deg)

	texture:SetRotation(rad)

end