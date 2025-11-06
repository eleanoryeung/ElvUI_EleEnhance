local EleE, T, E, L, V, P, G = unpack(select(2, ...))

local MBar = EleE.MicroBar

local MicroMenu = _G.MicroMenu

function MBar:Initialize()
	if not EleE.initialized then return end

	if not E.db.elee["interface"] then E.db.elee["interface"] = {} end
    if not E.db.elee.interface["microbar"] then
        E.db.elee.interface["microbar"] = {}
        E:CopyTable(E.db.elee.interface.microbar, P.elee.interface.microbar)
	end

	MBar.db = E.db.elee.interface.microbar
	if not self.db.enabled then return end

    MicroMenu:Show()
end

EleE:RegisterModule(MBar:GetName())