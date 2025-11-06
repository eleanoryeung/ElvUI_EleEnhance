local EleE, T, E, L, V, P, G = unpack(select(2, ...))

local RB = EleE.RiderBar
local LibAdvFlight = LibStub:GetLibrary("LibAdvFlight-1.0")

function RB:applyBar()
    PowerBarContainerHolder:ClearAllPoints()
    PowerBarContainerHolder:SetPoint("CENTER", PowerBarContainerMover, "CENTER", 0, self.db.Yoffset)
    UIWidgetPowerBarContainerFrame:SetScale(self.db.scale)
end

function RB:revertBar()
    PowerBarContainerHolder:ClearAllPoints()
    PowerBarContainerHolder:SetPoint("CENTER", PowerBarContainerMover, "CENTER", 0, 0)
    UIWidgetPowerBarContainerFrame:SetScale(1.0)
end

function RB:OnAdvFlyEnabled()
    RB:applyBar()
end

function RB:OnAdvFlyDisabled()
    RB:revertBar()
end

function RB:Initialize()
	if not EleE.initialized then return end

	if not E.db.elee["interface"] then E.db.elee["interface"] = {} end
    if not E.db.elee.interface["riderbar"] then
        E.db.elee.interface["riderbar"] = {}
        E:CopyTable(E.db.elee.interface.riderbar, P.elee.interface.riderbar)
	end

	RB.db = E.db.elee.interface.riderbar
	if not self.db.enabled then return end

	LibAdvFlight.RegisterCallback(LibAdvFlight.Events.ADV_FLYING_ENABLED, RB.OnAdvFlyEnabled)
    LibAdvFlight.RegisterCallback(LibAdvFlight.Events.ADV_FLYING_DISABLED, RB.OnAdvFlyDisabled)
end

EleE:RegisterModule(RB:GetName())
