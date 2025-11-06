local EleE, T, E, L, V, P, G = unpack(select(2, ...))

local PDT = EleE.ProfessionDT
local DT = E.DataTexts

local GetProfessionInfo = _G.GetProfessionInfo
local GetProfessions = _G.GetProfessions
local IsShiftKeyDown = _G.IsShiftKeyDown
local CastSpellByName = _G.CastSpellByName

local format = format
local tinsert = tinsert
local sort = sort
local wipe = wipe
local strjoin = strjoin

local professions = {}
local displayString = ''
local displayNoSkill = ''
local tooltipString = ''
local textureString = '|T%s:16:16:0:0:64:64:4:60:4:60|t'

local spellName = {
	["採礦"] = "採礦日誌",
	["草藥學"] = "草藥學日誌",
	["剝皮"] = "剝皮日誌",
	["釣魚"] = "釣魚日誌",
}

local function tableHasKey(table, key)
    return table[key] ~= nil
end

local function GetProfessionName(prof)
	return professions[prof] and professions[prof].name or ''
end

local function sortedPairs(t, f)
	local a = {}
	for n in pairs(t) do tinsert(a, n) end
	sort(a, f)
	local i = 0
	local iter = function()
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
	end
	return iter
end

local function OnEvent(self)
	wipe(professions)
	local prof1, prof2, archy, fishing, cooking = GetProfessions()
	local order = 1

	if prof1 then
		local name, texture, rank, maxRank = GetProfessionInfo(prof1)
		professions['prof1'] = { order = order + 1, name = name, texture = format(textureString, texture), rank = rank, maxRank = maxRank }
		order = order + 1
	end

	if prof2 then
		local name, texture, rank, maxRank = GetProfessionInfo(prof2)
		professions['prof2'] = { order = order + 1, name = name, texture = format(textureString, texture), rank = rank, maxRank = maxRank }
		order = order + 1
	end

	if archy then
		local name, texture, rank, maxRank = GetProfessionInfo(archy)
		professions['archy'] = { order = order + 1, name = name, texture = format(textureString, texture), rank = rank, maxRank = maxRank }
		order = order + 1
	end

	if fishing then
		local name, texture, rank, maxRank = GetProfessionInfo(fishing)
		professions['fishing'] = { order = order + 1, name = name, texture = format(textureString, texture), rank = rank, maxRank = maxRank }
		order = order + 1
	end

	if cooking then
		local name, texture, rank, maxRank = GetProfessionInfo(cooking)
		professions['cooking'] = { order = order + 1, name = name, texture = format(textureString, texture), rank = rank, maxRank = maxRank }
	end

	local data
	if prof1 then
		data = professions["prof1"]
	elseif prof2 then
		data = professions["prof2"]
	end

	if data then
		if E.db.elee.profdt.showSkill then
			self.text:SetFormattedText(displayString, data.name, data.rank, data.maxRank)
		else
			self.text:SetFormattedText(displayNoSkill, data.name)
		end
	else
		self.text:SetText(L["No Profession"])
	end
end

local function OnClick(_, button)
	local data
	if button == "LeftButton" then
		data = IsShiftKeyDown() and professions['archy'] or professions['prof1']
	elseif button == "RightButton" then
		data = IsShiftKeyDown() and professions['cooking'] or professions['prof2']
	else
		data = professions["fishing"]
	end

	if data and data.name then
		CastSpellByName(tableHasKey(spellName, data.name) and spellName[data.name] or data.name)
	end
end

local function OnEnter()
	DT.tooltip:ClearLines()

	for _, data in sortedPairs(professions, function(a, b) return professions[a].order < professions[b].order end) do
		DT.tooltip:AddDoubleLine(strjoin('', data.texture, ' ', data.name), format(tooltipString, data.rank, data.maxRank), 1, 1, 1, 1, 1, 1)
	end

	if E.db.elee.profdt.hint then
		DT.tooltip:AddLine(' ')
		DT.tooltip:AddDoubleLine(L["Left Click:"], L["Open "] .. GetProfessionName('prof1'), 1, 1, 1, 1, 1, 0)
		DT.tooltip:AddDoubleLine(L["Right Click:"], L["Open "] .. GetProfessionName('prof2'), 1, 1, 1, 1, 1, 0)
		DT.tooltip:AddDoubleLine(L["Shift + Left Click:"], L["Open Archaeology"], 1, 1, 1, 1, 1, 0)
		DT.tooltip:AddDoubleLine(L["Shift + Right Click:"], L["Open Cooking"], 1, 1, 1, 1, 1, 0)
	end

	DT.tooltip:Show()
end

local function SettingsUpdate(self, hex, r, g, b)
	displayString = strjoin('', '|cffffffff%s:|r ', hex, '%d|r/', hex, '%d|r')
	displayNoSkill = strjoin('', hex, '%s|r')
	tooltipString = strjoin('' , hex, '%d|r|cffffffff/|r', hex, '%d|r')
end

function PDT:Initialize()
	if not EleE.initialized then return end
	
	if not E.db.elee["profdt"] then 
        E.db.elee["profdt"] = {}
        E:CopyTable(E.db.elee.profdt, P.elee.profdt)
    end
	
	self.db = E.db.elee.profdt
	if not self.db.enabled then return end

    DT:RegisterDatatext("Professions DataText", "EleE",
						{"CHAT_MSG_SKILL", "TRADE_SKILL_LIST_UPDATE", "TRADE_SKILL_DETAILS_UPDATE"},
						OnEvent, nil, OnClick, OnEnter, nil, L["Professions"], nil, SettingsUpdate)
end

EleE:RegisterModule(PDT:GetName())