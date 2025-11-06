local EleE, _, E, L = unpack(select(2, ...))

local DT = E.DataTexts
local LSM = LibStub("LibSharedMedia-3.0")

local tinsert = tinsert

local function configTable()
	if not EleE.initialized then return end

	E.Options.args.elee.args.modules.args.datatext = {
		type = "group",
		name = L["datatext"],
		order = 9,
		args = {
			profdt = {
                type = "group",
                childGroups = "tab",
				name = L["profdt"],
                order = 10,
                get = function(info) return E.db.elee.profdt[info[#info]] end,
                set = function(info, value) E.db.elee.profdt[info[#info]] = value; DT:ForceUpdate_DataText("Professions DataText") end,
				args = {
					enabled = {
                        order = 1,
                        type = "toggle",
                        name = L["Enabled"],
                    },
                    showSkill = {
                        order = 2,
                        type = "toggle",
                        name = L["showSkill"],
                    },
                    label = {
                        order = 3,
                        type = "toggle",
                        name = L["showHint"],
                    },
				},
			},
		},
	}
end

tinsert(EleE.Configs, configTable)