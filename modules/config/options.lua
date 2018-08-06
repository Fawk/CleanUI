local A, L = unpack(select(2, ...))

local function standardUnit(name, unit, order)
	return {
		type = "group",
		order = order,
		name = name,
		args = {

		}
	}
end

A.options = {
	name = "CleanUI Options",
	type = "group",
	inline = true,
	order = 1,
	args = {
		general = {
			name = "General",
			type = "group",
			order = 1,
			args = {
				minimap = {
					type = "group",
					order = 1,
					name = "Minimap",
					args = {

					}
				}
			}
		},
		units = {
			name = "Units",
			type = "group",
			order = 2,
			args = {
				player = {
					type = "group",
					order = 1,
					name = "Player",
					args = {}
				},
				target = standardUnit("Target", 2),
				targettarget = standardUnit("Target of Target", 3),
				pet = standardUnit("Pet", 4),
				focus = standardUnit("Focus", 5),
				boss = {
					type = "group",
					order = 6,
					name = "Boss",
					args = {

					}
				}
			}
		},
		group = {
			name = "Group",
			type = "group",
			order = 3,
			args = {
				party = {
					type = "group",
					order = 1,
					name = "Party",
					args = {}
				},
				raid = {
					type = "group",
					order = 2,
					name = "Raid",
					args = {}
				}
			}
		}
	}
}