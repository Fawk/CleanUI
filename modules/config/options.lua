local A, L = unpack(select(2, ...))
A.options = {
	name = "Options",
	type = "group",
	inline = true,
	order = 1,
	childGroups = "tree",
	get = function(info) end,
	set = function(info, val) end,
	args = {
		enable = {
			name = "Enable",
			desc = "Enables / disables the addon",
			type = "toggle",
			order = 1,
			set = function(info,val)  end,
			get = function(info) end
		},
		moreoptions = {
			name = "More Options",
			type = "group",
			order = 2,
			args = {
				-- more options go here
				something = {
					type = "select",
					name = "Something",
					set = function(info, val) end,
					get = function(info) end,
					values = { "ABC", "ADG", "ASD" }
				}
			}
		}
	}
}