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
        ["Aiwen"] = {
            ["Options"] = {
                ["Party"] = {
                    ["Clickcast"] = {
                        { type = "*type1", action = "macro" },
                        { type = "*macrotext1", action = "/cast [@unit,help,nodead] Plea; [@unit,help,dead] Resurrection" },
                        { type = "shift-macrotext1", action = "/cast [@unit,help,nodead] Shadow Mend" },
                        { type = "ctrl-macrotext1", action = "/cast [@unit,help,nodead] Pain Suppression" },
                        { type = "ctrl-shift-type1", action = "target" },
                        { type = "*type2", action = "macro" },
                        { type = "*macrotext2", action = "/cast [@unit,help,nodead] Power Word: Shield" },
                        { type = "shift-macrotext2", action = "/cast [@unit,help,nodead] Power Word: Radiance" },
                        { type = "ctrl-shift-type2", action = "togglemenu" },
                        { type = "*type3", action = "macro" },
                        { type = "*macrotext3", action = "/cast [@unit,help,nodead] Purify" },
                        { type = "shift-macrotext3", action = "/cast [@unit,help,nodead] Leap of Faith" }
                    },
                    ["RaidBuffs"] = {
                        ["Limit"] = 40,
                        ["Tracked"] = {
                            [194384] = {
                                ["Own Only"] = true,
                                ["Position"] = {
                                    ["Point"] = "TOPRIGHT",
                                    ["Local Point"] = "TOPRIGHT",
                                    ["Offset X"] = 0,
                                    ["Offset Y"] = 0,
                                    ["Relative To"] = "Parent"
                                },
                                ["Hide Countdown Numbers"] = false,
                                ["Cooldown Numbers Text Size"] = 9,
                                ["Size"] = 14
                            },
                            [17] = {
                                ["Own Only"] = true,
                                ["Position"] = {
                                    ["Point"] = "TOPLEFT",
                                    ["Local Point"] = "TOPLEFT",
                                    ["Offset X"] = 0,
                                    ["Offset Y"] = 0,
                                    ["Relative To"] = "Parent"
                                },
                                ["Hide Countdown Numbers"] = false,
                                ["Cooldown Numbers Text Size"] = 9,
                                ["Size"] = 14
                            }
                        },
                        ["Important"] = true,
                        ["Enabled"] = true
                    }
                },
                ["Raid"] = {
                    ["Clickcast"] = {
                        { type = "*type1", action = "macro" },
                        { type = "*macrotext1", action = "/cast [@unit,help,nodead] Plea; [@unit,help,dead] Resurrection" },
                        { type = "shift-macrotext1", action = "/cast [@unit,help,nodead] Shadow Mend" },
                        { type = "ctrl-macrotext1", action = "/cast [@unit,help,nodead] Pain Suppression" },
                        { type = "ctrl-shift-type1", action = "target" },
                        { type = "*type2", action = "macro" },
                        { type = "*macrotext2", action = "/cast [@unit,help,nodead] Power Word: Shield" },
                        { type = "shift-macrotext2", action = "/cast [@unit,help,nodead] Power Word: Radiance" },
                        { type = "ctrl-shift-type2", action = "togglemenu" },
                        { type = "*type3", action = "macro" },
                        { type = "*macrotext3", action = "/cast [@unit,help,nodead] Purify" },
                        { type = "shift-macrotext3", action = "/cast [@unit,help,nodead] Leap of Faith" }
                    },
                    ["RaidBuffs"] = {
                        ["Limit"] = 40,
                        ["Tracked"] = {
                            [194384] = {
                                ["Own Only"] = true,
                                ["Position"] = {
                                    ["Point"] = "TOPRIGHT",
                                    ["Local Point"] = "TOPRIGHT",
                                    ["Offset X"] = 0,
                                    ["Offset Y"] = 0,
                                    ["Relative To"] = "Parent"
                                },
                                ["Hide Countdown Numbers"] = false,
                                ["Cooldown Numbers Text Size"] = 9,
                                ["Size"] = 14
                            },
                            [17] = {
                                ["Own Only"] = true,
                                ["Position"] = {
                                    ["Point"] = "TOPLEFT",
                                    ["Local Point"] = "TOPLEFT",
                                    ["Offset X"] = 0,
                                    ["Offset Y"] = 0,
                                    ["Relative To"] = "Parent"
                                },
                                ["Hide Countdown Numbers"] = false,
                                ["Cooldown Numbers Text Size"] = 9,
                                ["Size"] = 14
                            }
                        },
                        ["Important"] = true,
                        ["Enabled"] = true
                    }
                }
            }
        },
        ["Seife"] = {
            ["Options"] = {
                ["Key Bindings"] = {
                    ["1"] = "ActionBar1Button1",
                    ["2"] = "ActionBar1Button2",
                    ["3"] = "ActionBar1Button3",
                    ["4"] = "ActionBar1Button4",
                    ["5"] = "ActionBar1Button5",
                    ["SHIFT-DOWN"] = "ActionBar1Button7",
                    ["SHIFT-UP"] = "ActionBar1Button8",
                    ["CTRL-DOWN"] = "ActionBar1Button9",
                    ["CTRL-UP"] = "ActionBar1Button10",
                    ["ALT-DOWN"] = "ActionBar1Button11",
                    ["ALT-UP"] = "ActionBar1Button12",
                    ["SHIFT-1"] = "ActionBar2Button1",
                    ["SHIFT-2"] = "ActionBar2Button2",
                    ["SHIFT-3"] = "ActionBar2Button3",
                    ["SHIFT-4"] = "ActionBar2Button4",
                },
                ["Party"] = {
                    ["Clickcast"] = {
                        { type = "*type1", action = "macro" },
                        { type = "*macrotext1", action = "/cast [@unit,help,nodead] Effuse; [@unit,help,dead] Resuscitate" },
                        { type = "shift-macrotext1", action = "/cast [@unit,help,nodead] Enveloping Mist" },
                        { type = "ctrl-macrotext1", action = "/cast [@unit,help,nodead] Life Cocoon" },
                        { type = "ctrl-shift-type1", action = "target" },
                        { type = "*type2", action = "macro" },
                        { type = "*macrotext2", action = "/cast [@unit,help,nodead] Renewing Mist" },
                        { type = "shift-macrotext2", action = "/cast [@unit,help,nodead] Vivify" },
                        { type = "ctrl-shift-type2", action = "togglemenu" },
                        { type = "*type3", action = "macro" },
                        { type = "*macrotext3", action = "/cast [@unit,help,nodead] Detox" },
                        { type = "shift-macrotext3", action = "/cast [@unit,help,nodead] Sheilun's Gift" }
                    },
                    ["RaidBuffs"] = {
                        ["Tracked"] = {
                            [119611] = {
                                ["Own Only"] = true,
                                ["Position"] = {
                                    ["Point"] = "TOPRIGHT",
                                    ["Local Point"] = "TOPRIGHT",
                                    ["Offset X"] = 0,
                                    ["Offset Y"] = 0,
                                    ["Relative To"] = "Parent"
                                },
                                ["Hide Countdown Numbers"] = false,
                                ["Cooldown Numbers Text Size"] = 9,
                                ["Size"] = 16
                            },
                            [116849] = {
                                ["Own Only"] = true,
                                ["Position"] = {
                                    ["Point"] = "TOP",
                                    ["Local Point"] = "TOP",
                                    ["Offset X"] = 0,
                                    ["Offset Y"] = -5,
                                    ["Relative To"] = "Parent"
                                },
                                ["Hide Countdown Numbers"] = true,
                                ["Cooldown Numbers Text Size"] = 9,
                                ["Size"] = 16
                            },
                            [191840] = {
                                ["Own Only"] = true,
                                ["Position"] = {
                                    ["Point"] = "LEFT",
                                    ["Local Point"] = "LEFT",
                                    ["Offset X"] = 0,
                                    ["Offset Y"] = 0,
                                    ["Relative To"] = "Parent"
                                },
                                ["Hide Countdown Numbers"] = false,
                                ["Cooldown Numbers Text Size"] = 9,
                                ["Size"] = 14
                            }
                        }
                    }
                },
                ["Raid"] = {
                    ["Clickcast"] = {
                        { type = "*type1", action = "macro" },
                        { type = "*macrotext1", action = "/cast [@unit,help,nodead] Effuse; [@unit,help,dead] Resuscitate" },
                        { type = "shift-macrotext1", action = "/cast [@unit,help,nodead] Enveloping Mist" },
                        { type = "ctrl-macrotext1", action = "/cast [@unit,help,nodead] Life Cocoon" },
                        { type = "ctrl-shift-type1", action = "target" },
                        { type = "*type2", action = "macro" },
                        { type = "*macrotext2", action = "/cast [@unit,help,nodead] Renewing Mist" },
                        { type = "shift-macrotext2", action = "/cast [@unit,help,nodead] Vivify" },
                        { type = "ctrl-macrotext2", action = "/cast [@unit,help,nodead] Tiger's Lust" },
                        { type = "ctrl-shift-type2", action = "togglemenu" },
                        { type = "*type3", action = "macro" },
                        { type = "*macrotext3", action = "/cast [@unit,help,nodead] Detox" },
                        { type = "shift-macrotext3", action = "/cast [@unit,help,nodead] Sheilun's Gift" }
                    },
                    ["RaidBuffs"] = {
                        ["Tracked"] = {
                            [119611] = {
                                ["Own Only"] = true,
                                ["Position"] = {
                                    ["Point"] = "TOPRIGHT",
                                    ["Local Point"] = "TOPRIGHT",
                                    ["Offset X"] = 0,
                                    ["Offset Y"] = 0,
                                    ["Relative To"] = "Parent"
                                },
                                ["Hide Countdown Numbers"] = false,
                                ["Cooldown Numbers Text Size"] = 9,
                                ["Size"] = 14
                            },
                            [116849] = {
                                ["Own Only"] = true,
                                ["Position"] = {
                                    ["Point"] = "TOP",
                                    ["Local Point"] = "TOP",
                                    ["Offset X"] = 0,
                                    ["Offset Y"] = -5,
                                    ["Relative To"] = "Parent"
                                },
                                ["Hide Countdown Numbers"] = true,
                                ["Cooldown Numbers Text Size"] = 9,
                                ["Size"] = 16
                            },
                            [191840] = {
                                ["Own Only"] = true,
                                ["Position"] = {
                                    ["Point"] = "LEFT",
                                    ["Local Point"] = "LEFT",
                                    ["Offset X"] = 0,
                                    ["Offset Y"] = 0,
                                    ["Relative To"] = "Parent"
                                },
                                ["Hide Countdown Numbers"] = false,
                                ["Cooldown Numbers Text Size"] = 9,
                                ["Size"] = 14
                            }
                        }
                    }
                },
                ["Info Field"] = {
                    ["Enabled"] = true,
                    ["Limit"] = 10,
                    ["Size"] = 32,
                    ["Direction"] = "Right",
                    ["Orientation"] = "HORIZONTAL",
                    ["Position"] = {
                        ["Relative To"] = "Parent",
                        ["Point"] = "CENTER",
                        ["Local Point"] = "CENTER",
                        ["Offset X"] = 3.4875648021698,
                        ["Offset Y"] = -158.936065673828,
                    },
                    ["Presets"] = {
                        {
                            ["spellId"] = 115151,
                            ["size"] = 32,
                            ["priority"] = 2,
                            ["condition"] = "func:cooldownWithCountdown",
                            ["options"] = {}
                        },
                        {
                            ["id"] = 2,
                            ["spellId"] = 123986,
                            ["size"] = 32,
                            ["priority"] = 3,
                            ["condition"] = "func:cooldownWithCountdown",
                            ["options"] = {}
                        },
                        {
                            ["spellId"] = 205406,
                            ["size"] = 32,
                            ["priority"] = 4,
                            ["condition"] = "func:trackSpellCount",
                            ["options"] = {}
                        },
                        {
                            ["spellId"] = 197206,
                            ["size"] = 32,
                            ["priority"] = 1,
                            ["condition"] = "func:activeBuffWithStackAndCountdown",
                            ["options"] = { "glow" }
                        },
                        {
                            ["spellId"] = 191837,
                            ["size"] = 32,
                            ["priority"] = 2,
                            ["condition"] = "func:cooldownWithCountdown",
                            ["options"] = {}
                        },
                        {
                            ["spellId"] = 122783,
                            ["size"] = 32,
                            ["priority"] = 2,
                            ["condition"] = "func:cooldownWithCountdown",
                            ["options"] = {}
                        },
                        {
                            ["spellId"] = 115310,
                            ["size"] = 32,
                            ["priority"] = 2,
                            ["condition"] = "func:cooldownWithCountdown",
                            ["options"] = {}
                        },
                        {
                            ["spellId"] = 198664,
                            ["size"] = 32,
                            ["priority"] = 2,
                            ["condition"] = "func:cooldownWithCountdown",
                            ["options"] = {}
                        },
                        {
                            ["spellId"] = 196725,
                            ["size"] = 32,
                            ["priority"] = 2,
                            ["condition"] = "func:cooldownWithCountdown",
                            ["options"] = {}
                        },
                        {
                            ["spellId"] = 197908,
                            ["size"] = 32,
                            ["priority"] = 2,
                            ["condition"] = "func:cooldownWithCountdown",
                            ["options"] = {}
                        },
                        {
                            ["spellId"] = 246328,
                            ["size"] = 32,
                            ["priority"] = 1,
                            ["condition"] = "func:activeBuffWithStackAndCountdown",
                            ["options"] = { "glow" }
                        },
                    }
                }
            }
        },
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
    					["Enabled"] = false,
    					["Position"] = "ABOVE",
    					["Relative To"] = "Player",
    					["Offset X"] = 0,
    					["Offset Y"] = 0
    				},
    				["Debuffs"] = {
    					["Enabled"] = false,
    					["Position"] = "ABOVE",
    					["Relative To"] = "Buffs",
    					["Offset X"] = 0,
    					["Offset Y"] = 0
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
                    ["AltPowerBar"] = {
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
                            ["Point"] = "TOP",
                            ["Local Point"] = "BOTTOM",
                            ["Offset X"] = 0,
                            ["Offset Y"] = 0,
                            ["Relative To"] = "Player"
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
    					["Position"] = "ABOVE",
    					["Relative To"] = "Player",
    					["Offset X"] = 0,
    					["Offset Y"] = 0
    				},
    				["Debuffs"] = {
    					["Enabled"] = false,
    					["Position"] = "ABOVE",
    					["Relative To"] = "Buffs",
    					["Offset X"] = 0,
    					["Offset Y"] = 0
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
                        ["Position"] = "ABOVE",
                        ["Relative To"] = "TargetTarget",
                        ["Offset X"] = 0,
                        ["Offset Y"] = 0
                    },
                    ["Debuffs"] = {
                        ["Enabled"] = false,
                        ["Position"] = "ABOVE",
                        ["Relative To"] = "Buffs",
                        ["Offset X"] = 0,
                        ["Offset Y"] = 0
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
                    ["Debuff Order"] = { "Magic", "Disease", "Curse", "Poison", "Physical" },
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
                ["Raid"] = {
                    ["Position"] = {
                        ["Relative To"] = "Parent",
                        ["Point"] = "CENTER",
                        ["Local Point"] = "TOPLEFT",
                        ["Offset X"] = -100.29987347126007,
                        ["Offset Y"] = -200.094223022461,
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
                    ["Debuff Order"] = { "Magic", "Disease", "Curse", "Poison", "Physical" },
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
	["Characters"] = {
        ["Aiwen-ShatteredHand"] = "Aiwen",
        ["Seife-ShatteredHand"] = "Seife"
    }
}

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
    if not self.prepared[type] and defaults["Profiles"][A["Modules"]["Profile"]:GetActive()]["Options"][type] then
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