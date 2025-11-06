local EleE, _, E, L = unpack(select(2, ...))

local ACH = E.Libs.ACH

local tinsert = tinsert

local function configTable()
	if not EleE.initialized then return end

	E.Options.args.elee.args.modules.args.interface = {
		type = "group",
		name = L["interface"],
		order = 3,
		args = {
            bagbar = {
                order = 1, type= "group", name = L["bagbar"], guiInline = true,
                -- intro = ACH:Description(L["BBBB"], 0),
                get = function(info) return E.db.elee.interface.bagbar[info[#info]] end,
                set = function(info, value) E.db.elee.interface.bagbar[info[#info]] = value; E:StaticPopup_Show("GLOBAL_RL") end,
                args = {
                    desc = ACH:Description(L["BBBB"], 1),
                    enabled = {
                        order = 2, type = "toggle", name = L["Enabled"],
                    },
                },
            },
            minimap = {
                order = 2, type = "group", name = L["minimap"],
                guiInline = true,
                get = function(info) return E.db.elee.interface.minimap[info[#info]] end,
                set = function(info, value) E.db.elee.interface.minimap[info[#info]] = value; E:StaticPopup_Show("GLOBAL_RL") end,
                args = {
                    enabled = {
                        order = 1, type = "toggle", name = L["Enabled"],
                    },
                    skin = {
                        order = 2, type = "toggle", name = L["skin_minimap"],
                        disabled = function() return not E.db.elee.interface.minimap.enabled end,
                    },
                    res = {
                        order = 3, type = "toggle", name = L["ResTop"],
                        disabled = function() return not E.db.elee.interface.minimap.enabled end,
                    },
                    expand = {
                        order = 4, type = "toggle", name = L["ExpandTop"],
                        disabled = function() return not E.db.elee.interface.minimap.enabled or not E.db.elee.interface.minimap.res end,
                    },
                }
            },
            riderbar = {
                order = 3, type = "group", name = L["rider_bar"],
                guiInline = true,
                get = function(info) return E.db.elee.interface.riderbar[info[#info]] end,
                set = function(info, value) E.db.elee.interface.riderbar[info[#info]] = value; end,
                args = {
                    desc = ACH:Description(L["rider_bar_desc"], 1),
                    enabled = {
                        order = 2, type = "toggle", name = L["Enabled"],
                    },
                    scale = {
                        order = 3, type = "range", name = L["Scale"],
                        min = 0.5, max = 1.5, step = 0.05,
                    },
                    Yoffset = {
                        order = 4, type = "range", name = L["Y-Offset"],
                        min = -1500, max = 1000, step = 50,
                    }
                }
            },
		},
	}
end

tinsert(EleE.Configs, configTable)