local EleE, T, E, L, V, P, G = unpack(select(2, ...))
local _G = _G

local IME = EleE.IME
local S = E:GetModule("Skins")
local LSM = LibStub("LibSharedMedia-3.0")

function IME:IMESkins()
    -- 输入法候选框
    if _G.IMECandidatesFrame then
        print("DEBUG")
        local frame = _G.IMECandidatesFrame
        local db = IME.db
        if db.no_backdrop then S:HandlePortraitFrame(frame) end
        for i = 1, 10 do
            if frame["c" .. i] then
                frame["c" .. i].label:FontTemplate(LSM:Fetch("font", db.label.font), db.label.size, db.label.style)
                frame["c" .. i].candidate:FontTemplate(LSM:Fetch("font", db.candidate.font), db.candidate.size,
                                                       db.candidate.style)
                frame["c" .. i].candidate:SetWidth(db.width)
            end
        end
    end
end

function IME:Initialize()
    if not EleE.initialized then return end

    if not E.db.elee["chat"] then E.db.elee["chat"] = {} end
    if not E.db.elee.chat["ime"] then
        E.db.elee.chat["ime"] = {}
        E:CopyTable(E.db.elee.chat.ime, P.elee.chat.ime)
    end

    IME.db = E.db.elee.chat.ime
    if not self.db.enabled then return end

    function IME:ForUpdateAll()
        IME:IMESkins()
    end
    IME:IMESkins()
end

EleE:RegisterModule(IME:GetName())