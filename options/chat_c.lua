local EleE, _, E, L = unpack(select(2, ...))

local LSM = LibStub("LibSharedMedia-3.0")

local tinsert = tinsert

local function configTable()
	if not EleE.initialized then return end

	E.Options.args.elee.args.modules.args.chat = {
		type = "group",
		name = L["Chat"],
		order = 5,
		args = {
			ime = {
                type = "group",
                childGroups = "tab",
				name = L["ime"],
                order = 10,
                get = function(info) return E.db.elee.chat.ime[info[#info]] end,
                set = function(info, value) E.db.elee.chat.ime[info[#info]] = value; E:StaticPopup_Show("GLOBAL_RL") end,
				args = {
                    enabled = {
                        order = 1,
                        type = "toggle",
                        name = L["Enabled"],
                    },
					no_backdrop = {
                        order = 2,
                        type = "toggle",
                        name = L["no_backdrop"],
                    },
                    width = {
                        order = 3,
                        type = "range",
                        name = L["Width"],
                        desc = L["ime_width_desc"],
                        min = 100, max = 600, step = 1,
                    },
                    label = {
                        type = "group",
                        order = 4,
                        name = L["Label"],
                        guiInline = true,
                        get = function(info) return E.db.elee.chat.ime.label[info[#info]] end,
                        set = function(info, value) E.db.elee.chat.ime.label[info[#info]] = value end,
                        args = {
                            font = {
                                type = 'select', dialogControl = 'LSM30_Font',
                                order = 1,
                                name = L['Font'],
                                values = LSM:HashTable('font'),
                            },
                            size = {
                                order = 2,
                                type = "range",
                                name = L["Size"],
                                min = 6, max = 22, step = 1,
                            },
                            style = {
                                order = 3,
                                name = L["Style"],
                                type = 'select',
                                values = {
                                    ['NONE'] = L['None'],
                                    ['OUTLINE'] = L['OUTLINE'],
                                    ['MONOCHROME'] = L['MONOCHROME'],
                                    ['MONOCHROMEOUTLINE'] = L['MONOCROMEOUTLINE'],
                                    ['THICKOUTLINE'] = L['THICKOUTLINE'],
                                },
                            },
                        },
                    },
                    candidate = {
                        type = "group",
                        order = 5,
                        name = L["candidate"],
                        desc = L["ime_candidates"],
                        guiInline = true,
                        get = function(info) return E.db.elee.chat.ime.candidate[info[#info]] end,
                        set = function(info, value) E.db.elee.chat.ime.candidate[info[#info]] = value end,
                        args = {
                            font = {
                                type = 'select', dialogControl = 'LSM30_Font',
                                order = 1,
                                name = L['Font'],
                                values = LSM:HashTable('font'),
                            },
                            size = {
                                order = 2,
                                name = L['Size'],
                                type = 'range',
                                min = 6, max = 22, step = 1,
                            },
                            style = {
                                order = 3,
                                name = L["Style"],
                                type = 'select',
                                values = {
                                    ['NONE'] = L['None'],
                                    ['OUTLINE'] = L['OUTLINE'],
                                    ['MONOCHROME'] = L['MONOCHROME'],
                                    ['MONOCHROMEOUTLINE'] = L['MONOCROMEOUTLINE'],
                                    ['THICKOUTLINE'] = L['THICKOUTLINE'],
                                },
                            },
                        },
                    },
				},
			},
		},
	}
end

tinsert(EleE.Configs, configTable)