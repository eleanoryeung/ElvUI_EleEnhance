local EleE, _, E, L = unpack(select(2, ...))

local RB = EleE.RiderBar

local LSM = LibStub("LibSharedMedia-3.0")

local tinsert = tinsert


local RoleIconTextures = {
    SUNUI = {
        TANK = [[Interface\AddOns\ElvUI_EleEnhance\media\textures\SunUI\role_tank]],
        HEALER = [[Interface\AddOns\ElvUI_EleEnhance\media\textures\SunUI\role_healer]],
        DAMAGER = [[Interface\AddOns\ElvUI_EleEnhance\media\textures\SunUI\role_dps]],
    },
    LYNUI = {
        TANK = [[Interface\AddOns\ElvUI_EleEnhance\media\textures\LynUI\role_tank]],
        HEALER = [[Interface\AddOns\ElvUI_EleEnhance\media\textures\LynUI\role_healer]],
        DAMAGER = [[Interface\AddOns\ElvUI_EleEnhance\media\textures\LynUI\role_dps]],
    },
    AZUI = {
        TANK = [[Interface\AddOns\ElvUI_EleEnhance\media\textures\AzeriteUI\role_tank]],
        HEALER = [[Interface\AddOns\ElvUI_EleEnhance\media\textures\AzeriteUI\role_healer]],
        DAMAGER = [[Interface\AddOns\ElvUI_EleEnhance\media\textures\AzeriteUI\role_dps]],
    },
}

local SampleStrings = {}
do
    local icons = ""
    icons = "ElvUI "
    icons = icons .. "|T" .. E.Media.Textures.Tank .. ":16:16|t "
    icons = icons .. "|T" .. E.Media.Textures.Healer .. ":16:16|t "
    icons = icons .. "|T" .. E.Media.Textures.DPS .. ":16:16|t "
    SampleStrings.elvui = icons

    icons = "SunUI "
    icons = icons .. "|T" .. RoleIconTextures.SUNUI.TANK .. ":16:16|t "
    icons = icons .. "|T" .. RoleIconTextures.SUNUI.HEALER .. ":16:16|t "
    icons = icons .. "|T" .. RoleIconTextures.SUNUI.DAMAGER .. ":16:16|t"
    SampleStrings.sunui = icons

    icons = "LynUI"
    icons = icons .. "|T" .. RoleIconTextures.LYNUI.TANK .. ":16:16|t "
    icons = icons .. "|T" .. RoleIconTextures.LYNUI.HEALER .. ":16:16|t "
    icons = icons .. "|T" .. RoleIconTextures.LYNUI.DAMAGER .. ":16:16|t"
    SampleStrings.lynui = icons
    
    icons = "AzUI"
    icons = icons .. "|T" .. RoleIconTextures.AZUI.TANK .. ":16:16|t "
    icons = icons .. "|T" .. RoleIconTextures.AZUI.HEALER .. ":16:16|t "
    icons = icons .. "|T" .. RoleIconTextures.AZUI.DAMAGER .. ":16:16|t"
    SampleStrings.azui = icons
end


local function configTable()
    if not EleE.initialized then return end
    
    E.Options.args.elee.args.modules.args.misc = {
		type = "group",
		name = L["misc"],
		order = 10,
		args = {
            lfglist = {
                type = "group",
                name = L["LFGList"],
                order = 2,
                guiInline = true,
                get = function(info) return E.db.elee.misc.LFGlist[info[#info]] end,
                set = function(info, value) E.db.elee.misc.LFGlist[info[#info]] = value; E:StaticPopup_Show("GLOBAL_RL") end,
                args = {
                    enabled = {
                        order = 1,
                        type = "toggle",
                        name = L["Enabled"],
                    },
                    icon = {
                        order = 2,
                        type = "group",
                        name = L["Icon"],
                        disabled = function() return not E.db.elee.misc.LFGlist.enabled end,
                        get = function(info) return E.db.elee.misc.LFGlist.icon[info[#info]] end,
                        set = function(info, value) E.db.elee.misc.LFGlist.icon[info[#info]] = value E:StaticPopup_Show("PRIVATE_RL") end,
                        args = {
                            reskin = {
                                order = 1,
                                type = "toggle",
                                name = L["reskin_icon"],
                            },
                            pack = {
                                order = 2,
                                type = "select",
                                name = L["Style"],
                                hidden = function() return not E.db.elee.misc.LFGlist.icon.reskin end,
                                values = {
                                    SUNUI = SampleStrings.sunui,
                                    LYNUI = SampleStrings.lynui,
                                    AZUI = SampleStrings.azui,
                                    DEFAULT = SampleStrings.elvui
                                }
                            },
                            border = {
                                order = 3,
                                type = "toggle",
                                name = L["Border"]
                            },
                            size = {
                                order = 4,
                                type = "range",
                                name = L["Size"],
                                min = 1, max = 20, step = 1
                            },
                            alpha = {
                                order = 5,
                                type = "range",
                                name = L["Alpha"],
                                min = 0, max = 1, step = 0.01
                            },
                        }
                    },
                    line = {
                        order = 3,
                        type = "group",
                        name = L["lfg_line"],
                        disabled = function() return not E.db.elee.misc.LFGlist.enabled end,
                        get = function(info) return E.db.elee.misc.LFGlist.line[info[#info]] end,
                        set = function(info, value) E.db.elee.misc.LFGlist.line[info[#info]] = value E:StaticPopup_Show("PRIVATE_RL") end,
                        args = {
                            enabled = {
                                order = 1,
                                type = "toggle",
                                name = L["Enabled"],
                            },
                            tex = {
                                order = 2,
                                type = "select",
                                name = L["Texture"],
                                dialogControl = "LSM30_Statusbar",
                                values = LSM:HashTable("statusbar")
                            },
                            width = {
                                order = 3,
                                type = "range",
                                name = L["Width"],
                                min = 1, max = 20, step = 1
                            },
                            height = {
                                order = 4,
                                type = "range",
                                name = L["Height"],
                                min = 1, max = 20, step = 1
                            },
                            offsetX = {
                                order = 5,
                                type = "range",
                                name = L["X-Offset"],
                                min = -20, max = 20, step = 1
                            },
                            offsetY = {
                                order = 6,
                                type = "range",
                                name = L["Y-Offset"],
                                min = -20, max = 20, step = 1
                            },
                            alpha = {
                                order = 7,
                                type = "range",
                                name = L["Alpha"],
                                min = 0, max = 1, step = 0.01
                            }
                        }
                    }
                }
            },
            stealth = {
                type = "group",
                name = L["stealth_overlay"],
                order = 3,
                guiInline = true,
                get = function(info) return E.db.elee.misc.stealth[info[#info]] end,
                set = function(info, value) E.db.elee.misc.stealth[info[#info]] = value; E:StaticPopup_Show("GLOBAL_RL") end,
                args = {
					enabled = {
                        order = 1,
                        type = "toggle",
                        name = L["Enabled"],
                    }
                }
            },
            newsfix = {
                type = "group",
                name = L["guildnewsfix"],
                order = 15,
                guiInline = true,
                get = function(info) return E.db.elee.misc.newsfix[info[#info]] end,
                set = function(info, value) E.db.elee.misc.newsfix[info[#info]] = value; E:StaticPopup_Show("GLOBAL_RL") end,
                args = {
					enabled = {
                        order = 1,
                        type = "toggle",
                        name = L["Enabled"],
                    }
                }
            },
            name = {
                type = "group",
                name = L["friendly_name"],
                order = 4,
                guiInline = true,
                get = function(info) return E.db.elee.misc.name[info[#info]] end,
                set = function(info, value) E.db.elee.misc.name[info[#info]] = value; E:StaticPopup_Show("GLOBAL_RL") end,
                args = {
                    enabled = {
                        order = 1,
                        type = "toggle",
                        name = L["Enabled"],
                    },
                    font = {
                        order = 2,
                        type = 'select', dialogControl = 'LSM30_Font',
                        name = L['Font'],
                        values = LSM:HashTable('font'),
                    },
                    size = {
                        order = 3,
                        type = "range",
                        name = L["size"],
                        min = 5, max = 16, step = 1,
                    },
                }
            },
        }
    }
end

tinsert(EleE.Configs, configTable)