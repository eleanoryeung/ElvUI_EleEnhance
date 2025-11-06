local EleE, T, E, L, V, P, G = unpack(select(2, ...))

local _G = _G

local pcall = pcall
local tinsert = table.insert

local LSM = E.Libs.LSM


EleE.RegisteredModules = {}
function EleE:RegisterModule(name)
	if self.initialized then
		self:GetModule(name):Initialize()
	else
		tinsert(self.RegisteredModules, name)
	end
end


function EleE:InitializeModules()
	for _, moduleName in pairs(EleE.RegisteredModules) do
		local module = self:GetModule(moduleName)
		if module.Initialize then
			pcall(module.Initialize, module)
		end
	end
end

local collectgarbage = collectgarbage
EleE.UpdateFunctions = {}
function EleE:UpdateAll()
	if not EleE.initialized then
		return
	end

	for _, moduleName in pairs(EleE.RegisteredModules) do
		local module = EleE:GetModule(moduleName)
		if module.ForUpdateAll then
			module:ForUpdateAll()
		else
			if EleE.UpdateFunctions[moduleName] then
				EleE.UpdateFunctions[moduleName]()
			end
		end
	end

	collectgarbage("collect")
end

function T.SetFontOutline(text, font, size)
    if not text or not text.GetFont then
        return
    end

    local fontName, fontHeight = text:GetFont()

    if size and type(size) == "string" then
        size = fontHeight + tonumber(size)
    end

    if font and not strfind(font, ".ttf") then
        font = LSM:Fetch('font', font)
    end

    text:FontTemplate(font or fontName, size or fontHeight, "OUTLINE")
    text:SetShadowColor(0, 0, 0, 0)
    text.SetShadowColor = E.noop
end
