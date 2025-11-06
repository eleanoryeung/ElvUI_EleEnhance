local EleE, T, E, L, V, P, G = unpack(select(2, ...))

local FN = EleE.FriendlyName
local LSM = LibStub("LibSharedMedia-3.0")

local DELAY_TIME = 2

local GetTime = GetTime

local lastEnterTime

function FN:SetFont(obj)
    obj:SetFont(LSM:Fetch("font", self.db.font), self.db.size, "OUTLINE") 
    obj:SetShadowOffset(0, 0)
end 

function FN:setDefault()
    --启用名字模式，注意这个CVAR是全局的，所以使用时必需搭配姓名板插件，否则敌方姓名板也没有血条 
    --如果你哪天不用这段代码了，光删代码删插件没用，要在游戏里输入 /run SetCVar("nameplateShowOnlyNames", 0) 才能恢复设置 
    -- SetCVar("nameplateShowOnlyNames", 1) 
     
    --将自定义字体API套用到姓名板的文字上 
    self:SetFont(SystemFont_LargeNamePlate) 
    self:SetFont(SystemFont_NamePlate) 
    self:SetFont(SystemFont_LargeNamePlateFixed) 
    self:SetFont(SystemFont_NamePlateFixed) 
    self:SetFont(SystemFont_NamePlateCastBar) 
     
    --将友方姓名板的框架尺寸设为1，由于暴雪的CVAR只是单纯的隐藏血条，必需做这个设置，才能在堆叠模式下不挤占敌方姓名板空间 
    C_NamePlate.SetNamePlateFriendlySize(45,12) 
    --将全局缩放设为1，否则引起掉帧(7.0最严重能掉一半，9.0掉个1/3吧) 
    SetCVar("namePlateMinScale", 1) 
    SetCVar("namePlateMaxScale", 1) 
     
    --边缘贴齐 
    SetCVar("nameplateOtherTopInset", .08) 
    SetCVar("nameplateOtherBottomInset", .1) 
    SetCVar("nameplateLargeTopInset", .08) 
    SetCVar("nameplateLargeBottomInset", .1) 
    --禁用点击，使用之后，对于友方玩家，点名字无法选中目标，要选模型 
    C_NamePlate.SetNamePlateFriendlyClickThrough(false)
    --友方显示条件，把非玩家都隐去 
    SetCVar("nameplateShowFriendlyGuardians", 0) --守护者
    SetCVar("nameplateShowFriendlyMinions", 0) --仆从
    SetCVar("nameplateShowFriendlyPets", 0) --宠物
    SetCVar("nameplateShowFriendlyTotems", 0) --图腾
end 

function FN:Initialize()
	if not EleE.initialized then return end
	
	if not E.db.elee["misc"] then E.db.elee["misc"] = {} end
    if not E.db.elee.misc["name"] then
        E.db.elee.misc["name"] = {}
        E:CopyTable(E.db.elee.misc.name, P.elee.misc.name)
	end
	
	self.db = E.db.elee.misc.name
	if not self.db.enabled then return end

    self.eventframe = CreateFrame("Frame")
	self.eventframe:SetScript("OnEvent", function(_, event)
        if event == "LOADING_SCREEN_DISABLED" then
            lastEnterTime = GetTime()
            self.eventframe:SetScript("OnUpdate", function()
                if (GetTime() - lastEnterTime) >= DELAY_TIME then
                    self:setDefault()
                    self.eventframe:SetScript("OnUpdate", nil)
                end
            end)
		    self.eventframe:UnregisterEvent("LOADING_SCREEN_DISABLED")
        end
    end)
    self.eventframe:RegisterEvent("LOADING_SCREEN_DISABLED")
end

EleE:RegisterModule(FN:GetName())