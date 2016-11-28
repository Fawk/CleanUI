local A, L = unpack(select(2, ...))

local Grid = {}

function Grid:Create(options)
	assert(type(options) == "table")

	local data = options.data

	if not data.rows:isEmpty() then
		for row in next, data.rows do
			local columns = row.columns
			if not columns:isEmpty() then
				if columns:size() == 1 then
					local column = columns:get(1)
					
				else
					for column in next, columns do

					end
				end
			end
		end
	end
end