local AddonName = ...
local A, L = unpack(select(2, ...))

local global = _G[AddonName.."_DB"]

local defaults =  {
    ["Profiles"] = {
	    ["Default"] = {
    		["Options"] = {
    			["Player"] = {
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
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
                        ["Background Multiplier"] = -1,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default",
                        ["Missing Health Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
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
                        ["Background Multiplier"] = -1,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default",
                        ["Missing Power Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
    				},
    				["Buffs"] = {
    					["Enabled"] = true,
    					["Position"] = {
                            ["Point"] = "TOPLEFT",
                            ["Local Point"] = "TOPLEFT",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0,
                            ["Relative To"] = "FrameParent"
                        },
                        ["Style"] = "Bar",
                        ["Bar Growth"] = "Upwards",
                        ["Icon Growth"] = "Right Then Down",
                        ["Offset X"] = 1,
                        ["Offset Y"] = 1,
                        ["Icon Limit Per Row"] = 5,
    					["Attached"] = true,
                        ["Attached Position"] = "Above",
                        ["Limit"] = 10,
                        ["Hide no duration"] = true,
                        ["Own only"] = true,
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Reversed"] = false,
                        ["Texture"] = "Default",
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 20,
                            ["Height"] = 20
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0, 1 },
                            ["Offset"] = {
                                ["Top"] = 1,
                                ["Bottom"] = 1,
                                ["Left"] = 1,
                                ["Right"] = 1
                            },
                            ["Edge Size"] = 3,
                            ["Match width"] = false,
                            ["Width"] = 202,
                            ["Match height"] = false,
                            ["Height"] = 52,
                            ["Enabled"] = true
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
                        ["Style"] = "Icon",
                        ["Growth"] = "Left",
                        ["Attached"] = "LEFT",
                        ["Limit"] = 10,
                        ["Cast by me"] = true,
                        ["Background Multiplier"] = 0.33,
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 16,
                            ["Height"] = 16
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0, 1 },
                            ["Offset"] = {
                                ["Top"] = 1,
                                ["Bottom"] = 1,
                                ["Left"] = 1,
                                ["Right"] = 1
                            },
                            ["Edge Size"] = 3,
                            ["Match width"] = true,
                            ["Width"] = 100,
                            ["Match height"] = true,
                            ["Height"] = 100,
                            ["Enabled"] = true
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
    					["Height"] = 50
    				},
                    ["Tags"] = {
                        ["Name"] = {
                            ["Format"] = "[name]",
                            ["Size"] = 10,
                            ["Local Point"] = "TOPLEFT",
                            ["Point"] = "TOPLEFT",
                            ["Relative To"] = "Player",
                            ["Offset X"] = 2,
                            ["Offset Y"] = -2,
                            ["Hide"] = false
                        }
                    },
                    ["Heal Prediction"] = {
                        ["Enabled"] = true,
                        ["Texture"] = "Default",
                        ["Max Overflow"] = 1,
                        ["Colors"] = {
                            ["My Heals"] = { 0, .827, .765, .5 },
                            ["All Heals"] = { 0, .631, .557, .5 },
                            ["Absorb"] = { .7, .7, 1, .5 },
                            ["Heal Absorb"] = { .7, .7, 1, .5 }
                        }
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0, 1 },
                        ["Offset"] = {
                            ["Top"] = 1,
                            ["Bottom"] = 1,
                            ["Left"] = 1,
                            ["Right"] = 1
                        },
                        ["Edge Size"] = 3,
                        ["Match width"] = true,
                        ["Width"] = 100,
                        ["Match height"] = true,
                        ["Height"] = 100,
                        ["Enabled"] = true
                    },
                    ["Alternative Power"] = {
                        ["Enabled"] = true,
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0, 1 },
                            ["Offset"] = {
                                ["Top"] = 1,
                                ["Bottom"] = 1,
                                ["Left"] = 1,
                                ["Right"] = 1
                            },
                            ["Edge Size"] = 3,
                            ["Match width"] = true,
                            ["Width"] = 100,
                            ["Match height"] = true,
                            ["Height"] = 100,
                            ["Enabled"] = true
                        },
                        ["Position"] = {
                            ["Point"] = "TOPLEFT",
                            ["Local Point"] = "TOPLEFT",
                            ["Offset X"] = 300,
                            ["Offset Y"] = -400,
                            ["Relative To"] = "FrameParent"
                        },
                        ["Size"] = {
                            ["Width"] = 200,
                            ["Height"] = 20
                        },
                        ["Texture"] = "Default",
                        ["Background Multiplier"] = 0.3,
                        ["Color"] = { 0.7, 0.5, 0.3, 1 }
                    },
                    ["Runes"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Relative To"] = "Parent",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1, 
                        },
                        ["Size"] = {
                            ["Width"] = 200,
                            ["Height"] = 15
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0, 1 },
                            ["Offset"] = {
                                ["Top"] = 1,
                                ["Bottom"] = 1,
                                ["Left"] = 1,
                                ["Right"] = 1
                            },
                            ["Edge Size"] = 3,
                            ["Enabled"] = true,
                        },
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default",
                        ["X Spacing"] = 1,
                        ["Y Spacing"] = 1,
                        ["Attached"] = true,
                        ["Attached Position"] = "Below",
                    },
                    ["Combo Points"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Relative To"] = "Parent",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1, 
                        },
                        ["Size"] = {
                            ["Width"] = 191,
                            ["Height"] = 15
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0, 1 },
                            ["Offset"] = {
                                ["Top"] = 1,
                                ["Bottom"] = 1,
                                ["Left"] = 1,
                                ["Right"] = 1
                            },
                            ["Edge Size"] = 3,
                            ["Match width"] = true,
                            ["Width"] = 100,
                            ["Match height"] = true,
                            ["Height"] = 100,
                            ["Enabled"] = true
                        },
                        ["Orientation"] = "HORIZONTAL",
                        ["Texture"] = "Default",
                        ["X Spacing"] = 1,
                        ["Y Spacing"] = 1,
                        ["Attached"] = true,
                        ["Attached Position"] = "Below",
                    },
                    ["Soul Shards"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Relative To"] = "Parent",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1, 
                        },
                        ["Size"] = {
                            ["Width"] = 196,
                            ["Height"] = 15
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0, 1 },
                            ["Offset"] = {
                                ["Top"] = 1,
                                ["Bottom"] = 1,
                                ["Left"] = 1,
                                ["Right"] = 1
                            },
                            ["Edge Size"] = 3,
                            ["Match width"] = true,
                            ["Width"] = 100,
                            ["Match height"] = true,
                            ["Height"] = 100,
                            ["Enabled"] = true
                        },
                        ["Orientation"] = "HORIZONTAL",
                        ["Texture"] = "Default",
                        ["X Spacing"] = 1,
                        ["Y Spacing"] = 1,
                        ["Attached"] = true,
                        ["Attached Position"] = "Below",
                    },
                    ["Chi"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Relative To"] = "Parent",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1, 
                        },
                        ["Size"] = {
                            ["Width"] = 196,
                            ["Height"] = 15
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0, 1 },
                            ["Offset"] = {
                                ["Top"] = 1,
                                ["Bottom"] = 1,
                                ["Left"] = 1,
                                ["Right"] = 1
                            },
                            ["Edge Size"] = 3,
                            ["Match width"] = true,
                            ["Width"] = 100,
                            ["Match height"] = true,
                            ["Height"] = 100,
                            ["Enabled"] = true
                        },
                        ["Orientation"] = "HORIZONTAL",
                        ["Texture"] = "Default",
                        ["X Spacing"] = 1,
                        ["Y Spacing"] = 1,
                        ["Attached"] = true,
                        ["Attached Position"] = "Below",
                    },
                    ["Arcane Charges"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Relative To"] = "Parent",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0, 
                        },
                        ["Size"] = {
                            ["Width"] = 150,
                            ["Height"] = 15
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0, 1 },
                            ["Offset"] = {
                                ["Top"] = 1,
                                ["Bottom"] = 1,
                                ["Left"] = 1,
                                ["Right"] = 1
                            },
                            ["Edge Size"] = 3,
                            ["Match width"] = true,
                            ["Width"] = 100,
                            ["Match height"] = true,
                            ["Height"] = 100,
                            ["Enabled"] = true
                        },
                        ["Orientation"] = "HORIZONTAL",
                        ["Texture"] = "Default",
                        ["X Spacing"] = 1,
                        ["Y Spacing"] = 1,
                        ["Attached"] = true,
                        ["Attached Position"] = "Below",
                    },
                    ["Holy Power"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Relative To"] = "Parent",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1, 
                        },
                        ["Size"] = {
                            ["Width"] = 200,
                            ["Height"] = 15
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0, 1 },
                            ["Offset"] = {
                                ["Top"] = 1,
                                ["Bottom"] = 1,
                                ["Left"] = 1,
                                ["Right"] = 1
                            },
                            ["Edge Size"] = 3,
                            ["Match width"] = true,
                            ["Width"] = 100,
                            ["Match height"] = true,
                            ["Height"] = 100,
                            ["Enabled"] = true
                        },
                        ["Orientation"] = "HORIZONTAL",
                        ["Texture"] = "Default",
                        ["X Spacing"] = 1,
                        ["Y Spacing"] = 1,
                        ["Attached"] = true,
                        ["Attached Position"] = "Below"
                    },              
                    ["Castbar"] = {
                        ["Enabled"] = true,
                        ["Missing Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        },
                        ["Texture"] = "Default",
                        ["Position"] = {
                            ["Relative To"] = "FrameParent",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1, 
                        },
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
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
                            ["Font Size"] = 10,
                            ["Format"] = "[current]/[max]"
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
                            ["Font Size"] = 0.7,
                            ["Format"] = "[name]"
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
                                ["Color"] = { 0, 0, 0, 1 },
                                ["Offset"] = {
                                    ["Top"] = 1,
                                    ["Bottom"] = 1,
                                    ["Left"] = 1,
                                    ["Right"] = 1
                                },
                                ["Edge Size"] = 3,
                                ["Match width"] = true,
                                ["Width"] = 100,
                                ["Match height"] = true,
                                ["Height"] = 100,
                                ["Enabled"] = true
                            },
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0, 1 },
                            ["Offset"] = {
                                ["Top"] = 1,
                                ["Bottom"] = 1,
                                ["Left"] = 1,
                                ["Right"] = 1
                            },
                            ["Edge Size"] = 3,
                            ["Match width"] = true,
                            ["Width"] = 100,
                            ["Match height"] = true,
                            ["Height"] = 100,
                            ["Enabled"] = true
                        },
                        ["Attached Position"] = "Below",
                        ["Attached"] = true,
                    },
                    ["Stagger"] = {
                        ["Enabled"] = true,
                        ["Texture"] = "Default",
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Position"] = {
                            ["Relative To"] = "FrameParent",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1, 
                        },
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 150,
                            ["Height"] = 15
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0, 1 },
                            ["Offset"] = {
                                ["Top"] = 1,
                                ["Bottom"] = 1,
                                ["Left"] = 1,
                                ["Right"] = 1
                            },
                            ["Edge Size"] = 3,
                            ["Match width"] = true,
                            ["Width"] = 100,
                            ["Match height"] = true,
                            ["Height"] = 100,
                            ["Enabled"] = true
                        },
                        ["Colors"] = {
                            ["High"] = { .7, 0, 0, 1 },
                            ["Medium"] = { .5, .5, 0, 1 },
                            ["Low"] = { 0, .7, 0, 1}
                        },
                        ["Background Multiplier"] = 0.33,
                        ["Attached Position"] = "Below",
                        ["Place After Chi"] = true,
                        ["Attached"] = true
                    },
                    ["Combat Indicator"] = {
                        ["Enabled"] = true
                    },
    				["Enabled"] = true
    			},
    			["Target"] = {
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
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
                        ["Texture"] = "Default",
                        ["Missing Health Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
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
                        ["Texture"] = "Default",
                        ["Missing Power Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
    				},
                    ["Buffs"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "TOPLEFT",
                            ["Local Point"] = "TOPLEFT",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0,
                            ["Relative To"] = "FrameParent"
                        },
                        ["Style"] = "Bar",
                        ["Bar Growth"] = "Upwards",
                        ["Icon Growth"] = "Right Then Down",
                        ["Offset X"] = 1,
                        ["Offset Y"] = 1,
                        ["Icon Limit Per Row"] = 5,
                        ["Attached"] = true,
                        ["Attached Position"] = "Above",
                        ["Limit"] = 10,
                        ["Hide no duration"] = true,
                        ["Own only"] = true,
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Reversed"] = false,
                        ["Texture"] = "Default",
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 16,
                            ["Height"] = 16
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0, 1 },
                            ["Offset"] = {
                                ["Top"] = 1,
                                ["Bottom"] = 1,
                                ["Left"] = 1,
                                ["Right"] = 1
                            },
                            ["Edge Size"] = 3,
                            ["Match width"] = true,
                            ["Width"] = 100,
                            ["Match height"] = true,
                            ["Height"] = 100,
                            ["Enabled"] = true
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
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Parent"
                        },
                        ["Attached"] = "TOP",
                        ["Style"] = "Bar",
                        ["Growth"] = "Upwards",
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 16,
                            ["Height"] = 16
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0, 1 },
                            ["Offset"] = {
                                ["Top"] = 1,
                                ["Bottom"] = 1,
                                ["Left"] = 1,
                                ["Right"] = 1
                            },
                            ["Edge Size"] = 3,
                            ["Match width"] = true,
                            ["Width"] = 100,
                            ["Match height"] = true,
                            ["Height"] = 100,
                            ["Enabled"] = true
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
    					["Height"] = 50
    				},
					["Tags"] = {},
                    ["Heal Prediction"] = {
                        ["Enabled"] = true,
                        ["Texture"] = "Default",
                        ["Max Overflow"] = 1,
                        ["Colors"] = {
                            ["My Heals"] = { 0, .827, .765, .5 },
                            ["All Heals"] = { 0, .631, .557, .5 },
                            ["Absorb"] = { .7, .7, 1, .5 },
                            ["Heal Absorb"] = { .7, .7, 1, .5 }
                        }
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0, 1 },
                        ["Offset"] = {
                            ["Top"] = 1,
                            ["Bottom"] = 1,
                            ["Left"] = 1,
                            ["Right"] = 1
                        },
                        ["Edge Size"] = 3,
                        ["Match width"] = true,
                        ["Width"] = 100,
                        ["Match height"] = true,
                        ["Height"] = 100,
                        ["Enabled"] = true
                    },
                    ["Castbar"] = {
                        ["Enabled"] = true,
                        ["Missing Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        },
                        ["Texture"] = "Default",
                        ["Position"] = {
                            ["Relative To"] = "Class Icons",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0, 
                        },
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
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
                            ["Font Size"] = 10,
                            ["Format"] = "[current]/[max]"
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
                            ["Font Size"] = 0.7,
                            ["Format"] = "[name]"
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
                                ["Color"] = { 0, 0, 0, 1 },
                                ["Offset"] = {
                                    ["Top"] = 1,
                                    ["Bottom"] = 1,
                                    ["Left"] = 1,
                                    ["Right"] = 1
                                },
                                ["Edge Size"] = 3,
                                ["Match width"] = true,
                                ["Width"] = 100,
                                ["Match height"] = true,
                                ["Height"] = 100,
                                ["Enabled"] = true
                            }
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0, 1 },
                            ["Offset"] = {
                                ["Top"] = 1,
                                ["Bottom"] = 1,
                                ["Left"] = 1,
                                ["Right"] = 1
                            },
                            ["Edge Size"] = 3,
                            ["Match width"] = true,
                            ["Width"] = 100,
                            ["Match height"] = true,
                            ["Height"] = 100,
                            ["Enabled"] = true
                        },
                        ["Attached Position"] = "Below"
                    },
                    ["Enabled"] = true
    			},
                ["Target of Target"] = {
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "CENTER",
                        ["Local Point"] = "CENTER",
                        ["Offset X"] = 400,
                        ["Offset Y"] = 0,
                    },
                    ["Castbar"] = {
                        ["Enabled"] = true,
                        ["Missing Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        },
                        ["Texture"] = "Default",
                        ["Position"] = {
                            ["Relative To"] = "Parent",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0, 
                        },
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
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
                            ["Font Size"] = 10,
                            ["Format"] = "[current]/[max]"
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
                            ["Font Size"] = 0.7,
                            ["Format"] = "[name]"
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
                                ["Color"] = { 0, 0, 0, 1 },
                                ["Offset"] = {
                                    ["Top"] = 1,
                                    ["Bottom"] = 1,
                                    ["Left"] = 1,
                                    ["Right"] = 1
                                },
                                ["Edge Size"] = 3,
                                ["Match width"] = true,
                                ["Width"] = 100,
                                ["Match height"] = true,
                                ["Height"] = 100,
                                ["Enabled"] = true
                            },
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0, 1 },
                            ["Offset"] = {
                                ["Top"] = 1,
                                ["Bottom"] = 1,
                                ["Left"] = 1,
                                ["Right"] = 1
                            },
                            ["Edge Size"] = 3,
                            ["Match width"] = true,
                            ["Width"] = 100,
                            ["Match height"] = true,
                            ["Height"] = 100,
                            ["Enabled"] = true
                        },
                        ["Attached Position"] = "Below",
                    },
                    ["Heal Prediction"] = {
                        ["Enabled"] = true,
                        ["Texture"] = "Default",
                        ["Max Overflow"] = 1,
                        ["Colors"] = {
                            ["My Heals"] = { 0, .827, .765, .5 },
                            ["All Heals"] = { 0, .631, .557, .5 },
                            ["Absorb"] = { .7, .7, 1, .5 },
                            ["Heal Absorb"] = { .7, .7, 1, .5 }
                        }
                    },
                    ["Health"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "TOP",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0,
                            ["Relative To"] = "Target of Target"
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
                        ["Texture"] = "Default",
                        ["Missing Health Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
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
                        ["Texture"] = "Default",
                        ["Missing Power Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
                    },
                    ["Buffs"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "TOPLEFT",
                            ["Local Point"] = "TOPLEFT",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0,
                            ["Relative To"] = "FrameParent"
                        },
                        ["Style"] = "Bar",
                        ["Bar Growth"] = "Upwards",
                        ["Icon Growth"] = "Right Then Down",
                        ["Offset X"] = 1,
                        ["Offset Y"] = 1,
                        ["Icon Limit Per Row"] = 5,
                        ["Attached"] = true,
                        ["Attached Position"] = "Above",
                        ["Limit"] = 10,
                        ["Hide no duration"] = true,
                        ["Own only"] = true,
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Reversed"] = false,
                        ["Texture"] = "Default",
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 16,
                            ["Height"] = 16
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0, 1 },
                            ["Offset"] = {
                                ["Top"] = 1,
                                ["Bottom"] = 1,
                                ["Left"] = 1,
                                ["Right"] = 1
                            },
                            ["Edge Size"] = 3,
                            ["Match width"] = true,
                            ["Width"] = 100,
                            ["Match height"] = true,
                            ["Height"] = 100,
                            ["Enabled"] = true
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
                        ["Height"] = 26
                    },
                    ["Tags"] = {},
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0, 1 },
                        ["Offset"] = {
                            ["Top"] = 1,
                            ["Bottom"] = 1,
                            ["Left"] = 1,
                            ["Right"] = 1
                        },
                        ["Edge Size"] = 3,
                        ["Match width"] = true,
                        ["Width"] = 100,
                        ["Match height"] = true,
                        ["Height"] = 100,
                        ["Enabled"] = true
                    },
                    ["Enabled"] = true
                },
                ["Party"] = {
                    ["Clickcast"] = {
                        ["Enabled"] = true,
                        ["Actions"] = {}
                    },
                    ["Status"] = {
                        ["Out of range"] = {
                            ["Action"] = "Modify",
                            ["Settings"] = {
                                ["Present Type"] = "None",
                                ["Modify Type"] = "Alpha",
                                ["Alpha Value"] = 50,
                                ["Color"] = { 1, 1, 1, 1 },
                                ["Icon Size"] = 16,
                                ["Font Size"] = 10,
                                ["Position"] = {
                                    ["Point"] = "TOPLEFT",
                                    ["Local Point"] = "TOPLEFT",
                                    ["Offset X"] = 2,
                                    ["Offset Y"] = -2,
                                },
                            }
                        },
                        ["Dead"] = {
                            ["Action"] = "Present",
                            ["Settings"] = {
                                ["Present Type"] = "Text",
                                ["Modify Type"] = "None",
                                ["Alpha Value"] = 100,
                                ["Color"] = { 0.7, 0, 0, 1 },
                                ["Icon Size"] = 16,
                                ["Font Size"] = 10,
                                ["Position"] = {
                                    ["Point"] = "TOPLEFT",
                                    ["Local Point"] = "TOPLEFT",
                                    ["Offset X"] = 2,
                                    ["Offset Y"] = -2,
                                },
                            }
                        },
                        ["Offline"] = {
                            ["Action"] = "Present",
                            ["Settings"] = {
                                ["Present Type"] = "Text",
                                ["Modify Type"] = "None",
                                ["Alpha Value"] = 100,
                                ["Color"] = { 0.7, 0, 0, 1 },
                                ["Icon Size"] = 16,
                                ["Font Size"] = 10,
                                ["Position"] = {
                                    ["Point"] = "TOPLEFT",
                                    ["Local Point"] = "TOPLEFT",
                                    ["Offset X"] = 2,
                                    ["Offset Y"] = -2,
                                },
                            }
                        },
                        ["Ghost"] = {
                            ["Action"] = "Present",
                            ["Settings"] = {
                                ["Present Type"] = "Text",
                                ["Modify Type"] = "None",
                                ["Alpha Value"] = 100,
                                ["Color"] = { 1, 0.8, 0, 1 },
                                ["Icon Size"] = 16,
                                ["Font Size"] = 10,
                                ["Position"] = {
                                    ["Point"] = "TOPLEFT",
                                    ["Local Point"] = "TOPLEFT",
                                    ["Offset X"] = 2,
                                    ["Offset Y"] = -2,
                                },
                            }
                        }
                    },
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
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
                        ["Texture"] = "Default",
                        ["Missing Health Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        },
                        ["Frequent Updates"] = true
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
                        ["Texture"] = "Default",
                        ["Missing Power Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
                    },
                    ["Size"] = {
                        ["Width"] = 63,
                        ["Height"] = 47
                    },
                    ["Orientation"] = "HORIZONTAL",
                    ["Growth Direction"] = "Right",
                    ["Tags"] = {
                        ["Name"] = {
                            ["Format"] = "[name:4]",
                            ["Size"] = 10,
                            ["Local Point"] = "BOTTOMLEFT",
                            ["Point"] = "BOTTOMLEFT",
                            ["Relative To"] = "Parent",
                            ["Offset X"] = 2,
                            ["Offset Y"] = 2,
                            ["Hide"] = false
                        }
                    },
                    ["Raid Buffs"] = {
                        ["Limit"] = 40,
                        ["Tracked"] = {
                        },
						["Important"] = true,
                        ["Enabled"] = true
                    },
                    ["Heal Prediction"] = {
                        ["Enabled"] = true,
                        ["Texture"] = "Default",
                        ["Max Overflow"] = 1,
                        ["Colors"] = {
                            ["My Heals"] = { 0, .827, .765, .5 },
                            ["All Heals"] = { 0, .631, .557, .5 },
                            ["Absorb"] = { .7, .7, 1, .5 },
                            ["Heal Absorb"] = { .7, .7, 1, .5 }
                        }
                    },
                    ["Offset X"] = 2,
                    ["Offset Y"] = 0,
                    ["Show Player"] = true,
                    ["Highlight Target"] = true,
                    ["Show Debuff Border"] = true,
                    ["Debuff Order"] = { "Magic", "Disease", "Curse", "Poison" },
                    ["Visibility"] = "[@party1,exists] show; hide",
                    ["Group By"] = "Role",
                    ["Sort Alphabetically"] = true,
                    ["Sorting Direction"] = "ASC",
                    ["Group Role Indicator"] = {
                        ["Position"] = {
                            ["Point"] = "TOPLEFT",
                            ["Local Point"] = "TOPLEFT",
                            ["Offset X"] = 2,
                            ["Offset Y"] = -2,
                            ["Relative To"] = "Parent"    
                        },
                        ["Size"] = 20,
                        ["Style"] = "Letter",
                        ["Text Size"] = 10,
                        ["Text Color"] = { 1, 1, 1, 1 },
                        ["Text Style"] = "Outline",
                        ["Texture"] = nil,
                        ["Enabled"] = true
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0, 1 },
                        ["Offset"] = {
                            ["Top"] = 1,
                            ["Bottom"] = 1,
                            ["Left"] = 1,
                            ["Right"] = 1
                        },
                        ["Edge Size"] = 3,
                        ["Match width"] = true,
                        ["Width"] = 100,
                        ["Match height"] = true,
                        ["Height"] = 100,
                        ["Enabled"] = true
                    },
                    ["Enabled"] = true
                },
                ["Raid"] = {
                    ["Clickcast"] = {
                        ["Enabled"] = true,
                        ["Actions"] = {}
                    },
                    ["Visibility"] = "[@raid1,exists] show; hide",
                    ["Group By"] = "Role",
                    ["Sort Alphabetically"] = true,
                    ["Sorting Direction"] = "ASC",
                    ["Max Columns"] = 5,
                    ["Status"] = {
                        ["Out of range"] = {
                            ["Action"] = "Modify",
                            ["Settings"] = {
                                ["Present Type"] = "None",
                                ["Modify Type"] = "Alpha",
                                ["Alpha Value"] = 50,
                                ["Color"] = { 1, 1, 1, 1 },
                                ["Icon Size"] = 16,
                                ["Font Size"] = 10,
                                ["Position"] = {
                                    ["Point"] = "TOPLEFT",
                                    ["Local Point"] = "TOPLEFT",
                                    ["Offset X"] = 2,
                                    ["Offset Y"] = -2,
                                },
                            }
                        },
                        ["Dead"] = {
                            ["Action"] = "Present",
                            ["Settings"] = {
                                ["Present Type"] = "Text",
                                ["Modify Type"] = "None",
                                ["Alpha Value"] = 100,
                                ["Color"] = { 0.7, 0, 0, 1 },
                                ["Icon Size"] = 16,
                                ["Font Size"] = 10,
                                ["Position"] = {
                                    ["Point"] = "TOPLEFT",
                                    ["Local Point"] = "TOPLEFT",
                                    ["Offset X"] = 2,
                                    ["Offset Y"] = -2,
                                },
                            }
                        },
                        ["Offline"] = {
                            ["Action"] = "Present",
                            ["Settings"] = {
                                ["Present Type"] = "Text",
                                ["Modify Type"] = "None",
                                ["Alpha Value"] = 100,
                                ["Color"] = { 0.7, 0, 0, 1 },
                                ["Icon Size"] = 16,
                                ["Font Size"] = 10,
                                ["Position"] = {
                                    ["Point"] = "TOPLEFT",
                                    ["Local Point"] = "TOPLEFT",
                                    ["Offset X"] = 2,
                                    ["Offset Y"] = -2,
                                },
                            }
                        },
                        ["Ghost"] = {
                            ["Action"] = "Present",
                            ["Settings"] = {
                                ["Present Type"] = "Text",
                                ["Modify Type"] = "None",
                                ["Alpha Value"] = 100,
                                ["Color"] = { 1, 0.8, 0, 1 },
                                ["Icon Size"] = 16,
                                ["Font Size"] = 10,
                                ["Position"] = {
                                    ["Point"] = "TOPLEFT",
                                    ["Local Point"] = "TOPLEFT",
                                    ["Offset X"] = 2,
                                    ["Offset Y"] = -2,
                                },
                            }
                        }
                    },
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
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
                        ["Texture"] = "Default",
                        ["Missing Health Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        },
                        ["Frequent Updates"] = true
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
                        ["Texture"] = "Default",
                        ["Missing Power Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
                    },
                    ["Size"] = {
                        ["Width"] = 63,
                        ["Height"] = 47
                    },
                    ["Growth Direction"] = "Right Then Down",
                    ["Tags"] = {},
                    ["Raid Buffs"] = {
                        ["Tracked"] = {},
                        ["Important"] = true,
                        ["Enabled"] = true
                    },
                    ["Heal Prediction"] = {
                        ["Enabled"] = true,
                        ["Texture"] = "Default",
                        ["Max Overflow"] = 1,
                        ["Colors"] = {
                            ["My Heals"] = { 0, .827, .765, .5 },
                            ["All Heals"] = { 0, .631, .557, .5 },
                            ["Absorb"] = { .7, .7, 1, .5 },
                            ["Heal Absorb"] = { .7, .7, 1, .5 }
                        }
                    },
                    ["Offset X"] = 2,
                    ["Offset Y"] = 2,
                    ["Show Player"] = true,
                    ["Highlight Target"] = true,
                    ["Show Debuff Border"] = true,
                    ["Debuff Order"] = { "Magic", "Disease", "Curse", "Poison" },
                    ["Group Role Indicator"] = {
                        ["Position"] = {
                            ["Point"] = "TOPLEFT",
                            ["Local Point"] = "TOPLEFT",
                            ["Offset X"] = 2,
                            ["Offset Y"] = -2,
                            ["Relative To"] = "Parent"    
                        },
                        ["Size"] = 20,
                        ["Style"] = "Letter",
                        ["Text Size"] = 10,
                        ["Text Color"] = { 1, 1, 1, 1 },
                        ["Text Style"] = "Outline",
                        ["Texture"] = nil,
                        ["Enabled"] = true
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0, 1 },
                        ["Offset"] = {
                            ["Top"] = 1,
                            ["Bottom"] = 1,
                            ["Left"] = 1,
                            ["Right"] = 1
                        },
                        ["Edge Size"] = 3,
                        ["Match width"] = true,
                        ["Width"] = 100,
                        ["Match height"] = true,
                        ["Height"] = 100,
                        ["Enabled"] = true
                    },
                    ["Enabled"] = true
                },
                ["Pet"] = {
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "CENTER",
                        ["Local Point"] = "CENTER",
                        ["Offset X"] = -465.640625,
                        ["Offset Y"] = -500.187973022461,
                    },
                    ["Health"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "TOP",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0,
                            ["Relative To"] = "Pet"
                        },
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 150,
                            ["Height"] = 15
                        },
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default",
                        ["Missing Health Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
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
                            ["Height"] = 5
                        },
                        ["Color By"] = "Power",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default",
                        ["Missing Power Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
                    },
                    ["Buffs"] = {
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "TOPLEFT",
                            ["Local Point"] = "TOPLEFT",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0,
                            ["Relative To"] = "FrameParent"
                        },
                        ["Style"] = "Bar",
                        ["Bar Growth"] = "Upwards",
                        ["Icon Growth"] = "Right Then Down",
                        ["Offset X"] = 1,
                        ["Offset Y"] = 1,
                        ["Icon Limit Per Row"] = 5,
                        ["Attached"] = true,
                        ["Attached Position"] = "Above",
                        ["Limit"] = 10,
                        ["Hide no duration"] = true,
                        ["Own only"] = true,
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Reversed"] = false,
                        ["Texture"] = "Default",
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 16,
                            ["Height"] = 16
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0, 1 },
                            ["Offset"] = {
                                ["Top"] = 1,
                                ["Bottom"] = 1,
                                ["Left"] = 1,
                                ["Right"] = 1
                            },
                            ["Edge Size"] = 3,
                            ["Match width"] = true,
                            ["Width"] = 100,
                            ["Match height"] = true,
                            ["Height"] = 100,
                            ["Enabled"] = true
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
                        ["Enabled"] = true,
                        ["Position"] = {
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1,
                            ["Relative To"] = "Parent"
                        },
                        ["Attached"] = "TOP",
                        ["Style"] = "Bar",
                        ["Growth"] = "Upwards",
                        ["Size"] = {
                            ["Match width"] = true,
                            ["Match height"] = false,
                            ["Width"] = 16,
                            ["Height"] = 16
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0, 1 },
                            ["Offset"] = {
                                ["Top"] = 1,
                                ["Bottom"] = 1,
                                ["Left"] = 1,
                                ["Right"] = 1
                            },
                            ["Edge Size"] = 3,
                            ["Match width"] = true,
                            ["Width"] = 100,
                            ["Match height"] = true,
                            ["Height"] = 100,
                            ["Enabled"] = true
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
                        ["Height"] = 21
                    },
                    ["Tags"] = {},
                    ["Heal Prediction"] = {
                        ["Enabled"] = true,
                        ["Texture"] = "Default",
                        ["Max Overflow"] = 1,
                        ["Colors"] = {
                            ["My Heals"] = { 0, .827, .765, .5 },
                            ["All Heals"] = { 0, .631, .557, .5 },
                            ["Absorb"] = { .7, .7, 1, .5 },
                            ["Heal Absorb"] = { .7, .7, 1, .5 }
                        }
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0, 1 },
                        ["Offset"] = {
                            ["Top"] = 1,
                            ["Bottom"] = 1,
                            ["Left"] = 1,
                            ["Right"] = 1
                        },
                        ["Edge Size"] = 3,
                        ["Match width"] = true,
                        ["Width"] = 100,
                        ["Match height"] = true,
                        ["Height"] = 100,
                        ["Enabled"] = true
                    },
                    ["Castbar"] = {
                        ["Enabled"] = true,
                        ["Missing Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        },
                        ["Texture"] = "Default",
                        ["Position"] = {
                            ["Relative To"] = "Class Icons",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = -1, 
                        },
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
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
                            ["Font Size"] = 10,
                            ["Format"] = "[current]/[max]"
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
                            ["Font Size"] = 0.7,
                            ["Format"] = "[name]"
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
                                ["Color"] = { 0, 0, 0, 1 },
                                ["Offset"] = {
                                    ["Top"] = 1,
                                    ["Bottom"] = 1,
                                    ["Left"] = 1,
                                    ["Right"] = 1
                                },
                                ["Edge Size"] = 3,
                                ["Match width"] = true,
                                ["Width"] = 100,
                                ["Match height"] = true,
                                ["Height"] = 100,
                                ["Enabled"] = true
                            },
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0, 1 },
                            ["Offset"] = {
                                ["Top"] = 1,
                                ["Bottom"] = 1,
                                ["Left"] = 1,
                                ["Right"] = 1
                            },
                            ["Edge Size"] = 3,
                            ["Match width"] = true,
                            ["Width"] = 100,
                            ["Match height"] = true,
                            ["Height"] = 100,
                            ["Enabled"] = true
                        },
                        ["Attached Position"] = "Below"
                    },
                    ["Enabled"] = true
                },
                ["Boss"] = {
                    ["Clickcast"] = {},
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "TOPRIGHT",
                        ["Local Point"] = "TOPRIGHT",
                        ["Offset X"] = -250,
                        ["Offset Y"] = -200
                    },
                    ["Size"] = {
                        ["Width"] = 150,
                        ["Height"] = 50
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
                            ["Width"] = 150,
                            ["Height"] = 35
                        },
                        ["Color By"] = "Gradient",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
                        ["Texture"] = "Default",
                        ["Missing Health Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
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
                        ["Texture"] = "Default",
                        ["Missing Power Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        }
                    },
                    ["Orientation"] = "VERTICAL",
                    ["Tags"] = {},
                    ["Offset X"] = 2,
                    ["Offset Y"] = 0,
                    ["Highlight Target"] = true,
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0, 1 },
                        ["Offset"] = {
                            ["Top"] = 1,
                            ["Bottom"] = 1,
                            ["Left"] = 1,
                            ["Right"] = 1
                        },
                        ["Edge Size"] = 3,
                        ["Enabled"] = true,
                    },
                    ["Castbar"] = {
                        ["Enabled"] = true,
                        ["Missing Bar"] = {
                            ["Enabled"] = false,
                            ["Custom Color"] = {
                                0.5, -- [1]
                                0.5, -- [2]
                                0.5, -- [3]
                                1, -- [4]
                            },
                            ["Color By"] = "Custom",
                        },
                        ["Texture"] = "Default",
                        ["Position"] = {
                            ["Relative To"] = "Class Icons",
                            ["Point"] = "BOTTOM",
                            ["Local Point"] = "TOP",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0, 
                        },
                        ["Color By"] = "Class",
                        ["Custom Color"] = { 1, 1, 1 },
                        ["Background Multiplier"] = 0.33,
                        ["Orientation"] = "HORIZONTAL",
                        ["Reversed"] = false,
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
                            ["Font Size"] = 10,
                            ["Format"] = "[current]/[max]"
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
                            ["Font Size"] = 0.7,
                            ["Format"] = "[name]"
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
                                ["Color"] = { 0, 0, 0, 1 },
                                ["Offset"] = {
                                    ["Top"] = 1,
                                    ["Bottom"] = 1,
                                    ["Left"] = 1,
                                    ["Right"] = 1
                                },
                                ["Edge Size"] = 3,
                                ["Enabled"] = true
                            }
                        },
                        ["Background"] = {
                            ["Color"] = { 0, 0, 0, 1 },
                            ["Offset"] = {
                                ["Top"] = 1,
                                ["Bottom"] = 1,
                                ["Left"] = 1,
                                ["Right"] = 1
                            },
                            ["Edge Size"] = 3,
                            ["Match width"] = true,
                            ["Width"] = 100,
                            ["Match height"] = true,
                            ["Height"] = 100,
                            ["Enabled"] = true
                        },
                        ["Attached Position"] = "Below"
                    },
                    ["Enabled"] = true
                },
    			["Minimap"] = {
    				["Size"] = 200,
    				["Position"] = {
    					["Point"] = "TOPRIGHT",
    					["Local Point"] = "TOPRIGHT",
    					["Offset X"] = 0,
    					["Offset Y"] = 0,
    					["Relative To"] = "FrameParent"
    				}
    			},
                ["Vehicle Seat Indicator"] = {
                    ["Position"] = {
                        ["Point"] = "TOPLEFT",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = 100,
                        ["Offset Y"] = -100,
                        ["Relative To"] = "FrameParent"
                    }
                },
                ["Objective Tracker"] = {
                    ["Position"] = {
                        ["Point"] = "TOPRIGHT",
                        ["Local Point"] = "TOPRIGHT",
                        ["Offset X"] = -10,
                        ["Offset Y"] = -300,
                        ["Relative To"] = "FrameParent"
                    },
                    ["Size"] = {
                        ["Width"] = 250,
                        ["Height"] = 800
                    }
                },
                ["Cooldown bar"] = {
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
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
                        ["Relative To"] = "FrameParent",
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
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "CENTER",
                        ["Local Point"] = "CENTER",
                        ["Offset X"] = 3.4875648021698,
                        ["Offset Y"] = -158.936065673828,
                    },
                    ["Presets"] = {}
                },
                ["Talking Head Frame"] = {
                     ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "TOPLEFT",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = 10,
                        ["Offset Y"] = -10,
                    }
                },
                ["Actionbars"] = {
                   ["Enabled"] = true,
                   ["Show Grid"] = true,
                   ["Bars"] = {
                        ["Bar1"] = {
                            ["Position"] = {
                                ["Point"] = "BOTTOM",
                                ["Local Point"] = "BOTTOM",
                                ["Offset X"] = 0,
                                ["Offset Y"] = 0
                            },
                            ["Orientation"] = "HORIZONTAL",
                            ["X Spacing"] = 0,
                            ["Y Spacing"] = 0,
                            ["Limit"] = 12,
                            ["Size"] = 24,
                        },
                        ["Bar2"] = {
                            ["Position"] = {
                                ["Point"] = "BOTTOM",
                                ["Local Point"] = "BOTTOM",
                                ["Offset X"] = 0,
                                ["Offset Y"] = 16
                            },
                            ["Orientation"] = "HORIZONTAL",
                            ["X Spacing"] = 0,
                            ["Y Spacing"] = 0,
                            ["Limit"] = 12,
                            ["Size"] = 24,
                        },
                        ["Bar3"] = {
                            ["Position"] = {
                                ["Point"] = "BOTTOM",
                                ["Local Point"] = "BOTTOM",
                                ["Offset X"] = 0,
                                ["Offset Y"] = 32
                            },
                            ["Orientation"] = "HORIZONTAL",
                            ["X Spacing"] = 0,
                            ["Y Spacing"] = 0,
                            ["Limit"] = 12,
                            ["Size"] = 24,
                        },
                        ["Bar4"] = {
                            ["Position"] = {
                                ["Point"] = "BOTTOM",
                                ["Local Point"] = "BOTTOM",
                                ["Offset X"] = 0,
                                ["Offset Y"] = 48
                            },
                            ["Orientation"] = "HORIZONTAL",
                            ["X Spacing"] = 0,
                            ["Y Spacing"] = 0,
                            ["Limit"] = 12,
                            ["Size"] = 24,
                        },
                        ["Bar5"] = {
                            ["Position"] = {
                                ["Point"] = "BOTTOM",
                                ["Local Point"] = "BOTTOM",
                                ["Offset X"] = 0,
                                ["Offset Y"] = 64
                            },
                            ["Orientation"] = "HORIZONTAL",
                            ["X Spacing"] = 0,
                            ["Y Spacing"] = 0,
                            ["Limit"] = 12,
                            ["Size"] = 24,
                        }
                    }
                },
                ["Micro Bar"] = {
                    ["Enabled"] = true,
                    ["Position"] = {
                        ["Point"] = "BOTTOMRIGHT",
                        ["Local Point"] = "BOTTOMRIGHT",
                        ["Offset X"] = -200,
                        ["Offset Y"] = 0,
                    }
                },
                ["Bag Bar"] = {
                    ["Enabled"] = true,
                    ["Position"] = {
                        ["Point"] = "BOTTOMRIGHT",
                        ["Local Point"] = "BOTTOMRIGHT",
                        ["Offset X"] = 0,
                        ["Offset Y"] = 0,
                    }
                },
                ["Override Bar"] = {
                    ["Enabled"] = true,
                    ["Position"] = {
                        ["Point"] = "TOPLEFT",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = 0,
                        ["Offset Y"] = 0,
                    }
                },
                ["Stance Bar"] = {
                    ["Enabled"] = true,
                    ["Position"] = {
                        ["Point"] = "TOPLEFT",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = 0,
                        ["Offset Y"] = 0,
                    }
                },
                ["Pet Bar"] = {
                    ["Enabled"] = true,
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "TOPLEFT",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = 850,
                        ["Offset Y"] = -50,
                    },
                    ["Icon Size"] = 24,
                    ["Vertical Limit"] = 12,
                    ["Horizontal Limit"] = 1,
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0, 1 },
                        ["Offset"] = {
                            ["Top"] = 1,
                            ["Bottom"] = 1,
                            ["Left"] = 1,
                            ["Right"] = 1
                        },
                        ["Edge Size"] = 3,
                        ["Match width"] = true,
                        ["Width"] = 100,
                        ["Match height"] = true,
                        ["Height"] = 100,
                        ["Enabled"] = true
                    },
                },
                ["Experience Bar"] = {
                    ["Enabled"] = true,
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "TOPLEFT",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = 500,
                        ["Offset Y"] = -50,
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0, 1 },
                        ["Offset"] = {
                            ["Top"] = 1,
                            ["Bottom"] = 1,
                            ["Left"] = 1,
                            ["Right"] = 1
                        },
                        ["Edge Size"] = 3,
                        ["Match width"] = true,
                        ["Width"] = 100,
                        ["Match height"] = true,
                        ["Height"] = 100,
                        ["Enabled"] = true
                    },
                    ["Size"] = {
                        ["Width"] = 250,
                        ["Height"] = 25
                    },
                    ["Background Multiplier"] = 0.33,
                    ["Orientation"] = "HORIZONTAL",
                    ["Reversed"] = false,
                    ["Texture"] = "Default",
                    ["Color"] = { 0.8, 0, 0.4 }
                },
                ["Reputation Bar"] = {
                    ["Enabled"] = true,
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "TOPLEFT",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = 500,
                        ["Offset Y"] = -250,
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0, 1 },
                        ["Offset"] = {
                            ["Top"] = 1,
                            ["Bottom"] = 1,
                            ["Left"] = 1,
                            ["Right"] = 1
                        },
                        ["Edge Size"] = 3,
                        ["Enabled"] = true,
                    },
                    ["Size"] = {
                        ["Width"] = 500,
                        ["Height"] = 25
                    },
                    ["Background Multiplier"] = 0.33,
                    ["Orientation"] = "HORIZONTAL",
                    ["Reversed"] = false,
                    ["Texture"] = "Default"
                },
                ["Artifact Power Bar"] = {
                    ["Enabled"] = true,
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "TOPLEFT",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = 500,
                        ["Offset Y"] = -50,
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0, 1 },
                        ["Offset"] = {
                            ["Top"] = 1,
                            ["Bottom"] = 1,
                            ["Left"] = 1,
                            ["Right"] = 1
                        },
                        ["Edge Size"] = 3,
                        ["Match width"] = true,
                        ["Width"] = 100,
                        ["Match height"] = true,
                        ["Height"] = 100,
                        ["Enabled"] = true
                    },
                    ["Size"] = {
                        ["Width"] = 500,
                        ["Height"] = 25
                    },
                    ["Background Multiplier"] = 0.33,
                    ["Orientation"] = "HORIZONTAL",
                    ["Reversed"] = false,
                    ["Texture"] = "Default",
                    ["Color"] = { 0.90196, 0.8, 0.50196 }
                },
                ["Vehicle Leave Button"] = {
                    ["Enabled"] = true,
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "TOPLEFT",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = 1200,
                        ["Offset Y"] = -500,
                    },
                    ["Background"] = {
                        ["Color"] = { 0, 0, 0, 1 },
                        ["Offset"] = {
                            ["Top"] = 1,
                            ["Bottom"] = 1,
                            ["Left"] = 1,
                            ["Right"] = 1
                        },
                        ["Edge Size"] = 3,
                        ["Match width"] = true,
                        ["Width"] = 100,
                        ["Match height"] = true,
                        ["Height"] = 100,
                        ["Enabled"] = true
                    },
                    ["Size"] = 48,
                },
                ["Character Info"] = {
                    ["Enabled"] = true,
                    ["Position"] = {
                        ["Relative To"] = "FrameParent",
                        ["Point"] = "TOPLEFT",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = 100,
                        ["Offset Y"] = -500,
                    },
                }
    		}
	    }
	},
	["Characters"] = {},
    global = {
        customLayouts = {}
    }
}

A.defaults = defaults