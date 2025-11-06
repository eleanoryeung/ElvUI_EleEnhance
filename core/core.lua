local E, _, V, P, G = unpack(ElvUI);
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)
local EP = E.Libs.EP
local AddOnName, Engine = ...

local _G = _G
local format = format
local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata

local EleE = LibStub("AceAddon-3.0"):NewAddon(AddOnName, "AceConsole-3.0", "AceEvent-3.0", 'AceTimer-3.0', 'AceHook-3.0');
-- EleE.callbacks = EleE.callbacks or LibStub("CallbackHandler-1.0"):New(EleE)

EleE.version = GetAddOnMetadata("ElvUI_EleEnhance", "Version")
EleE.Title = format("|cffffb6c1%s |r", "Eleanor's Enhancements")

BINDING_HEADER_EleE = "|cffffb6c1Eleanor's Enhancements|r"

-- Creating a toolkit table
local Toolkit = {}

-- Setting up table to unpack.
Engine[1] = EleE
Engine[2] = Toolkit
Engine[3] = E
Engine[4] = L
Engine[5] = V
Engine[6] = P
Engine[7] = G
_G[AddOnName] = Engine;

EleE.IME = EleE:NewModule("IME")
EleE.ProfessionDT = EleE:NewModule("ProfessionDT")
EleE.FriendlyName = EleE:NewModule("FriendlyName", "AceEvent-3.0")
EleE.LFGList = EleE:NewModule("LFGList", "AceHook-3.0")
EleE.StealthOverlay = EleE:NewModule("StealthOverlay", "AceEvent-3.0")
EleE.RiderBar = EleE:NewModule("RiderBar")
EleE.Minimap = EleE:NewModule("Minimap")
-- EleE.MicroBar = EleE:NewModule("MicroBar")
EleE.BagBar = EleE:NewModule("BagBar")
EleE.GuildNewsFix = EleE:NewModule("GuildNewsFix")

EleE.Configs = {}
local function GetOptions()
    for _, func in pairs(EleE.Configs) do
        func()
    end
end

function EleE:Initialize()
	if not E.db["elee"] then E.db["elee"] = {} end

	self.initialized = true
	self:InitializeModules()

	hooksecurefunc(E, "UpdateAll", EleE.UpdateAll)

	EP:RegisterPlugin(AddOnName, GetOptions)
end

EP:HookInitialize(EleE, EleE.Initialize)