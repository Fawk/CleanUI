local A, L = unpack(select(2, ...))
local rawset = rawset
local rawget = rawget
local pairs = pairs
local smatch = string.match
local setmetatable = setmetatable

local Database = {
    prepared = {}
}

Database.TYPE_CHARACTER = "Characters"

for k,v in pairs(Database) do
    if smatch(k, "%a+_%a+") then
        Database.prepared[Database[k]] = {}
    end
end

local defaults =  {
    ["Profiles"] = {
	    ["Default"] = {
    		["Options"] = {
    			["Player"] = {
                    ["Position"] = {
                        ["Relative To"] = "Parent",
                        ["Point"] = "CENTER",
                        ["Local Point"] = "CENTER",
                        ["Offset X"] = -266.735260009766,
                        ["Offset Y"] = -202.188110351563,
                    },
    				["Health"] = {
    					["Enabled"] = true,
    					["Position"] = {
    						["Point"] = "TOP",
    						["Local Point"] = "TOP",
    						["Offset X"] = 0,
    						["Offset Y"] = 0,
    						["Relative To"] = "Player"
    					},
    					["Size"] = {
    						["Match width"] = true,
    						["Match height"] = false,
    						["Width"] = 150,
    						["Height"] = 35
    					},
                        ["Color By"] = "Gradient",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2"
    				},
    				["Power"] = {
    					["Enabled"] = true,
    					["Position"] = {
    						["Point"] = "BOTTOM",
    						["Local Point"] = "TOP",
    						["Offset X"] = 0,
    						["Offset Y"] = -1,
    						["Relative To"] = "Health"
    					},
    					["Size"] = {
    						["Match width"] = true,
    						["Match height"] = false,
    						["Width"] = 150,
    						["Height"] = 15
    					},
                        ["Color By"] = "Power",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2"
    				},
    				["Buffs"] = {
    					["Enabled"] = true,
    					["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Parent"
                        },
                        ["Style"] = "Bar",
                        ["Growth"] = "Upwards",
    					["Attached"] = "TOP",
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 16,
                            ["Height"] = 16
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = -1,
                                ["Bottom"] = -1,
                                ["Left"] = -1,
                                ["Right"] = -1
                            },
                            ["Enabled"] = true,
                        },
                        ["Blacklist"] = {
                            ["Enabled"] = true,
                            ["Ids"] = {}
                        },
                        ["Whitelist"] = {
                            ["Enabled"] = false,
                            ["Ids"] = {}
                        }
    				},
    				["Debuffs"] = {
                        ["Enabled"] = false,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Parent"
                        },
                        ["Style"] = "Bar",
                        ["Growth"] = "Upwards",
                        ["Attached"] = "TOP",
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 16,
                            ["Height"] = 16
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = -1,
                                ["Bottom"] = -1,
                                ["Left"] = -1,
                                ["Right"] = -1
                            },
                            ["Enabled"] = true,
                        },
                        ["Blacklist"] = {
                            ["Enabled"] = true,
                            ["Ids"] = {}
                        },
                        ["Whitelist"] = {
                            ["Enabled"] = false,
                            ["Ids"] = {}
                        }
    				},
    				["Size"] = {
    					["Width"] = 200,
    					["Height"] = 51
    				},
                    ["Tags"] = {
                        ["Name"] = {
                            ["Font"] = "NotoBold",
                            ["Size"] = 14,
                            ["Color"] = { 1, 1, 1 },
                            ["Outline"] = "Outline",
                            ["Text"] = "[name]",
                            ["Position"] = {
                                ["Point"] = "TOPLEFT",
                                ["Local Point"] = "BOTTOMLEFT",
                                ["Offset X"] = 5,
                                ["Offset Y"] = 2,
                                ["Relative To"] = "Player"
                            },
                            ["Enabled"] = false
                        },
                        ["Custom"] = {}
                    },
                    ["HealPrediction"] = {
                        ["Texture"] = "Default2",
                        ["MaxOverflow"] = 1,
                        ["FrequentUpdates"] = true,
                        ["Enabled"] = true
                    },
					["Background"] = {
						["Color"] = { 0, 0, 0 },
						["Offset"] = {
							["Top"] = -1,
							["Bottom"] = -1,
							["Left"] = -1,
							["Right"] = -1
						},
						["Enabled"] = true,
					},
                    ["AlternativePower"] = {
                        ["Enabled"] = true,
                        ["Background"] = {
                            ["Enabled"] = true,
                            ["Offset"] = {
                                ["Top"] = -1,
                                ["Bottom"] = -1,
                                ["Left"] = -1,
                                ["Right"] = -1
                            },
                            ["Color"] = { 0, 0, 0 }
                        },
                        ["Position"] = {
                            ["Point"] = "TOPLEFT",
                            ["Local Point"] = "TOPLEFT",
                            ["Offset X"] = 300,
                            ["Offset Y"] = 400,
                            ["Relative To"] = "Parent"
                        },
                        ["Size"] = {
                            ["Width"] = 200,
                            ["Height"] = 20
                        },
                        ["Texture"] = "Default2",
                        ["Background Multiplier"] = 0.3,
                        ["Hide Blizzard"] = true
                    },
                    ["ClassIcons"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Relative To"] = "Parent",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0, 
                        },
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 150,
                            ["Height"] = 15
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = -1,
                                ["Bottom"] = -1,
                                ["Left"] = -1,
                                ["Right"] = -1
                            },
                            ["Enabled"] = true,
                        },
                        ["Attached"] = true
                    },
                    ["Castbar"] = {
                        ["Enabled"] = true,
                        ["Texture"] = "Default2",
                        ["Position"] = {
                            ["Relative To"] = "ClassIcons",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0, 
                        },
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 150,
                            ["Height"] = 15
                        },
                        ["Time"] = {
                            ["Enabled"] = true,
                            ["Position"] = {
                                ["Relative To"] = "Parent",
                                ["Point"] = "RIGHT",
                                ["Local Point"] = "RIGHT",
                                ["Offset X"] = -5,
                                ["Offset Y"] = 0, 
                            },
                            ["Font Size"] = 10
                        },
                        ["Name"] = {
                            ["Enabled"] = true,
                            ["Position"] = {
                                ["Relative To"] = "Parent",
                                ["Point"] = "LEFT",
                                ["Local Point"] = "LEFT",
                                ["Offset X"] = 18,
                                ["Offset Y"] = 0, 
                            },
                            ["Font Size"] = 0.7
                        },
                        ["Icon"] = {
                            ["Enabled"] = true,
                            ["Position"] = "LEFT",
                            ["Size"] = {
                                ["Match width"] = false,
                                ["Match height"] = true,
                                ["Size"] = 10
                            },
                            ["Background"] = {
                                ["Color"] = { 0, 0, 0 },
                                ["Offset"] = {
                                    ["Top"] = -1,
                                    ["Bottom"] = -1,
                                    ["Left"] = -1,
                                    ["Right"] = -1
                                },
                                ["Enabled"] = true
                            }
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = -1,
                                ["Bottom"] = -1,
                                ["Left"] = -1,
                                ["Right"] = -1
                            },
                            ["Enabled"] = true,
                        },
                        ["Attached"] = true,
                    },
                    ["Stagger"] = {
                        ["Enabled"] = true,
                        ["Texture"] = "Default2",
                        ["Position"] = {
                            ["Relative To"] = "Parent",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0, 
                        },
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 150,
                            ["Height"] = 15
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = -1,
                                ["Bottom"] = -1,
                                ["Left"] = -1,
                                ["Right"] = -1
                            },
                            ["Enabled"] = true,
                        },
                        ["Attached"] = true
                    },
                    ["CombatIndicator"] = {
                        ["Enabled"] = true
                    },
    				["Enabled"] = true
    			},
    			["Target"] = {
                    ["Position"] = {
                        ["Relative To"] = "Parent",
                        ["Point"] = "CENTER",
                        ["Local Point"] = "CENTER",
                        ["Offset X"] = 265.640625,
                        ["Offset Y"] = -202.187973022461,
                    },
    				["Health"] = {
    					["Enabled"] = true,
    					["Position"] = {
    						["Point"] = "TOP",
    						["Local Point"] = "TOP",
    						["Offset X"] = 0,
    						["Offset Y"] = 0,
    						["Relative To"] = "Target"
    					},
    					["Size"] = {
    						["Match width"] = true,
    						["Match height"] = false,
    						["Width"] = 250,
    						["Height"] = 35
    					},
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2"
    				},
    				["Power"] = {
    					["Enabled"] = true,
    					["Position"] = {
    						["Point"] = "BOTTOM",
    						["Local Point"] = "TOP",
    						["Offset X"] = 0,
    						["Offset Y"] = -1,
    						["Relative To"] = "Health"
    					},
    					["Size"] = {
    						["Match width"] = true,
    						["Match height"] = false,
    						["Width"] = 250,
    						["Height"] = 15
    					},
                        ["Color By"] = "Power",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2"
    				},
    				["Buffs"] = {
                        ["Enabled"] = false,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Parent"
                        },
                        ["Style"] = "Bar",
                        ["Growth"] = "Upwards",
                        ["Attached"] = "TOP",
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 16,
                            ["Height"] = 16
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = -1,
                                ["Bottom"] = -1,
                                ["Left"] = -1,
                                ["Right"] = -1
                            },
                            ["Enabled"] = true,
                        },
                        ["Blacklist"] = {
                            ["Enabled"] = true,
                            ["Ids"] = {}
                        },
                        ["Whitelist"] = {
                            ["Enabled"] = false,
                            ["Ids"] = {}
                        }
    				},
    				["Debuffs"] = {
                        ["Enabled"] = false,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Parent"
                        },
                        ["Style"] = "Bar",
                        ["Growth"] = "Upwards",
                        ["Attached"] = "TOP",
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 16,
                            ["Height"] = 16
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = -1,
                                ["Bottom"] = -1,
                                ["Left"] = -1,
                                ["Right"] = -1
                            },
                            ["Enabled"] = true,
                        },
                        ["Blacklist"] = {
                            ["Enabled"] = true,
                            ["Ids"] = {}
                        },
                        ["Whitelist"] = {
                            ["Enabled"] = false,
                            ["Ids"] = {}
                        }
    				},
    				["Size"] = {
    					["Width"] = 200,
    					["Height"] = 51
    				},
					["Tags"] = {
                        ["Name"] = {
                            ["Font"] = "NotoBold",
                            ["Size"] = 10,
                            ["Color"] = { 1, 1, 1 },
                            ["Outline"] = "OUTLINE",
                            ["Text"] = "[name]",
                            ["Position"] = {
                                ["Point"] = "LEFT",
                                ["Local Point"] = "LEFT",
                                ["Offset X"] = 5,
                                ["Offset Y"] = 0,
                                ["Relative To"] = "Health"
                            },
                            ["Enabled"] = true
                        },
                        ["Custom"] = {
                            ["Health Text"] = {
                                ["Font"] = "NotoBold",
                                ["Size"] = 10,
                                ["Color"] = { 1, 1, 1 },
                                ["Outline"] = "OUTLINE",
                                ["Text"] = "[hp:round]",
                                ["Position"] = {
                                    ["Point"] = "RIGHT",
                                    ["Local Point"] = "RIGHT",
                                    ["Offset X"] = -5,
                                    ["Offset Y"] = -10,
                                    ["Relative To"] = "Target"
                                },
                                ["Enabled"] = true
                            } 
                        }
                    },
                    ["HealPrediction"] = {
                        ["Texture"] = "Default2",
                        ["MaxOverflow"] = 1,
                        ["FrequentUpdates"] = true,
                        ["Enabled"] = true
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0 },
                        ["Offset"] = {
                            ["Top"] = -1,
                            ["Bottom"] = -1,
                            ["Left"] = -1,
                            ["Right"] = -1
                        },
                        ["Enabled"] = true,
                    },
                    ["Castbar"] = {
                        ["Enabled"] = true,
                        ["Texture"] = "Default2",
                        ["Position"] = {
                            ["Relative To"] = "ClassIcons",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0, 
                        },
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 150,
                            ["Height"] = 16
                        },
                        ["Time"] = {
                            ["Enabled"] = true,
                            ["Position"] = {
                                ["Relative To"] = "Parent",
                                ["Point"] = "RIGHT",
                                ["Local Point"] = "RIGHT",
                                ["Offset X"] = -5,
                                ["Offset Y"] = 0, 
                            },
                            ["Font Size"] = 10
                        },
                        ["Name"] = {
                            ["Enabled"] = true,
                            ["Position"] = {
                                ["Relative To"] = "Parent",
                                ["Point"] = "LEFT",
                                ["Local Point"] = "LEFT",
                                ["Offset X"] = 18,
                                ["Offset Y"] = 0, 
                            },
                            ["Font Size"] = 0.7
                        },
                        ["Icon"] = {
                            ["Enabled"] = true,
                            ["Position"] = "LEFT",
                            ["Size"] = {
                                ["Match width"] = false,
                                ["Match height"] = true,
                                ["Size"] = 10
                            },
                            ["Background"] = {
                                ["Color"] = { 0, 0, 0 },
                                ["Offset"] = {
                                    ["Top"] = -1,
                                    ["Bottom"] = -1,
                                    ["Left"] = -1,
                                    ["Right"] = -1
                                },
                                ["Enabled"] = true
                            }
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0 },
                            ["Offset"] = {
                                ["Top"] = -1,
                                ["Bottom"] = -1,
                                ["Left"] = -1,
                                ["Right"] = -1
                            },
                            ["Enabled"] = true,
                        },
                        ["Attached"] = true,
                    },
                    ["Enabled"] = true
    			},
                ["TargetTarget"] = {
                    ["Position"] = {
                        ["Relative To"] = "Target",
                        ["Point"] = "BOTTOMRIGHT",
                        ["Local Point"] = "BOTTOMLEFT",
                        ["Offset X"] = 0,
                        ["Offset Y"] = 0,
                    },
                    ["Health"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "TOP",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0,
                            ["Relative To"] = "TargetTarget"
                        },
                        ["Size"] = {
                            ["Match width"] = false,
                            ["Match height"] = false,
                            ["Width"] = 100,
                            ["Height"] = 20
                        },
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2"
                    },
                    ["Power"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Health"
                        },
                        ["Size"] = {
                            ["Match width"] = false,
                            ["Match height"] = false,
                            ["Width"] = 100,
                            ["Height"] = 5
                        },
                        ["Color By"] = "Power",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2"
                    },
                    ["Buffs"] = {
                        ["Enabled"] = false,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Parent"
                        },
                        ["Style"] = "Bar",
                        ["Growth"] = "Upwards",
                        ["Attached"] = "TOP",
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 16,
                            ["Height"] = 16
                        },
                        ["Blacklist"] = {
                            ["Enabled"] = true,
                            ["Ids"] = {}
                        },
                        ["Whitelist"] = {
                            ["Enabled"] = false,
                            ["Ids"] = {}
                        }
                    },
                    ["Debuffs"] = {
                        ["Enabled"] = false,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Parent"
                        },
                        ["Style"] = "Bar",
                        ["Growth"] = "Upwards",
                        ["Attached"] = "TOP",
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 16,
                            ["Height"] = 16
                        },
                        ["Blacklist"] = {
                            ["Enabled"] = true,
                            ["Ids"] = {}
                        },
                        ["Whitelist"] = {
                            ["Enabled"] = false,
                            ["Ids"] = {}
                        }
                    },
                    ["Size"] = {
                        ["Width"] = 100,
                        ["Height"] = 25
                    },
                    ["Tags"] = {
                        ["Name"] = {
                            ["Font"] = "NotoBold",
                            ["Size"] = 10,
                            ["Color"] = { 1, 1, 1 },
                            ["Outline"] = "SHADOW",
                            ["Text"] = "[name]",
                            ["Position"] = {
                                ["Point"] = "LEFT",
                                ["Local Point"] = "LEFT",
                                ["Offset X"] = 5,
                                ["Offset Y"] = 0,
                                ["Relative To"] = "Health"
                            },
                            ["Enabled"] = true
                        },
                        ["Custom"] = {}
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0 },
                        ["Offset"] = {
                            ["Top"] = -1,
                            ["Bottom"] = -1,
                            ["Left"] = -1,
                            ["Right"] = -1
                        },
                        ["Enabled"] = true,
                    },
                    ["Enabled"] = true
                },
                ["Pet"] = {
                    ["Position"] = {
                        ["Relative To"] = "Player",
                        ["Point"] = "BOTTOMLEFT",
                        ["Local Point"] = "BOTTOMRIGHT",
                        ["Offset X"] = 0,
                        ["Offset Y"] = 0,
                    },
                    ["Health"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "TOP",
                            ["Local Point"] = "ALL",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0,
                            ["Relative To"] = "Pet"
                        },
                        ["Size"] = {
                            ["Match width"] = false,
                            ["Match height"] = false,
                            ["Width"] = 100,
                            ["Height"] = 20
                        },
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2"
                    },
                    ["Size"] = {
                        ["Width"] = 100,
                        ["Height"] = 20
                    },
                    ["Tags"] = {
                        ["Name"] = {
                            ["Font"] = "NotoBold",
                            ["Size"] = 10,
                            ["Color"] = { 1, 1, 1 },
                            ["Outline"] = "SHADOW",
                            ["Text"] = "[name]",
                            ["Position"] = {
                                ["Point"] = "LEFT",
                                ["Local Point"] = "LEFT",
                                ["Offset X"] = 5,
                                ["Offset Y"] = 0,
                                ["Relative To"] = "Health"
                            },
                            ["Enabled"] = true
                        },
                        ["Custom"] = {}
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0 },
                        ["Offset"] = {
                            ["Top"] = -1,
                            ["Bottom"] = -1,
                            ["Left"] = -1,
                            ["Right"] = -1
                        },
                        ["Enabled"] = true,
                    },
                    ["Enabled"] = true
                },
                ["Party"] = {
                    ["Position"] = {
                        ["Relative To"] = "Parent",
                        ["Point"] = "CENTER",
                        ["Local Point"] = "CENTER",
                        ["Offset X"] = -1.29987347126007,
                        ["Offset Y"] = -201.094223022461,
                    },
                    ["Health"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "TOP",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0,
                            ["Relative To"] = "Parent"
                        },
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 64,
                            ["Height"] = 41
                        },
                        ["Color By"] = "Gradient",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "VERTICAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2"
                    },
                    ["Power"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Health"
                        },
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 64,
                            ["Height"] = 5
                        },
                        ["Color By"] = "Power",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2"
                    },
                    ["Size"] = {
                        ["Width"] = 63,
                        ["Height"] = 47
                    },
                    ["Orientation"] = "HORIZONTAL",
                    ["Tags"] = {
                        ["Name"] = {
                            ["Font"] = "NotoBold",
                            ["Size"] = 12,
                            ["Color"] = { 1, 1, 1 },
                            ["Outline"] = "SHADOW",
                            ["Text"] = "[3charname]",
                            ["Position"] = {
                                ["Point"] = "ALL",
                                ["Local Point"] = "ALL",
                                ["Offset X"] = 0,
                                ["Offset Y"] = 0,
                                ["Relative To"] = "Parent"
                            },
                            ["Enabled"] = true,
                        },
                        ["Custom"] = {}
                    },
                    ["RaidBuffs"] = {
                        ["Limit"] = 40,
                        ["Tracked"] = {},
						["Important"] = true,
                        ["Enabled"] = true
                    },
                    ["HealPrediction"] = {
                        ["Texture"] = "Default2",
                        ["MaxOverflow"] = 1,
                        ["FrequentUpdates"] = true,
                        ["Enabled"] = true
                    },
                    ["Offset X"] = 2,
                    ["Offset Y"] = 0,
                    ["Show Player"] = true,
                    ["Highlight Target"] = true,
                    ["Show Debuff Border"] = true,
                    ["Debuff Order"] = { "Magic", "Disease", "Curse", "Poison" },
                    ["Key Bindings"] = {},
                    ["GroupRoleIndicator"] = {
                        ["Position"] = {
                            ["Point"] = "TOPLEFT",
                            ["Local Point"] = "TOPLEFT",
                            ["Offset X"] = 2,
                            ["Offset Y"] = -2,
                            ["Relative To"] = "Parent"    
                        },
                        ["Enabled"] = true
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0 },
                        ["Offset"] = {
                            ["Top"] = -1,
                            ["Bottom"] = -1,
                            ["Left"] = -1,
                            ["Right"] = -1
                        },
                        ["Enabled"] = true,
                    },
                    ["Enabled"] = true
                },
                ["Raid"] = {
                    ["Position"] = {
                        ["Relative To"] = "Parent",
                        ["Point"] = "TOPLEFT",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = 1117.7001953125,
                        ["Offset Y"] = -899.094360351563,
                    },
                    ["Health"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "TOP",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0,
                            ["Relative To"] = "Parent"
                        },
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 64,
                            ["Height"] = 41
                        },
                        ["Color By"] = "Gradient",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "VERTICAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2"
                    },
                    ["Power"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Health"
                        },
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 64,
                            ["Height"] = 5
                        },
                        ["Color By"] = "Power",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default2"
                    },
                    ["Size"] = {
                        ["Width"] = 63,
                        ["Height"] = 47
                    },
                    ["Orientation"] = "HORIZONTAL",
                    ["Tags"] = {
                        ["Name"] = {
                            ["Font"] = "NotoBold",
                            ["Size"] = 12,
                            ["Color"] = { 1, 1, 1 },
                            ["Outline"] = "SHADOW",
                            ["Text"] = "[3charname]",
                            ["Position"] = {
                                ["Point"] = "ALL",
                                ["Local Point"] = "ALL",
                                ["Offset X"] = 0,
                                ["Offset Y"] = 0,
                                ["Relative To"] = "Parent"
                            },
                            ["Enabled"] = true,
                        },
                        ["Custom"] = {}
                    },
                    ["RaidBuffs"] = {
                        ["Tracked"] = {},
                        ["Important"] = true,
                        ["Enabled"] = true
                    },
                    ["HealPrediction"] = {
                        ["Texture"] = "Default2",
                        ["MaxOverflow"] = 1,
                        ["FrequentUpdates"] = true,
                        ["Enabled"] = true
                    },
                    ["Offset X"] = 2,
                    ["Offset Y"] = 2,
                    ["Show Player"] = true,
                    ["Highlight Target"] = true,
                    ["Show Debuff Border"] = true,
                    ["Debuff Order"] = { "Magic", "Disease", "Curse", "Poison" },
                    ["Key Bindings"] = {},
                    ["LFDRole"] = {
                        ["Position"] = {
                            ["Point"] = "TOPLEFT",
                            ["Local Point"] = "TOPLEFT",
                            ["Offset X"] = 2,
                            ["Offset Y"] = -2,
                            ["Relative To"] = "Parent"    
                        },
                        ["Enabled"] = true
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0 },
                        ["Offset"] = {
                            ["Top"] = -1,
                            ["Bottom"] = -1,
                            ["Left"] = -1,
                            ["Right"] = -1
                        },
                        ["Enabled"] = true,
                    },
                    ["Enabled"] = true
                },
    			["Minimap"] = {
    				["Size"] = 150,
    				["Position"] = {
    					["Point"] = "TOPRIGHT",
    					["Local Point"] = "TOPRIGHT",
    					["Offset X"] = 0,
    					["Offset Y"] = 0,
    					["Relative To"] = "Parent"
    				}
    			},
                ["Vehicle Seat Indicator"] = {
                    ["Position"] = {
                        ["Point"] = "TOPLEFT",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = 100,
                        ["Offset Y"] = -100,
                        ["Relative To"] = "Parent"
                    }
                },
                ["Objective Tracker"] = {
                    ["Position"] = {
                        ["Point"] = "TOPRIGHT",
                        ["Local Point"] = "TOPRIGHT",
                        ["Offset X"] = -10,
                        ["Offset Y"] = -300,
                        ["Relative To"] = "Parent"
                    }
                },
                ["Cooldown bar"] = {
                    ["Position"] = {
                        ["Relative To"] = "Parent",
                        ["Point"] = "CENTER",
                        ["Local Point"] = "CENTER",
                        ["Offset X"] = 3.4875648021698,
                        ["Offset Y"] = -158.936065673828,
                    },
                },
				["Chat"] = {
					["Hide In Combat"] = false
				},
                ["Extra Action Button"] = {
                    ["Position"] = {
                        ["Relative To"] = "Parent",
                        ["Point"] = "BOTTOM",
                        ["Local Point"] = "BOTTOM",
                        ["Offset X"] = -6.56422424316406,
                        ["Offset Y"] = 144.222183227539,
                    },
                },
                ["Info Field"] = {
                    ["Enabled"] = true,
                    ["Limit"] = 10,
                    ["Size"] = 20,
                    ["Direction"] = "Right",
                    ["Orientation"] = "HORIZONTAL",
                    ["Position"] = {
                        ["Relative To"] = "Parent",
                        ["Point"] = "CENTER",
                        ["Local Point"] = "CENTER",
                        ["Offset X"] = 3.4875648021698,
                        ["Offset Y"] = -158.936065673828,
                    },
                    ["Presets"] = {}
                }
    		}
	    }
	},
	["Characters"] = {}
}

A.defaults = defaults

local function deepCopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

local function iter(old, new)
    for k,v in pairs(old) do
        if type(v) == "table" then
            iter(v, new[k]) 
        else
            if v ~= new[k] then
                old[k] = new[k]
            end
        end
    end
end

local function merge(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                merge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

local defaultsMeta = {
    __index = function(t, k)
        if not rawget(t, k) and rawget(defaults, k) then
            rawset(t, k, deepCopy(rawget(defaults, k)))
        end
        return rawget(t, k)
    end
}

local function scan(tbl, d)
    for k,v in pairs(d) do
        if type(v) == "table" then
            if not tbl[k] then
                tbl[k] = setmetatable({}, {
                    __index = function(t, kv)
                        if not rawget(t, kv) and rawget(v, kv) then
                            rawset(t, kv, deepCopy(rawget(v, kv)))
                        end
                        return rawget(t, kv)
                    end
                })
            end
            scan(tbl[k], v)
        else
            if not tbl[k] then
                tbl[k] = v
            end
        end
    end
end

for profile, tbl in next, defaults["Profiles"] do
    if profile ~= "Default" then
        scan(tbl, defaults["Profiles"]["Default"])
    end
end

function Database:Prepare(type, value)
    if not self.prepared[type] then
        self.prepared[type] = {}
    end
    self.prepared[type] = value
end

function Database:GetDefaults(profile)
    return defaults["Profiles"][profile]
end

function Database:Save()
    local activeProfile = A["Modules"]["Profile"]:GetActive()
    local save = setmetatable({}, defaultsMeta)
    save[self.TYPE_CHARACTER] = deepCopy(defaults[self.TYPE_CHARACTER])

    for k,v in pairs(self.prepared) do
        if not save["Profiles"][activeProfile] then
            save["Profiles"][activeProfile] = deepCopy(A.db["Profiles"][activeProfile])
        end
        save["Profiles"][activeProfile]["Options"][k] = v
    end
    
    --A:DebugTable(save["Profiles"][activeProfile]["Options"]["Minimap"])

    CleanUI_DB = save
end

function Database:CreateDatabase()
	if CleanUI_DB == nil then 
		CleanUI_DB = {}
        return deepCopy(defaults)
	else
        return merge(deepCopy(defaults), deepCopy(CleanUI_DB))
    end
end

A["Database"] = Database