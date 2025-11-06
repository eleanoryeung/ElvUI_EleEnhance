local EleE, T, E, L, V, P, G = unpack(select(2, ...))

local BBar = EleE.BagBar

local BagsBar = _G.BagsBar

function BBar:Initialize()
	if not EleE.initialized then return end

	if not E.db.elee["interface"] then E.db.elee["interface"] = {} end
    if not E.db.elee.interface["bagbar"] then
        E.db.elee.interface["bagbar"] = {}
        E:CopyTable(E.db.elee.interface.bagbar, P.elee.interface.bagbar)
	end

	BBar.db = E.db.elee.interface.bagbar
	if not self.db.enabled then return end

    BagsBar:SetParent(UIParent)
end

EleE:RegisterModule(BBar:GetName())