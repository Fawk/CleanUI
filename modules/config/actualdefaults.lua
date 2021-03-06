local A = unpack(select(2, ...))

local defaults = {
    profile = {
        units = {
        	player = {
                position = {
                    relative = "FrameParent",
                    point = "CENTER",
                    localPoint = "CENTER",
                    x = -266.735260009766,
                    y = -202.188110351563,
                },
        		health = {
        			enabled = true,
        			position = {
        				point = "TOP",
        				localPoint = "TOP",
        				x = 0,
        				y = 0,
        				relative = "Player"
        			},
        			size = {
        				matchWidth = true,
        				matchHeight = false,
        				width = 150,
        				height = 35
        			},
                    colorBy = "Gradient",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
                    mult = -1,
                    orientation = "HORIZONTAL",
                    reversed = false,
                    frequentUpdates = false,
                    texture = "Default",
                    missingBar = {
                        enabled = false,
                        customColor = { r = 0.5, g = 0.5, b = 0.5, a = 1 },
                        colorBy = "Custom",
                    }
        		},
        		power = {
        			enabled = true,
        			position = {
        				point = "BOTTOM",
        				localPoint = "TOP",
        				x = 0,
        				y = -1,
        				relative = "health"
        			},
        			size = {
        				matchWidth = true,
        				matchHeight = false,
        				width = 150,
        				height = 15
        			},
                    colorBy = "power",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
                    mult = -1,
                    orientation = "HORIZONTAL",
                    reversed = false,
                    texture = "Default",
                    missingBar = {
                        enabled = false,
                        customColor = { r = 0.5, g = 0.5, b = 0.5, a = 1 },
                        colorBy = "Custom",
                    }
        		},
        		buffs = {
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
                    x = 0,
                    y = 0,
                    spacingX = 1,
                    spacingY = 1,
                    iconLimit = 5,
                    iconTextSize = 10,
        			attached = true,
                    attachedPosition = "Above",
                    limit = 10,
                    hideNoDuration = true,
                    own = true,
                    colorBy = "Class",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
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
                        color = { r = 0, g = 0, b = 0, a = 1 },
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
                    x = 0,
                    y = 0,
                    spacingX = 1,
                    spacingY = 1,
                    iconLimit = 5,
                    iconTextSize = 10,
                    attached = true,
                    attachedPosition = "Above",
                    limit = 10,
                    own = false,
                    colorBy = "Class",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
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
                        color = { r = 0, g = 0, b = 0, a = 1 },
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
        		size = {
        			width = 200,
        			height = 50
        		},
                tags = {
                    list = {
                        name = {
                            format = "[name]",
                            size = 10,
                            localPoint = "TOPLEFT",
                            point = "TOPLEFT",
                            relative = "Parent",
                            x = 2,
                            y = -2,
                            hide = false
                        }
                    }
                },
                healPrediction = {
                    enabled = true,
                    texture = "Default",
                    overflow = 1,
                    colors = {
                        my = { r = 0, g = .827, b = .765, a = .5 },
                        all = { r = 0, g = .631, b = .557, a = .5 },
                        absorb = { r = .7, g = .7, b = 1, a = .5 },
                        healAbsorb = { r = .7, g = .7, b = 1, a = .5 }
                    }
                },
                background = {
                    color = { r = 0, g = 0, b = 0, a = 1 },
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
                        color = { r = 0, g = 0, b = 0, a = 1 },
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
                        height = 20,
                        matchWidth = true,
                        matchHeight = false,
                    },
                    texture = "Default",
                    mult = 0.3,
                    color = { r = 0.7, g = 0.5, b = 0.3, a = 1 }
                },
                runes = {
                    enabled = true,
                    position = {
                        relative = "FrameParent",
                        point = "CENTER",
                        localPoint = "CENTER",
                        x = 0,
                        y = 0, 
                    },
                    size = {
                        width = 200,
                        height = 20,
                        matchWidth = true,
                        matchHeight = false,
                    },
                    background = {
                        color = { r = 0, g = 0, b = 0, a = 1 },
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
                        relative = "FrameParent",
                        point = "CENTER",
                        localPoint = "CENTER",
                        x = 0,
                        y = 0, 
                    },
                    size = {
                        width = 200,
                        height = 20,
                        matchWidth = true,
                        matchHeight = false,
                    },
                    background = {
                        color = { r = 0, g = 0, b = 0, a = 1 },
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
                        relative = "FrameParent",
                        point = "CENTER",
                        localPoint = "CENTER",
                        x = 0,
                        y = 0, 
                    },
                    size = {
                        width = 200,
                        height = 20,
                        matchWidth = true,
                        matchHeight = false,
                    },
                    background = {
                        color = { r = 0, g = 0, b = 0, a = 1 },
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
                        relative = "FrameParent",
                        point = "CENTER",
                        localPoint = "CENTER",
                        x = 0,
                        y = 0, 
                    },
                    size = {
                        width = 200,
                        height = 20,
                        matchWidth = true,
                        matchHeight = false,
                    },
                    background = {
                        color = { r = 0, g = 0, b = 0, a = 1 },
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
                        relative = "FrameParent",
                        point = "CENTER",
                        localPoint = "CENTER",
                        x = 0,
                        y = 0, 
                    },
                    size = {
                        width = 200,
                        height = 20,
                        matchWidth = true,
                        matchHeight = false,
                    },
                    background = {
                        color = { r = 0, g = 0, b = 0, a = 1 },
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
                        relative = "FrameParent",
                        point = "CENTER",
                        localPoint = "CENTER",
                        x = 0,
                        y = 0, 
                    },
                    size = {
                        width = 200,
                        height = 20,
                        matchWidth = true,
                        matchHeight = false,
                    },
                    background = {
                        color = { r = 0, g = 0, b = 0, a = 1 },
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
                        customColor = { r = .5, g = .5, b = .5, a = 1 },
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
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
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
                            color = { r = 0, g = 0, b = 0, a = 1 },
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
                        color = { r = 0, g = 0, b = 0, a = 1 },
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
                        point = "CENTER",
                        localPoint = "CENTER",
                        x = 0,
                        y = 0, 
                    },
                    size = {
                        matchWidth = true,
                        matchHeight = false,
                        width = 150,
                        height = 15
                    },
                    background = {
                        color = { r = 0, g = 0, b = 0, a = 1 },
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
                        high = { r = .7, g = 0, b = 0, a = 1 },
                        medium = { r = .5, g = .5, b = 0, a = 1 },
                        low = { r = 0, g = .7, b = 0, a = 1}
                    },
                    mult = 0.33,
                    attachedPosition = "Below",
                    afterChi = true,
                    attached = true
                },
                combat = {
                    enabled = true,
                    style = "Letter",
                    fontSize = 10,
                    size = 24,
                    color = { r = 1, g = 0.8, b = 0, a = 1 },
                    position = {
                        relative = "Parent",
                        point = "TOPLEFT",
                        localPoint = "TOPLEFT",
                        x = 2,
                        y = -2
                    }
                },
                clickcast = {
                    enabled = true,
                    actions = {}
                },
        		enabled = true
        	},
        	target = {
                position = {
                    relative = "FrameParent",
                    point = "CENTER",
                    localPoint = "CENTER",
                    x = 265.640625,
                    y = -202.187973022461,
                },
        		health = {
        			enabled = true,
        			position = {
        				point = "TOP",
        				localPoint = "TOP",
        				x = 0,
        				y = 0,
        				relative = "Target"
        			},
        			size = {
        				matchWidth = true,
        				matchHeight = false,
        				width = 250,
        				height = 35
        			},
                    colorBy = "Class",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
                    mult = 0.33,
                    orientation = "HORIZONTAL",
                    reversed = false,
                    frequentUpdates = false,            
                    texture = "Default",
                    missingBar = {
                        enabled = false,
                        customColor = {
                            0.5, -- [1]
                            0.5, -- [2]
                            0.5, -- [3]
                            1, -- [4]
                        },
                        colorBy = "Custom",
                    }
        		},
        		power = {
        			enabled = true,
        			position = {
        				point = "BOTTOM",
        				localPoint = "TOP",
        				x = 0,
        				y = -1,
        				relative = "health"
        			},
        			size = {
        				matchWidth = true,
        				matchHeight = false,
        				width = 250,
        				height = 15
        			},
                    colorBy = "power",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
                    mult = 0.33,
                    orientation = "HORIZONTAL",
                    reversed = false,
                    texture = "Default",
                    missingBar = {
                        enabled = false,
                        customColor = { r = .5, g = .5, b = .5, a = 1 },
                        colorBy = "Custom",
                    }
        		},
                buffs = {
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
                    x = 0,
                    y = 0,
                    spacingX = 1,
                    spacingY = 1,
                    iconLimit = 5,
                    iconTextSize = 10,
                    attached = true,
                    attachedPosition = "Above",
                    limit = 10,
                    hideNoDuration = true,
                    own = true,
                    colorBy = "Class",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
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
                        color = { r = 0, g = 0, b = 0, a = 1 },
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
                    x = 0,
                    y = 0,
                    spacingX = 1,
                    spacingY = 1,
                    iconLimit = 5,
                    iconTextSize = 10,
                    attached = true,
                    attachedPosition = "Above",
                    limit = 10,
                    own = false,
                    colorBy = "Class",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
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
                        color = { r = 0, g = 0, b = 0, a = 1 },
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
        		size = {
        			width = 200,
        			height = 50
        		},
        		tags = {
                    list = {
                        name = {
                            format = "[name]",
                            size = 10,
                            localPoint = "TOPLEFT",
                            point = "TOPLEFT",
                            relative = "Parent",
                            x = 2,
                            y = -2,
                            hide = false
                        }
                    }
                },
                healPrediction = {
                    enabled = true,
                    texture = "Default",
                    overflow = 1,
                    colors = {
                        my = { r = 0, g = .827, b = .765, a = .5 },
                        all = { r = 0, g = .631, b = .557, a = .5 },
                        absorb = { r = .7, g = .7, b = 1, a = .5 },
                        healAbsorb = { r = .7, g = .7, b = 1, a = .5 }
                    }
                },
                background = {
                    color = { r = 0, g = 0, b = 0, a = 1 },
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
                castbar = {
                    enabled = true,
                    missingBar = {
                        enabled = false,
                        customColor = { r = .5, g = .5, b = .5, a = 1 },
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
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
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
                            color = { r = 0, g = 0, b = 0, a = 1 },
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
                        }
                    },
                    background = {
                        color = { r = 0, g = 0, b = 0, a = 1 },
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
                clickcast = {
                    enabled = true,
                    actions = {}
                },
                enabled = true
        	},
            targettarget = {
                clickcast = {
                    enabled = true,
                    actions = {}
                },
                position = {
                    relative = "FrameParent",
                    point = "CENTER",
                    localPoint = "CENTER",
                    x = 400,
                    y = 0,
                },
                castbar = {
                    enabled = true,
                    missingBar = {
                        enabled = false,
                        customColor = { r = .5, g = .5, b = .5, a = 1 },
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
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
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
                            color = { r = 0, g = 0, b = 0, a = 1 },
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
                        color = { r = 0, g = 0, b = 0, a = 1 },
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
                    x = 0,
                    y = 0
                },
                healPrediction = {
                    enabled = true,
                    texture = "Default",
                    overflow = 1,
                    colors = {
                        my = { r = 0, g = .827, b = .765, a = .5 },
                        all = { r = 0, g = .631, b = .557, a = .5 },
                        absorb = { r = .7, g = .7, b = 1, a = .5 },
                        healAbsorb = { r = .7, g = .7, b = 1, a = .5 }
                    }
                },
                health = {
                    enabled = true,
                    position = {
                        point = "TOP",
                        localPoint = "TOP",
                        x = 0,
                        y = 0,
                        relative = "Target of Target"
                    },
                    size = {
                        matchWidth = false,
                        matchHeight = false,
                        width = 100,
                        height = 20
                    },
                    colorBy = "Class",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
                    mult = 0.33,
                    orientation = "HORIZONTAL",
                    reversed = false,
                    frequentUpdates = false,
                    texture = "Default",
                    missingBar = {
                        enabled = false,
                        customColor = { r = .5, g = .5, b = .5, a = 1 },
                        colorBy = "Custom",
                    }
                },
                power = {
                    enabled = true,
                    position = {
                        point = "BOTTOM",
                        localPoint = "TOP",
                        x = 0,
                        y = -1,
                        relative = "health"
                    },
                    size = {
                        matchWidth = false,
                        matchHeight = false,
                        width = 100,
                        height = 5
                    },
                    colorBy = "Power",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
                    mult = 0.33,
                    orientation = "HORIZONTAL",
                    reversed = false,
                    texture = "Default",
                    missingBar = {
                        enabled = false,
                        customColor = { r = .5, g = .5, b = .5, a = 1 },
                        colorBy = "Custom",
                    }
                },
                buffs = {
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
                    x = 0,
                    y = 0,
                    spacingX = 1,
                    spacingY = 1,
                    iconLimit = 5,
                    iconTextSize = 10,
                    attached = true,
                    attachedPosition = "Above",
                    limit = 10,
                    hideNoDuration = true,
                    own = true,
                    colorBy = "Class",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
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
                        color = { r = 0, g = 0, b = 0, a = 1 },
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
                    x = 0,
                    y = 0,
                    spacingX = 1,
                    spacingY = 1,
                    iconLimit = 5,
                    iconTextSize = 10,
                    attached = true,
                    attachedPosition = "Above",
                    limit = 10,
                    own = false,
                    colorBy = "Class",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
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
                        color = { r = 0, g = 0, b = 0, a = 1 },
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
                size = {
                    width = 100,
                    height = 26
                },
                tags = {
                    list = {
                        name = {
                            format = "[name]",
                            size = 10,
                            localPoint = "TOPLEFT",
                            point = "TOPLEFT",
                            relative = "Parent",
                            x = 2,
                            y = -2,
                            hide = false
                        }
                    }
                },
                background = {
                    color = { r = 0, g = 0, b = 0, a = 1 },
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
                enabled = true
            },
            pet = {
                clickcast = {
                    enabled = true,
                    actions = {}
                },
                position = {
                    relative = "FrameParent",
                    point = "CENTER",
                    localPoint = "CENTER",
                    x = -465.640625,
                    y = -500.187973022461,
                },
                health = {
                    enabled = true,
                    position = {
                        point = "TOP",
                        localPoint = "TOP",
                        x = 0,
                        y = 0,
                        relative = "Pet"
                    },
                    size = {
                        matchWidth = true,
                        matchHeight = false,
                        width = 150,
                        height = 15
                    },
                    colorBy = "Class",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
                    mult = 0.33,
                    orientation = "HORIZONTAL",
                    reversed = false,
                    frequentUpdates = false,
                    texture = "Default",
                    missingBar = {
                        enabled = false,
                        customColor = { r = .5, g = .5, b = .5, a = 1 },
                        colorBy = "Custom",
                    }
                },
                power = {
                    enabled = true,
                    position = {
                        point = "BOTTOM",
                        localPoint = "TOP",
                        x = 0,
                        y = -1,
                        relative = "health"
                    },
                    size = {
                        matchWidth = true,
                        matchHeight = false,
                        width = 250,
                        height = 5
                    },
                    colorBy = "Power",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
                    mult = 0.33,
                    orientation = "HORIZONTAL",
                    reversed = false,
                    texture = "Default",
                    missingBar = {
                        enabled = false,
                        customColor = { r = .5, g = .5, b = .5, a = 1 },
                        colorBy = "Custom",
                    }
                },
                buffs = {
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
                    x = 0,
                    y = 0,
                    spacingX = 1,
                    spacingY = 1,
                    iconLimit = 5,
                    iconTextSize = 10,
                    attached = true,
                    attachedPosition = "Above",
                    limit = 10,
                    hideNoDuration = true,
                    own = true,
                    colorBy = "Class",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
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
                        color = { r = 0, g = 0, b = 0, a = 1 },
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
                    x = 0,
                    y = 0,
                    spacingX = 1,
                    spacingY = 1,
                    iconLimit = 5,
                    iconTextSize = 10,
                    attached = true,
                    attachedPosition = "Above",
                    limit = 10,
                    own = false,
                    colorBy = "Class",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
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
                        color = { r = 0, g = 0, b = 0, a = 1 },
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
                size = {
                    width = 200,
                    height = 21
                },
                tags = {
                    list = {
                        name = {
                            format = "[name]",
                            size = 10,
                            localPoint = "TOPLEFT",
                            point = "TOPLEFT",
                            relative = "Parent",
                            x = 2,
                            y = -2,
                            hide = false
                        }
                    }
                },
                healPrediction = {
                    enabled = true,
                    texture = "Default",
                    overflow = 1,
                    colors = {
                        my = { r = 0, g = .827, b = .765, a = .5 },
                        all = { r = 0, g = .631, b = .557, a = .5 },
                        absorb = { r = .7, g = .7, b = 1, a = .5 },
                        healAbsorb = { r = .7, g = .7, b = 1, a = .5 }
                    }
                },
                background = {
                    color = { r = 0, g = 0, b = 0, a = 1 },
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
                castbar = {
                    enabled = true,
                    missingBar = {
                        enabled = false,
                        customColor = { r = .5, g = .5, b = .5, a = 1 },
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
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
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
                            color = { r = 0, g = 0, b = 0, a = 1 },
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
                        color = { r = 0, g = 0, b = 0, a = 1 },
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
                enabled = true
            },
            boss = {
                clickcast = {
                    enabled = true,
                    actions = {}
                },
                position = {
                    relative = "FrameParent",
                    point = "TOPRIGHT",
                    localPoint = "TOPRIGHT",
                    x = -250,
                    y = -200
                },
                size = {
                    width = 150,
                    height = 50
                },
                health = {
                    enabled = true,
                    position = {
                        point = "TOP",
                        localPoint = "TOP",
                        x = 0,
                        y = 0,
                        relative = "Parent"
                    },
                    size = {
                        matchWidth = true,
                        matchHeight = false,
                        width = 150,
                        height = 35
                    },
                    colorBy = "Gradient",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
                    mult = 0.33,
                    orientation = "HORIZONTAL",
                    reversed = false,
                    frequentUpdates = false,
                    texture = "Default",
                    missingBar = {
                        enabled = false,
                        customColor = { r = .5, g = .5, b = .5, a = 1 },
                        colorBy = "Custom",
                    }
                },
                power = {
                    enabled = true,
                    position = {
                        point = "BOTTOM",
                        localPoint = "TOP",
                        x = 0,
                        y = -1,
                        relative = "health"
                    },
                    size = {
                        matchWidth = true,
                        matchHeight = false,
                        width = 150,
                        height = 15
                    },
                    colorBy = "power",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
                    mult = 0.33,
                    orientation = "HORIZONTAL",
                    reversed = false,
                    texture = "Default",
                    missingBar = {
                        enabled = false,
                        customColor = { r = .5, g = .5, b = .5, a = 1 },
                        colorBy = "Custom",
                    }
                },
                orientation = "VERTICAL",
                tags = {
                    list = {
                        name = {
                            format = "[name]",
                            size = 10,
                            localPoint = "TOPLEFT",
                            point = "TOPLEFT",
                            relative = "Parent",
                            x = 2,
                            y = -2,
                            hide = false
                        }
                    }
                },
                x = 2,
                y = 0,
                highlight = true,
                background = {
                    color = { r = 0, g = 0, b = 0, a = 1 },
                    offset = {
                        top = 1,
                        bottom = 1,
                        left = 1,
                        right = 1
                    },
                    size = 3,
                    enabled = true,
                },
                castbar = {
                    enabled = true,
                    missingBar = {
                        enabled = false,
                        customColor = { r = .5, g = .5, b = .5, a = 1 },
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
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
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
                            color = { r = 0, g = 0, b = 0, a = 1 },
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
                        }
                    },
                    background = {
                        color = { r = 0, g = 0, b = 0, a = 1 },
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
                enabled = true
            },
        },
        group = {
            party = {
                clickcast = {
                    enabled = true,
                    actions = {}
                },
                status = {
                    range = {
                        action = "Modify",
                        settings = {
                            present = "None",
                            modify = "Alpha",
                            alpha = 50,
                            color = { r = 1, g = 1, b = 1, a = 1 },
                            iconSize = 16,
                            icon = nil,
                            size = 10,
                            position = {
                                point = "TOPLEFT",
                                localPoint = "TOPLEFT",
                                x = 2,
                                y = -2,
                            },
                        }
                    },
                    dead = {
                        action = "Present",
                        settings = {
                            present = "Text",
                            modify = "None",
                            alpha = 100,
                            color = { r = 0.7, g = 0, b = 0, a = 1 },
                            iconSize = 16,
                            icon = nil,
                            size = 10,
                            position = {
                                point = "TOPLEFT",
                                localPoint = "TOPLEFT",
                                x = 2,
                                y = -2,
                            },
                        }
                    },
                    offline = {
                        action = "Present",
                        settings = {
                            present = "Text",
                            modify = "None",
                            alpha = 100,
                            color = { r = 0.7, g = 0, b = 0, a = 1 },
                            iconSize = 16,
                            icon = nil,
                            size = 10,
                            position = {
                                point = "TOPLEFT",
                                localPoint = "TOPLEFT",
                                x = 2,
                                y = -2,
                            },
                        }
                    },
                    ghost = {
                        action = "Present",
                        settings = {
                            present = "Text",
                            modify = "None",
                            alpha = 100,
                            color = { r = 1, g = 0.8, b = 0, a = 1 },
                            iconSize = 16,
                            icon = nil,
                            size = 10,
                            position = {
                                point = "TOPLEFT",
                                localPoint = "TOPLEFT",
                                x = 2,
                                y = -2,
                            },
                        }
                    }
                },
                position = {
                    relative = "FrameParent",
                    point = "CENTER",
                    localPoint = "CENTER",
                    x = -1.29987347126007,
                    y = -201.094223022461,
                },
                health = {
                    enabled = true,
                    position = {
                        point = "TOP",
                        localPoint = "TOP",
                        x = 0,
                        y = 0,
                        relative = "Parent"
                    },
                    size = {
                        matchWidth = true,
                        matchHeight = false,
                        width = 64,
                        height = 41
                    },
                    colorBy = "Gradient",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
                    mult = 0.33,
                    orientation = "VERTICAL",
                    reversed = false,
                    frequentUpdates = true,
                    texture = "Default",
                    missingBar = {
                        enabled = false,
                        customColor = { r = .5, g = .5, b = .5, a = 1 },
                        colorBy = "Custom",
                    },
                    frequentUpdates = true
                },
                power = {
                    enabled = true,
                    position = {
                        point = "BOTTOM",
                        localPoint = "TOP",
                        x = 0,
                        y = -1,
                        relative = "health"
                    },
                    size = {
                        matchWidth = true,
                        matchHeight = false,
                        width = 64,
                        height = 5
                    },
                    colorBy = "power",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
                    mult = 0.33,
                    orientation = "HORIZONTAL",
                    reversed = false,
                    texture = "Default",
                    missingBar = {
                        enabled = false,
                        customColor = { r = .5, g = .5, b = .5, a = 1 },
                        colorBy = "Custom",
                    }
                },
                size = {
                    width = 63,
                    height = 47
                },
                orientation = "HORIZONTAL",
                growth = "Right",
                tags = {
                    list = {
                        name = {
                            format = "[name:4]",
                            size = 10,
                            localPoint = "BOTTOMLEFT",
                            point = "BOTTOMLEFT",
                            relative = "Parent",
                            x = 2,
                            y = 2,
                            hide = false
                        }
                    }
                },
                groupbuffs = {
                    tracked = {
                    },
                    enabled = true
                },
                healPrediction = {
                    enabled = true,
                    texture = "Default",
                    overflow = 1,
                    colors = {
                        my = { r = 0, g = .827, b = .765, a = .5 },
                        all = { r = 0, g = .631, b = .557, a = .5 },
                        absorb = { r = .7, g = .7, b = 1, a = .5 },
                        healAbsorb = { r = .7, g = .7, b = 1, a = .5 }
                    }
                },
                x = 2,
                y = 0,
                showPlayer = true,
                visibility = "[@party1,exists] show; hide",
                groupBy = "Role",
                alphabetically = true,
                sortDirection = "ASC",
                role = {
                    position = {
                        point = "TOPLEFT",
                        localPoint = "TOPLEFT",
                        x = 2,
                        y = -2,
                        relative = "Parent"    
                    },
                    size = 20,
                    style = "Letter",
                    textSize = 10,
                    color = { r = 1, g = 1, b = 1, a = 1 },
                    textStyle = "Outline",
                    texture = nil,
                    enabled = true
                },
                background = {
                    color = { r = 0, g = 0, b = 0, a = 1 },
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
                border = {
                    enabled = true,
                    highlight = true,
                    targetColor = { r = 1, g = 1, b = 1, a = 1 },
                    debuff = true,
                    debuffOrder = { "Magic", "Disease", "Curse", "Poison" }
                },
                enabled = true
            },
            raid = {
                clickcast = {
                    enabled = true,
                    actions = {}
                },
                visibility = "[@raid1,exists] show; hide",
                groupBy = "Role",
                alphabetically = true,
                sortDirection = "ASC",
                maxColumns = 5,
                status = {
                    range = {
                        action = "Modify",
                        settings = {
                            present = "None",
                            modify = "Alpha",
                            alpha = 50,
                            color = { r = 1, g = 1, b = 1, a = 1 },
                            iconSize = 16,
                            icon = nil,
                            size = 10,
                            position = {
                                point = "TOPLEFT",
                                localPoint = "TOPLEFT",
                                x = 2,
                                y = -2,
                            },
                        }
                    },
                    dead = {
                        action = "Present",
                        settings = {
                            present = "Text",
                            modify = "None",
                            alpha = 100,
                            color = { r = 0.7, g = 0, b = 0, a = 1 },
                            iconSize = 16,
                            icon = nil,
                            size = 10,
                            position = {
                                point = "TOPLEFT",
                                localPoint = "TOPLEFT",
                                x = 2,
                                y = -2,
                            },
                        }
                    },
                    offline = {
                        action = "Present",
                        settings = {
                            present = "Text",
                            modify = "None",
                            alpha = 100,
                            color = { r = 0.7, g = 0, b = 0, a = 1 },
                            iconSize = 16,
                            icon = nil,
                            size = 10,
                            position = {
                                point = "TOPLEFT",
                                localPoint = "TOPLEFT",
                                x = 2,
                                y = -2,
                            },
                        }
                    },
                    ghost = {
                        action = "Present",
                        settings = {
                            present = "Text",
                            modify = "None",
                            alpha = 100,
                            color = { r = 1, g = 0.8, b = 0, a =1 },
                            iconSize = 16,
                            icon = nil,
                            size = 10,
                            position = {
                                point = "TOPLEFT",
                                localPoint = "TOPLEFT",
                                x = 2,
                                y = -2,
                            },
                        }
                    }
                },
                position = {
                    relative = "FrameParent",
                    point = "TOPLEFT",
                    localPoint = "TOPLEFT",
                    x = 1117.7001953125,
                    y = -899.094360351563,
                },
                health = {
                    enabled = true,
                    position = {
                        point = "TOP",
                        localPoint = "TOP",
                        x = 0,
                        y = 0,
                        relative = "Parent"
                    },
                    size = {
                        matchWidth = true,
                        matchHeight = false,
                        width = 64,
                        height = 41
                    },
                    colorBy = "Gradient",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
                    mult = 0.33,
                    orientation = "VERTICAL",
                    reversed = false,
                    frequentUpdates = false,
                    texture = "Default",
                    missingBar = {
                        enabled = false,
                        customColor = { r = .5, g = .5, b = .5, a = 1 },
                        colorBy = "Custom",
                    },
                    frequentUpdates = true
                },
                power = {
                    enabled = true,
                    position = {
                        point = "BOTTOM",
                        localPoint = "TOP",
                        x = 0,
                        y = -1,
                        relative = "health"
                    },
                    size = {
                        matchWidth = true,
                        matchHeight = false,
                        width = 64,
                        height = 5
                    },
                    colorBy = "Power",
                    customColor = { r = 1, g = 1, b = 1, a = 1 },
                    mult = 0.33,
                    orientation = "HORIZONTAL",
                    reversed = false,
                    texture = "Default",
                    missingBar = {
                        enabled = false,
                        customColor = { r = .5, g = .5, b = .5, a = 1 },
                        colorBy = "Custom",
                    }
                },
                size = {
                    width = 63,
                    height = 47
                },
                growth = "Right Then Down",
                tags = {
                    name = {
                        format = "[name]",
                        size = 10,
                        localPoint = "TOPLEFT",
                        point = "TOPLEFT",
                        relative = "Parent",
                        x = 2,
                        y = -2,
                        hide = false
                    }
                },
                groupbuffs = {
                    tracked = {},
                    enabled = true
                },
                healPrediction = {
                    enabled = true,
                    texture = "Default",
                    overflow = 1,
                    colors = {
                        my = { r = 0, g = .827, b = .765, a = .5 },
                        all = { r = 0, g = .631, b = .557, a = .5 },
                        absorb = { r = .7, g = .7, b = 1, a = .5 },
                        healAbsorb = { r = .7, g = .7, b = 1, a = .5 }
                    }
                },
                x = 2,
                y = 2,
                showPlayer = true,
                highlight = true,
                debuff = true,
                debuffOrder = { "Magic", "Disease", "Curse", "Poison" },
                role = {
                    position = {
                        point = "TOPLEFT",
                        localPoint = "TOPLEFT",
                        x = 2,
                        y = -2,
                        relative = "Parent"    
                    },
                    size = 20,
                    style = "Letter",
                    textSize = 10,
                    color = { r = 1, g = 1, b = 1, a = 1 },
                    textStyle = "Outline",
                    texture = nil,
                    enabled = true
                },
                background = {
                    color = { r = 0, g = 0, b = 0, a = 1 },
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
                border = {
                    enabled = true,
                    highlight = true,
                    targetColor = { r = 1, g = 1, b = 1, a = 1 },
                    debuff = true,
                    debuffOrder = { "Magic", "Disease", "Curse", "Poison" }
                },
                enabled = true
            },
        },
        general = {
        	minimap = {
        		size = 200,
        		position = {
        			point = "TOPRIGHT",
        			localPoint = "TOPRIGHT",
        			x = 0,
        			y = 0,
        			relative = "FrameParent"
        		}
        	},
            vehicle = {
                position = {
                    point = "TOPLEFT",
                    localPoint = "TOPLEFT",
                    x = 100,
                    y = -100,
                    relative = "FrameParent"
                }
            },
            objectiveTracker = {
                position = {
                    point = "TOPRIGHT",
                    localPoint = "TOPRIGHT",
                    x = -10,
                    y = -300,
                    relative = "FrameParent"
                },
                size = {
                    width = 250,
                    height = 800
                }
            },
        	chat = {
        	},
            extraActionButton = {
                position = {
                    relative = "FrameParent",
                    point = "BOTTOM",
                    localPoint = "BOTTOM",
                    x = -6.56422424316406,
                    y = 144.222183227539,
                },
            },
            infoField = {
                enabled = true,
                limit = 10,
                size = 20,
                growth = "Right",
                orientation = "HORIZONTAL",
                position = {
                    relative = "FrameParent",
                    point = "CENTER",
                    localPoint = "CENTER",
                    x = 3.4875648021698,
                    y = -158.936065673828,
                },
                presets = {}
            },
            actionbars = {
               enabled = true,
               grid = true,
               bars = {
                    bar1 = {
                        position = {
                            point = "BOTTOM",
                            localPoint = "BOTTOM",
                            x = 0,
                            y = 0
                        },
                        orientation = "HORIZONTAL",
                        x = 0,
                        y = 0,
                        verticalLimit = 1,
                        horizontalLimit = 12,
                        size = 24,
                    },
                    bar2 = {
                        position = {
                            point = "BOTTOM",
                            localPoint = "BOTTOM",
                            x = 0,
                            y = 16
                        },
                        orientation = "HORIZONTAL",
                        x = 0,
                        y = 0,
                        verticalLimit = 1,
                        horizontalLimit = 12,
                        size = 24,
                    },
                    bar3 = {
                        position = {
                            point = "BOTTOM",
                            localPoint = "BOTTOM",
                            x = 0,
                            y = 32
                        },
                        orientation = "HORIZONTAL",
                        x = 0,
                        y = 0,
                        verticalLimit = 1,
                        horizontalLimit = 12,
                        size = 24,
                    },
                    bar4 = {
                        position = {
                            point = "BOTTOM",
                            localPoint = "BOTTOM",
                            x = 0,
                            y = 48
                        },
                        orientation = "HORIZONTAL",
                        x = 0,
                        y = 0,
                        verticalLimit = 1,
                        horizontalLimit = 12,
                        size = 24,
                    },
                    bar5 = {
                        position = {
                            point = "BOTTOM",
                            localPoint = "BOTTOM",
                            x = 0,
                            y = 64
                        },
                        orientation = "HORIZONTAL",
                        x = 0,
                        y = 0,
                        verticalLimit = 1,
                        horizontalLimit = 12,
                        size = 24,
                    }
                }
            },
            microBar = {
                enabled = true,
                position = {
                    point = "BOTTOMRIGHT",
                    localPoint = "BOTTOMRIGHT",
                    x = -200,
                    y = 0,
                },
                hide = false,
            },
            bagBar = {
                enabled = true,
                position = {
                    point = "BOTTOMRIGHT",
                    localPoint = "BOTTOMRIGHT",
                    x = 0,
                    y = 0,
                },
                hide = false,
            },
            overrideBar = {
                enabled = true,
                position = {
                    point = "TOPLEFT",
                    localPoint = "TOPLEFT",
                    x = 0,
                    y = 0,
                }
            },
            stanceBar = {
                enabled = true,
                position = {
                    point = "TOPLEFT",
                    localPoint = "TOPLEFT",
                    x = 0,
                    y = 0,
                }
            },
            petBar = {
                enabled = true,
                position = {
                    relative = "FrameParent",
                    point = "TOPLEFT",
                    localPoint = "TOPLEFT",
                    x = 850,
                    y = -50,
                },
                iconSize = 24,
                verticalLimit = 1,
                horizontalLimit = 12,
                background = {
                    color = { r = 0, g = 0, b = 0, a = 1 },
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
            experience = {
                enabled = true,
                position = {
                    relative = "FrameParent",
                    point = "TOPLEFT",
                    localPoint = "TOPLEFT",
                    x = 500,
                    y = -50,
                },
                background = {
                    color = { r = 0, g = 0, b = 0, a = 1 },
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
                size = {
                    width = 250,
                    height = 25
                },
                mult = 0.33,
                orientation = "HORIZONTAL",
                reversed = false,
                texture = "Default",
                color = { r = 0.8, g = 0, b = 0.4, a = 1 }
            },
            reputation = {
                enabled = true,
                position = {
                    relative = "FrameParent",
                    point = "TOPLEFT",
                    localPoint = "TOPLEFT",
                    x = 500,
                    y = -250,
                },
                background = {
                    color = { r = 0, g = 0, b = 0, a = 1 },
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
                size = {
                    width = 500,
                    height = 25
                },
                mult = 0.33,
                orientation = "HORIZONTAL",
                reversed = false,
                texture = "Default"
            },
            artifact = {
                enabled = true,
                position = {
                    relative = "FrameParent",
                    point = "TOPLEFT",
                    localPoint = "TOPLEFT",
                    x = 500,
                    y = -50,
                },
                background = {
                    color = { r = 0, g = 0, b = 0, a = 1 },
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
                size = {
                    width = 500,
                    height = 25
                },
                mult = 0.33,
                orientation = "HORIZONTAL",
                reversed = false,
                texture = "Default",
                color = { r = 0.90196, g = 0.8, b = 0.50196, a = 1 }
            },
            vehicleLeaveButton = {
                enabled = true,
                position = {
                    relative = "FrameParent",
                    point = "TOPLEFT",
                    localPoint = "TOPLEFT",
                    x = 1200,
                    y = -500,
                },
                background = {
                    color = { r = 0, g = 0, b = 0, a = 1 },
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
                size = 48,
            },
            characterInfo = {
                enabled = true,
                position = {
                    relative = "FrameParent",
                    point = "TOPLEFT",
                    localPoint = "TOPLEFT",
                    x = 100,
                    y = -500,
                },
            }
        }
    }
}

A.actualDefaults = defaults