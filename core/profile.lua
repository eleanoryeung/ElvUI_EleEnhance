local EleE, T, E, L, V, P, G = unpack(select(2, ...))

P["elee"] = {
    ["chat"] = {
        ["ime"] = {
            ["enabled"] = true,
            ["no_backdrop"] = true,
            ["width"] = 200,
            ["label"] = {
                ["font"] = E.db.general.font,
                ["size"] = E.db.general.fontSize + 3,
				["style"] = "OUTLINE",
            },
            ["candidate"] = {
                ["font"] = E.db.general.font,
				["size"] = E.db.general.fontSize + 3,
				["style"] = "OUTLINE",
            }
        }
    },
    ["misc"] = {
        ["delete"] = {
            enabled = true,
            use_delete_key = true,
            click_button_delete = true,
            skip_confirm_delete = false,
        },
        ["LFGlist"] = {
            enabled = true,
            ["icon"] = {
                reskin = true,
			    pack = "DEFAULT",
			    size = 16,
			    border = false,
			    alpha = 1
            },
            ["line"] = {
                enabled = true,
                tex = "ElvUI Norm",
                width = 16, height = 3,
                offsetX = 0, offsetY = -1,
                alpha = 1
            },
        },
        ["stealth"] = {
            enabled = true
        },
        ["newsfix"] = {
            enabled = true
        },
        ["name"] = {
            enabled = true,
            font = E.db.general.font,
            size = 14,
        }
    },
    ["profdt"] = {
        enabled = true,
        showSkill = true,
        label = true,
    },
    ["interface"] = {
        ["riderbar"] = {
            enabled = true,
            scale = 1,
            Yoffset = 0,
        },
        ["microbar"] = {
            enabled = true,
            scale = 1,
            Yoffset = 0,
        },
        ["bagbar"] = {
            enabled = true,
            scale = 1,
            Yoffset = 0,
        },
        ["minimap"] = {
            enabled = true,
            skin = true,
            res = true,
            expand = true,
        },
    }
}