
CleanUI_DB = {
	["Characters"] = {
		["Ljushuvud-Karazhan"] = "Default",
		["Methree-Karazhan"] = "Default",
		["Ilythra-Karazhan"] = "Disc",
		["Aiwen-ShatteredHand"] = "Default",
	},
	["Profiles"] = {
		["Default"] = {
			["Options"] = {
				["Objective Tracker"] = {
					["Size"] = {
						["Height"] = 800,
						["Width"] = 250,
					},
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 2307.9990234375,
						["Offset Y"] = -516.999938964844,
					},
				},
				["Talking Head Frame"] = {
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 10,
						["Offset Y"] = -10,
					},
				},
				["Minimap"] = {
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 1551.99975585938,
						["Offset Y"] = -1241.99887084961,
					},
					["Size"] = 200,
				},
				["Boss"] = {
					["Enabled"] = true,
					["Clickcast"] = {
					},
					["Highlight Target"] = true,
					["Power"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Power",
						["Position"] = {
							["Relative To"] = "Health",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Orientation"] = "HORIZONTAL",
						["Texture"] = "Default2",
						["Reversed"] = false,
						["Size"] = {
							["Height"] = 15,
							["Width"] = 150,
							["Match width"] = true,
							["Match height"] = false,
						},
					},
					["Tags"] = {
						["Name"] = {
							["Outline"] = "SHADOW",
							["Font"] = "NotoBold",
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "ALL",
								["Local Point"] = "ALL",
								["Offset X"] = 0,
								["Offset Y"] = 0,
							},
							["Color"] = {
								1, -- [1]
								1, -- [2]
								1, -- [3]
							},
							["Text"] = "[name]",
							["Enabled"] = true,
							["Size"] = 10,
						},
						["Custom"] = {
						},
					},
					["Background"] = {
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Enabled"] = true,
					},
					["Offset Y"] = 0,
					["Health"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Texture"] = "Default2",
						["Color By"] = "Gradient",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "TOP",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Orientation"] = "HORIZONTAL",
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
						["Reversed"] = false,
						["Size"] = {
							["Height"] = 35,
							["Width"] = 150,
							["Match width"] = true,
							["Match height"] = false,
						},
					},
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 2012.9990234375,
						["Offset Y"] = -514.999938964844,
					},
					["Orientation"] = "VERTICAL",
					["Offset X"] = 2,
					["Castbar"] = {
						["Enabled"] = true,
						["Attached"] = true,
						["Size"] = {
							["Height"] = 15,
							["Width"] = 150,
							["Match width"] = true,
							["Match height"] = false,
						},
						["Name"] = {
							["Enabled"] = true,
							["Font Size"] = 0.7,
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "LEFT",
								["Local Point"] = "LEFT",
								["Offset X"] = 18,
								["Offset Y"] = 0,
							},
						},
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Time"] = {
							["Enabled"] = true,
							["Font Size"] = 10,
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "RIGHT",
								["Local Point"] = "RIGHT",
								["Offset X"] = -5,
								["Offset Y"] = 0,
							},
						},
						["Background"] = {
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Enabled"] = true,
						},
						["Icon"] = {
							["Enabled"] = true,
							["Background"] = {
								["Offset"] = {
									["Top"] = -1,
									["Right"] = -1,
									["Left"] = -1,
									["Bottom"] = -1,
								},
								["Color"] = {
									0, -- [1]
									0, -- [2]
									0, -- [3]
								},
								["Enabled"] = true,
							},
							["Size"] = {
								["Size"] = 10,
								["Match width"] = false,
								["Match height"] = true,
							},
							["Position"] = "LEFT",
						},
						["Texture"] = "Default2",
					},
					["Size"] = {
						["Height"] = 50,
						["Width"] = 150,
					},
				},
				["Key Bindings"] = {
					["SHIFT-BUTTON4"] = "CleanUI_ActionBar4Button10",
					["SHIFT-C"] = "CleanUI_ActionBar2Button6",
					["SHIFT-1"] = "CleanUI_ActionBar2Button1",
					["SHIFT-4"] = "CleanUI_ActionBar2Button4",
					["ALT-MOUSEWHEELDOWN"] = "CleanUI_ActionBar4Button5",
					["1"] = "CleanUI_ActionBar1Button1",
					["SHIFT-MOUSEWHEELUP"] = "CleanUI_ActionBar4Button2",
					["3"] = "CleanUI_ActionBar1Button3",
					["2"] = "CleanUI_ActionBar1Button2",
					["5"] = "CleanUI_ActionBar1Button5",
					["4"] = "CleanUI_ActionBar1Button4",
					["7"] = "CleanUI_ActionBar1Button7",
					["6"] = "CleanUI_ActionBar1Button6",
					["9"] = "CleanUI_ActionBar1Button9",
					["8"] = "CleanUI_ActionBar1Button8",
					["SHIFT-F"] = "CleanUI_ActionBar3Button3",
					["SHIFT-R"] = "CleanUI_ActionBar2Button10",
					["CTRL-Q"] = "CleanUI_ActionBar3Button8",
					["E"] = "CleanUI_ActionBar3Button1",
					["CTRL-MOUSEWHEELDOWN"] = "CleanUI_ActionBar4Button3",
					["F"] = "CleanUI_ActionBar3Button2",
					["SHIFT-MOUSEWHEELDOWN"] = "CleanUI_ActionBar4Button1",
					["SHIFT-2"] = "CleanUI_ActionBar2Button2",
					["Q"] = "CleanUI_ActionBar2Button7",
					["R"] = "CleanUI_ActionBar2Button9",
					["ALT-MOUSEWHEELUP"] = "CleanUI_ActionBar4Button6",
					["SHIFT-Q"] = "CleanUI_ActionBar2Button8",
					["CTRL-MOUSEWHEELUP"] = "CleanUI_ActionBar4Button4",
					["SHIFT-X"] = "CleanUI_ActionBar4Button8",
					["SHIFT-S"] = "CleanUI_ActionBar3Button6",
					["SHIFT-BUTTON5"] = "CleanUI_ActionBar4Button9",
					["SHIFT-E"] = "CleanUI_ActionBar2Button5",
					["SHIFT-3"] = "CleanUI_ActionBar2Button3",
					["SHIFT-Z"] = "CleanUI_ActionBar4Button7",
				},
				["Target"] = {
					["Enabled"] = true,
					["Debuffs"] = {
						["Enabled"] = true,
						["Attached"] = "TOP",
						["Blacklist"] = {
							["Enabled"] = true,
							["Ids"] = {
							},
						},
						["Style"] = "Bar",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Growth"] = "Upwards",
						["Background"] = {
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Enabled"] = true,
						},
						["Whitelist"] = {
							["Enabled"] = false,
							["Ids"] = {
							},
						},
						["Size"] = {
							["Height"] = 16,
							["Width"] = 16,
							["Match width"] = true,
							["Match height"] = false,
						},
					},
					["HealthPrediction"] = {
						["Enabled"] = true,
						["FrequentUpdates"] = true,
						["MaxOverflow"] = 1,
						["Texture"] = "Default2",
					},
					["Power"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Power",
						["Position"] = {
							["Relative To"] = "Health",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Orientation"] = "HORIZONTAL",
						["Texture"] = "Default2",
						["Reversed"] = false,
						["Size"] = {
							["Height"] = 15,
							["Width"] = 250,
							["Match width"] = true,
							["Match height"] = false,
						},
					},
					["Tags"] = {
						["Name"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "NotoBold",
							["Position"] = {
								["Relative To"] = "Health",
								["Point"] = "LEFT",
								["Local Point"] = "LEFT",
								["Offset X"] = 5,
								["Offset Y"] = 0,
							},
							["Color"] = {
								1, -- [1]
								1, -- [2]
								1, -- [3]
							},
							["Text"] = "[name]",
							["Enabled"] = true,
							["Size"] = 10,
						},
						["Custom"] = {
							["Health Text"] = {
								["Outline"] = "OUTLINE",
								["Font"] = "NotoBold",
								["Position"] = {
									["Relative To"] = "Target",
									["Point"] = "RIGHT",
									["Local Point"] = "RIGHT",
									["Offset X"] = -5,
									["Offset Y"] = -10,
								},
								["Color"] = {
									1, -- [1]
									1, -- [2]
									1, -- [3]
								},
								["Text"] = "[hp:round]",
								["Enabled"] = true,
								["Size"] = 10,
							},
						},
					},
					["Health"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Texture"] = "Default2",
						["Color By"] = "Class",
						["Position"] = {
							["Relative To"] = "Target",
							["Point"] = "TOP",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Orientation"] = "HORIZONTAL",
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
						["Reversed"] = false,
						["Size"] = {
							["Height"] = 35,
							["Width"] = 250,
							["Match width"] = true,
							["Match height"] = false,
						},
					},
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 1278.99975585938,
						["Offset Y"] = -1184.99993896484,
					},
					["Buffs"] = {
						["Enabled"] = false,
						["Growth"] = "Right",
						["Blacklist"] = {
							["Enabled"] = true,
							["Ids"] = {
							},
						},
						["Style"] = "Icon",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Attached"] = "RIGHT",
						["Background"] = {
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Enabled"] = true,
						},
						["Whitelist"] = {
							["Enabled"] = false,
							["Ids"] = {
							},
						},
						["Size"] = {
							["Height"] = 16,
							["Width"] = 16,
							["Match width"] = true,
							["Match height"] = false,
						},
					},
					["Background"] = {
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Enabled"] = true,
					},
					["Castbar"] = {
						["Enabled"] = true,
						["Attached"] = true,
						["Size"] = {
							["Height"] = 16,
							["Width"] = 150,
							["Match width"] = true,
							["Match height"] = false,
						},
						["Name"] = {
							["Enabled"] = true,
							["Font Size"] = 0.7,
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "LEFT",
								["Local Point"] = "LEFT",
								["Offset X"] = 18,
								["Offset Y"] = 0,
							},
						},
						["Position"] = {
							["Relative To"] = "ClassIcons",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Time"] = {
							["Enabled"] = true,
							["Font Size"] = 10,
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "RIGHT",
								["Local Point"] = "RIGHT",
								["Offset X"] = -5,
								["Offset Y"] = 0,
							},
						},
						["Background"] = {
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Enabled"] = true,
						},
						["Icon"] = {
							["Enabled"] = true,
							["Background"] = {
								["Offset"] = {
									["Top"] = -1,
									["Right"] = -1,
									["Left"] = -1,
									["Bottom"] = -1,
								},
								["Color"] = {
									0, -- [1]
									0, -- [2]
									0, -- [3]
								},
								["Enabled"] = true,
							},
							["Size"] = {
								["Size"] = 10,
								["Match width"] = false,
								["Match height"] = true,
							},
							["Position"] = "LEFT",
						},
						["Texture"] = "Default2",
					},
					["Size"] = {
						["Height"] = 51,
						["Width"] = 200,
					},
				},
				["Raid"] = {
					["HealthPrediction"] = {
						["Enabled"] = true,
						["FrequentUpdates"] = true,
						["MaxOverflow"] = 1,
						["Texture"] = "Default2",
					},
					["Debuff Order"] = {
						"Magic", -- [1]
						"Disease", -- [2]
						"Curse", -- [3]
						"Poison", -- [4]
					},
					["RaidBuffs"] = {
						["Enabled"] = true,
						["Important"] = true,
						["Tracked"] = {
						},
					},
					["Show Player"] = true,
					["Offset Y"] = 2,
					["Background"] = {
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Enabled"] = true,
					},
					["GroupRoleIndicator"] = {
						["Enabled"] = true,
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "TOPLEFT",
							["Local Point"] = "TOPLEFT",
							["Offset X"] = 2,
							["Offset Y"] = -2,
						},
					},
					["Size"] = {
						["Height"] = 47,
						["Width"] = 63,
					},
					["Enabled"] = true,
					["Tags"] = {
						["Name"] = {
							["Outline"] = "SHADOW",
							["Font"] = "NotoBold",
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "ALL",
								["Local Point"] = "ALL",
								["Offset X"] = 0,
								["Offset Y"] = 0,
							},
							["Color"] = {
								1, -- [1]
								1, -- [2]
								1, -- [3]
							},
							["Text"] = "[3charname]",
							["Enabled"] = true,
							["Size"] = 12,
						},
						["Custom"] = {
						},
					},
					["Highlight Target"] = true,
					["Show Debuff Border"] = true,
					["Health"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Gradient",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "TOP",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Orientation"] = "VERTICAL",
						["Texture"] = "Default2",
						["Reversed"] = false,
						["Size"] = {
							["Height"] = 41,
							["Width"] = 64,
							["Match width"] = true,
							["Match height"] = false,
						},
					},
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 1749.99963378906,
						["Offset Y"] = -1050.99966430664,
					},
					["Orientation"] = "HORIZONTAL",
					["Offset X"] = 2,
					["Power"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Power",
						["Position"] = {
							["Relative To"] = "Health",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Orientation"] = "HORIZONTAL",
						["Texture"] = "Default2",
						["Reversed"] = false,
						["Size"] = {
							["Height"] = 5,
							["Width"] = 64,
							["Match width"] = true,
							["Match height"] = false,
						},
					},
					["Clickcast"] = {
						{
							["action"] = "macro",
							["type"] = "*type1",
						}, -- [1]
						{
							["action"] = "/cast [@unit,help,nodead] Plea; [@unit,help,dead] Resurrection",
							["type"] = "*macrotext1",
						}, -- [2]
						{
							["action"] = "/cast [@unit,help,nodead] Shadow Mend; [@unit,help,nodead] Flash Heal",
							["type"] = "shift-macrotext1",
						}, -- [3]
						{
							["action"] = "/cast [@unit,help,nodead] Pain Suppression",
							["type"] = "ctrl-macrotext1",
						}, -- [4]
						{
							["action"] = "target",
							["type"] = "ctrl-shift-type1",
						}, -- [5]
						{
							["action"] = "macro",
							["type"] = "*type2",
						}, -- [6]
						{
							["action"] = "/cast [@unit,help,nodead] Power Word: Shield",
							["type"] = "*macrotext2",
						}, -- [7]
						{
							["action"] = "/cast [@unit,help,nodead] Power Word: Radiance",
							["type"] = "shift-macrotext2",
						}, -- [8]
						{
							["action"] = "togglemenu",
							["type"] = "ctrl-shift-type2",
						}, -- [9]
						{
							["action"] = "macro",
							["type"] = "*type3",
						}, -- [10]
						{
							["action"] = "/cast [@unit,help,nodead] Purify",
							["type"] = "*macrotext3",
						}, -- [11]
						{
							["action"] = "/cast [@unit,help,nodead] Leap of Faith",
							["type"] = "shift-macrotext3",
						}, -- [12]
						{
							["action"] = "/cast [@unit,help,nodead] Penance",
							["type"] = "ctrl-macrotext3",
						}, -- [13]
					},
				},
				["Cooldown bar"] = {
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "CENTER",
						["Local Point"] = "CENTER",
						["Offset X"] = 0,
						["Offset Y"] = 0,
					},
				},
				["Artifact Power Bar"] = {
					["Enabled"] = true,
					["Color"] = {
						0.90196, -- [1]
						0.8, -- [2]
						0.50196, -- [3]
					},
					["Background Multiplier"] = 0.33,
					["Texture"] = "Default2",
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 777.999938964844,
						["Offset Y"] = -0.000244140625,
					},
					["Orientation"] = "HORIZONTAL",
					["Background"] = {
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Enabled"] = true,
					},
					["Reversed"] = false,
					["Size"] = {
						["Height"] = 25,
						["Width"] = 500,
					},
				},
				["Reputation Bar"] = {
					["Enabled"] = true,
					["Texture"] = "Default2",
					["Reversed"] = false,
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 1279.99975585938,
						["Offset Y"] = 0,
					},
					["Orientation"] = "HORIZONTAL",
					["Background"] = {
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Enabled"] = true,
					},
					["Background Multiplier"] = 0.33,
					["Size"] = {
						["Height"] = 25,
						["Width"] = 500,
					},
				},
				["Party"] = {
					["HealthPrediction"] = {
						["Enabled"] = true,
						["FrequentUpdates"] = true,
						["MaxOverflow"] = 1,
						["Texture"] = "Default2",
					},
					["Highlight Target"] = true,
					["RaidBuffs"] = {
						["Enabled"] = true,
						["Important"] = true,
						["Limit"] = 40,
						["Tracked"] = {
							[119611] = {
								["Cooldown Numbers Text Size"] = 9,
								["Own Only"] = true,
								["Size"] = 16,
								["Position"] = {
									["Relative To"] = "Parent",
									["Point"] = "TOPRIGHT",
									["Local Point"] = "TOPRIGHT",
									["Offset X"] = 0,
									["Offset Y"] = 0,
								},
								["Hide Countdown Numbers"] = false,
							},
							[116849] = {
								["Cooldown Numbers Text Size"] = 9,
								["Own Only"] = true,
								["Size"] = 16,
								["Position"] = {
									["Relative To"] = "Parent",
									["Point"] = "TOP",
									["Local Point"] = "TOP",
									["Offset X"] = 0,
									["Offset Y"] = -5,
								},
								["Hide Countdown Numbers"] = true,
							},
							[191840] = {
								["Cooldown Numbers Text Size"] = 9,
								["Own Only"] = true,
								["Size"] = 14,
								["Position"] = {
									["Relative To"] = "Parent",
									["Point"] = "LEFT",
									["Local Point"] = "LEFT",
									["Offset X"] = 0,
									["Offset Y"] = 0,
								},
								["Hide Countdown Numbers"] = false,
							},
						},
					},
					["Show Player"] = true,
					["Offset Y"] = 0,
					["Background"] = {
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Enabled"] = true,
					},
					["GroupRoleIndicator"] = {
						["Enabled"] = true,
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "TOPLEFT",
							["Local Point"] = "TOPLEFT",
							["Offset X"] = 2,
							["Offset Y"] = -2,
						},
					},
					["Size"] = {
						["Height"] = 47,
						["Width"] = 63,
					},
					["Enabled"] = true,
					["Tags"] = {
						["Name"] = {
							["Outline"] = "SHADOW",
							["Font"] = "NotoBold",
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "ALL",
								["Local Point"] = "ALL",
								["Offset X"] = 0,
								["Offset Y"] = 0,
							},
							["Color"] = {
								1, -- [1]
								1, -- [2]
								1, -- [3]
							},
							["Text"] = "[3charname]",
							["Enabled"] = true,
							["Size"] = 12,
						},
						["Custom"] = {
						},
					},
					["Debuff Order"] = {
						"Magic", -- [1]
						"Disease", -- [2]
						"Curse", -- [3]
						"Poison", -- [4]
					},
					["Clickcast"] = {
						{
							["action"] = "macro",
							["type"] = "*type1",
						}, -- [1]
						{
							["action"] = "/cast [@unit,help,nodead] Plea; [@unit,help,dead] Resurrection",
							["type"] = "*macrotext1",
						}, -- [2]
						{
							["action"] = "/cast [@unit,help,nodead] Shadow Mend; [@unit,help,nodead] Flash Heal",
							["type"] = "shift-macrotext1",
						}, -- [3]
						{
							["action"] = "/cast [@unit,help,nodead] Pain Suppression",
							["type"] = "ctrl-macrotext1",
						}, -- [4]
						{
							["action"] = "target",
							["type"] = "ctrl-shift-type1",
						}, -- [5]
						{
							["action"] = "macro",
							["type"] = "*type2",
						}, -- [6]
						{
							["action"] = "/cast [@unit,help,nodead] Power Word: Shield",
							["type"] = "*macrotext2",
						}, -- [7]
						{
							["action"] = "/cast [@unit,help,nodead] Power Word: Radiance",
							["type"] = "shift-macrotext2",
						}, -- [8]
						{
							["action"] = "/cast [@unit,help,nodead] Clarity of Will",
							["type"] = "ctrl-macrotext2",
						}, -- [9]
						{
							["action"] = "togglemenu",
							["type"] = "ctrl-shift-type2",
						}, -- [10]
						{
							["action"] = "macro",
							["type"] = "*type3",
						}, -- [11]
						{
							["action"] = "/cast [@unit,help,nodead] Purify",
							["type"] = "*macrotext3",
						}, -- [12]
						{
							["action"] = "/cast [@unit,help,nodead] Leap of Faith",
							["type"] = "shift-macrotext3",
						}, -- [13]
						{
							["action"] = "/cast [@unit,help,nodead] Penance",
							["type"] = "ctrl-macrotext3",
						}, -- [14]
					},
					["Health"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Texture"] = "Default2",
						["Color By"] = "Gradient",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "TOP",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Orientation"] = "VERTICAL",
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
						["Reversed"] = false,
						["Size"] = {
							["Height"] = 41,
							["Width"] = 64,
							["Match width"] = true,
							["Match height"] = false,
						},
					},
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 1750.99951171875,
						["Offset Y"] = -1392.99947357178,
					},
					["Orientation"] = "HORIZONTAL",
					["Offset X"] = 2,
					["Show Debuff Border"] = true,
					["Power"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Power",
						["Position"] = {
							["Relative To"] = "Health",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Orientation"] = "HORIZONTAL",
						["Texture"] = "Default2",
						["Reversed"] = false,
						["Size"] = {
							["Height"] = 5,
							["Width"] = 64,
							["Match width"] = true,
							["Match height"] = false,
						},
					},
				},
				["Player"] = {
					["Enabled"] = true,
					["Debuffs"] = {
						["Enabled"] = false,
						["Growth"] = "Left",
						["Blacklist"] = {
							["Enabled"] = true,
							["Ids"] = {
							},
						},
						["Style"] = "Icon",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Attached"] = "LEFT",
						["Background"] = {
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Enabled"] = true,
						},
						["Whitelist"] = {
							["Enabled"] = false,
							["Ids"] = {
							},
						},
						["Size"] = {
							["Height"] = 16,
							["Width"] = 16,
							["Match width"] = true,
							["Match height"] = false,
						},
					},
					["HealthPrediction"] = {
						["Enabled"] = true,
						["FrequentUpdates"] = true,
						["MaxOverflow"] = 1,
						["Texture"] = "Default2",
					},
					["Power"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Power",
						["Position"] = {
							["Relative To"] = "Health",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Orientation"] = "HORIZONTAL",
						["Texture"] = "Default2",
						["Reversed"] = false,
						["Size"] = {
							["Height"] = 15,
							["Width"] = 150,
							["Match width"] = true,
							["Match height"] = false,
						},
					},
					["Stagger"] = {
						["Enabled"] = true,
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Size"] = {
							["Height"] = 15,
							["Width"] = 150,
							["Match width"] = true,
							["Match height"] = false,
						},
						["Background"] = {
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Enabled"] = true,
						},
						["Attached"] = true,
						["Texture"] = "Default2",
					},
					["Castbar"] = {
						["Enabled"] = true,
						["Attached"] = true,
						["Size"] = {
							["Height"] = 15,
							["Width"] = 150,
							["Match width"] = true,
							["Match height"] = false,
						},
						["Name"] = {
							["Enabled"] = true,
							["Font Size"] = 0.7,
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "LEFT",
								["Local Point"] = "LEFT",
								["Offset X"] = 18,
								["Offset Y"] = 0,
							},
						},
						["Position"] = {
							["Relative To"] = "ClassIcons",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Time"] = {
							["Enabled"] = true,
							["Font Size"] = 10,
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "RIGHT",
								["Local Point"] = "RIGHT",
								["Offset X"] = -5,
								["Offset Y"] = 0,
							},
						},
						["Background"] = {
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Enabled"] = true,
						},
						["Icon"] = {
							["Enabled"] = true,
							["Background"] = {
								["Offset"] = {
									["Top"] = -1,
									["Right"] = -1,
									["Left"] = -1,
									["Bottom"] = -1,
								},
								["Color"] = {
									0, -- [1]
									0, -- [2]
									0, -- [3]
								},
								["Enabled"] = true,
							},
							["Size"] = {
								["Size"] = 10,
								["Match width"] = false,
								["Match height"] = true,
							},
							["Position"] = "LEFT",
						},
						["Texture"] = "Default2",
					},
					["CombatIndicator"] = {
						["Enabled"] = true,
					},
					["AlternativePower"] = {
						["Enabled"] = true,
						["Hide Blizzard"] = true,
						["Position"] = {
							["Relative To"] = "FrameParent",
							["Point"] = "TOPLEFT",
							["Local Point"] = "TOPLEFT",
							["Offset X"] = 823.999694824219,
							["Offset Y"] = -1202.00015258789,
						},
						["Background Multiplier"] = 0.3,
						["Background"] = {
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Enabled"] = true,
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
						},
						["Texture"] = "Default2",
						["Size"] = {
							["Height"] = 20,
							["Width"] = 200,
						},
					},
					["Tags"] = {
						["Name"] = {
							["Outline"] = "Outline",
							["Font"] = "NotoBold",
							["Position"] = {
								["Relative To"] = "Player",
								["Point"] = "TOPLEFT",
								["Local Point"] = "BOTTOMLEFT",
								["Offset X"] = 5,
								["Offset Y"] = 2,
							},
							["Color"] = {
								1, -- [1]
								1, -- [2]
								1, -- [3]
							},
							["Text"] = "[name]",
							["Enabled"] = false,
							["Size"] = 14,
						},
						["Custom"] = {
						},
					},
					["Health"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Texture"] = "Default2",
						["Color By"] = "Gradient",
						["Position"] = {
							["Relative To"] = "Player",
							["Point"] = "TOP",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Orientation"] = "HORIZONTAL",
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
						["Reversed"] = false,
						["Size"] = {
							["Height"] = 35,
							["Width"] = 150,
							["Match width"] = true,
							["Match height"] = false,
						},
					},
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 1077.99963378906,
						["Offset Y"] = -1184.9994354248,
					},
					["Background"] = {
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Enabled"] = true,
					},
					["Buffs"] = {
						["Enabled"] = true,
						["Growth"] = "Upwards",
						["Blacklist"] = {
							["Enabled"] = true,
							["Ids"] = {
							},
						},
						["Style"] = "Bar",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Attached"] = "TOP",
						["Background"] = {
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Enabled"] = true,
						},
						["Whitelist"] = {
							["Enabled"] = false,
							["Ids"] = {
							},
						},
						["Size"] = {
							["Height"] = 16,
							["Width"] = 16,
							["Match width"] = true,
							["Match height"] = false,
						},
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
						["Background"] = {
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Enabled"] = true,
						},
						["Attached"] = true,
						["Size"] = {
							["Height"] = 15,
							["Width"] = 150,
							["Match width"] = true,
							["Match height"] = false,
						},
					},
					["Size"] = {
						["Height"] = 51,
						["Width"] = 200,
					},
				},
				["Vehicle Leave Button"] = {
					["Enabled"] = true,
					["Background"] = {
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Enabled"] = true,
					},
					["Size"] = 48,
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 2156.9990234375,
						["Offset Y"] = -1079.00021362305,
					},
				},
				["Pet"] = {
					["Enabled"] = true,
					["Debuffs"] = {
						["Enabled"] = true,
						["Attached"] = "TOP",
						["Blacklist"] = {
							["Enabled"] = true,
							["Ids"] = {
							},
						},
						["Style"] = "Bar",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Growth"] = "Upwards",
						["Background"] = {
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Enabled"] = true,
						},
						["Whitelist"] = {
							["Enabled"] = false,
							["Ids"] = {
							},
						},
						["Size"] = {
							["Height"] = 16,
							["Width"] = 16,
							["Match width"] = true,
							["Match height"] = false,
						},
					},
					["HealthPrediction"] = {
						["Enabled"] = true,
						["FrequentUpdates"] = true,
						["MaxOverflow"] = 1,
						["Texture"] = "Default2",
					},
					["Power"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Power",
						["Position"] = {
							["Relative To"] = "Health",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Orientation"] = "HORIZONTAL",
						["Texture"] = "Default2",
						["Reversed"] = false,
						["Size"] = {
							["Height"] = 5,
							["Width"] = 250,
							["Match width"] = true,
							["Match height"] = false,
						},
					},
					["Tags"] = {
						["Name"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "NotoBold",
							["Position"] = {
								["Relative To"] = "Health",
								["Point"] = "LEFT",
								["Local Point"] = "LEFT",
								["Offset X"] = 5,
								["Offset Y"] = 0,
							},
							["Color"] = {
								1, -- [1]
								1, -- [2]
								1, -- [3]
							},
							["Text"] = "[name]",
							["Enabled"] = true,
							["Size"] = 10,
						},
						["Custom"] = {
							["Health Text"] = {
								["Outline"] = "OUTLINE",
								["Font"] = "NotoBold",
								["Position"] = {
									["Relative To"] = "Target",
									["Point"] = "RIGHT",
									["Local Point"] = "RIGHT",
									["Offset X"] = -5,
									["Offset Y"] = -10,
								},
								["Color"] = {
									1, -- [1]
									1, -- [2]
									1, -- [3]
								},
								["Text"] = "[hp:round]",
								["Enabled"] = true,
								["Size"] = 10,
							},
						},
					},
					["Health"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Class",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "TOP",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Orientation"] = "HORIZONTAL",
						["Texture"] = "Default2",
						["Reversed"] = false,
						["Size"] = {
							["Height"] = 15,
							["Width"] = 150,
							["Match width"] = true,
							["Match height"] = false,
						},
					},
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 760.999694824219,
						["Offset Y"] = -1321.00042724609,
					},
					["Buffs"] = {
						["Enabled"] = false,
						["Growth"] = "Right",
						["Blacklist"] = {
							["Enabled"] = true,
							["Ids"] = {
							},
						},
						["Style"] = "Icon",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Attached"] = "RIGHT",
						["Background"] = {
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Enabled"] = true,
						},
						["Whitelist"] = {
							["Enabled"] = false,
							["Ids"] = {
							},
						},
						["Size"] = {
							["Height"] = 16,
							["Width"] = 16,
							["Match width"] = true,
							["Match height"] = false,
						},
					},
					["Background"] = {
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Enabled"] = true,
					},
					["Castbar"] = {
						["Enabled"] = true,
						["Attached"] = true,
						["Size"] = {
							["Height"] = 16,
							["Width"] = 150,
							["Match width"] = true,
							["Match height"] = false,
						},
						["Name"] = {
							["Enabled"] = true,
							["Font Size"] = 0.7,
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "LEFT",
								["Local Point"] = "LEFT",
								["Offset X"] = 18,
								["Offset Y"] = 0,
							},
						},
						["Position"] = {
							["Relative To"] = "ClassIcons",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Time"] = {
							["Enabled"] = true,
							["Font Size"] = 10,
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "RIGHT",
								["Local Point"] = "RIGHT",
								["Offset X"] = -5,
								["Offset Y"] = 0,
							},
						},
						["Background"] = {
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Enabled"] = true,
						},
						["Icon"] = {
							["Enabled"] = true,
							["Background"] = {
								["Offset"] = {
									["Top"] = -1,
									["Right"] = -1,
									["Left"] = -1,
									["Bottom"] = -1,
								},
								["Color"] = {
									0, -- [1]
									0, -- [2]
									0, -- [3]
								},
								["Enabled"] = true,
							},
							["Size"] = {
								["Size"] = 10,
								["Match width"] = false,
								["Match height"] = true,
							},
							["Position"] = "LEFT",
						},
						["Texture"] = "Default2",
					},
					["Size"] = {
						["Height"] = 22,
						["Width"] = 200,
					},
				},
				["Actionbars"] = {
					{
						["Enabled"] = true,
						["Vertical Limit"] = 12,
						["Position"] = {
							["Relative To"] = "FrameParent",
							["Point"] = "TOPLEFT",
							["Local Point"] = "TOPLEFT",
							["Offset X"] = 1128.99963378906,
							["Offset Y"] = -1283.0001373291,
						},
						["Icon Size"] = 24,
						["Horizontal Limit"] = 1,
					}, -- [1]
					{
						["Enabled"] = true,
						["Vertical Limit"] = 12,
						["Position"] = {
							["Relative To"] = "FrameParent",
							["Point"] = "TOPLEFT",
							["Local Point"] = "TOPLEFT",
							["Offset X"] = 1081.99963378906,
							["Offset Y"] = -1308.00033569336,
						},
						["Icon Size"] = 32,
						["Horizontal Limit"] = 1,
					}, -- [2]
					{
						["Enabled"] = true,
						["Vertical Limit"] = 12,
						["Position"] = {
							["Relative To"] = "FrameParent",
							["Point"] = "TOPLEFT",
							["Local Point"] = "TOPLEFT",
							["Offset X"] = 1081.99963378906,
							["Offset Y"] = -1340.9994354248,
						},
						["Icon Size"] = 32,
						["Horizontal Limit"] = 1,
					}, -- [3]
					{
						["Enabled"] = true,
						["Vertical Limit"] = 12,
						["Position"] = {
							["Relative To"] = "FrameParent",
							["Point"] = "TOPLEFT",
							["Local Point"] = "TOPLEFT",
							["Offset X"] = 1081.99963378906,
							["Offset Y"] = -1373.99994659424,
						},
						["Icon Size"] = 32,
						["Horizontal Limit"] = 1,
					}, -- [4]
					{
						["Enabled"] = true,
						["Vertical Limit"] = 12,
						["Position"] = {
							["Relative To"] = "FrameParent",
							["Point"] = "TOPLEFT",
							["Local Point"] = "TOPLEFT",
							["Offset X"] = 1081.99963378906,
							["Offset Y"] = -1406.99993133545,
						},
						["Icon Size"] = 32,
						["Horizontal Limit"] = 1,
					}, -- [5]
				},
				["Extra Action Button"] = {
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 2157.9990234375,
						["Offset Y"] = -1203.00007629395,
					},
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
				},
				["Info Field"] = {
					["Enabled"] = true,
					["Direction"] = "Right",
					["Limit"] = 10,
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 0,
						["Offset Y"] = -159.429077148438,
					},
					["Orientation"] = "HORIZONTAL",
					["Presets"] = {
					},
					["Size"] = 20,
				},
				["Vehicle Seat Indicator"] = {
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 100,
						["Offset Y"] = -100,
					},
				},
				["TargetTarget"] = {
					["Enabled"] = true,
					["Debuffs"] = {
						["Enabled"] = false,
						["Blacklist"] = {
							["Enabled"] = true,
							["Ids"] = {
							},
						},
						["Style"] = "Bar",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Whitelist"] = {
							["Enabled"] = false,
							["Ids"] = {
							},
						},
						["Attached"] = "TOP",
						["Growth"] = "Upwards",
						["Size"] = {
							["Height"] = 16,
							["Width"] = 16,
							["Match width"] = true,
							["Match height"] = false,
						},
					},
					["Power"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Power",
						["Position"] = {
							["Relative To"] = "Health",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Orientation"] = "HORIZONTAL",
						["Texture"] = "Default2",
						["Reversed"] = false,
						["Size"] = {
							["Height"] = 5,
							["Width"] = 100,
							["Match width"] = false,
							["Match height"] = false,
						},
					},
					["Health"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Texture"] = "Default2",
						["Color By"] = "Class",
						["Position"] = {
							["Relative To"] = "TargetTarget",
							["Point"] = "TOP",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Orientation"] = "HORIZONTAL",
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
						["Reversed"] = false,
						["Size"] = {
							["Height"] = 20,
							["Width"] = 100,
							["Match width"] = false,
							["Match height"] = false,
						},
					},
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 1501.99938964844,
						["Offset Y"] = -1045.00030517578,
					},
					["Background"] = {
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Enabled"] = true,
					},
					["Buffs"] = {
						["Enabled"] = false,
						["Blacklist"] = {
							["Enabled"] = true,
							["Ids"] = {
							},
						},
						["Style"] = "Bar",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Whitelist"] = {
							["Enabled"] = false,
							["Ids"] = {
							},
						},
						["Attached"] = "TOP",
						["Growth"] = "Upwards",
						["Size"] = {
							["Height"] = 16,
							["Width"] = 16,
							["Match width"] = true,
							["Match height"] = false,
						},
					},
					["Tags"] = {
						["Name"] = {
							["Outline"] = "SHADOW",
							["Font"] = "NotoBold",
							["Position"] = {
								["Relative To"] = "Health",
								["Point"] = "LEFT",
								["Local Point"] = "LEFT",
								["Offset X"] = 5,
								["Offset Y"] = 0,
							},
							["Color"] = {
								1, -- [1]
								1, -- [2]
								1, -- [3]
							},
							["Text"] = "[name]",
							["Enabled"] = true,
							["Size"] = 10,
						},
						["Custom"] = {
						},
					},
					["Size"] = {
						["Height"] = 25,
						["Width"] = 100,
					},
				},
				["Chat"] = {
					["Hide In Combat"] = false,
				},
				["Pet Bar"] = {
					["Enabled"] = true,
					["Vertical Limit"] = 12,
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 757.999755859375,
						["Offset Y"] = -1415.99990844727,
					},
					["Icon Size"] = 24,
					["Horizontal Limit"] = 1,
				},
				["Experience Bar"] = {
					["Enabled"] = true,
					["Color"] = {
						0.8, -- [1]
						0, -- [2]
						0.4, -- [3]
					},
					["Background Multiplier"] = 0.33,
					["Texture"] = "Default2",
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 1153.99975585938,
						["Offset Y"] = -1255.99984741211,
					},
					["Orientation"] = "HORIZONTAL",
					["Background"] = {
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Enabled"] = true,
					},
					["Reversed"] = false,
					["Size"] = {
						["Height"] = 25,
						["Width"] = 250,
					},
				},
			},
		},
		["Disc"] = {
			["Options"] = {
				["Objective Tracker"] = {
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 2307.9990234375,
						["Offset Y"] = -517.000183105469,
					},
					["Size"] = {
						["Height"] = 800,
						["Width"] = 250,
					},
				},
				["Talking Head Frame"] = {
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 10,
						["Offset Y"] = -10,
					},
				},
				["Minimap"] = {
					["Size"] = 200,
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 1551.99975585938,
						["Offset Y"] = -1241.99896240234,
					},
				},
				["Boss"] = {
					["Enabled"] = true,
					["Castbar"] = {
						["Enabled"] = true,
						["Attached"] = true,
						["Texture"] = "Default2",
						["Name"] = {
							["Enabled"] = true,
							["Font Size"] = 0.7,
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "LEFT",
								["Local Point"] = "LEFT",
								["Offset X"] = 18,
								["Offset Y"] = 0,
							},
						},
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Time"] = {
							["Enabled"] = true,
							["Font Size"] = 10,
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "RIGHT",
								["Local Point"] = "RIGHT",
								["Offset X"] = -5,
								["Offset Y"] = 0,
							},
						},
						["Background"] = {
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Enabled"] = true,
						},
						["Icon"] = {
							["Enabled"] = true,
							["Background"] = {
								["Color"] = {
									0, -- [1]
									0, -- [2]
									0, -- [3]
								},
								["Offset"] = {
									["Top"] = -1,
									["Right"] = -1,
									["Left"] = -1,
									["Bottom"] = -1,
								},
								["Enabled"] = true,
							},
							["Position"] = "LEFT",
							["Size"] = {
								["Match height"] = true,
								["Match width"] = false,
								["Size"] = 10,
							},
						},
						["Size"] = {
							["Height"] = 15,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 150,
						},
					},
					["Highlight Target"] = true,
					["Power"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Power",
						["Position"] = {
							["Relative To"] = "Health",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Orientation"] = "HORIZONTAL",
						["Size"] = {
							["Height"] = 15,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 150,
						},
						["Reversed"] = false,
						["Texture"] = "Default2",
					},
					["Tags"] = {
						["Name"] = {
							["Outline"] = "SHADOW",
							["Font"] = "NotoBold",
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "ALL",
								["Local Point"] = "ALL",
								["Offset X"] = 0,
								["Offset Y"] = 0,
							},
							["Color"] = {
								1, -- [1]
								1, -- [2]
								1, -- [3]
							},
							["Text"] = "[name]",
							["Enabled"] = true,
							["Size"] = 10,
						},
						["Custom"] = {
						},
					},
					["Offset X"] = 2,
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 2012.9990234375,
						["Offset Y"] = -514.999938964844,
					},
					["Health"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Gradient",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "TOP",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Orientation"] = "HORIZONTAL",
						["Size"] = {
							["Height"] = 35,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 150,
						},
						["Reversed"] = false,
						["Texture"] = "Default2",
					},
					["Offset Y"] = 0,
					["Orientation"] = "VERTICAL",
					["Background"] = {
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Enabled"] = true,
					},
					["Clickcast"] = {
					},
					["Size"] = {
						["Height"] = 50,
						["Width"] = 150,
					},
				},
				["Reputation Bar"] = {
					["Enabled"] = true,
					["Size"] = {
						["Height"] = 25,
						["Width"] = 500,
					},
					["Background Multiplier"] = 0.33,
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 1277.99975585938,
						["Offset Y"] = 1,
					},
					["Orientation"] = "HORIZONTAL",
					["Background"] = {
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Enabled"] = true,
					},
					["Reversed"] = false,
					["Texture"] = "Default2",
				},
				["Experience Bar"] = {
					["Enabled"] = true,
					["Color"] = {
						0.8, -- [1]
						0, -- [2]
						0.4, -- [3]
					},
					["Background Multiplier"] = 0.33,
					["Size"] = {
						["Height"] = 25,
						["Width"] = 250,
					},
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 1153.99975585938,
						["Offset Y"] = -1255.99993896484,
					},
					["Orientation"] = "HORIZONTAL",
					["Background"] = {
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Enabled"] = true,
					},
					["Reversed"] = false,
					["Texture"] = "Default2",
				},
				["Raid"] = {
					["HealthPrediction"] = {
						["Enabled"] = true,
						["MaxOverflow"] = 1,
						["FrequentUpdates"] = true,
						["Texture"] = "Default2",
					},
					["Highlight Target"] = true,
					["RaidBuffs"] = {
						["Enabled"] = true,
						["Important"] = true,
						["Tracked"] = {
							[33206] = {
								["Cooldown Numbers Text Size"] = 9,
								["Own Only"] = true,
								["Hide Countdown Numbers"] = false,
								["Position"] = {
									["Relative To"] = "Parent",
									["Point"] = "CENTER",
									["Local Point"] = "CENTER",
									["Offset X"] = 0,
									["Offset Y"] = 0,
								},
								["Size"] = 14,
							},
							[152118] = {
								["Cooldown Numbers Text Size"] = 9,
								["Own Only"] = true,
								["Hide Countdown Numbers"] = false,
								["Position"] = {
									["Relative To"] = "Parent",
									["Point"] = "TOP",
									["Local Point"] = "TOP",
									["Offset X"] = 0,
									["Offset Y"] = 0,
								},
								["Size"] = 14,
							},
							[194384] = {
								["Cooldown Numbers Text Size"] = 9,
								["Own Only"] = true,
								["Hide Countdown Numbers"] = false,
								["Position"] = {
									["Relative To"] = "Parent",
									["Point"] = "TOPRIGHT",
									["Local Point"] = "TOPRIGHT",
									["Offset X"] = 0,
									["Offset Y"] = 0,
								},
								["Size"] = 14,
							},
							[17] = {
								["Cooldown Numbers Text Size"] = 9,
								["Own Only"] = true,
								["Hide Countdown Numbers"] = false,
								["Position"] = {
									["Relative To"] = "Parent",
									["Point"] = "TOPLEFT",
									["Local Point"] = "TOPLEFT",
									["Offset X"] = 0,
									["Offset Y"] = 0,
								},
								["Size"] = 14,
							},
						},
					},
					["Show Player"] = true,
					["Offset Y"] = 2,
					["Background"] = {
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Enabled"] = true,
					},
					["GroupRoleIndicator"] = {
						["Enabled"] = true,
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "TOPLEFT",
							["Local Point"] = "TOPLEFT",
							["Offset X"] = 2,
							["Offset Y"] = -2,
						},
					},
					["Size"] = {
						["Height"] = 47,
						["Width"] = 63,
					},
					["Enabled"] = true,
					["Clickcast"] = {
						{
							["action"] = "macro",
							["type"] = "*type1",
						}, -- [1]
						{
							["action"] = "/cast [@unit,help,nodead] Plea; [@unit,help,dead] Resurrection",
							["type"] = "*macrotext1",
						}, -- [2]
						{
							["action"] = "/cast [@unit,help,nodead] Shadow Mend; [@unit,help,nodead] Flash Heal",
							["type"] = "shift-macrotext1",
						}, -- [3]
						{
							["action"] = "/cast [@unit,help,nodead] Pain Suppression",
							["type"] = "ctrl-macrotext1",
						}, -- [4]
						{
							["action"] = "target",
							["type"] = "ctrl-shift-type1",
						}, -- [5]
						{
							["action"] = "macro",
							["type"] = "*type2",
						}, -- [6]
						{
							["action"] = "/cast [@unit,help,nodead] Power Word: Shield",
							["type"] = "*macrotext2",
						}, -- [7]
						{
							["action"] = "/cast [@unit,help,nodead] Power Word: Radiance",
							["type"] = "shift-macrotext2",
						}, -- [8]
						{
							["action"] = "/cast [@unit,help,nodead] Clarity of Will",
							["type"] = "ctrl-macrotext2",
						}, -- [9]
						{
							["action"] = "togglemenu",
							["type"] = "ctrl-shift-type2",
						}, -- [10]
						{
							["action"] = "macro",
							["type"] = "*type3",
						}, -- [11]
						{
							["action"] = "/cast [@unit,help,nodead] Purify",
							["type"] = "*macrotext3",
						}, -- [12]
						{
							["action"] = "/cast [@unit,help,nodead] Leap of Faith",
							["type"] = "shift-macrotext3",
						}, -- [13]
						{
							["action"] = "/cast [@unit,help,nodead] Penance",
							["type"] = "ctrl-macrotext3",
						}, -- [14]
					},
					["Power"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Power",
						["Position"] = {
							["Relative To"] = "Health",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Orientation"] = "HORIZONTAL",
						["Size"] = {
							["Height"] = 5,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 64,
						},
						["Reversed"] = false,
						["Texture"] = "Default2",
					},
					["Tags"] = {
						["Name"] = {
							["Outline"] = "SHADOW",
							["Font"] = "NotoBold",
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "ALL",
								["Local Point"] = "ALL",
								["Offset X"] = 0,
								["Offset Y"] = 0,
							},
							["Color"] = {
								1, -- [1]
								1, -- [2]
								1, -- [3]
							},
							["Text"] = "[3charname]",
							["Enabled"] = true,
							["Size"] = 12,
						},
						["Custom"] = {
						},
					},
					["Health"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Gradient",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "TOP",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Orientation"] = "VERTICAL",
						["Size"] = {
							["Height"] = 41,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 64,
						},
						["Reversed"] = false,
						["Texture"] = "Default2",
					},
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 1749.99963378906,
						["Offset Y"] = -1050.99981689453,
					},
					["Orientation"] = "HORIZONTAL",
					["Offset X"] = 2,
					["Show Debuff Border"] = true,
					["Debuff Order"] = {
						"Magic", -- [1]
						"Disease", -- [2]
						"Curse", -- [3]
						"Poison", -- [4]
					},
				},
				["Cooldown bar"] = {
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "CENTER",
						["Local Point"] = "CENTER",
						["Offset X"] = 0,
						["Offset Y"] = 0,
					},
				},
				["Artifact Power Bar"] = {
					["Enabled"] = true,
					["Color"] = {
						0.90196, -- [1]
						0.8, -- [2]
						0.50196, -- [3]
					},
					["Background Multiplier"] = 0.33,
					["Size"] = {
						["Height"] = 25,
						["Width"] = 500,
					},
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 777.999938964844,
						["Offset Y"] = 1,
					},
					["Orientation"] = "HORIZONTAL",
					["Background"] = {
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Enabled"] = true,
					},
					["Reversed"] = false,
					["Texture"] = "Default2",
				},
				["Target"] = {
					["Enabled"] = true,
					["Debuffs"] = {
						["Enabled"] = true,
						["Attached"] = "TOP",
						["Blacklist"] = {
							["Enabled"] = true,
							["Ids"] = {
							},
						},
						["Style"] = "Bar",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Growth"] = "Upwards",
						["Background"] = {
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Enabled"] = true,
						},
						["Whitelist"] = {
							["Enabled"] = false,
							["Ids"] = {
							},
						},
						["Size"] = {
							["Height"] = 16,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 16,
						},
					},
					["HealthPrediction"] = {
						["Enabled"] = true,
						["MaxOverflow"] = 1,
						["FrequentUpdates"] = true,
						["Texture"] = "Default2",
					},
					["Tags"] = {
						["Name"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "NotoBold",
							["Position"] = {
								["Relative To"] = "Health",
								["Point"] = "LEFT",
								["Local Point"] = "LEFT",
								["Offset X"] = 5,
								["Offset Y"] = 0,
							},
							["Color"] = {
								1, -- [1]
								1, -- [2]
								1, -- [3]
							},
							["Text"] = "[name]",
							["Enabled"] = true,
							["Size"] = 10,
						},
						["Custom"] = {
							["Health Text"] = {
								["Outline"] = "OUTLINE",
								["Font"] = "NotoBold",
								["Position"] = {
									["Relative To"] = "Target",
									["Point"] = "RIGHT",
									["Local Point"] = "RIGHT",
									["Offset X"] = -5,
									["Offset Y"] = -10,
								},
								["Color"] = {
									1, -- [1]
									1, -- [2]
									1, -- [3]
								},
								["Text"] = "[hp:round]",
								["Enabled"] = true,
								["Size"] = 10,
							},
						},
					},
					["Power"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Power",
						["Position"] = {
							["Relative To"] = "Health",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Orientation"] = "HORIZONTAL",
						["Size"] = {
							["Height"] = 15,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 250,
						},
						["Reversed"] = false,
						["Texture"] = "Default2",
					},
					["Health"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Class",
						["Position"] = {
							["Relative To"] = "Target",
							["Point"] = "TOP",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Orientation"] = "HORIZONTAL",
						["Size"] = {
							["Height"] = 35,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 250,
						},
						["Reversed"] = false,
						["Texture"] = "Default2",
					},
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 1441.00012207031,
						["Offset Y"] = -1138.00054931641,
					},
					["Castbar"] = {
						["Enabled"] = true,
						["Attached"] = true,
						["Texture"] = "Default2",
						["Name"] = {
							["Enabled"] = true,
							["Font Size"] = 0.7,
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "LEFT",
								["Local Point"] = "LEFT",
								["Offset X"] = 18,
								["Offset Y"] = 0,
							},
						},
						["Position"] = {
							["Relative To"] = "ClassIcons",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Time"] = {
							["Enabled"] = true,
							["Font Size"] = 10,
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "RIGHT",
								["Local Point"] = "RIGHT",
								["Offset X"] = -5,
								["Offset Y"] = 0,
							},
						},
						["Background"] = {
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Enabled"] = true,
						},
						["Icon"] = {
							["Enabled"] = true,
							["Background"] = {
								["Color"] = {
									0, -- [1]
									0, -- [2]
									0, -- [3]
								},
								["Offset"] = {
									["Top"] = -1,
									["Right"] = -1,
									["Left"] = -1,
									["Bottom"] = -1,
								},
								["Enabled"] = true,
							},
							["Position"] = "LEFT",
							["Size"] = {
								["Match height"] = true,
								["Match width"] = false,
								["Size"] = 10,
							},
						},
						["Size"] = {
							["Height"] = 16,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 150,
						},
					},
					["Buffs"] = {
						["Enabled"] = false,
						["Growth"] = "Right",
						["Blacklist"] = {
							["Enabled"] = true,
							["Ids"] = {
							},
						},
						["Style"] = "Icon",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Attached"] = "RIGHT",
						["Background"] = {
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Enabled"] = true,
						},
						["Whitelist"] = {
							["Enabled"] = false,
							["Ids"] = {
							},
						},
						["Size"] = {
							["Height"] = 16,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 16,
						},
					},
					["Background"] = {
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Enabled"] = true,
					},
					["Size"] = {
						["Height"] = 51,
						["Width"] = 200,
					},
				},
				["Party"] = {
					["HealthPrediction"] = {
						["Enabled"] = true,
						["MaxOverflow"] = 1,
						["FrequentUpdates"] = true,
						["Texture"] = "Default2",
					},
					["Highlight Target"] = true,
					["RaidBuffs"] = {
						["Enabled"] = true,
						["Important"] = true,
						["Limit"] = 40,
						["Tracked"] = {
							[33206] = {
								["Cooldown Numbers Text Size"] = 9,
								["Own Only"] = true,
								["Hide Countdown Numbers"] = false,
								["Position"] = {
									["Relative To"] = "Parent",
									["Point"] = "CENTER",
									["Local Point"] = "CENTER",
									["Offset X"] = 0,
									["Offset Y"] = 0,
								},
								["Size"] = 14,
							},
							[152118] = {
								["Cooldown Numbers Text Size"] = 9,
								["Own Only"] = true,
								["Hide Countdown Numbers"] = false,
								["Position"] = {
									["Relative To"] = "Parent",
									["Point"] = "TOP",
									["Local Point"] = "TOP",
									["Offset X"] = 0,
									["Offset Y"] = 0,
								},
								["Size"] = 14,
							},
							[194384] = {
								["Cooldown Numbers Text Size"] = 9,
								["Own Only"] = true,
								["Hide Countdown Numbers"] = false,
								["Position"] = {
									["Relative To"] = "Parent",
									["Point"] = "TOPRIGHT",
									["Local Point"] = "TOPRIGHT",
									["Offset X"] = 0,
									["Offset Y"] = 0,
								},
								["Size"] = 14,
							},
							[17] = {
								["Cooldown Numbers Text Size"] = 9,
								["Own Only"] = true,
								["Hide Countdown Numbers"] = false,
								["Position"] = {
									["Relative To"] = "Parent",
									["Point"] = "TOPLEFT",
									["Local Point"] = "TOPLEFT",
									["Offset X"] = 0,
									["Offset Y"] = 0,
								},
								["Size"] = 14,
							},
						},
					},
					["Show Player"] = true,
					["Offset Y"] = 0,
					["Background"] = {
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Enabled"] = true,
					},
					["GroupRoleIndicator"] = {
						["Enabled"] = true,
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "TOPLEFT",
							["Local Point"] = "TOPLEFT",
							["Offset X"] = 2,
							["Offset Y"] = -2,
						},
					},
					["Size"] = {
						["Height"] = 47,
						["Width"] = 63,
					},
					["Enabled"] = true,
					["Clickcast"] = {
						{
							["action"] = "macro",
							["type"] = "*type1",
						}, -- [1]
						{
							["action"] = "/cast [@unit,help,nodead] Plea; [@unit,help,dead] Resurrection",
							["type"] = "*macrotext1",
						}, -- [2]
						{
							["action"] = "/cast [@unit,help,nodead] Shadow Mend; [@unit,help,nodead] Flash Heal",
							["type"] = "shift-macrotext1",
						}, -- [3]
						{
							["action"] = "/cast [@unit,help,nodead] Pain Suppression",
							["type"] = "ctrl-macrotext1",
						}, -- [4]
						{
							["action"] = "target",
							["type"] = "ctrl-shift-type1",
						}, -- [5]
						{
							["action"] = "macro",
							["type"] = "*type2",
						}, -- [6]
						{
							["action"] = "/cast [@unit,help,nodead] Power Word: Shield",
							["type"] = "*macrotext2",
						}, -- [7]
						{
							["action"] = "/cast [@unit,help,nodead] Power Word: Radiance",
							["type"] = "shift-macrotext2",
						}, -- [8]
						{
							["action"] = "/cast [@unit,help,nodead] Clarity of Will",
							["type"] = "ctrl-macrotext2",
						}, -- [9]
						{
							["action"] = "togglemenu",
							["type"] = "ctrl-shift-type2",
						}, -- [10]
						{
							["action"] = "macro",
							["type"] = "*type3",
						}, -- [11]
						{
							["action"] = "/cast [@unit,help,nodead] Purify",
							["type"] = "*macrotext3",
						}, -- [12]
						{
							["action"] = "/cast [@unit,help,nodead] Leap of Faith",
							["type"] = "shift-macrotext3",
						}, -- [13]
						{
							["action"] = "/cast [@unit,help,nodead] Penance",
							["type"] = "ctrl-macrotext3",
						}, -- [14]
					},
					["Power"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Power",
						["Position"] = {
							["Relative To"] = "Health",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Orientation"] = "HORIZONTAL",
						["Size"] = {
							["Height"] = 5,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 64,
						},
						["Reversed"] = false,
						["Texture"] = "Default2",
					},
					["Tags"] = {
						["Name"] = {
							["Outline"] = "SHADOW",
							["Font"] = "NotoBold",
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "ALL",
								["Local Point"] = "ALL",
								["Offset X"] = 0,
								["Offset Y"] = 0,
							},
							["Color"] = {
								1, -- [1]
								1, -- [2]
								1, -- [3]
							},
							["Text"] = "[3charname]",
							["Enabled"] = true,
							["Size"] = 12,
						},
						["Custom"] = {
						},
					},
					["Health"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Gradient",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "TOP",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Orientation"] = "VERTICAL",
						["Size"] = {
							["Height"] = 41,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 64,
						},
						["Reversed"] = false,
						["Texture"] = "Default2",
					},
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 1116.99963378906,
						["Offset Y"] = -1138.00061035156,
					},
					["Orientation"] = "HORIZONTAL",
					["Offset X"] = 2,
					["Show Debuff Border"] = true,
					["Debuff Order"] = {
						"Magic", -- [1]
						"Disease", -- [2]
						"Curse", -- [3]
						"Poison", -- [4]
					},
				},
				["Chat"] = {
					["Hide In Combat"] = false,
				},
				["Vehicle Leave Button"] = {
					["Enabled"] = true,
					["Background"] = {
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Enabled"] = true,
					},
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 2156.9990234375,
						["Offset Y"] = -1079.0002746582,
					},
					["Size"] = 48,
				},
				["Pet"] = {
					["Enabled"] = true,
					["Debuffs"] = {
						["Enabled"] = true,
						["Attached"] = "TOP",
						["Blacklist"] = {
							["Enabled"] = true,
							["Ids"] = {
							},
						},
						["Style"] = "Bar",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Growth"] = "Upwards",
						["Background"] = {
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Enabled"] = true,
						},
						["Whitelist"] = {
							["Enabled"] = false,
							["Ids"] = {
							},
						},
						["Size"] = {
							["Height"] = 16,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 16,
						},
					},
					["HealthPrediction"] = {
						["Enabled"] = true,
						["MaxOverflow"] = 1,
						["FrequentUpdates"] = true,
						["Texture"] = "Default2",
					},
					["Tags"] = {
						["Name"] = {
							["Outline"] = "OUTLINE",
							["Font"] = "NotoBold",
							["Position"] = {
								["Relative To"] = "Health",
								["Point"] = "LEFT",
								["Local Point"] = "LEFT",
								["Offset X"] = 5,
								["Offset Y"] = 0,
							},
							["Color"] = {
								1, -- [1]
								1, -- [2]
								1, -- [3]
							},
							["Text"] = "[name]",
							["Enabled"] = true,
							["Size"] = 10,
						},
						["Custom"] = {
							["Health Text"] = {
								["Outline"] = "OUTLINE",
								["Font"] = "NotoBold",
								["Position"] = {
									["Relative To"] = "Target",
									["Point"] = "RIGHT",
									["Local Point"] = "RIGHT",
									["Offset X"] = -5,
									["Offset Y"] = -10,
								},
								["Color"] = {
									1, -- [1]
									1, -- [2]
									1, -- [3]
								},
								["Text"] = "[hp:round]",
								["Enabled"] = true,
								["Size"] = 10,
							},
						},
					},
					["Power"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Power",
						["Position"] = {
							["Relative To"] = "Health",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Orientation"] = "HORIZONTAL",
						["Size"] = {
							["Height"] = 5,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 250,
						},
						["Reversed"] = false,
						["Texture"] = "Default2",
					},
					["Health"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Class",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "TOP",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Orientation"] = "HORIZONTAL",
						["Size"] = {
							["Height"] = 15,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 150,
						},
						["Reversed"] = false,
						["Texture"] = "Default2",
					},
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 760.999694824219,
						["Offset Y"] = -1321.00042724609,
					},
					["Castbar"] = {
						["Enabled"] = true,
						["Attached"] = true,
						["Texture"] = "Default2",
						["Name"] = {
							["Enabled"] = true,
							["Font Size"] = 0.7,
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "LEFT",
								["Local Point"] = "LEFT",
								["Offset X"] = 18,
								["Offset Y"] = 0,
							},
						},
						["Position"] = {
							["Relative To"] = "ClassIcons",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Time"] = {
							["Enabled"] = true,
							["Font Size"] = 10,
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "RIGHT",
								["Local Point"] = "RIGHT",
								["Offset X"] = -5,
								["Offset Y"] = 0,
							},
						},
						["Background"] = {
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Enabled"] = true,
						},
						["Icon"] = {
							["Enabled"] = true,
							["Background"] = {
								["Color"] = {
									0, -- [1]
									0, -- [2]
									0, -- [3]
								},
								["Offset"] = {
									["Top"] = -1,
									["Right"] = -1,
									["Left"] = -1,
									["Bottom"] = -1,
								},
								["Enabled"] = true,
							},
							["Position"] = "LEFT",
							["Size"] = {
								["Match height"] = true,
								["Match width"] = false,
								["Size"] = 10,
							},
						},
						["Size"] = {
							["Height"] = 16,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 150,
						},
					},
					["Buffs"] = {
						["Enabled"] = false,
						["Growth"] = "Right",
						["Blacklist"] = {
							["Enabled"] = true,
							["Ids"] = {
							},
						},
						["Style"] = "Icon",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Attached"] = "RIGHT",
						["Background"] = {
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Enabled"] = true,
						},
						["Whitelist"] = {
							["Enabled"] = false,
							["Ids"] = {
							},
						},
						["Size"] = {
							["Height"] = 16,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 16,
						},
					},
					["Background"] = {
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Enabled"] = true,
					},
					["Size"] = {
						["Height"] = 22,
						["Width"] = 200,
					},
				},
				["Actionbars"] = {
					{
						["Enabled"] = true,
						["Vertical Limit"] = 12,
						["Position"] = {
							["Relative To"] = "FrameParent",
							["Point"] = "TOPLEFT",
							["Local Point"] = "TOPLEFT",
							["Offset X"] = 1128.99963378906,
							["Offset Y"] = -1283.0001373291,
						},
						["Icon Size"] = 24,
						["Horizontal Limit"] = 1,
					}, -- [1]
					{
						["Enabled"] = true,
						["Vertical Limit"] = 12,
						["Position"] = {
							["Relative To"] = "FrameParent",
							["Point"] = "TOPLEFT",
							["Local Point"] = "TOPLEFT",
							["Offset X"] = 1081.99963378906,
							["Offset Y"] = -1308.00042724609,
						},
						["Icon Size"] = 32,
						["Horizontal Limit"] = 1,
					}, -- [2]
					{
						["Enabled"] = true,
						["Vertical Limit"] = 12,
						["Position"] = {
							["Relative To"] = "FrameParent",
							["Point"] = "TOPLEFT",
							["Local Point"] = "TOPLEFT",
							["Offset X"] = 1081.99963378906,
							["Offset Y"] = -1340.9994354248,
						},
						["Icon Size"] = 32,
						["Horizontal Limit"] = 1,
					}, -- [3]
					{
						["Enabled"] = true,
						["Vertical Limit"] = 12,
						["Position"] = {
							["Relative To"] = "FrameParent",
							["Point"] = "TOPLEFT",
							["Local Point"] = "TOPLEFT",
							["Offset X"] = 1081.99963378906,
							["Offset Y"] = -1374.00003814697,
						},
						["Icon Size"] = 32,
						["Horizontal Limit"] = 1,
					}, -- [4]
					{
						["Enabled"] = true,
						["Vertical Limit"] = 12,
						["Position"] = {
							["Relative To"] = "FrameParent",
							["Point"] = "TOPLEFT",
							["Local Point"] = "TOPLEFT",
							["Offset X"] = 1081.99963378906,
							["Offset Y"] = -1406.99993133545,
						},
						["Icon Size"] = 32,
						["Horizontal Limit"] = 1,
					}, -- [5]
				},
				["Extra Action Button"] = {
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 2157.9990234375,
						["Offset Y"] = -1203.00015258789,
					},
				},
				["Player"] = {
					["Enabled"] = true,
					["Debuffs"] = {
						["Enabled"] = true,
						["Growth"] = "Left",
						["Blacklist"] = {
							["Enabled"] = true,
							["Ids"] = {
							},
						},
						["Style"] = "Icon",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Attached"] = "LEFT",
						["Background"] = {
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Enabled"] = true,
						},
						["Whitelist"] = {
							["Enabled"] = false,
							["Ids"] = {
							},
						},
						["Size"] = {
							["Height"] = 16,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 16,
						},
					},
					["HealthPrediction"] = {
						["Enabled"] = true,
						["MaxOverflow"] = 1,
						["FrequentUpdates"] = true,
						["Texture"] = "Default2",
					},
					["Power"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Power",
						["Position"] = {
							["Relative To"] = "Health",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Orientation"] = "HORIZONTAL",
						["Size"] = {
							["Height"] = 15,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 150,
						},
						["Reversed"] = false,
						["Texture"] = "Default2",
					},
					["AlternativePower"] = {
						["Enabled"] = true,
						["Hide Blizzard"] = true,
						["Position"] = {
							["Relative To"] = "FrameParent",
							["Point"] = "TOPLEFT",
							["Local Point"] = "TOPLEFT",
							["Offset X"] = 685.999633789063,
							["Offset Y"] = -1154.00033569336,
						},
						["Size"] = {
							["Height"] = 20,
							["Width"] = 200,
						},
						["Background"] = {
							["Enabled"] = true,
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
						},
						["Texture"] = "Default2",
						["Background Multiplier"] = 0.3,
					},
					["Castbar"] = {
						["Enabled"] = true,
						["Attached"] = true,
						["Texture"] = "Default2",
						["Name"] = {
							["Enabled"] = true,
							["Font Size"] = 0.7,
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "LEFT",
								["Local Point"] = "LEFT",
								["Offset X"] = 18,
								["Offset Y"] = 0,
							},
						},
						["Position"] = {
							["Relative To"] = "ClassIcons",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Time"] = {
							["Enabled"] = true,
							["Font Size"] = 10,
							["Position"] = {
								["Relative To"] = "Parent",
								["Point"] = "RIGHT",
								["Local Point"] = "RIGHT",
								["Offset X"] = -5,
								["Offset Y"] = 0,
							},
						},
						["Background"] = {
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Enabled"] = true,
						},
						["Icon"] = {
							["Enabled"] = true,
							["Background"] = {
								["Color"] = {
									0, -- [1]
									0, -- [2]
									0, -- [3]
								},
								["Offset"] = {
									["Top"] = -1,
									["Right"] = -1,
									["Left"] = -1,
									["Bottom"] = -1,
								},
								["Enabled"] = true,
							},
							["Position"] = "LEFT",
							["Size"] = {
								["Match height"] = true,
								["Match width"] = false,
								["Size"] = 10,
							},
						},
						["Size"] = {
							["Height"] = 15,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 150,
						},
					},
					["Buffs"] = {
						["Enabled"] = true,
						["Growth"] = "Upwards",
						["Blacklist"] = {
							["Enabled"] = true,
							["Ids"] = {
							},
						},
						["Style"] = "Bar",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Attached"] = "TOP",
						["Background"] = {
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Enabled"] = true,
						},
						["Whitelist"] = {
							["Enabled"] = false,
							["Ids"] = {
							},
						},
						["Size"] = {
							["Height"] = 16,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 16,
						},
					},
					["Stagger"] = {
						["Enabled"] = true,
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Texture"] = "Default2",
						["Background"] = {
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Enabled"] = true,
						},
						["Attached"] = true,
						["Size"] = {
							["Height"] = 15,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 150,
						},
					},
					["Background"] = {
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Enabled"] = true,
					},
					["Health"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Gradient",
						["Position"] = {
							["Relative To"] = "Player",
							["Point"] = "TOP",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Orientation"] = "HORIZONTAL",
						["Size"] = {
							["Height"] = 35,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 150,
						},
						["Reversed"] = false,
						["Texture"] = "Default2",
					},
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 915.999694824219,
						["Offset Y"] = -1137.99966430664,
					},
					["Tags"] = {
						["Name"] = {
							["Outline"] = "Outline",
							["Font"] = "NotoBold",
							["Position"] = {
								["Relative To"] = "Player",
								["Point"] = "TOPLEFT",
								["Local Point"] = "BOTTOMLEFT",
								["Offset X"] = 5,
								["Offset Y"] = 2,
							},
							["Color"] = {
								1, -- [1]
								1, -- [2]
								1, -- [3]
							},
							["Text"] = "[name]",
							["Enabled"] = false,
							["Size"] = 14,
						},
						["Custom"] = {
						},
					},
					["CombatIndicator"] = {
						["Enabled"] = true,
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
						["Background"] = {
							["Color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
							},
							["Offset"] = {
								["Top"] = -1,
								["Right"] = -1,
								["Left"] = -1,
								["Bottom"] = -1,
							},
							["Enabled"] = true,
						},
						["Attached"] = true,
						["Size"] = {
							["Height"] = 15,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 150,
						},
					},
					["Size"] = {
						["Height"] = 51,
						["Width"] = 200,
					},
				},
				["Info Field"] = {
					["Enabled"] = true,
					["Direction"] = "Right",
					["Limit"] = 10,
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 0,
						["Offset Y"] = -159.429077148438,
					},
					["Orientation"] = "HORIZONTAL",
					["Presets"] = {
					},
					["Size"] = 20,
				},
				["Vehicle Seat Indicator"] = {
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 100,
						["Offset Y"] = -100,
					},
				},
				["TargetTarget"] = {
					["Enabled"] = true,
					["Debuffs"] = {
						["Enabled"] = false,
						["Size"] = {
							["Height"] = 16,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 16,
						},
						["Style"] = "Bar",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Growth"] = "Upwards",
						["Attached"] = "TOP",
						["Whitelist"] = {
							["Enabled"] = false,
							["Ids"] = {
							},
						},
						["Blacklist"] = {
							["Enabled"] = true,
							["Ids"] = {
							},
						},
					},
					["Power"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Power",
						["Position"] = {
							["Relative To"] = "Health",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Orientation"] = "HORIZONTAL",
						["Size"] = {
							["Height"] = 5,
							["Match height"] = false,
							["Match width"] = false,
							["Width"] = 100,
						},
						["Reversed"] = false,
						["Texture"] = "Default2",
					},
					["Health"] = {
						["Enabled"] = true,
						["Custom Color"] = {
							1, -- [1]
							1, -- [2]
							1, -- [3]
						},
						["Background Multiplier"] = 0.33,
						["Color By"] = "Class",
						["Position"] = {
							["Relative To"] = "TargetTarget",
							["Point"] = "TOP",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = 0,
						},
						["Orientation"] = "HORIZONTAL",
						["Size"] = {
							["Height"] = 20,
							["Match height"] = false,
							["Match width"] = false,
							["Width"] = 100,
						},
						["Reversed"] = false,
						["Texture"] = "Default2",
					},
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 1654.99914550781,
						["Offset Y"] = -947.000549316406,
					},
					["Buffs"] = {
						["Enabled"] = false,
						["Size"] = {
							["Height"] = 16,
							["Match height"] = false,
							["Match width"] = true,
							["Width"] = 16,
						},
						["Style"] = "Bar",
						["Position"] = {
							["Relative To"] = "Parent",
							["Point"] = "BOTTOM",
							["Local Point"] = "TOP",
							["Offset X"] = 0,
							["Offset Y"] = -1,
						},
						["Growth"] = "Upwards",
						["Attached"] = "TOP",
						["Whitelist"] = {
							["Enabled"] = false,
							["Ids"] = {
							},
						},
						["Blacklist"] = {
							["Enabled"] = true,
							["Ids"] = {
							},
						},
					},
					["Background"] = {
						["Color"] = {
							0, -- [1]
							0, -- [2]
							0, -- [3]
						},
						["Offset"] = {
							["Top"] = -1,
							["Right"] = -1,
							["Left"] = -1,
							["Bottom"] = -1,
						},
						["Enabled"] = true,
					},
					["Tags"] = {
						["Name"] = {
							["Outline"] = "SHADOW",
							["Font"] = "NotoBold",
							["Position"] = {
								["Relative To"] = "Health",
								["Point"] = "LEFT",
								["Local Point"] = "LEFT",
								["Offset X"] = 5,
								["Offset Y"] = 0,
							},
							["Color"] = {
								1, -- [1]
								1, -- [2]
								1, -- [3]
							},
							["Text"] = "[name]",
							["Enabled"] = true,
							["Size"] = 10,
						},
						["Custom"] = {
						},
					},
					["Size"] = {
						["Height"] = 25,
						["Width"] = 100,
					},
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
				},
				["Pet Bar"] = {
					["Enabled"] = true,
					["Vertical Limit"] = 12,
					["Position"] = {
						["Relative To"] = "FrameParent",
						["Point"] = "TOPLEFT",
						["Local Point"] = "TOPLEFT",
						["Offset X"] = 757.999755859375,
						["Offset Y"] = -1415.99990844727,
					},
					["Icon Size"] = 24,
					["Horizontal Limit"] = 1,
				},
				["Key Bindings"] = {
					["SHIFT-BUTTON4"] = "CleanUI_ActionBar3Button6",
					["SHIFT-C"] = "CleanUI_ActionBar3Button4",
					["SHIFT-1"] = "CleanUI_ActionBar2Button1",
					["SHIFT-4"] = "CleanUI_ActionBar2Button4",
					["ALT-MOUSEWHEELDOWN"] = "CleanUI_ActionBar4Button5",
					["BUTTON5"] = "CleanUI_ActionBar3Button8",
					["1"] = "CleanUI_ActionBar1Button1",
					["SHIFT-MOUSEWHEELUP"] = "CleanUI_ActionBar4Button2",
					["3"] = "CleanUI_ActionBar1Button3",
					["SHIFT-X"] = "CleanUI_ActionBar4Button8",
					["5"] = "CleanUI_ActionBar1Button5",
					["4"] = "CleanUI_ActionBar1Button4",
					["7"] = "CleanUI_ActionBar1Button7",
					["6"] = "CleanUI_ActionBar1Button6",
					["9"] = "CleanUI_ActionBar1Button9",
					["8"] = "CleanUI_ActionBar1Button8",
					["SHIFT-F"] = "CleanUI_ActionBar3Button3",
					["SHIFT-R"] = "CleanUI_ActionBar2Button10",
					["E"] = "CleanUI_ActionBar3Button1",
					["CTRL-MOUSEWHEELDOWN"] = "CleanUI_ActionBar4Button3",
					["F"] = "CleanUI_ActionBar3Button2",
					["SHIFT-MOUSEWHEELDOWN"] = "CleanUI_ActionBar4Button1",
					["SHIFT-2"] = "CleanUI_ActionBar2Button2",
					["Q"] = "CleanUI_ActionBar2Button7",
					["R"] = "CleanUI_ActionBar2Button9",
					["ALT-MOUSEWHEELUP"] = "CleanUI_ActionBar4Button6",
					["SHIFT-Q"] = "CleanUI_ActionBar2Button8",
					["BUTTON4"] = "CleanUI_ActionBar3Button9",
					["SHIFT-Z"] = "CleanUI_ActionBar4Button7",
					["SHIFT-E"] = "CleanUI_ActionBar2Button5",
					["SHIFT-BUTTON5"] = "CleanUI_ActionBar3Button5",
					["CTRL-MOUSEWHEELUP"] = "CleanUI_ActionBar4Button4",
					["SHIFT-3"] = "CleanUI_ActionBar2Button3",
					["2"] = "CleanUI_ActionBar1Button2",
				},
			},
		},
	},
}
