local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local T = A.Tools

local floor = math.floor

local GetScreenWidth = GetScreenWidth
local GetScreenHeight = GetScreenHeight

local function createDropdownTable(...)
    local tbl = {}
    for _,v in next, {...} do
        tbl[v] = v:fupper()
    end
    return tbl
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

function A:RegisterOptions()

	local O = {}
	function O:Get(info)
		local db = getParent(info)
		return db[info[#info]]
	end
	function O:Set(info, val)
		local db = getParent(info)
		db[info[#info]] = val
	end

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
							health = {
								type = "group",
								order = 1,
								name = "Health",
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
						            		return parent.colorBy ~= "Custom"
						            	end,
					                	type = "color",
					                	order = 3,
					                	name = "Custom Color",
					                	hasAlpha = true,
					                	get = "Get",
					                	set = "Set"
					                },
						            mult = {
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
										type = "select",
										order = 5,
										name = "Orientation",
										values = createDropdownTable("HORIZONTAL", "VERTICAL"),
										get = "Get",
										set = "Set"
						            },
						            reversed = {
										type = "toggle",
										order = 6,
										name = "Reversed",
										get = "Get",
										set = "Set"
									},
						            texture = {
										type = "select",
										order = 7,
										name = "Texture",
								      	values = media:HashTable("statusbar"),
								      	dialogControl = "LSM30_Statusbar",
										get = "Get",
										set = "Set"
						            },
									position = {
										type = "group",
										order = 8,
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
												step = 1,
												get = "Get",
												set = "Set",
											},
											relative = {
												type = "select",
												order = 5,
												name = "Relative To",
												values = createDropdownTable("Player", "power"),
												get = "Get",
												set = "Set"
											}
										}
									},
									size = {
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
												get = "Get",
												set = "Set",
											}
										}
									},
						            missingBar = {
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
								            		return parent.colorBy ~= "Custom"
								            	end,
							                	type = "color",
							                	order = 2,
							                	name = "Custom Color",
							                	hasAlpha = true,
							                	get = "Get",
							                	set = "Set"
							                },
							                colorBy = {
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
								type = "group",
								order = 2,
								name = "Power",
								childGroups = "tab",
								args = {}
							},
	--[[						buffs = {
								enabled = true,
								position = {
					                point = "TOPLEFT",
					                localPoint = "TOPLEFT",
					                x = 0,
					                y = 0,
					                relative = "FrameParent"
					            },
					            style = "Bar",
					            barGrowth = "Upwards",
					            iconGrowth = "Right Then Down",
					            x = 1,
					            y = 1,
					            iconLimit = 5,
								attached = true,
					            attachedPosition = "Above",
					            limit = 10,
					            hideNoDuration = true,
					            own = true,
					            colorBy = "Class",
					            customColor = { 1, 1, 1 },
					            mult = 0.33,
					            reversed = false,
					            texture = "Default",
					            size = {
					                matchWidth = true,
					                matchHeight = false,
					                width = 20,
					                height = 20
					            },
					            name = {
					                size = 10,
					                position = {
					                    point = "LEFT",
					                    localPoint = "LEFT",
					                    x = 25,
					                    y = 0,
					                }
					            },
					            time = {
					                size = 10,
					                position = {
					                    point = "RIGHT",
					                    localPoint = "RIGHT",
					                    x = -5,
					                    y = 0,
					                }
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
					                matchWidth = false,
					                width = 202,
					                matchHeight = false,
					                height = 52,
					                enabled = true
					            },
					            blacklist = {
					                enabled = true,
					                ids = {}
					            },
					            whitelist = {
					                enabled = false,
					                ids = {}
					            }
							},
							debuffs = {
					            enabled = false,
					            position = {
					                point = "BOTTOM",
					                localPoint = "TOP",
					                x = 0,
					                y = -1,
					                relative = "Parent"
					            },
					            style = "Icon",
					            growth = "Left",
					            attached = "LEFT",
					            limit = 10,
					            own = true,
					            mult = 0.33,
					            size = {
					                matchWidth = true,
					                matchHeight = false,
					                width = 16,
					                height = 16
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
					            blacklist = {
					                enabled = true,
					                ids = {}
					            },
					            whitelist = {
					                enabled = false,
					                ids = {}
					            }
							},
							size = {
								width = 200,
								height = 50
							},
					        tags = {
					            name = {
					                format = "[name]",
					                size = 10,
					                localPoint = "TOPLEFT",
					                point = "TOPLEFT",
					                relative = "Player",
					                x = 2,
					                y = -2,
					                hide = false
					            }
					        },
					        healPrediction = {
					            enabled = true,
					            texture = "Default",
					            overflow = 1,
					            colors = {
					                my = { 0, .827, .765, .5 },
					                all = { 0, .631, .557, .5 },
					                absorb = { .7, .7, 1, .5 },
					                healAbsorb = { .7, .7, 1, .5 }
					            }
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
					        altpower = {
					            enabled = true,
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
					            position = {
					                point = "TOPLEFT",
					                localPoint = "TOPLEFT",
					                x = 300,
					                y = -400,
					                relative = "FrameParent"
					            },
					            size = {
					                width = 200,
					                height = 20
					            },
					            texture = "Default",
					            mult = 0.3,
					            color = { 0.7, 0.5, 0.3, 1 }
					        },
					        runes = {
					            enabled = true,
					            position = {
					                relative = "Parent",
					                point = "BOTTOM",
					                localPoint = "TOP",
					                x = 0,
					                y = -1, 
					            },
					            size = {
					                width = 200,
					                height = 15
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
					                enabled = true,
					            },
					            orientation = "HORIZONTAL",
					            reversed = false,
					            texture = "Default",
					            x = 1,
					            y = 1,
					            attached = true,
					            attachedPosition = "Below",
					        },
					        comboPoints = {
					            enabled = true,
					            position = {
					                relative = "Parent",
					                point = "BOTTOM",
					                localPoint = "TOP",
					                x = 0,
					                y = -1, 
					            },
					            size = {
					                width = 191,
					                height = 15
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
					            orientation = "HORIZONTAL",
					            texture = "Default",
					            x = 1,
					            y = 1,
					            attached = true,
					            attachedPosition = "Below",
					        },
					        soulShards = {
					            enabled = true,
					            position = {
					                relative = "Parent",
					                point = "BOTTOM",
					                localPoint = "TOP",
					                x = 0,
					                y = -1, 
					            },
					            size = {
					                width = 196,
					                height = 15
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
					            orientation = "HORIZONTAL",
					            texture = "Default",
					            x = 1,
					            y = 1,
					            attached = true,
					            attachedPosition = "Below",
					        },
					        chi = {
					            enabled = true,
					            position = {
					                relative = "Parent",
					                point = "BOTTOM",
					                localPoint = "TOP",
					                x = 0,
					                y = -1, 
					            },
					            size = {
					                width = 196,
					                height = 15
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
					            orientation = "HORIZONTAL",
					            texture = "Default",
					            x = 1,
					            y = 1,
					            attached = true,
					            attachedPosition = "Below",
					        },
					        arcaneCharges = {
					            enabled = true,
					            position = {
					                relative = "Parent",
					                point = "BOTTOM",
					                localPoint = "TOP",
					                x = 0,
					                y = 0, 
					            },
					            size = {
					                width = 150,
					                height = 15
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
					            orientation = "HORIZONTAL",
					            texture = "Default",
					            x = 1,
					            y = 1,
					            attached = true,
					            attachedPosition = "Below",
					        },
					        holyPower = {
					            enabled = true,
					            position = {
					                relative = "Parent",
					                point = "BOTTOM",
					                localPoint = "TOP",
					                x = 0,
					                y = -1, 
					            },
					            size = {
					                width = 200,
					                height = 15
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
					            orientation = "HORIZONTAL",
					            texture = "Default",
					            x = 1,
					            y = 1,
					            attached = true,
					            attachedPosition = "Below"
					        },              
					        castbar = {
					            enabled = true,
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
					        },
					        stagger = {
					            enabled = true,
					            texture = "Default",
					            orientation = "HORIZONTAL",
					            reversed = false,
					            position = {
					                relative = "FrameParent",
					                point = "BOTTOM",
					                localPoint = "TOP",
					                x = 0,
					                y = -1, 
					            },
					            size = {
					                matchWidth = true,
					                matchHeight = false,
					                width = 150,
					                height = 15
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
					            colors = {
					                high = { .7, 0, 0, 1 },
					                medium = { .5, .5, 0, 1 },
					                low = { 0, .7, 0, 1}
					            },
					            mult = 0.33,
					            attachedPosition = "Below",
					            afterChi = true,
					            attached = true
					        },
					        combat = {
					            enabled = true
					        },
							enabled = true--]]
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