local AddonName = ...
local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local T = A.Tools

local floor = math.floor

local GetScreenWidth = GetScreenWidth
local GetScreenHeight = GetScreenHeight

local UnitClass = UnitClass
local GetSpecialization = GetSpecialization

local clickcastDesc = [=[
Enter the macro conditional to use for clickcast.
Format needs to follow the standard macro format:
/cast [conditions...] Spell
Where multiple spells are separated by semicolon.
@mouseover condition is not required and will be added automatically.
]=]

local tagsDesc = [=[

Available tags:

Health:
[hp] - current health amount
[maxhp] - current max health amount
[perhp] - current health in percentage towards max health 
[hp:round] - current health in a short format, e.g. 5.5K, 5.5M, 5.5B
[maxhp:round] - current max health in a short format, same as above
[hp:deficit] - current missing health in a short format without decimals, e.g. -5k, will not be displayed at full health

Power:
[pp] - current power amount
[maxpp] - current max power amount
[perpp] - current power in percentage towards max power 
[pp:round] - current power in a short format, e.g. 5.5K, 5.5M, 5.5B
[maxpp:round] - current max power in a short format, same as above
[pp:deficit] - current missing power in a short format without decimals, e.g. -5k, will not be displayed at full power

Heal Prediction:
[heal] - current incoming heals from yourself
[heal:round] - same as above but in a short format, e.g. 5.5K
[allheal] - current incoming heals from other sources
[allheal:round] - same as above but in a short format, e.g. 5.5K
[absorb] - current amount of absorb for the unit
[absorb:round] - same as above but in a short format, e.g. 5.5K
[perabsorb] - same as absorb but in a percentage value towards max health
[healabsorb] - current amount of absorbed healing for the unit
[healabsorb:round] - same as above but in a short format, e.g. 5.5K

Name:
[name] - the name of the unit
[name:x] - the name of the unit restricted to x characters

Class:
[class] - the class of the unit

Colors:
[color:AABBCC] - any hex value can be used to color the text, e.g. FFFFFF for white

Or you can use the few predefined ones listed here:
[color:white]
[color:black]
[color:red]
[color:green]
[color:blue]
[color:yellow]
[color:purple]
[color:cyan]
[color:orange]
[color:pink]

These are pretty self-explainatory:
[color:class]
[color:power]
[color:health]
[color:healthgradient] - color the text based on the current health value, red and green and all in between

]=]

local function isClass(token)
	return select(2, UnitClass("player")) == token
end

local function isSpec(spec)
	return GetSpecialization() == spec
end

local function createDropdownTable(...)
    local tbl = {}
    for _,v in next, {...} do
        tbl[v] = v:fupper()
    end
    return tbl
end

local function createElementTable(isPlayer)
	local tbl = { ["Parent"] = "Parent" }
	
	for _,key in A.elements.shared() do
		tbl[key] = key
	end

	if (isPlayer) then
		for _,key in A.elements.player() do
			tbl[key] = key
		end
	end

	return tbl
end

local function getParent(info)
	local db = A.db.profile
	for i = 1, #info - 1 do
		local d = db[info[i]]
		if (d) then
			db = d
		end
	end
	return db	
end

local function goBack(info)
	local i = {}
	for x = 1, #info - 1 do
		i[x] = info[x]
	end
	return i
end

local function parentDisabled(info)
	local db = getParent(info)

	local i = goBack(info)
	while (db.enabled == nil) do
		db = getParent(i)
		i = goBack(i)
	end

	return not db.enabled
end

local function positionSetting(order, relativeTable)
	local tbl = {
		disabled = parentDisabled,
		type = "group",
		order = order,
		name = "Position",
		args = {
			localPoint = {
				type = "select",
				order = 1,
				name = "Local Point",
				values = T.points,
				get = "Get",
				set = "Set"
			},
			point = {
				type = "select",
				order = 2,
				name = "Point",
				values = T.points,
				get = "Get",
				set = "Set"
			},
			x = {
				type = "range",
				order = 3,
				name = "Offset X",
				min = -floor(GetScreenWidth()),
				max = floor(GetScreenWidth()),
				softMin = -200,
				softMax = 200,
				step = 1,
				get = "Get",
				set = "Set",
			},
			y = {
				type = "range",
				order = 4,
				name = "Offset Y",
				min = -floor(GetScreenHeight()),
				max = floor(GetScreenHeight()),
				softMin = -200,
				softMax = 200,
				step = 1,
				get = "Get",
				set = "Set",
			}
		}
	}

	if (relativeTable) then
		tbl.args.relative = {
			type = "select",
			order = 5,
			name = "Relative To",
			values = relativeTable,
			get = "Get",
			set = "Set"
		}
	end

	return tbl
end

local function backgroundSetting(order)
	return {
		disabled = parentDisabled,
    	type = "group",
    	order = order,
    	name = "Background",
    	args = {
    		enabled = {
				type = "toggle",
				order = 1,
				name = "Enabled",
				get = "Get",
				set = "Set"
    		},
            color = {
            	disabled = parentDisabled,
            	type = "color",
            	order = 2,
            	name = "Custom Color",
            	hasAlpha = true,
            	get = "Get",
            	set = "Set"
            },
            size = {
            	disabled = parentDisabled,
				type = "range",
				order = 3,
				name = "Edge Size",
				min = 1,
				max = 100,
				step = 1,
				get = "Get",
				set = "Set",
            },
			matchWidth = {
				disabled = parentDisabled,
				type = "toggle",
				order = 4,
				name = "Match Width",
				get = "Get",
				set = "Set"
			},
			matchHeight = {
				disabled = parentDisabled,
				type = "toggle",
				order = 5,
				name = "Match Height",
				get = "Get",
				set = "Set"
			},
			width = {
				disabled = function(info)
            		local parent = getParent(info)
            		return not (parent.enabled and not parent.matchWidth)
            	end,
				type = "range",
				order = 6,
				name = "Width",
				min = 1,
				max = floor(GetScreenWidth()),
				step = 1,
				softMin = 1,
				softMax = 500,
				get = "Get",
				set = "Set",
			},
			height = {
				disabled = function(info)
            		local parent = getParent(info)
            		return not (parent.enabled and not parent.matchHeight)
            	end,
				type = "range",
				order = 7,
				name = "Height",
				min = 1,
				max = floor(GetScreenHeight()),
				step = 1,
				softMin = 1,
				softMax = 500,
				get = "Get",
				set = "Set",
			},
            offset = {
            	disabled = parentDisabled,
            	type = "group",
            	order = 8,
            	name = "Offset",
            	args = {
            		top = {
						type = "range",
						order = 1,
						name = "Top",
						min = -100,
						max = 100,
						step = 1,
						get = "Get",
						set = "Set",
            		},
            		bottom = {
						type = "range",
						order = 2,
						name = "Bottom",
						min = -100,
						max = 100,
						step = 1,
						get = "Get",
						set = "Set",
            		},
            		left = {
						type = "range",
						order = 3,
						name = "Left",
						min = -100,
						max = 100,
						step = 1,
						get = "Get",
						set = "Set",					                			
            		},
            		right = {
						type = "range",
						order = 4,
						name = "Right",
						min = -100,
						max = 100,
						step = 1,
						get = "Get",
						set = "Set",
            		}
            	}
            }
        }
   	}
end

local function constructTags(order, db, isPlayer, isGroup)
	local row = {
		format = {
			type = "input",
			order = 1,
			name = "Format",
			width = "full",
			desc = tagsDesc,
			get = "Get",
			set = "Set"
		},
		size = {
			type = "range",
			order = 2,
			name = "Text Size",
			min = 1,
			max = 100,
			step = 1,
			get = "Get",
			set = "Set"
		},
		localPoint = {
			type = "select",
			order = 3,
			name = "Local Point",
			values = T.points,
			get = "Get",
			set = "Set"
		},
		point = {
			type = "select",
			order = 4,
			name = "Point",
			values = T.points,
			get = "Get",
			set = "Set"
		},
		relative = {
			type = "select",
			order = 5,
			name = "Relative To",
			values = createElementTable(isPlayer),
			get = "Get",
			set = "Set"
		},
		x = {
			type = "range",
			order = 6,
			name = "Offset X",
			min = -500,
			max = 500,
			step = 1,
			get = "Get",
			set = "Set"
		},
		y = {
			type = "range",
			order = 7,
			name = "Offset Y",
			min = -500,
			max = 500,
			step = 1,
			get = "Get",
			set = "Set"
		},
		hide = {
			type = "toggle",
			order = 8,
			name = "Hide",
			get = "Get",
			set = "Set"
		},
		delete = {
			type = "execute",
			hidden = function(info)
				return info[#info - 1] == "name"
			end,
			order = 9,
			name = "Delete",
			func = function(info)
				local unit = info[#info - 4]

				if (isGroup) then
					A.db.profile.group[unit].tags.list[ info[#info - 1] ] = nil
					info.options.args.group.args[unit].args.tags.args.list.args[ info[#info - 1] ] = nil
				else
					A.db.profile.units[unit].tags.list[ info[#info - 1] ] = nil
					info.options.args.units.args[unit].args.tags.args.list.args[ info[#info - 1] ] = nil
				end
				A:UpdateDb()
			end,
		}
	}

	local options = {
		disabled = parentDisabled,
		type = "group",
		order = order,
		name = "Tags",
		args = {
			new = {
				type = "group",
				order = 1,
				name = "Create New",
				args = {
					create = {
						type = "input",
						name = "Key",
						order = 1,
						get = function(info) return "" end,
						set = function(info, key)
							local unit = info[#info - 3]
							local db
							if (isGroup) then
								db = A.db.profile.group[unit].tags.list
							else
								db = A.db.profile.units[unit].tags.list
							end
							if (db[key]) then
								print("Tags: That key is already being used, try another one!")
								return
							else
								db[key] = {
									format = "",
									size = 10,
		                            localPoint = "CENTER",
		                            point = "CENTER",
		                            relative = "Parent",
		                            x = 0,
		                            y = 0,
		                            hide = false
		                        }

		                        if (isGroup) then
			                        info.options.args.group.args[unit].args.tags.args.list.args[key] = {
			                        	type = "group",
			                        	order = T:tcount(db),
			                        	name = key,
			                        	args = row
			                    	}
		                        else
			                        info.options.args.units.args[unit].args.tags.args.list.args[key] = {
			                        	type = "group",
			                        	order = T:tcount(db),
			                        	name = key,
			                        	args = row
			                    	}
			                    end

		                        A:NotifyConfigChanges()
								A:UpdateDb()
							end
						end
					}
				}
			},
			list = {
				type = "group",
				order = 2,
				name = "List",
				args = {
					name = {
						type = "group",
						order = 1,
						name = "Name",
						args = row
					}
				}
			}
		}
	}
	
	local o = 2
	for key, tag in next, db.tags.list do
		options.args.list.args[key] = {
			type = "group",
			order = o,
			name = key,
			args = row
		}
		o = o + 1
	end

	return options
end

local keyMap = {
	["LMB"] = "LMB",
	["MMB"] = "MMB",
	["RMB"] = "RMB",
	["SHIFT-LMB"] = "SHIFT-LMB",
	["SHIFT-MMB"] = "SHIFT-MMB",
	["SHIFT-RMB"] = "SHIFT-RMB",
	["CTRL-LMB"] = "CTRL-LMB",
	["CTRL-MMB"] = "CTRL-MMB",
	["CTRL-RMB"] = "CTRL-RMB",
	["ALT-LMB"] = "ALT-LMB",
	["ALT-MMB"] = "ALT-MMB",
	["ALT-RMB"] = "ALT-RMB",
	["CTRL-SHIFT-LMB"] = "CTRL-SHIFT-LMB",
	["CTRL-SHIFT-MMB"] = "CTRL-SHIFT-MMB",
	["CTRL-SHIFT-RMB"] = "CTRL-SHIFT-RMB",
	["ALT-CTRL-SHIFT-LMB"] = "ALT-CTRL-SHIFT-LMB",
	["ALT-CTRL-SHIFT-MMB"] = "ALT-CTRL-SHIFT-MMB",
	["ALT-CTRL-SHIFT-RMB"] = "ALT-CTRL-SHIFT-RMB",
	["ALT-CTRL-LMB"] = "ALT-CTRL-LMB",
	["ALT-CTRL-MMB"] = "ALT-CTRL-MMB",
	["ALT-CTRL-RMB"] = "ALT-CTRL-RMB",
	["ALT-SHIFT-LMB"] = "ALT-SHIFT-LMB",
	["ALT-SHIFT-MMB"] = "ALT-SHIFT-MMB",
	["ALT-SHIFT-RMB"] = "ALT-SHIFT-RMB"
}

local function clickCastSetting(order, db)
	local args = {
		actions = {
			type = "group",
			order = 1,
			name = "Actions",
			args = {}
		}
	}

	local o = 1
	for key,_ in next, keyMap do
		args.actions.args[key] = {
			type = "input",
			order = o,
			name = key,
			width = "full",
			desc = clickcastDesc,
			get = function(info)
				local db = getParent(info)
				return db[key]
			end,
			set = function(info, val)
				local x = val:find("%[[^@]")
				while (x) do
				  val = string.format("%s%s%s", val:sub(1, x), "@mouseover,", val:sub(x+1))
				  x = val:find("%[[^@]", x+1)
				end
				local db = getParent(info)

				if (val == "") then val = nil end

				db[info[#info]] = val
				A:UpdateDb()
			end,
		}
		o = o + 1
	end

	return {
		type = "group",
		order = order,
		name = "Clickcast",
		args = args
	}
end

local function classPowerSetting(name, order, hidden)
	return {
		disabled = parentDisabled,
		hidden = hidden,
		type = "group",
		order = order,
		name = name,
		args = {
		    enabled = {
				type = "toggle",
				order = 1,
				name = "Enabled",
				get = "Get",
				set = "Set"
			},
		    size = {
		    	disabled = parentDisabled,
		    	type = "group",
		    	order = 2,
		    	name = "Size",
		    	args = {
					matchWidth = {
						type = "toggle",
						order = 1,
						name = "Match Width",
						get = "Get",
						set = "Set"
					},
					matchHeight = {
						type = "toggle",
						order = 2,
						name = "Match Height",
						get = "Get",
						set = "Set"
					},
					width = {
						disabled = function(info)
			        		local parent = getParent(info)
			        		return parent.matchWidth
			        	end,
						type = "range",
						order = 3,
						name = "Width",
						min = 1,
						max = floor(GetScreenWidth()),
						step = 1,
						softMin = 1,
						softMax = 500,
						get = "Get",
						set = "Set",
					},
					height = {
						disabled = function(info)
			        		local parent = getParent(info)
			        		return parent.matchHeight
			        	end,
						type = "range",
						order = 4,
						name = "Height",
						min = 1,
						max = floor(GetScreenHeight()),
						step = 1,
						softMin = 1,
						softMax = 500,
						get = "Get",
						set = "Set",
					}
				}
		    },
		    background = backgroundSetting(3),
	        orientation = {
	        	disabled = parentDisabled,
				type = "select",
				order = 4,
				name = "Orientation",
				values = createDropdownTable("HORIZONTAL", "VERTICAL"),
				get = "Get",
				set = "Set"
	        },
	        reversed = {
	        	disabled = parentDisabled,
				type = "toggle",
				order = 5,
				name = "Reversed",
				get = "Get",
				set = "Set"
			},
	        texture = {
	        	disabled = parentDisabled,
				type = "select",
				order = 6,
				name = "Texture",
		      	values = media:HashTable("statusbar"),
		      	dialogControl = "LSM30_Statusbar",
				get = "Get",
				set = "Set"
	        },
		    x = {
            	disabled = parentDisabled,
				type = "range",
				order = 7,
				name = "Attached Offset X",
				min = -500,
				max = 500,
				step = 1,
				get = "Get",
				set = "Set",
		    },
		    y = {
            	disabled = parentDisabled,
				type = "range",
				order = 8,
				name = "Attached Offset Y",
				min = -500,
				max = 500,
				step = 1,
				get = "Get",
				set = "Set",
		    },
		    attached = {
	        	disabled = parentDisabled,
				type = "toggle",
				order = 9,
				name = "Attached",
				get = "Get",
				set = "Set"
			},
		    attachedPosition = {
            	disabled = function(info)
            		local parent = getParent(info)
            		return not (parent.enabled and parent.attached)
            	end,
    			type = "select",
				order = 10,
				name = "Attached Position",
				values = createDropdownTable("Above", "Below", "Left", "Right"),
				get = "Get",
				set = "Set"
            }
		}
	}
end

local function castBarSetting(order)
	return {
		type = "group",
		order = order,
		name = "Castbar",
		args = {
		    enabled = {
				type = "toggle",
				order = 1,
				name = "Enabled",
				get = "Get",
				set = "Set"
			},
		    texture = {
	        	disabled = parentDisabled,
				type = "select",
				order = 2,
				name = "Texture",
		      	values = media:HashTable("statusbar"),
		      	dialogControl = "LSM30_Statusbar",
				get = "Get",
				set = "Set"
	        },
			colorBy = {
				disabled = parentDisabled,
				type = "select",
				order = 3,
				name = "Color By",
				values = createDropdownTable("Class", "health", "power", "Custom"),
				get = "Get",
				set = "Set"
	        },
	        customColor = {
	        	disabled = function(info)
	        		local parent = getParent(info)
	        		return not (parent.enabled and parent.colorBy == "Custom")
	        	end,
	        	type = "color",
	        	order = 4,
	        	name = "Custom Color",
	        	hasAlpha = true,
	        	get = "Get",
	        	set = "Set"
	        },
	        mult = {
	        	disabled = parentDisabled,
				type = "range",
				order = 5,
				name = "Background Multiplier",
				min = -1,
				max = 1,
				isPercent = true,
				get = "Get",
				set = "Set",
			},
	        orientation = {
	        	disabled = parentDisabled,
				type = "select",
				order = 6,
				name = "Orientation",
				values = createDropdownTable("HORIZONTAL", "VERTICAL"),
				get = "Get",
				set = "Set"
	        },
	        reversed = {
	        	disabled = parentDisabled,
				type = "toggle",
				order = 7,
				name = "Reversed",
				get = "Get",
				set = "Set"
			},
			size = {
				disabled = parentDisabled,
				type = "group",
				order = 8,
				name = "Size",
				args = {
					matchWidth = {
						type = "toggle",
						order = 1,
						name = "Match Width",
						get = "Get",
						set = "Set"
					},
					matchHeight = {
						type = "toggle",
						order = 2,
						name = "Match Height",
						get = "Get",
						set = "Set"
					},
					width = {
						disabled = function(info)
		            		local parent = getParent(info)
		            		return parent.matchWidth
		            	end,
						type = "range",
						order = 3,
						name = "Width",
						min = 1,
						max = floor(GetScreenWidth()),
						step = 1,
						softMin = 1,
						softMax = 500,
						get = "Get",
						set = "Set",
					},
					height = {
						disabled = function(info)
		            		local parent = getParent(info)
		            		return parent.matchHeight
		            	end,
						type = "range",
						order = 4,
						name = "Height",
						min = 1,
						max = floor(GetScreenHeight()),
						step = 1,
						softMin = 1,
						softMax = 500,
						get = "Get",
						set = "Set",
					}
				}
			},
		    time = {
		    	type = "group",
		    	order = 9,
		    	name = "Time",
		    	args = {
					enabled = {
						type = "toggle",
						order = 1,
						name = "Enabled",
						get = "Get",
						set = "Set"
					},
			        position = positionSetting(2),
					size = {
						type = "range",
						order = 3,
						name = "Text Size",
						min = 1,
						max = 100,
						step = 1,
						get = "Get",
						set = "Set"
					},
			        format = {
			        	type = "input",
			        	order = 4,
			        	desc = "Available tags are: [current] and [max]",
			        	name = "Format",
			        	get = "Get",
			        	set = "Set",
			    	}
			    }
		    },
		    name = {
		    	type = "group",
		    	order = 9,
		    	name = "Time",
		    	args = {
					enabled = {
						type = "toggle",
						order = 1,
						name = "Enabled",
						get = "Get",
						set = "Set"
					},
			        position = positionSetting(2),
					size = {
						type = "range",
						order = 3,
						name = "Text Size",
						min = 1,
						max = 100,
						step = 1,
						get = "Get",
						set = "Set"
					},
			        format = {
			        	type = "input",
			        	order = 4,
			        	desc = "Available tags are: [name] and [target]",
			        	name = "Format",
			        	get = "Get",
			        	set = "Set",
			    	}
			    }
		    },
		    icon = {
		    	type = "group",
		    	order = 10,
		    	name = "Icon",
		    	args = {
					enabled = {
						type = "toggle",
						order = 1,
						name = "Enabled",
						get = "Get",
						set = "Set"
					},
			        position = {
			        	type = "select",
			        	order = 2,
			        	name = "Position",
			        	get = "Get",
			        	set = "Set",
			        	values = createDropdownTable("Left", "Right", "Top", "Bottom")
			        },
					size = {
						disabled = parentDisabled,
						type = "group",
						order = 3,
						name = "Size",
						args = {
							matchWidth = {
								type = "toggle",
								order = 1,
								name = "Match Width",
								get = "Get",
								set = "Set"
							},
							matchHeight = {
								type = "toggle",
								order = 2,
								name = "Match Height",
								get = "Get",
								set = "Set"
							},
							size = {
								disabled = function(info)
				            		local parent = getParent(info)
				            		return parent.matchWidth or parent.matchHeight
				            	end,
								type = "range",
								order = 3,
								name = "Size",
								min = 1,
								max = 100,
								step = 1,
								get = "Get",
								set = "Set",
							},
						}
					},
			        background = backgroundSetting(4),
			    }
		    },
		    background = backgroundSetting(11),
			attached = {
				disabled = parentDisabled,
				type = "toggle",
				order = 12,
				name = "Attached",
				get = "Get",
				set = "Set"
			},
	        attachedPosition = {
	        	disabled = function(info)
	        		local parent = getParent(info)
	        		return not (parent.enabled and parent.attached)
	        	end,
				type = "select",
				order = 13,
				name = "Attached Position",
				values = createDropdownTable("Above", "Below", "Left", "Right"),
				get = "Get",
				set = "Set"
	        },
	        x = {
	        	disabled = function(info)
	        		local parent = getParent(info)
	        		return not (parent.enabled and parent.attached)
	        	end,
	        	type = "range",
	        	order = 14,
	        	name = "Attached Offset X",
	        	min = -500,
	        	max = 500,
	        	step = 1,
	        	get = "Get",
	        	set = "Set"
	    	},
	    	y = {
	        	disabled = function(info)
	        		local parent = getParent(info)
	        		return not (parent.enabled and parent.attached)
	        	end,
	        	type = "range",
	        	order = 15,
	        	name = "Attached Offset Y",
	        	min = -500,
	        	max = 500,
	        	step = 1,
	        	get = "Get",
	        	set = "Set"
	    	},
	        missingBar = {
	        	disabled = false,
	        	type = "group",
	        	order = 16,
	        	name = "Missing Bar",
	        	desc = "Bar that is displayed in place of the missing part of the original bar.",
	        	args = {
	                enabled = {
						type = "toggle",
						order = 1,
						name = "Enabled",
						get = "Get",
						set = "Set"
					},
	                customColor = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.colorBy == "Custom")
		            	end,
	                	type = "color",
	                	order = 2,
	                	name = "Custom Color",
	                	hasAlpha = true,
	                	get = "Get",
	                	set = "Set"
	                },
	                colorBy = {
	                	disabled = parentDisabled,
						type = "select",
						order = 3,
						name = "Color By",
						values = createDropdownTable("Class", "health", "power", "Gradient", "Custom"),
						get = "Get",
						set = "Set"
	                },
	        	}
	        }
		}
	}
end

local function statusCategory(name, order)
	return {
		type = "group",
		order = order,
		name = name,
		args = {
	        action = {
	        	type = "select",
	        	order = 1,
	        	name = "Action",
	        	values = createDropdownTable("Modify", "Present"),
				get = "Get",
				set = "Set"
	        },
	        settings = {
	        	type = "group",
	        	order = 1,
	        	name = "Settings",
	        	args = {
	                present = {
	                	type = "select",
	                	order = 1,
	                	name = "Present Type",
	                	values = createDropdownTable("None", "Text", "Icon"),
	                	get = "Get",
						set = "Set"
	                },
	                modify = {
	                	type = "select",
	                	order = 2,
	                	name = "Modify Type",
	                	values = createDropdownTable("Alpha", "Color", "None"),
	                	get = "Get",
						set = "Set"
	                },
	                alpha = {
	                	type = "range",
	                	order = 3,
	                	name = "Alpha",
	                	min = 0,
	                	max = 100,
	                	step = 1,
	                	get = "Get",
						set = "Set"
	                },
	                color = {
	                	type = "color",
	                	name = "Color",
	                	hasAlpha = true,
	                	get = "Get",
						set = "Set"
	                },
	                iconSize = {
	                	type = "range",
	                	order = 5,
	                	name = "Icon Size",
	                	min = 1,
	                	max = 100,
	                	step = 1,
	                	get = "Get",
						set = "Set"
	                },
	                icon = {
						type = "select",
						order = 6,
						name = "Icon",
						desc = "Uses the shared media textures that has background as type",
				      	values = media:HashTable("background"),
				      	dialogControl = "LSM30_Background",
	                	get = "Get",
						set = "Set"
	                },
	                size = {
	                	type = "range",
	                	order = 7,
	                	name = "Text Size",
	                	min = 1,
	                	max = 100,
	                	step = 1,
	                	get = "Get",
						set = "Set"
	                },
	                position = positionSetting(8)
	            }
	        }
	    }
	}
end

local function statusSetting(order)
	return {
		type = "group",
		order = order,
		name = "Status",
		desc = "Modify or Present changes during certain statuses for the units, e.g. dead, offline, not in range and ghost",
		args = {
			range = statusCategory("Range", 1),
			dead = statusCategory("Dead", 2),
			offline = statusCategory("Offline", 3),
			ghost = statusCategory("Ghost", 4) 
		}
	}
end

local function groupBuffSetting(order, db)
	local arg = {
		size = {
			type = "range",
			order = 1,
			name = "Size",
			min = 1,
			max = 100,
			step = 1,
			get = "Get",
			set = "Set"
		},
		position = positionSetting(2),
		hideNumbers = {
			type = "toggle",
			order = 3,
			name = "Hide Cooldown Number",
		},
		delete = {
			type = "execute",
			order = 4,
			name = "Remove",
			func = function(info)
				print(info[#info - 1])
			end,
			get = "Get",
			set = "Set"
		}
	}

	local o = 1
	local args = {}
	for spellId,_ in next, db.tracked do
		args[spellId] = {
			type = "group",
			order = o,
			name = spellId,
			args = arg,
		}
		o = o + 1
	end

	local options = {
    	disabled = parentDisabled,
    	type = "group",
    	order = order,
    	name = "Group Buffs",
    	args = {
			enabled = {
				type = "toggle",
				order = 1,
				name = "Enabled",
				get = "Get",
				set = "Set"
			},
			add = {
				type = "input",
				order = 2,
				name = "Add new",
				get = function(info) return "" end,
				set = function(info, id)
					local db = getParent(info)
					if (db.tracked[id]) then
						print("Group Buffs: The spell ", id, " is already tracked!")
						return
					end

					db.tracked[id] = {
						size = 10,
						position = {
							localPoint = "CENTER",
							point = "CENTER",
							x = 0,
							y = 0
						},
						hideNumbers = false,
					}

					local unit = info[#info - 3]
					
					info.options.args.units.args[unit].args.groupbuffs.args.tracked[key] = {
                    	type = "group",
                    	order = T:tcount(db),
                    	name = key,
                    	args = arg
                	}
                    A:NotifyConfigChanges()
					A:UpdateDb()
				end,
			},
            tracked = {
            	disabled = parentDisabled,
            	type = "group",
            	order = 3,
            	name = "Tracked",
            	args = args
            },
        }
    }

    return options
end

local function groupRoleSetting(order)
	return {
		disabled = parentDisabled,
		type = "group",
		order = order,
		name = "Role",
		args = {
			enabled = {
				type = "toggle",
				order = 1,
				name = "Enabled",
				get = "Get",
				set = "Set"
			},
			style = {
	        	type = "select",
	        	order = 2,
	        	name = "Style",
	        	values = createDropdownTable("Text", "Letter", "Blizzard"),
				get = "Get",
				set = "Set"
	        },
	        position = positionSetting(3),
	        size = {
	       		type = "range",
	       		order = 4,
	       		name = "Size",
	       		min = 1,
	       		max = 100,
				get = "Get",
				set = "Set"
	        },
	        textSize = {
	        	disabled = function(info)
	        		local parent = getParent(info)
	        		return not (parent.enabled and (parent.style == "Text" or parent.style == "Letter"))
	        	end,
	       		type = "range",
	       		order = 5,
	       		name = "Text Size",
	       		min = 1,
	       		max = 100,
				get = "Get",
				set = "Set"
	        },
	        color = {
	        	disabled = function(info)
	        		local parent = getParent(info)
	        		return not (parent.enabled and (parent.style == "Text" or parent.style == "Letter"))
	        	end,
	        	type = "color",
	        	order = 6,
	        	name = "Text Color",
				get = "Get",
				set = "Set"
	    	},
	        textStyle = {
	        	disabled = function(info)
	        		local parent = getParent(info)
	        		return not (parent.enabled and (parent.style == "Text" or parent.style == "Letter"))
	        	end,
	        	type = "select",
	        	order = 7,
	        	name = "Text Style",
	        	values = createDropdownTable("None", "Outline", "Thick Outline", "Shadow"),
				get = "Get",
				set = "Set"
	        },
	    }
    }
end

local function standardUnit(name, db, order)
	return {
		type = "group",
		order = order,
		name = name,
		childGroups = "tab",
		args = {
			enabled = {
				type = "toggle",
				order = 1,
				name = "Enabled",
				get = "Get",
				set = "Set"
			},
			health = {
				disabled = parentDisabled,
				type = "group",
				order = 2,
				name = "Health",
				childGroups = "tab",
				args = {
					enabled = {
						disabled = parentDisabled,
						type = "toggle",
						order = 1,
						name = "Enabled",
						get = "Get",
						set = "Set"
					},
					colorBy = {
						disabled = parentDisabled,
						type = "select",
						order = 2,
						name = "Color By",
						values = createDropdownTable("Class", "health", "Gradient", "Custom"),
						get = "Get",
						set = "Set"
		            },
		            customColor = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.colorBy == "Custom")
		            	end,
	                	type = "color",
	                	order = 3,
	                	name = "Custom Color",
	                	hasAlpha = true,
	                	get = "Get",
	                	set = "Set"
	                },
		            mult = {
		            	disabled = parentDisabled,
						type = "range",
						order = 4,
						name = "Background Multiplier",
						min = -1,
						max = 1,
						isPercent = true,
						get = "Get",
						set = "Set",
					},
		            orientation = {
		            	disabled = parentDisabled,
						type = "select",
						order = 5,
						name = "Orientation",
						values = createDropdownTable("HORIZONTAL", "VERTICAL"),
						get = "Get",
						set = "Set"
		            },
		            reversed = {
		            	disabled = parentDisabled,
						type = "toggle",
						order = 6,
						name = "Reversed",
						get = "Get",
						set = "Set"
					},
		            texture = {
		            	disabled = parentDisabled,
						type = "select",
						order = 7,
						name = "Texture",
				      	values = media:HashTable("statusbar"),
				      	dialogControl = "LSM30_Statusbar",
						get = "Get",
						set = "Set"
		            },
					position = positionSetting(8, createDropdownTable(name, "power")),
					size = {
						disabled = parentDisabled,
						type = "group",
						order = 9,
						name = "Size",
						args = {
							matchWidth = {
								type = "toggle",
								order = 1,
								name = "Match Width",
								get = "Get",
								set = "Set"
							},
							matchHeight = {
								type = "toggle",
								order = 2,
								name = "Match Height",
								get = "Get",
								set = "Set"
							},
							width = {
								disabled = function(info)
				            		local parent = getParent(info)
				            		return parent.matchWidth
				            	end,
								type = "range",
								order = 3,
								name = "Width",
								min = 1,
								max = floor(GetScreenWidth()),
								step = 1,
								softMin = 1,
								softMax = 500,
								get = "Get",
								set = "Set",
							},
							height = {
								disabled = function(info)
				            		local parent = getParent(info)
				            		return parent.matchHeight
				            	end,
								type = "range",
								order = 4,
								name = "Height",
								min = 1,
								max = floor(GetScreenHeight()),
								step = 1,
								softMin = 1,
								softMax = 500,
								get = "Get",
								set = "Set",
							}
						}
					},
		            missingBar = {
		            	disabled = false,
		            	type = "group",
		            	order = 10,
		            	name = "Missing Bar",
		            	desc = "Bar that is displayed in place of the missing part of the original bar.",
		            	args = {
			                enabled = {
								type = "toggle",
								order = 1,
								name = "Enabled",
								get = "Get",
								set = "Set"
							},
			                customColor = {
				            	disabled = function(info)
				            		local parent = getParent(info)
				            		return not (parent.enabled and parent.colorBy == "Custom")
				            	end,
			                	type = "color",
			                	order = 2,
			                	name = "Custom Color",
			                	hasAlpha = true,
			                	get = "Get",
			                	set = "Set"
			                },
			                colorBy = {
			                	disabled = parentDisabled,
								type = "select",
								order = 3,
								name = "Color By",
								values = createDropdownTable("Class", "health", "power", "Gradient", "Custom"),
								get = "Get",
								set = "Set"
			                },
		            	}
		            }
		        }
			},
			power = {
				disabled = parentDisabled,
				type = "group",
				order = 3,
				name = "Power",
				childGroups = "tab",
				args = {
					enabled = {
						type = "toggle",
						order = 1,
						name = "Enabled",
						get = "Get",
						set = "Set"
					},
					colorBy = {
						disabled = parentDisabled,
						type = "select",
						order = 2,
						name = "Color By",
						values = createDropdownTable("Class", "power", "Custom"),
						get = "Get",
						set = "Set"
		            },
		            customColor = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.colorBy == "Custom")
		            	end,
	                	type = "color",
	                	order = 3,
	                	name = "Custom Color",
	                	hasAlpha = true,
	                	get = "Get",
	                	set = "Set"
	                },
		            mult = {
						disabled = parentDisabled,
						type = "range",
						order = 4,
						name = "Background Multiplier",
						min = -1,
						max = 1,
						isPercent = true,
						get = "Get",
						set = "Set",
					},
		            orientation = {
						disabled = parentDisabled,
						type = "select",
						order = 5,
						name = "Orientation",
						values = createDropdownTable("HORIZONTAL", "VERTICAL"),
						get = "Get",
						set = "Set"
		            },
		            reversed = {
						disabled = parentDisabled,
						type = "toggle",
						order = 6,
						name = "Reversed",
						get = "Get",
						set = "Set"
					},
		            texture = {
						disabled = parentDisabled,
						type = "select",
						order = 7,
						name = "Texture",
				      	values = media:HashTable("statusbar"),
				      	dialogControl = "LSM30_Statusbar",
						get = "Get",
						set = "Set"
		            },
					position = positionSetting(8, createDropdownTable(name, "health")),
					size = {
						disabled = parentDisabled,
						type = "group",
						order = 9,
						name = "Size",
						args = {
							matchWidth = {
								type = "toggle",
								order = 1,
								name = "Match Width",
								get = "Get",
								set = "Set"
							},
							matchHeight = {
								type = "toggle",
								order = 2,
								name = "Match Height",
								get = "Get",
								set = "Set"
							},
							width = {
								disabled = function(info)
				            		local parent = getParent(info)
				            		return parent.matchWidth
				            	end,
								type = "range",
								order = 3,
								name = "Width",
								min = 1,
								max = floor(GetScreenWidth()),
								step = 1,
								softMin = 1,
								softMax = 500,
								get = "Get",
								set = "Set",
							},
							height = {
								disabled = function(info)
				            		local parent = getParent(info)
				            		return parent.matchHeight
				            	end,
								type = "range",
								order = 4,
								name = "Height",
								min = 1,
								max = floor(GetScreenHeight()),
								step = 1,
								softMin = 1,
								softMax = 500,
								get = "Get",
								set = "Set",
							}
						}
					},
		            missingBar = {
		            	disabled = false,
		            	type = "group",
		            	order = 10,
		            	name = "Missing Bar",
		            	desc = "Bar that is displayed in place of the missing part of the original bar.",
		            	args = {
			                enabled = {
								type = "toggle",
								order = 1,
								name = "Enabled",
								get = "Get",
								set = "Set"
							},
			                customColor = {
				            	disabled = function(info)
				            		local parent = getParent(info)
				            		return not (parent.enabled and parent.colorBy == "Custom")
				            	end,
			                	type = "color",
			                	order = 2,
			                	name = "Custom Color",
			                	hasAlpha = true,
			                	get = "Get",
			                	set = "Set"
			                },
			                colorBy = {
			                	disabled = parentDisabled,
								type = "select",
								order = 3,
								name = "Color By",
								values = createDropdownTable("Class", "health", "power", "Gradient", "Custom"),
								get = "Get",
								set = "Set"
			                },
		            	}
		            }
				}
			},
			buffs = {
				disabled = parentDisabled,
				type = "group",
				order = 4,
				name = "Buffs",
				childGroups = "tab",
				args = {
					enabled = {
						type = "toggle",
						order = 1,
						name = "Enabled",
						get = "Get",
						set = "Set"
					},
		            style = {
		           		disabled = parentDisabled,
            			type = "select",
						order = 2,
						name = "Style",
						values = createDropdownTable("Bar", "Icon"),
						get = "Get",
						set = "Set"
		            },
		            barGrowth = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.style == "Bar")
		            	end,
            			type = "select",
						order = 3,
						name = "Bar Growth",
						values = createDropdownTable("Upwards", "Downwards"),
						get = "Get",
						set = "Set"
		            },
		            iconGrowth = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.style == "Icon")
		            	end,
            			type = "select",
						order = 4,
						name = "Icon Growth",
						values = createDropdownTable("Right Then Down", "Right Then Up", "Left Then Down", "Left Then Up"),
						get = "Get",
						set = "Set"
		        	},
		            spacingX = {
		            	disabled = parentDisabled,
		            	type = "range",
		            	order = 5,
		            	name = "X Spacing",
		            	min = -10,
		            	max = 10,
		            	step = 1,
		            	get = "Get",
		            	set = "Set"
		            },
		            spacingY = {
		            	disabled = parentDisabled,
		            	type = "range",
		            	order = 6,
		            	name = "Y Spacing",
		            	min = -10,
		            	max = 10,
		            	step = 1,
		            	get = "Get",
		            	set = "Set"
		            },
		            iconLimit = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.style == "Icon")
		            	end,
		            	type = "range",
		            	order = 7,
		            	name = "Icon Limit",
		            	min = 1,
		            	max = 40,
		            	step = 1,
		            	get = "Get",
		            	set = "Set"
		            },
		            iconTextSize = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.style == "Icon")
		            	end,
		            	type = "range",
		            	order = 8,
		            	name = "Icon Text Size",
		            	min = 1,
		            	max = 100,
		            	step = 1,
		            	get = "Get",
		            	set = "Set"
		        	},
					attached = {
						disabled = parentDisabled,
						type = "toggle",
						order = 9,
						name = "Attached",
						get = "Get",
						set = "Set"
					},
		            attachedPosition = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.attached)
		            	end,
            			type = "select",
						order = 10,
						name = "Attached Position",
						values = createDropdownTable("Above", "Below", "Left", "Right"),
						get = "Get",
						set = "Set"
		            },
		            x = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.attached)
		            	end,
		            	type = "range",
		            	order = 11,
		            	name = "Attached Offset X",
		            	min = -500,
		            	max = 500,
		            	step = 1,
		            	get = "Get",
		            	set = "Set"
		        	},
		        	y = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.attached)
		            	end,
		            	type = "range",
		            	order = 12,
		            	name = "Attached Offset Y",
		            	min = -500,
		            	max = 500,
		            	step = 1,
		            	get = "Get",
		            	set = "Set"
		        	},
		            limit = {
		            	disabled = parentDisabled,
		            	type = "range",
		            	order = 13,
		            	name = "Aura Limit",
		            	min = 1,
		            	max = 40,
		            	step = 1,
		            	get = "Get",
		            	set = "Set"
		            },
		            hideNoDuration = {
		            	disabled = parentDisabled,
						type = "toggle",
						order = 14,
						name = "Hide No Duration",
						desc = "Hide auras that never expire, e.g. mounts, weekly event buffs, etc.",
						get = "Get",
						set = "Set"
		            },
		            own = {
		            	disabled = parentDisabled,
						type = "toggle",
						order = 15,
						name = "Own Only",
						desc = "Only show auras cast by yourself",
						get = "Get",
						set = "Set"
		            },
		            colorBy = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.style == "Bar")
		            	end,
						type = "select",
						order = 16,
						name = "Color By",
						values = createDropdownTable("Class", "health", "power", "Gradient", "Custom"),
						get = "Get",
						set = "Set"
		        	},
		            customColor = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.style == "Bar" and parent.colorBy == "Custom")
		            	end,
	                	type = "color",
	                	order = 17,
	                	name = "Custom Color",
	                	hasAlpha = true,
	                	get = "Get",
	                	set = "Set"
		            },
		            mult = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.style == "Bar")
		            	end,
						type = "range",
						order = 18,
						name = "Background Multiplier",
						min = -1,
						max = 1,
						isPercent = true,
						get = "Get",
						set = "Set",
		            },
		            reversed = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.style == "Bar")
		            	end,
						type = "toggle",
						order = 19,
						name = "Reversed",
						get = "Get",
						set = "Set"
		            },
		            texture = {
		            	disabled = parentDisabled,
						type = "select",
						order = 20,
						name = "Texture",
				      	values = media:HashTable("statusbar"),
				      	dialogControl = "LSM30_Statusbar",
						get = "Get",
						set = "Set"
		            },
		            size = {
		            	disabled = parentDisabled,
		            	type = "group",
		            	order = 21,
		            	name = "Size",
		            	args = {
							matchWidth = {
								type = "toggle",
								order = 1,
								name = "Match Width",
								get = "Get",
								set = "Set"
							},
							matchHeight = {
								type = "toggle",
								order = 2,
								name = "Match Height",
								get = "Get",
								set = "Set"
							},
							width = {
								disabled = function(info)
				            		local parent = getParent(info)
				            		return parent.matchWidth
				            	end,
								type = "range",
								order = 3,
								name = "Width",
								min = 1,
								max = floor(GetScreenWidth()),
								step = 1,
								softMin = 1,
								softMax = 500,
								get = "Get",
								set = "Set",
							},
							height = {
								disabled = function(info)
				            		local parent = getParent(info)
				            		return parent.matchHeight
				            	end,
								type = "range",
								order = 4,
								name = "Height",
								min = 1,
								max = floor(GetScreenHeight()),
								step = 1,
								softMin = 1,
								softMax = 500,
								get = "Get",
								set = "Set",
							}
			            }
		            },
		            name = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.style == "Bar")
		            	end,
		            	type = "group",
		            	order = 22,
		            	name = "Name",
		            	args = {
		            		enabled = {
								type = "toggle",
								order = 1,
								name = "Enabled",
								get = "Get",
								set = "Set"
		            		},
			                size = {
			                	disabled = parentDisabled,
								type = "range",
								order = 2,
								name = "Text Size",
								min = 1,
								max = 100,
								step = 1,
								get = "Get",
								set = "Set",
			                },
			                position = positionSetting(3)
			            }
		            },
		            time = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.style == "Bar")
		            	end,
		            	type = "group",
		            	order = 23,
		            	name = "Time",
		            	args = {
		            		enabled = {
								type = "toggle",
								order = 1,
								name = "Enabled",
								get = "Get",
								set = "Set"
		            		},
			                size = {
			                	disabled = parentDisabled,
								type = "range",
								order = 2,
								name = "Text Size",
								min = 1,
								max = 100,
								step = 1,
								get = "Get",
								set = "Set",
			                },
			                position = positionSetting(3)
			            }
		            },
		            background = backgroundSetting(24),
		            blacklist = {
		            	disabled = parentDisabled,
		            	type = "group",
		            	order = 25,
		            	name = "Blacklist",
		            	args = {
		            		enabled = {
								type = "toggle",
								order = 1,
								name = "Enabled",
								get = "Get",
								set = "Set"
		            		},
		            		ids = {
		            			disabled = parentDisabled,
		            			type = "group",
		            			order = 2,
		            			name = "Ids",
		            			args = {

		            			}
		            		}
		            	}
		            },
		            whitelist = { -- Contruct this properly
		            	disabled = parentDisabled,
		            	type = "group",
		            	order = 26,
		            	name = "WhiteList",
		            	args = {
		            		enabled = {
								type = "toggle",
								order = 1,
								name = "Enabled",
								get = "Get",
								set = "Set"
		            		},
		            		ids = {
		            			disabled = parentDisabled,
		            			type = "group",
		            			order = 2,
		            			name = "Ids",
		            			args = {
		            				
		            			}
		            		}
		            	}
		            },
		        }
			},
			debuffs = {
				disabled = parentDisabled,
				type = "group",
				order = 5,
				name = "Debuffs",
				childGroups = "tab",
				args = {
					enabled = {
						type = "toggle",
						order = 1,
						name = "Enabled",
						get = "Get",
						set = "Set"
					},
		            style = {
		           		disabled = parentDisabled,
            			type = "select",
						order = 2,
						name = "Style",
						values = createDropdownTable("Bar", "Icon"),
						get = "Get",
						set = "Set"
		            },
		            barGrowth = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.style == "Bar")
		            	end,
            			type = "select",
						order = 3,
						name = "Bar Growth",
						values = createDropdownTable("Upwards", "Downwards"),
						get = "Get",
						set = "Set"
		            },
		            iconGrowth = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.style == "Icon")
		            	end,
            			type = "select",
						order = 4,
						name = "Icon Growth",
						values = createDropdownTable("Right Then Down", "Right Then Up", "Left Then Down", "Left Then Up"),
						get = "Get",
						set = "Set"
		        	},
		            spacingX = {
		            	disabled = parentDisabled,
		            	type = "range",
		            	order = 5,
		            	name = "X Spacing",
		            	min = -10,
		            	max = 10,
		            	step = 1,
		            	get = "Get",
		            	set = "Set"
		            },
		            spacingY = {
		            	disabled = parentDisabled,
		            	type = "range",
		            	order = 6,
		            	name = "Y Spacing",
		            	min = -10,
		            	max = 10,
		            	step = 1,
		            	get = "Get",
		            	set = "Set"
		            },
		            iconLimit = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.style == "Icon")
		            	end,
		            	type = "range",
		            	order = 7,
		            	name = "Icon Limit",
		            	min = 1,
		            	max = 40,
		            	step = 1,
		            	get = "Get",
		            	set = "Set"
		            },
		            iconTextSize = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.style == "Icon")
		            	end,
		            	type = "range",
		            	order = 8,
		            	name = "Icon Limit",
		            	min = 1,
		            	max = 40,
		            	step = 1,
		            	get = "Get",
		            	set = "Set"
		        	},
					attached = {
						disabled = parentDisabled,
						type = "toggle",
						order = 9,
						name = "Attached",
						get = "Get",
						set = "Set"
					},
		            attachedPosition = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.attached)
		            	end,
            			type = "select",
						order = 10,
						name = "Attached Position",
						values = createDropdownTable("Above", "Below", "Left", "Right"),
						get = "Get",
						set = "Set"
		            },
		            x = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.attached)
		            	end,
		            	type = "range",
		            	order = 11,
		            	name = "Attached Offset X",
		            	min = -500,
		            	max = 500,
		            	step = 1,
		            	get = "Get",
		            	set = "Set"
		        	},
		        	y = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.attached)
		            	end,
		            	type = "range",
		            	order = 12,
		            	name = "Attached Offset Y",
		            	min = -500,
		            	max = 500,
		            	step = 1,
		            	get = "Get",
		            	set = "Set"
		        	},
		            limit = {
		            	disabled = parentDisabled,
		            	type = "range",
		            	order = 13,
		            	name = "Aura Limit",
		            	min = 1,
		            	max = 40,
		            	step = 1,
		            	get = "Get",
		            	set = "Set"
		            },
		            own = {
		            	disabled = parentDisabled,
						type = "toggle",
						order = 14,
						name = "Own Only",
						desc = "Only show auras cast by yourself",
						get = "Get",
						set = "Set"
		            },
		            colorBy = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.style == "Bar")
		            	end,
						type = "select",
						order = 15,
						name = "Color By",
						values = createDropdownTable("Class", "health", "power", "Gradient", "Custom"),
						get = "Get",
						set = "Set"
		        	},
		            customColor = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.style == "Bar" and parent.colorBy == "Custom")
		            	end,
	                	type = "color",
	                	order = 16,
	                	name = "Custom Color",
	                	hasAlpha = true,
	                	get = "Get",
	                	set = "Set"
		            },
		            mult = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.style == "Bar")
		            	end,
						type = "range",
						order = 17,
						name = "Background Multiplier",
						min = -1,
						max = 1,
						isPercent = true,
						get = "Get",
						set = "Set",
		            },
		            reversed = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.style == "Bar")
		            	end,
						type = "toggle",
						order = 18,
						name = "Reversed",
						get = "Get",
						set = "Set"
		            },
		            texture = {
		            	disabled = parentDisabled,
						type = "select",
						order = 19,
						name = "Texture",
				      	values = media:HashTable("statusbar"),
				      	dialogControl = "LSM30_Statusbar",
						get = "Get",
						set = "Set"
		            },
		            size = {
		            	disabled = parentDisabled,
		            	type = "group",
		            	order = 20,
		            	name = "Size",
		            	args = {
							matchWidth = {
								type = "toggle",
								order = 1,
								name = "Match Width",
								get = "Get",
								set = "Set"
							},
							matchHeight = {
								type = "toggle",
								order = 2,
								name = "Match Height",
								get = "Get",
								set = "Set"
							},
							width = {
								disabled = function(info)
				            		local parent = getParent(info)
				            		return parent.matchWidth
				            	end,
								type = "range",
								order = 3,
								name = "Width",
								min = 1,
								max = floor(GetScreenWidth()),
								step = 1,
								softMin = 1,
								softMax = 500,
								get = "Get",
								set = "Set",
							},
							height = {
								disabled = function(info)
				            		local parent = getParent(info)
				            		return parent.matchHeight
				            	end,
								type = "range",
								order = 4,
								name = "Height",
								min = 1,
								max = floor(GetScreenHeight()),
								step = 1,
								softMin = 1,
								softMax = 500,
								get = "Get",
								set = "Set",
							}
			            }
		            },
		            name = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.style == "Bar")
		            	end,
		            	type = "group",
		            	order = 21,
		            	name = "Name",
		            	args = {
		            		enabled = {
								type = "toggle",
								order = 1,
								name = "Enabled",
								get = "Get",
								set = "Set"
		            		},
			                size = {
			                	disabled = parentDisabled,
								type = "range",
								order = 2,
								name = "Text Size",
								min = 1,
								max = 100,
								step = 1,
								get = "Get",
								set = "Set",
			                },
			                position = positionSetting(3)
			            }
		            },
		            time = {
		            	disabled = function(info)
		            		local parent = getParent(info)
		            		return not (parent.enabled and parent.style == "Bar")
		            	end,
		            	type = "group",
		            	order = 22,
		            	name = "Time",
		            	args = {
		            		enabled = {
								type = "toggle",
								order = 1,
								name = "Enabled",
								get = "Get",
								set = "Set"
		            		},
			                size = {
			                	disabled = parentDisabled,
								type = "range",
								order = 2,
								name = "Text Size",
								min = 1,
								max = 100,
								step = 1,
								get = "Get",
								set = "Set",
			                },
			                position = positionSetting(3)
			            }
		            },
		            background = backgroundSetting(23),
		            blacklist = {
		            	disabled = parentDisabled,
		            	type = "group",
		            	order = 24,
		            	name = "Blacklist",
		            	args = {
		            		enabled = {
								type = "toggle",
								order = 1,
								name = "Enabled",
								get = "Get",
								set = "Set"
		            		},
		            		ids = {
		            			disabled = parentDisabled,
		            			type = "group",
		            			order = 2,
		            			name = "Ids",
		            			args = {

		            			}
		            		}
		            	}
		            },
		            whitelist = { -- Contruct this properly
		            	disabled = parentDisabled,
		            	type = "group",
		            	order = 25,
		            	name = "WhiteList",
		            	args = {
		            		enabled = {
								type = "toggle",
								order = 1,
								name = "Enabled",
								get = "Get",
								set = "Set"
		            		},
		            		ids = {
		            			disabled = parentDisabled,
		            			type = "group",
		            			order = 2,
		            			name = "Ids",
		            			args = {
		            				
		            			}
		            		}
		            	}
		            }
		        }
			},
			size = {
				disabled = parentDisabled,
				type = "group",
				order = 6,
				name = "Size",
				args = {
					width = {
						type = "range",
						order = 2,
						name = "Width",
						min = 1,
						max = floor(GetScreenWidth()),
						step = 1,
						get = "Get",
						set = "Set",
	                },
					height = {
						type = "range",
						order = 2,
						name = "Height",
						min = 1,
						max = floor(GetScreenHeight()),
						step = 1,
						get = "Get",
						set = "Set",
					}
				}
			},
	        tags = constructTags(7, db, true),
	        healPrediction = {
	        	disabled = parentDisabled,
	        	type = "group",
	        	order = 8,
	        	name = "Heal Prediction",
	        	args = {
		            enabled = {
						type = "toggle",
						order = 1,
						name = "Enabled",
						get = "Get",
						set = "Set"
		        	},
		            texture = {
						disabled = parentDisabled,
						type = "select",
						order = 2,
						name = "Texture",
				      	values = media:HashTable("statusbar"),
				      	dialogControl = "LSM30_Statusbar",
						get = "Get",
						set = "Set"
		            },
		            overflow = {
		            	disabled = parentDisabled,
		            	type = "range",
		            	order = 3,
		            	name = "Max Overflow",
		            	min = 1,
		            	max = 2,
		            	step = 0.1,
		            	isPercent = true
		            },
		            colors = {
		            	disabled = parentDisabled,
		            	type = "group",
		            	order = 4,
		            	name = "Colors",
		            	args = {
			                my = {
			                	type = "color",
			                	order = 1,
			                	name = "My Heals",
			                	hasAlpha = true,
			                	get = "Get",
			                	set = "Set"
			                },
			                all = {
			                	type = "color",
			                	order = 2,
			                	name = "All Heals",
			                	hasAlpha = true,
			                	get = "Get",
			                	set = "Set"
			                },
			                absorb = {
			                	type = "color",
			                	order = 3,
			                	name = "Absorb",
			                	hasAlpha = true,
			                	get = "Get",
			                	set = "Set"
			                },
			                healAbsorb = {
			                	type = "color",
			                	order = 4,
			                	name = "Heal Absorb",
			                	hasAlpha = true,
			                	get = "Get",
			                	set = "Set"
			                }
			            }
		            }
		        }
	        },
	        background = backgroundSetting(9),
	        castbar = castBarSetting(10),
	        clickcast = clickCastSetting(11, db.clickcast)
		}
	}
end

function A:RegisterOptions()

	local O = {}
	function O:Get(info)
		local db = getParent(info)

		local value = db[info[#info]]
		if (type(value) == "table" and value.r) then
			return value.r, value.g, value.b, value.a
		end

		return value
	end
	function O:Set(info, arg1, arg2, arg3, arg4)
		local db = getParent(info)

		if (arg2) then
			db[info[#info]] = { r = arg1, g = arg2, b = arg3, a = arg4 }
		else
			db[info[#info]] = arg1
		end

		A:UpdateDb()
	end

	local db = A.db.profile

	A.options = {
		name = "CleanUI Options",
		type = "group",
		inline = true,
		handler = O,
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
						childGroups = "tab",
						args = {
							enabled = {
								type = "toggle",
								order = 1,
								name = "Enabled",
								get = "Get",
								set = "Set"
							},
							health = {
								disabled = parentDisabled,
								type = "group",
								order = 2,
								name = "Health",
								childGroups = "tab",
								args = {
									enabled = {
										disabled = parentDisabled,
										type = "toggle",
										order = 1,
										name = "Enabled",
										get = "Get",
										set = "Set"
									},
									colorBy = {
										disabled = parentDisabled,
										type = "select",
										order = 2,
										name = "Color By",
										values = createDropdownTable("Class", "health", "Gradient", "Custom"),
										get = "Get",
										set = "Set"
						            },
						            customColor = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.colorBy == "Custom")
						            	end,
					                	type = "color",
					                	order = 3,
					                	name = "Custom Color",
					                	hasAlpha = true,
					                	get = "Get",
					                	set = "Set"
					                },
						            mult = {
						            	disabled = parentDisabled,
										type = "range",
										order = 4,
										name = "Background Multiplier",
										min = -1,
										max = 1,
										isPercent = true,
										get = "Get",
										set = "Set",
									},
						            orientation = {
						            	disabled = parentDisabled,
										type = "select",
										order = 5,
										name = "Orientation",
										values = createDropdownTable("HORIZONTAL", "VERTICAL"),
										get = "Get",
										set = "Set"
						            },
						            reversed = {
						            	disabled = parentDisabled,
										type = "toggle",
										order = 6,
										name = "Reversed",
										get = "Get",
										set = "Set"
									},
						            texture = {
						            	disabled = parentDisabled,
										type = "select",
										order = 7,
										name = "Texture",
								      	values = media:HashTable("statusbar"),
								      	dialogControl = "LSM30_Statusbar",
										get = "Get",
										set = "Set"
						            },
									position = positionSetting(8, createDropdownTable("Player", "power")),
									size = {
										disabled = parentDisabled,
										type = "group",
										order = 9,
										name = "Size",
										args = {
											matchWidth = {
												type = "toggle",
												order = 1,
												name = "Match Width",
												get = "Get",
												set = "Set"
											},
											matchHeight = {
												type = "toggle",
												order = 2,
												name = "Match Height",
												get = "Get",
												set = "Set"
											},
											width = {
												disabled = function(info)
								            		local parent = getParent(info)
								            		return parent.matchWidth
								            	end,
												type = "range",
												order = 3,
												name = "Width",
												min = 1,
												max = floor(GetScreenWidth()),
												step = 1,
												softMin = 1,
												softMax = 500,
												get = "Get",
												set = "Set",
											},
											height = {
												disabled = function(info)
								            		local parent = getParent(info)
								            		return parent.matchHeight
								            	end,
												type = "range",
												order = 4,
												name = "Height",
												min = 1,
												max = floor(GetScreenHeight()),
												step = 1,
												softMin = 1,
												softMax = 500,
												get = "Get",
												set = "Set",
											}
										}
									},
						            missingBar = {
						            	disabled = false,
						            	type = "group",
						            	order = 10,
						            	name = "Missing Bar",
						            	desc = "Bar that is displayed in place of the missing part of the original bar.",
						            	args = {
							                enabled = {
												type = "toggle",
												order = 1,
												name = "Enabled",
												get = "Get",
												set = "Set"
											},
							                customColor = {
								            	disabled = function(info)
								            		local parent = getParent(info)
								            		return not (parent.enabled and parent.colorBy == "Custom")
								            	end,
							                	type = "color",
							                	order = 2,
							                	name = "Custom Color",
							                	hasAlpha = true,
							                	get = "Get",
							                	set = "Set"
							                },
							                colorBy = {
							                	disabled = parentDisabled,
												type = "select",
												order = 3,
												name = "Color By",
												values = createDropdownTable("Class", "health", "power", "Gradient", "Custom"),
												get = "Get",
												set = "Set"
							                },
						            	}
						            }
						        }
							},
							power = {
								disabled = parentDisabled,
								type = "group",
								order = 3,
								name = "Power",
								childGroups = "tab",
								args = {
									enabled = {
										type = "toggle",
										order = 1,
										name = "Enabled",
										get = "Get",
										set = "Set"
									},
									colorBy = {
										disabled = parentDisabled,
										type = "select",
										order = 2,
										name = "Color By",
										values = createDropdownTable("Class", "power", "Custom"),
										get = "Get",
										set = "Set"
						            },
						            customColor = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.colorBy == "Custom")
						            	end,
					                	type = "color",
					                	order = 3,
					                	name = "Custom Color",
					                	hasAlpha = true,
					                	get = "Get",
					                	set = "Set"
					                },
						            mult = {
										disabled = parentDisabled,
										type = "range",
										order = 4,
										name = "Background Multiplier",
										min = -1,
										max = 1,
										isPercent = true,
										get = "Get",
										set = "Set",
									},
						            orientation = {
										disabled = parentDisabled,
										type = "select",
										order = 5,
										name = "Orientation",
										values = createDropdownTable("HORIZONTAL", "VERTICAL"),
										get = "Get",
										set = "Set"
						            },
						            reversed = {
										disabled = parentDisabled,
										type = "toggle",
										order = 6,
										name = "Reversed",
										get = "Get",
										set = "Set"
									},
						            texture = {
										disabled = parentDisabled,
										type = "select",
										order = 7,
										name = "Texture",
								      	values = media:HashTable("statusbar"),
								      	dialogControl = "LSM30_Statusbar",
										get = "Get",
										set = "Set"
						            },
									position = positionSetting(8, createDropdownTable("Player", "health")),
									size = {
										disabled = parentDisabled,
										type = "group",
										order = 9,
										name = "Size",
										args = {
											matchWidth = {
												type = "toggle",
												order = 1,
												name = "Match Width",
												get = "Get",
												set = "Set"
											},
											matchHeight = {
												type = "toggle",
												order = 2,
												name = "Match Height",
												get = "Get",
												set = "Set"
											},
											width = {
												disabled = function(info)
								            		local parent = getParent(info)
								            		return parent.matchWidth
								            	end,
												type = "range",
												order = 3,
												name = "Width",
												min = 1,
												max = floor(GetScreenWidth()),
												step = 1,
												softMin = 1,
												softMax = 500,
												get = "Get",
												set = "Set",
											},
											height = {
												disabled = function(info)
								            		local parent = getParent(info)
								            		return parent.matchHeight
								            	end,
												type = "range",
												order = 4,
												name = "Height",
												min = 1,
												max = floor(GetScreenHeight()),
												step = 1,
												softMin = 1,
												softMax = 500,
												get = "Get",
												set = "Set",
											}
										}
									},
						            missingBar = {
						            	disabled = false,
						            	type = "group",
						            	order = 10,
						            	name = "Missing Bar",
						            	desc = "Bar that is displayed in place of the missing part of the original bar.",
						            	args = {
							                enabled = {
												type = "toggle",
												order = 1,
												name = "Enabled",
												get = "Get",
												set = "Set"
											},
							                customColor = {
								            	disabled = function(info)
								            		local parent = getParent(info)
								            		return not (parent.enabled and parent.colorBy == "Custom")
								            	end,
							                	type = "color",
							                	order = 2,
							                	name = "Custom Color",
							                	hasAlpha = true,
							                	get = "Get",
							                	set = "Set"
							                },
							                colorBy = {
							                	disabled = parentDisabled,
												type = "select",
												order = 3,
												name = "Color By",
												values = createDropdownTable("Class", "health", "power", "Gradient", "Custom"),
												get = "Get",
												set = "Set"
							                },
						            	}
						            }
								}
							},
							buffs = {
								disabled = parentDisabled,
								type = "group",
								order = 4,
								name = "Buffs",
								childGroups = "tab",
								args = {
									enabled = {
										type = "toggle",
										order = 1,
										name = "Enabled",
										get = "Get",
										set = "Set"
									},
						            style = {
						           		disabled = parentDisabled,
				            			type = "select",
										order = 2,
										name = "Style",
										values = createDropdownTable("Bar", "Icon"),
										get = "Get",
										set = "Set"
						            },
						            barGrowth = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Bar")
						            	end,
				            			type = "select",
										order = 3,
										name = "Bar Growth",
										values = createDropdownTable("Upwards", "Downwards"),
										get = "Get",
										set = "Set"
						            },
						            iconGrowth = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Icon")
						            	end,
				            			type = "select",
										order = 4,
										name = "Icon Growth",
										values = createDropdownTable("Right Then Down", "Right Then Up", "Left Then Down", "Left Then Up"),
										get = "Get",
										set = "Set"
						        	},
						            spacingX = {
						            	disabled = parentDisabled,
						            	type = "range",
						            	order = 5,
						            	name = "X Spacing",
						            	min = -10,
						            	max = 10,
						            	step = 1,
						            	get = "Get",
						            	set = "Set"
						            },
						            spacingY = {
						            	disabled = parentDisabled,
						            	type = "range",
						            	order = 6,
						            	name = "Y Spacing",
						            	min = -10,
						            	max = 10,
						            	step = 1,
						            	get = "Get",
						            	set = "Set"
						            },
						            iconLimit = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Icon")
						            	end,
						            	type = "range",
						            	order = 7,
						            	name = "Icon Limit",
						            	min = 1,
						            	max = 40,
						            	step = 1,
						            	get = "Get",
						            	set = "Set"
						            },
						            iconTextSize = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Icon")
						            	end,
						            	type = "range",
						            	order = 8,
						            	name = "Icon Text Size",
						            	min = 1,
						            	max = 100,
						            	step = 1,
						            	get = "Get",
						            	set = "Set"
						        	},
									attached = {
										disabled = parentDisabled,
										type = "toggle",
										order = 9,
										name = "Attached",
										get = "Get",
										set = "Set"
									},
						            attachedPosition = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.attached)
						            	end,
				            			type = "select",
										order = 10,
										name = "Attached Position",
										values = createDropdownTable("Above", "Below", "Left", "Right"),
										get = "Get",
										set = "Set"
						            },
						            x = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.attached)
						            	end,
						            	type = "range",
						            	order = 11,
						            	name = "Attached Offset X",
						            	min = -500,
						            	max = 500,
						            	step = 1,
						            	get = "Get",
						            	set = "Set"
						        	},
						        	y = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.attached)
						            	end,
						            	type = "range",
						            	order = 12,
						            	name = "Attached Offset Y",
						            	min = -500,
						            	max = 500,
						            	step = 1,
						            	get = "Get",
						            	set = "Set"
						        	},
						            limit = {
						            	disabled = parentDisabled,
						            	type = "range",
						            	order = 13,
						            	name = "Aura Limit",
						            	min = 1,
						            	max = 40,
						            	step = 1,
						            	get = "Get",
						            	set = "Set"
						            },
						            hideNoDuration = {
						            	disabled = parentDisabled,
										type = "toggle",
										order = 14,
										name = "Hide No Duration",
										desc = "Hide auras that never expire, e.g. mounts, weekly event buffs, etc.",
										get = "Get",
										set = "Set"
						            },
						            own = {
						            	disabled = parentDisabled,
										type = "toggle",
										order = 15,
										name = "Own Only",
										desc = "Only show auras cast by yourself",
										get = "Get",
										set = "Set"
						            },
						            colorBy = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Bar")
						            	end,
										type = "select",
										order = 16,
										name = "Color By",
										values = createDropdownTable("Class", "health", "power", "Gradient", "Custom"),
										get = "Get",
										set = "Set"
						        	},
						            customColor = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Bar" and parent.colorBy == "Custom")
						            	end,
					                	type = "color",
					                	order = 17,
					                	name = "Custom Color",
					                	hasAlpha = true,
					                	get = "Get",
					                	set = "Set"
						            },
						            mult = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Bar")
						            	end,
										type = "range",
										order = 18,
										name = "Background Multiplier",
										min = -1,
										max = 1,
										isPercent = true,
										get = "Get",
										set = "Set",
						            },
						            reversed = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Bar")
						            	end,
										type = "toggle",
										order = 19,
										name = "Reversed",
										get = "Get",
										set = "Set"
						            },
						            texture = {
						            	disabled = parentDisabled,
										type = "select",
										order = 20,
										name = "Texture",
								      	values = media:HashTable("statusbar"),
								      	dialogControl = "LSM30_Statusbar",
										get = "Get",
										set = "Set"
						            },
						            size = {
						            	disabled = parentDisabled,
						            	type = "group",
						            	order = 21,
						            	name = "Size",
						            	args = {
											matchWidth = {
												type = "toggle",
												order = 1,
												name = "Match Width",
												get = "Get",
												set = "Set"
											},
											matchHeight = {
												type = "toggle",
												order = 2,
												name = "Match Height",
												get = "Get",
												set = "Set"
											},
											width = {
												disabled = function(info)
								            		local parent = getParent(info)
								            		return parent.matchWidth
								            	end,
												type = "range",
												order = 3,
												name = "Width",
												min = 1,
												max = floor(GetScreenWidth()),
												step = 1,
												softMin = 1,
												softMax = 500,
												get = "Get",
												set = "Set",
											},
											height = {
												disabled = function(info)
								            		local parent = getParent(info)
								            		return parent.matchHeight
								            	end,
												type = "range",
												order = 4,
												name = "Height",
												min = 1,
												max = floor(GetScreenHeight()),
												step = 1,
												softMin = 1,
												softMax = 500,
												get = "Get",
												set = "Set",
											}
							            }
						            },
						            name = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Bar")
						            	end,
						            	type = "group",
						            	order = 22,
						            	name = "Name",
						            	args = {
						            		enabled = {
												type = "toggle",
												order = 1,
												name = "Enabled",
												get = "Get",
												set = "Set"
						            		},
							                size = {
							                	disabled = parentDisabled,
												type = "range",
												order = 2,
												name = "Text Size",
												min = 1,
												max = 100,
												step = 1,
												get = "Get",
												set = "Set",
							                },
							                position = positionSetting(3)
							            }
						            },
						            time = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Bar")
						            	end,
						            	type = "group",
						            	order = 23,
						            	name = "Time",
						            	args = {
						            		enabled = {
												type = "toggle",
												order = 1,
												name = "Enabled",
												get = "Get",
												set = "Set"
						            		},
							                size = {
							                	disabled = parentDisabled,
												type = "range",
												order = 2,
												name = "Text Size",
												min = 1,
												max = 100,
												step = 1,
												get = "Get",
												set = "Set",
							                },
							                position = positionSetting(3)
							            }
						            },
						            background = backgroundSetting(24),
						            blacklist = {
						            	disabled = parentDisabled,
						            	type = "group",
						            	order = 25,
						            	name = "Blacklist",
						            	args = {
						            		enabled = {
												type = "toggle",
												order = 1,
												name = "Enabled",
												get = "Get",
												set = "Set"
						            		},
						            		ids = {
						            			disabled = parentDisabled,
						            			type = "group",
						            			order = 2,
						            			name = "Ids",
						            			args = {

						            			}
						            		}
						            	}
						            },
						            whitelist = { -- Contruct this properly
						            	disabled = parentDisabled,
						            	type = "group",
						            	order = 26,
						            	name = "WhiteList",
						            	args = {
						            		enabled = {
												type = "toggle",
												order = 1,
												name = "Enabled",
												get = "Get",
												set = "Set"
						            		},
						            		ids = {
						            			disabled = parentDisabled,
						            			type = "group",
						            			order = 2,
						            			name = "Ids",
						            			args = {
						            				
						            			}
						            		}
						            	}
						            },
						        }
							},
							debuffs = {
								disabled = parentDisabled,
								type = "group",
								order = 5,
								name = "Debuffs",
								childGroups = "tab",
								args = {
									enabled = {
										type = "toggle",
										order = 1,
										name = "Enabled",
										get = "Get",
										set = "Set"
									},
						            style = {
						           		disabled = parentDisabled,
				            			type = "select",
										order = 2,
										name = "Style",
										values = createDropdownTable("Bar", "Icon"),
										get = "Get",
										set = "Set"
						            },
						            barGrowth = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Bar")
						            	end,
				            			type = "select",
										order = 3,
										name = "Bar Growth",
										values = createDropdownTable("Upwards", "Downwards"),
										get = "Get",
										set = "Set"
						            },
						            iconGrowth = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Icon")
						            	end,
				            			type = "select",
										order = 4,
										name = "Icon Growth",
										values = createDropdownTable("Right Then Down", "Right Then Up", "Left Then Down", "Left Then Up"),
										get = "Get",
										set = "Set"
						        	},
						            spacingX = {
						            	disabled = parentDisabled,
						            	type = "range",
						            	order = 5,
						            	name = "X Spacing",
						            	min = -10,
						            	max = 10,
						            	step = 1,
						            	get = "Get",
						            	set = "Set"
						            },
						            spacingY = {
						            	disabled = parentDisabled,
						            	type = "range",
						            	order = 6,
						            	name = "Y Spacing",
						            	min = -10,
						            	max = 10,
						            	step = 1,
						            	get = "Get",
						            	set = "Set"
						            },
						            iconLimit = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Icon")
						            	end,
						            	type = "range",
						            	order = 7,
						            	name = "Icon Limit",
						            	min = 1,
						            	max = 40,
						            	step = 1,
						            	get = "Get",
						            	set = "Set"
						            },
						            iconTextSize = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Icon")
						            	end,
						            	type = "range",
						            	order = 8,
						            	name = "Icon Text Size",
						            	min = 1,
						            	max = 100,
						            	step = 1,
						            	get = "Get",
						            	set = "Set"
						        	},
									attached = {
										disabled = parentDisabled,
										type = "toggle",
										order = 9,
										name = "Attached",
										get = "Get",
										set = "Set"
									},
						            attachedPosition = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.attached)
						            	end,
				            			type = "select",
										order = 10,
										name = "Attached Position",
										values = createDropdownTable("Above", "Below", "Left", "Right"),
										get = "Get",
										set = "Set"
						            },
						            x = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.attached)
						            	end,
						            	type = "range",
						            	order = 11,
						            	name = "Attached Offset X",
						            	min = -500,
						            	max = 500,
						            	step = 1,
						            	get = "Get",
						            	set = "Set"
						        	},
						        	y = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.attached)
						            	end,
						            	type = "range",
						            	order = 12,
						            	name = "Attached Offset Y",
						            	min = -500,
						            	max = 500,
						            	step = 1,
						            	get = "Get",
						            	set = "Set"
						        	},
						            limit = {
						            	disabled = parentDisabled,
						            	type = "range",
						            	order = 13,
						            	name = "Aura Limit",
						            	min = 1,
						            	max = 40,
						            	step = 1,
						            	get = "Get",
						            	set = "Set"
						            },
						            own = {
						            	disabled = parentDisabled,
										type = "toggle",
										order = 14,
										name = "Own Only",
										desc = "Only show auras cast by yourself",
										get = "Get",
										set = "Set"
						            },
						            colorBy = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Bar")
						            	end,
										type = "select",
										order = 15,
										name = "Color By",
										values = createDropdownTable("Class", "health", "power", "Gradient", "Custom"),
										get = "Get",
										set = "Set"
						        	},
						            customColor = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Bar" and parent.colorBy == "Custom")
						            	end,
					                	type = "color",
					                	order = 16,
					                	name = "Custom Color",
					                	hasAlpha = true,
					                	get = "Get",
					                	set = "Set"
						            },
						            mult = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Bar")
						            	end,
										type = "range",
										order = 17,
										name = "Background Multiplier",
										min = -1,
										max = 1,
										isPercent = true,
										get = "Get",
										set = "Set",
						            },
						            reversed = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Bar")
						            	end,
										type = "toggle",
										order = 18,
										name = "Reversed",
										get = "Get",
										set = "Set"
						            },
						            texture = {
						            	disabled = parentDisabled,
										type = "select",
										order = 19,
										name = "Texture",
								      	values = media:HashTable("statusbar"),
								      	dialogControl = "LSM30_Statusbar",
										get = "Get",
										set = "Set"
						            },
						            size = {
						            	disabled = parentDisabled,
						            	type = "group",
						            	order = 20,
						            	name = "Size",
						            	args = {
											matchWidth = {
												type = "toggle",
												order = 1,
												name = "Match Width",
												get = "Get",
												set = "Set"
											},
											matchHeight = {
												type = "toggle",
												order = 2,
												name = "Match Height",
												get = "Get",
												set = "Set"
											},
											width = {
												disabled = function(info)
								            		local parent = getParent(info)
								            		return parent.matchWidth
								            	end,
												type = "range",
												order = 3,
												name = "Width",
												min = 1,
												max = floor(GetScreenWidth()),
												step = 1,
												softMin = 1,
												softMax = 500,
												get = "Get",
												set = "Set",
											},
											height = {
												disabled = function(info)
								            		local parent = getParent(info)
								            		return parent.matchHeight
								            	end,
												type = "range",
												order = 4,
												name = "Height",
												min = 1,
												max = floor(GetScreenHeight()),
												step = 1,
												softMin = 1,
												softMax = 500,
												get = "Get",
												set = "Set",
											}
							            }
						            },
						            name = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Bar")
						            	end,
						            	type = "group",
						            	order = 21,
						            	name = "Name",
						            	args = {
						            		enabled = {
												type = "toggle",
												order = 1,
												name = "Enabled",
												get = "Get",
												set = "Set"
						            		},
							                size = {
							                	disabled = parentDisabled,
												type = "range",
												order = 2,
												name = "Text Size",
												min = 1,
												max = 100,
												step = 1,
												get = "Get",
												set = "Set",
							                },
							                position = positionSetting(3)
							            }
						            },
						            time = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Bar")
						            	end,
						            	type = "group",
						            	order = 22,
						            	name = "Time",
						            	args = {
						            		enabled = {
												type = "toggle",
												order = 1,
												name = "Enabled",
												get = "Get",
												set = "Set"
						            		},
							                size = {
							                	disabled = parentDisabled,
												type = "range",
												order = 2,
												name = "Text Size",
												min = 1,
												max = 100,
												step = 1,
												get = "Get",
												set = "Set",
							                },
							                position = positionSetting(3)
							            }
						            },
						            background = backgroundSetting(23),
						            blacklist = {
						            	disabled = parentDisabled,
						            	type = "group",
						            	order = 24,
						            	name = "Blacklist",
						            	args = {
						            		enabled = {
												type = "toggle",
												order = 1,
												name = "Enabled",
												get = "Get",
												set = "Set"
						            		},
						            		ids = {
						            			disabled = parentDisabled,
						            			type = "group",
						            			order = 2,
						            			name = "Ids",
						            			args = {

						            			}
						            		}
						            	}
						            },
						            whitelist = { -- Contruct this properly
						            	disabled = parentDisabled,
						            	type = "group",
						            	order = 25,
						            	name = "WhiteList",
						            	args = {
						            		enabled = {
												type = "toggle",
												order = 1,
												name = "Enabled",
												get = "Get",
												set = "Set"
						            		},
						            		ids = {
						            			disabled = parentDisabled,
						            			type = "group",
						            			order = 2,
						            			name = "Ids",
						            			args = {
						            				
						            			}
						            		}
						            	}
						            }
						        }
							},
							size = {
								disabled = parentDisabled,
								type = "group",
								order = 6,
								name = "Size",
								args = {
									width = {
										type = "range",
										order = 2,
										name = "Width",
										min = 1,
										max = floor(GetScreenWidth()),
										step = 1,
										get = "Get",
										set = "Set",
					                },
									height = {
										type = "range",
										order = 2,
										name = "Height",
										min = 1,
										max = floor(GetScreenHeight()),
										step = 1,
										get = "Get",
										set = "Set",
									}
								}
							},
					        tags = constructTags(7, db.units.player, true),
					        healPrediction = {
					        	disabled = parentDisabled,
					        	type = "group",
					        	order = 8,
					        	name = "Heal Prediction",
					        	args = {
						            enabled = {
										type = "toggle",
										order = 1,
										name = "Enabled",
										get = "Get",
										set = "Set"
						        	},
						            texture = {
										disabled = parentDisabled,
										type = "select",
										order = 2,
										name = "Texture",
								      	values = media:HashTable("statusbar"),
								      	dialogControl = "LSM30_Statusbar",
										get = "Get",
										set = "Set"
						            },
						            overflow = {
						            	disabled = parentDisabled,
						            	type = "range",
						            	order = 3,
						            	name = "Max Overflow",
						            	min = 1,
						            	max = 2,
						            	step = 0.1,
						            	isPercent = true
						            },
						            colors = {
						            	disabled = parentDisabled,
						            	type = "group",
						            	order = 4,
						            	name = "Colors",
						            	args = {
							                my = {
							                	type = "color",
							                	order = 1,
							                	name = "My Heals",
							                	hasAlpha = true,
							                	get = "Get",
							                	set = "Set"
							                },
							                all = {
							                	type = "color",
							                	order = 2,
							                	name = "All Heals",
							                	hasAlpha = true,
							                	get = "Get",
							                	set = "Set"
							                },
							                absorb = {
							                	type = "color",
							                	order = 3,
							                	name = "Absorb",
							                	hasAlpha = true,
							                	get = "Get",
							                	set = "Set"
							                },
							                healAbsorb = {
							                	type = "color",
							                	order = 4,
							                	name = "Heal Absorb",
							                	hasAlpha = true,
							                	get = "Get",
							                	set = "Set"
							                }
							            }
						            }
						        }
					        },
					        background = backgroundSetting(9),
					        altpower = {
					        	disabled = parentDisabled,
					        	type = "group",
					        	order = 10,
					        	name = "Alt Power Bar",
					        	args = {
						            enabled = {
										type = "toggle",
										order = 1,
										name = "Enabled",
										get = "Get",
										set = "Set"
						        	},
						            background = backgroundSetting(2),
						            size = {
						            	disabled = parentDisabled,
						            	type = "group",
						            	order = 3,
						            	name = "Size",
						            	args = {
											matchWidth = {
												type = "toggle",
												order = 1,
												name = "Match Width",
												get = "Get",
												set = "Set"
											},
											matchHeight = {
												type = "toggle",
												order = 2,
												name = "Match Height",
												get = "Get",
												set = "Set"
											},
											width = {
												disabled = function(info)
								            		local parent = getParent(info)
								            		return parent.matchWidth
								            	end,
												type = "range",
												order = 3,
												name = "Width",
												min = 1,
												max = floor(GetScreenWidth()),
												step = 1,
												softMin = 1,
												softMax = 500,
												get = "Get",
												set = "Set",
											},
											height = {
												disabled = function(info)
								            		local parent = getParent(info)
								            		return parent.matchHeight
								            	end,
												type = "range",
												order = 4,
												name = "Height",
												min = 1,
												max = floor(GetScreenHeight()),
												step = 1,
												softMin = 1,
												softMax = 500,
												get = "Get",
												set = "Set",
											}
							            }
							        },
						            texture = {
										disabled = parentDisabled,
										type = "select",
										order = 4,
										name = "Texture",
								      	values = media:HashTable("statusbar"),
								      	dialogControl = "LSM30_Statusbar",
										get = "Get",
										set = "Set"
						            },
						            mult = {
										disabled = parentDisabled,
										type = "range",
										order = 5,
										name = "Background Multiplier",
										min = -1,
										max = 1,
										isPercent = true,
										get = "Get",
										set = "Set",
						        	},
						            color = {
						            	disabled = parentDisabled,
					                	type = "color",
					                	order = 6,
					                	name = "Color",
					                	hasAlpha = true,
					                	get = "Get",
					                	set = "Set"
					                }
					            }
					        },
					        runes = classPowerSetting("Runes", 11, function(info)
					        	return not isClass("DEATHKNIGHT")
					        end),
					        comboPoints = classPowerSetting("Combo Points", 11, function(info)
					        	return not isClass("ROGUE")
					        end),
					        soulShards = classPowerSetting("Soul Shards", 11, function(info)
					        	return not isClass("WARLOCK")
					        end),
					        chi = classPowerSetting("Chi", 11, function(info)
					        	return not (isClass("MONK") and isSpec(3))
					        end),
					        arcaneCharges = classPowerSetting("Arcane Charges", 11, function(info)
					        	return not (isClass("MAGE") and isSpec(1))
					        end),
					        holyPower = classPowerSetting("Holy Power", 11, function(info)
					        	return not (isClass("PALADIN") and isSpec(3))
					        end),              
					        stagger = classPowerSetting("Stagger", 11, function(info)
					        	return not (isClass("MONK") and isSpec(1))
					        end),
					        castbar = castBarSetting(12),
					        combat = {
					        	disabled = parentDisabled,
					        	type = "group",
					        	order = 13,
					        	name = "Combat Indicator",
					        	args = {
						            enabled = {
										type = "toggle",
										order = 1,
										name = "Enabled",
										get = "Get",
										set = "Set"
						        	},
				                    style = {
				                    	disabled = parentDisabled,
				                    	type = "select",
				                    	order = 2,
				                    	name = "Style",
				                    	values = createDropdownTable("Text", "Letter", "Texture", "Color"),
				                    	get = "Get",
				                    	set = "Set",
				                    },
				                    fontSize = {
				                    	disabled = parentDisabled,
				                    	type = "range",
				                    	order = 3,
				                    	name = "Text Size",
				                    	min = 1,
				                    	max = 100,
				                    	step = 1,
				                    	get = "Get",
				                    	set = "Set",
				                    },
				                    size = {
				                    	disabled = parentDisabled,
				                    	type = "range",
				                    	order = 4,
				                    	name = "Texture Size",
				                    	min = 1,
				                    	max = 100,
				                    	step = 1,
				                    	get = "Get",
				                    	set = "Set",
				                    },
				                    color = {
						            	disabled = parentDisabled,
					                	type = "color",
					                	order = 5,
					                	name = "Color",
					                	hasAlpha = true,
					                	get = "Get",
					                	set = "Set"
					                },
				                    position = positionSetting(6)
				                }
					        },
					   		clickcast = clickCastSetting(13, db.units.player.clickcast)
						}
					},
					target = standardUnit("Target", db.units.target, 2),
					targettarget = standardUnit("Target of Target", db.units.targettarget, 3),
					pet = standardUnit("Pet", db.units.pet, 4),
					--focus = standardUnit("Focus", db.units.focus, 5),
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
						childGroups = "tab",
						args = {
		            		enabled = {
								type = "toggle",
								order = 1,
								name = "Enabled",
								get = "Get",
								set = "Set"
		            		},
				        	clickcast = clickCastSetting(2, db.group.party.clickcast),
			                status = statusSetting(3),
							health = {
								disabled = parentDisabled,
								type = "group",
								order = 4,
								name = "Health",
								childGroups = "tab",
								args = {
									enabled = {
										disabled = parentDisabled,
										type = "toggle",
										order = 1,
										name = "Enabled",
										get = "Get",
										set = "Set"
									},
									colorBy = {
										disabled = parentDisabled,
										type = "select",
										order = 2,
										name = "Color By",
										values = createDropdownTable("Class", "health", "Gradient", "Custom"),
										get = "Get",
										set = "Set"
						            },
						            customColor = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.colorBy == "Custom")
						            	end,
					                	type = "color",
					                	order = 3,
					                	name = "Custom Color",
					                	hasAlpha = true,
					                	get = "Get",
					                	set = "Set"
					                },
						            mult = {
						            	disabled = parentDisabled,
										type = "range",
										order = 4,
										name = "Background Multiplier",
										min = -1,
										max = 1,
										isPercent = true,
										get = "Get",
										set = "Set",
									},
						            orientation = {
						            	disabled = parentDisabled,
										type = "select",
										order = 5,
										name = "Orientation",
										values = createDropdownTable("HORIZONTAL", "VERTICAL"),
										get = "Get",
										set = "Set"
						            },
						            reversed = {
						            	disabled = parentDisabled,
										type = "toggle",
										order = 6,
										name = "Reversed",
										get = "Get",
										set = "Set"
									},
						            texture = {
						            	disabled = parentDisabled,
										type = "select",
										order = 7,
										name = "Texture",
								      	values = media:HashTable("statusbar"),
								      	dialogControl = "LSM30_Statusbar",
										get = "Get",
										set = "Set"
						            },
									position = positionSetting(8, createDropdownTable("Parent", "power")),
									size = {
										disabled = parentDisabled,
										type = "group",
										order = 9,
										name = "Size",
										args = {
											matchWidth = {
												type = "toggle",
												order = 1,
												name = "Match Width",
												get = "Get",
												set = "Set"
											},
											matchHeight = {
												type = "toggle",
												order = 2,
												name = "Match Height",
												get = "Get",
												set = "Set"
											},
											width = {
												disabled = function(info)
								            		local parent = getParent(info)
								            		return parent.matchWidth
								            	end,
												type = "range",
												order = 3,
												name = "Width",
												min = 1,
												max = floor(GetScreenWidth()),
												step = 1,
												softMin = 1,
												softMax = 500,
												get = "Get",
												set = "Set",
											},
											height = {
												disabled = function(info)
								            		local parent = getParent(info)
								            		return parent.matchHeight
								            	end,
												type = "range",
												order = 4,
												name = "Height",
												min = 1,
												max = floor(GetScreenHeight()),
												step = 1,
												softMin = 1,
												softMax = 500,
												get = "Get",
												set = "Set",
											}
										}
									},
						            missingBar = {
						            	disabled = false,
						            	type = "group",
						            	order = 10,
						            	name = "Missing Bar",
						            	desc = "Bar that is displayed in place of the missing part of the original bar.",
						            	args = {
							                enabled = {
												type = "toggle",
												order = 1,
												name = "Enabled",
												get = "Get",
												set = "Set"
											},
							                customColor = {
								            	disabled = function(info)
								            		local parent = getParent(info)
								            		return not (parent.enabled and parent.colorBy == "Custom")
								            	end,
							                	type = "color",
							                	order = 2,
							                	name = "Custom Color",
							                	hasAlpha = true,
							                	get = "Get",
							                	set = "Set"
							                },
							                colorBy = {
							                	disabled = parentDisabled,
												type = "select",
												order = 3,
												name = "Color By",
												values = createDropdownTable("Class", "health", "power", "Gradient", "Custom"),
												get = "Get",
												set = "Set"
							                },
						            	}
						            }
						        }
							},
							power = {
								disabled = parentDisabled,
								type = "group",
								order = 5,
								name = "Power",
								childGroups = "tab",
								args = {
									enabled = {
										type = "toggle",
										order = 1,
										name = "Enabled",
										get = "Get",
										set = "Set"
									},
									colorBy = {
										disabled = parentDisabled,
										type = "select",
										order = 2,
										name = "Color By",
										values = createDropdownTable("Class", "power", "Custom"),
										get = "Get",
										set = "Set"
						            },
						            customColor = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.colorBy == "Custom")
						            	end,
					                	type = "color",
					                	order = 3,
					                	name = "Custom Color",
					                	hasAlpha = true,
					                	get = "Get",
					                	set = "Set"
					                },
						            mult = {
										disabled = parentDisabled,
										type = "range",
										order = 4,
										name = "Background Multiplier",
										min = -1,
										max = 1,
										isPercent = true,
										get = "Get",
										set = "Set",
									},
						            orientation = {
										disabled = parentDisabled,
										type = "select",
										order = 5,
										name = "Orientation",
										values = createDropdownTable("HORIZONTAL", "VERTICAL"),
										get = "Get",
										set = "Set"
						            },
						            reversed = {
										disabled = parentDisabled,
										type = "toggle",
										order = 6,
										name = "Reversed",
										get = "Get",
										set = "Set"
									},
						            texture = {
										disabled = parentDisabled,
										type = "select",
										order = 7,
										name = "Texture",
								      	values = media:HashTable("statusbar"),
								      	dialogControl = "LSM30_Statusbar",
										get = "Get",
										set = "Set"
						            },
									position = positionSetting(8, createDropdownTable("Parent", "health")),
									size = {
										disabled = parentDisabled,
										type = "group",
										order = 9,
										name = "Size",
										args = {
											matchWidth = {
												type = "toggle",
												order = 1,
												name = "Match Width",
												get = "Get",
												set = "Set"
											},
											matchHeight = {
												type = "toggle",
												order = 2,
												name = "Match Height",
												get = "Get",
												set = "Set"
											},
											width = {
												disabled = function(info)
								            		local parent = getParent(info)
								            		return parent.matchWidth
								            	end,
												type = "range",
												order = 3,
												name = "Width",
												min = 1,
												max = floor(GetScreenWidth()),
												step = 1,
												softMin = 1,
												softMax = 500,
												get = "Get",
												set = "Set",
											},
											height = {
												disabled = function(info)
								            		local parent = getParent(info)
								            		return parent.matchHeight
								            	end,
												type = "range",
												order = 4,
												name = "Height",
												min = 1,
												max = floor(GetScreenHeight()),
												step = 1,
												softMin = 1,
												softMax = 500,
												get = "Get",
												set = "Set",
											}
										}
									},
						            missingBar = {
						            	disabled = false,
						            	type = "group",
						            	order = 10,
						            	name = "Missing Bar",
						            	desc = "Bar that is displayed in place of the missing part of the original bar.",
						            	args = {
							                enabled = {
												type = "toggle",
												order = 1,
												name = "Enabled",
												get = "Get",
												set = "Set"
											},
							                customColor = {
								            	disabled = function(info)
								            		local parent = getParent(info)
								            		return not (parent.enabled and parent.colorBy == "Custom")
								            	end,
							                	type = "color",
							                	order = 2,
							                	name = "Custom Color",
							                	hasAlpha = true,
							                	get = "Get",
							                	set = "Set"
							                },
							                colorBy = {
							                	disabled = parentDisabled,
												type = "select",
												order = 3,
												name = "Color By",
												values = createDropdownTable("Class", "health", "power", "Gradient", "Custom"),
												get = "Get",
												set = "Set"
							                },
						            	}
						            }
								}
							},
							size = {
								disabled = parentDisabled,
								type = "group",
								order = 6,
								name = "Size",
								args = {
									width = {
										type = "range",
										order = 2,
										name = "Width",
										min = 1,
										max = floor(GetScreenWidth()),
										step = 1,
										get = "Get",
										set = "Set",
					                },
									height = {
										type = "range",
										order = 2,
										name = "Height",
										min = 1,
										max = floor(GetScreenHeight()),
										step = 1,
										get = "Get",
										set = "Set",
									}
								}
							},
				            orientation = {
				            	disabled = parentDisabled,
								type = "select",
								order = 7,
								name = "Orientation",
								values = createDropdownTable("HORIZONTAL", "VERTICAL"),
								get = "Get",
								set = "Set"
				            },
			                growth = {
				            	disabled = parentDisabled,
								type = "select",
								order = 8,
								name = "Growth",
								values = createDropdownTable("Left", "Right", "Upwards", "Downwards"),
								get = "Get",
								set = "Set"
				            },
			                tags = constructTags(9, db.group.party),
			                groupbuffs = groupBuffSetting(10, db.group.party.groupbuffs),
					        healPrediction = {
					        	disabled = parentDisabled,
					        	type = "group",
					        	order = 11,
					        	name = "Heal Prediction",
					        	args = {
						            enabled = {
										type = "toggle",
										order = 1,
										name = "Enabled",
										get = "Get",
										set = "Set"
						        	},
						            texture = {
										disabled = parentDisabled,
										type = "select",
										order = 2,
										name = "Texture",
								      	values = media:HashTable("statusbar"),
								      	dialogControl = "LSM30_Statusbar",
										get = "Get",
										set = "Set"
						            },
						            overflow = {
						            	disabled = parentDisabled,
						            	type = "range",
						            	order = 3,
						            	name = "Max Overflow",
						            	min = 1,
						            	max = 2,
						            	step = 0.1,
						            	isPercent = true
						            },
						            colors = {
						            	disabled = parentDisabled,
						            	type = "group",
						            	order = 4,
						            	name = "Colors",
						            	args = {
							                my = {
							                	type = "color",
							                	order = 1,
							                	name = "My Heals",
							                	hasAlpha = true,
							                	get = "Get",
							                	set = "Set"
							                },
							                all = {
							                	type = "color",
							                	order = 2,
							                	name = "All Heals",
							                	hasAlpha = true,
							                	get = "Get",
							                	set = "Set"
							                },
							                absorb = {
							                	type = "color",
							                	order = 3,
							                	name = "Absorb",
							                	hasAlpha = true,
							                	get = "Get",
							                	set = "Set"
							                },
							                healAbsorb = {
							                	type = "color",
							                	order = 4,
							                	name = "Heal Absorb",
							                	hasAlpha = true,
							                	get = "Get",
							                	set = "Set"
							                }
							            }
						            }
						        }
					        },
							x = {
								disabled = parentDisabled,
								type = "range",
								order = 12,
								name = "Spacing X",
								min = 1,
								max = 500,
								step = 1,
								get = "Get",
								set = "Set"
							},
							y = {
								disabled = parentDisabled,
								type = "range",
								order = 13,
								name = "Spacing Y",
								min = 1,
								max = 500,
								step = 1,
								get = "Get",
								set = "Set"
							},
			                showPlayer = {
								disabled = parentDisabled,
								type = "toggle",
								order = 14,
								name = "Show Player",
								get = "Get",
								set = "Set"
							},		                	
			                visibility = {
								disabled = parentDisabled,
			                	type = "input",
			                	order = 15,
			                	width = "double",
			                	name = "Visibility",
								get = "Get",
								set = "Set"
			            	},
			                groupBy = {
								disabled = parentDisabled,
			                	type = "select",
			                	order = 16,
			                	name = "Group By",
			                	values = createDropdownTable("Role", "Class", "Group"),
								get = "Get",
								set = "Set"
			                },
			                alphabetically = {
								disabled = parentDisabled,
								type = "toggle",
								order = 17,
								name = "Sort Alphabetically",
								get = "Get",
								set = "Set"
							},
			                sortDirection = {
								disabled = parentDisabled,
								type = "select",
								order = 18,
								name = "Sort Direction",
								values = { ["ASC"] = "Ascending", ["DESC"] = "Descending" },
								get = "Get",
								set = "Set"
			                },
			                role = groupRoleSetting(19),
			                background = backgroundSetting(20),
			                --[[border = {
			                    highlight = true,
			                    debuff = true,
			                    debuffOrder = { "Magic", "Disease", "Curse", "Poison" }
			                },--]]
						}
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

	A.options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(A.db)
end