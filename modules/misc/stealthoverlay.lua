local EleE, T, E, L, V, P, G = unpack(select(2, ...))

local SO = EleE.StealthOverlay

local StealthOverlayFrame = CreateFrame("Frame", "EleStealthOverlay", E.UIParent)
StealthOverlayFrame:Point("TOPLEFT")
StealthOverlayFrame:Point("BOTTOMRIGHT")
StealthOverlayFrame:SetFrameLevel(0)
StealthOverlayFrame:SetFrameStrata("BACKGROUND")
StealthOverlayFrame.tex = StealthOverlayFrame:CreateTexture()
StealthOverlayFrame.tex:SetTexture("Interface\\Addons\\ElvUI_EleEnhance\\Media\\StealthOverlay.tga")
StealthOverlayFrame.tex:SetAllPoints(UIParent)
StealthOverlayFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
StealthOverlayFrame:RegisterEvent("UPDATE_STEALTH")
StealthOverlayFrame:Hide()


function SO:Initialize()
	if not EleE.initialized then return end
	
	if not E.db.elee["misc"] then E.db.elee["misc"] = {} end
    if not E.db.elee.misc["stealth"] then
        E.db.elee.misc["stealth"] = {}
        E:CopyTable(E.db.elee.misc.stealth, P.elee.misc.stealth)
	end
	
	self.db = E.db.elee.misc.stealth
	if not self.db.enabled then return end

	StealthOverlayFrame:SetScript("OnEvent", function(__, event)
        --print(event.."stealth spam")
        if (event == "PLAYER_ENTERING_WORLD") then
            if IsStealthed() then
                StealthOverlayFrame:Show()
                UIFrameFadeIn(StealthOverlayFrame, 0.5, 0, 1)
            else
                StealthOverlayFrame:Hide()
            end
        elseif (event == "UPDATE_STEALTH") then
            if IsStealthed() then
                StealthOverlayFrame:Show()
                UIFrameFadeIn(StealthOverlayFrame, 0.5, 0, 1)
            else
                UIFrameFadeOut(StealthOverlayFrame, 0.4, 1, 0)
            end
        end
    end)
end

EleE:RegisterModule(SO:GetName())