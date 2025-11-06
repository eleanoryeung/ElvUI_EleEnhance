local EleE, _, E, L = unpack(select(2, ...))

local tinsert, format = tinsert, format

local function configTable()
    if not EleE.initialized then return end

	E.Options.args.elee = {
		type = "group",
		childGroups = "tab",
		name = EleE.Title,
		desc = L["Enhancements for |cff1784d1ElvUI|r"],

		order = 10,
		args = {
			header = E.Libs.ACH:Header("|cffffb6c1Eleanor's Enhancements|r", 1),
			modules = {
				order = 10,
				type = "group",
				name = L["Modules"],
				args = {
				},
			},
		},
	}
end

tinsert(EleE.Configs, configTable)