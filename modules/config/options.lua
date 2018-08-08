local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local T = A.Tools

local floor = math.floor

local GetScreenWidth = GetScreenWidth
local GetScreenHeight = GetScreenHeight

local UnitClass = UnitClass
local GetSpecialization = GetSpecialization

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
	
	A["Shared Elements"]:foreach(function(key, element)
		tbl[key] = key
	end)

	if (isPlayer) then
		A["Player Elements"]:foreach(function(key, element)
			tbl[key] = key
		end)
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

local function constructTags(order, db, isPlayer)
	local row = {
		format = {
			type = "input",
			order = 1,
			name = "Format",
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
				args = row
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
				values = createDropdownTable("Top", "Bottom", "Left", "Right"),
				get = "Get",
				set = "Set"
            }
		}
	}
end

local function castBarSetting(order)
	return {
	    enabled = {
			type = "toggle",
			order = 1,
			name = "Enabled",
			get = "Get",
			set = "Set"
		},
	    missingBar = {
	        enabled = false,
	        customColor = {
	            0.5, -- [1]
	            0.5, -- [2]
	            0.5, -- [3]
	            1, -- [4]
	        },
	        colorBy = "Custom",
	    },
	    texture = "Default",
	    position = {
	        relative = "FrameParent",
	        point = "CENTER",
	        localPoint = "CENTER",
	        x = 0,
	        y = 0, 
	    },
	    colorBy = "Class",
	    customColor = { 1, 1, 1 },
	    mult = 0.33,
	    orientation = "HORIZONTAL",
	    reversed = false,
	    size = {
	        matchWidth = true,
	        matchHeight = false,
	        width = 150,
	        height = 16
	    },
	    time = {
	        enabled = true,
	        position = {
	            relative = "Parent",
	            point = "RIGHT",
	            localPoint = "RIGHT",
	            x = -5,
	            y = 0, 
	        },
	        size = 10,
	        format = "[current]/[max]"
	    },
	    name = {
	        enabled = true,
	        position = {
	            relative = "Parent",
	            point = "LEFT",
	            localPoint = "LEFT",
	            x = 18,
	            y = 0, 
	        },
	        size = 0.7,
	        format = "[name]"
	    },
	    icon = {
	        enabled = true,
	        position = "LEFT",
	        size = {
	            matchWidth = false,
	            matchHeight = true,
	            size = 10
	        },
	        background = {
	            color = { 0, 0, 0, 1 },
	            offset = {
	                top = 1,
	                bottom = 1,
	                left = 1,
	                right = 1
	            },
	            size = 3,
	            matchWidth = true,
	            width = 100,
	            matchHeight = true,
	            height = 100,
	            enabled = true
	        },
	    },
	    background = {
	        color = { 0, 0, 0, 1 },
	        offset = {
	            top = 1,
	            bottom = 1,
	            left = 1,
	            right = 1
	        },
	        size = 3,
	        matchWidth = true,
	        width = 100,
	        matchHeight = true,
	        height = 100,
	        enabled = true
	    },
	    attachedPosition = "Below",
	    attached = true,
	    x = 0,
	    y = 0
	}
end

local function standardUnit(name, order)
	return {
		type = "group",
		order = order,
		name = name,
		args = {

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
										values = createDropdownTable("Class", "Power", "Gradient", "Custom"),
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
									position = positionSetting(8, createDropdownTable("Player", "Power")),
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
						            	disabled = parentDisabled,
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
												values = createDropdownTable("Class", "Health", "Power", "Gradient", "Custom"),
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
										values = createDropdownTable("Class", "Power", "Custom"),
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
									position = positionSetting(8, createDropdownTable("Player", "Health")),
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
						            	disabled = parentDisabled,
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
												values = createDropdownTable("Class", "Health", "Power", "Gradient", "Custom"),
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
						            x = {
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
						            y = {
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
									attached = {
										disabled = parentDisabled,
										type = "toggle",
										order = 8,
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
										order = 9,
										name = "Attached Position",
										values = createDropdownTable("Top", "Bottom", "Left", "Right"),
										get = "Get",
										set = "Set"
						            },
						            limit = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Bar")
						            	end,
						            	type = "range",
						            	order = 10,
						            	name = "Bar Limit",
						            	min = 1,
						            	max = 40,
						            	step = 1,
						            	get = "Get",
						            	set = "Set"
						            },
						            hideNoDuration = {
						            	disabled = parentDisabled,
										type = "toggle",
										order = 11,
										name = "Hide No Duration",
										desc = "Hide auras that never expire, e.g. mounts, weekly event buffs, etc.",
										get = "Get",
										set = "Set"
						            },
						            own = {
						            	disabled = parentDisabled,
										type = "toggle",
										order = 12,
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
										order = 13,
										name = "Color By",
										values = createDropdownTable("Class", "Health", "Power", "Gradient", "Custom"),
										get = "Get",
										set = "Set"
						        	},
						            customColor = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Bar" and parent.colorBy == "Custom")
						            	end,
					                	type = "color",
					                	order = 14,
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
										order = 15,
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
										order = 16,
										name = "Reversed",
										get = "Get",
										set = "Set"
						            },
						            texture = {
						            	disabled = parentDisabled,
										type = "select",
										order = 17,
										name = "Texture",
								      	values = media:HashTable("statusbar"),
								      	dialogControl = "LSM30_Statusbar",
										get = "Get",
										set = "Set"
						            },
						            size = {
						            	disabled = parentDisabled,
						            	type = "group",
						            	order = 18,
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
						            	disabled = parentDisabled,
						            	type = "group",
						            	order = 19,
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
						            	disabled = parentDisabled,
						            	type = "group",
						            	order = 20,
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
						            background = backgroundSetting(21),
						            blacklist = {
						            	disabled = parentDisabled,
						            	type = "group",
						            	order = 22,
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
						            	order = 23,
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
						            x = {
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
						            y = {
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
									attached = {
										disabled = parentDisabled,
										type = "toggle",
										order = 8,
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
										order = 9,
										name = "Attached Position",
										values = createDropdownTable("Top", "Bottom", "Left", "Right"),
										get = "Get",
										set = "Set"
						            },
						            limit = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Bar")
						            	end,
						            	type = "range",
						            	order = 10,
						            	name = "Bar Limit",
						            	min = 1,
						            	max = 40,
						            	step = 1,
						            	get = "Get",
						            	set = "Set"
						            },
						            own = {
						            	disabled = parentDisabled,
										type = "toggle",
										order = 12,
										name = "Own Only",
										desc = "Only show debuffs cast by yourself",
										get = "Get",
										set = "Set"
						            },
						            colorBy = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Bar")
						            	end,
										type = "select",
										order = 13,
										name = "Color By",
										values = createDropdownTable("Class", "Health", "Power", "Gradient", "Custom"),
										get = "Get",
										set = "Set"
						        	},
						            customColor = {
						            	disabled = function(info)
						            		local parent = getParent(info)
						            		return not (parent.enabled and parent.style == "Bar" and parent.colorBy == "Custom")
						            	end,
					                	type = "color",
					                	order = 14,
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
										order = 15,
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
										order = 16,
										name = "Reversed",
										get = "Get",
										set = "Set"
						            },
						            texture = {
						            	disabled = parentDisabled,
										type = "select",
										order = 17,
										name = "Texture",
								      	values = media:HashTable("statusbar"),
								      	dialogControl = "LSM30_Statusbar",
										get = "Get",
										set = "Set"
						            },
						            size = {
						            	disabled = parentDisabled,
						            	type = "group",
						            	order = 18,
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
						            	disabled = parentDisabled,
						            	type = "group",
						            	order = 19,
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
						            	disabled = parentDisabled,
						            	type = "group",
						            	order = 20,
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
						            background = backgroundSetting(21),
						            blacklist = {
						            	disabled = parentDisabled,
						            	type = "group",
						            	order = 22,
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
						            	order = 23,
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
					        --castbar = castBarSetting(12),
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
					        }
						}
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

	A.options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(A.db)
end