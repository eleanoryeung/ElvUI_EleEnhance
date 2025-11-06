local EleE, T, E, L, V, P, G = unpack(select(2, ...))

local LL = EleE.LFGList
local LSM = E.Libs.LSM

local pairs = pairs
local type = type

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local LibStub = LibStub

local C_LFGList_GetSearchResultMemberInfo = C_LFGList.GetSearchResultMemberInfo

local roleCache = {}
local roleOrder = {
    ["TANK"] = 1,
    ["HEALER"] = 2,
    ["DAMAGER"] = 3,
}
local rolestr = {
    [1] = "TANK",
    [2] = "HEALER",
    [3] = "DAMAGER",
}

local RoleIconTextures = {
    SUNUI = {
        TANK = [[Interface\AddOns\ElvUI_EleEnhance\media\textures\SunUI\role_tank.tga]],
        HEALER = [[Interface\AddOns\ElvUI_EleEnhance\media\textures\SunUI\role_healer.tga]],
        DAMAGER = [[Interface\AddOns\ElvUI_EleEnhance\media\textures\SunUI\role_dps.tga]],
    },
    LYNUI = {
        TANK = [[Interface\AddOns\ElvUI_EleEnhance\media\textures\LynUI\role_tank.tga]],
        HEALER = [[Interface\AddOns\ElvUI_EleEnhance\media\textures\LynUI\role_healer.tga]],
        DAMAGER = [[Interface\AddOns\ElvUI_EleEnhance\media\textures\LynUI\role_dps.tga]],
    },
    AZUI = {
        TANK = [[Interface\AddOns\ElvUI_EleEnhance\media\textures\AzeriteUI\role_tank.tga]],
        HEALER = [[Interface\AddOns\ElvUI_EleEnhance\media\textures\AzeriteUI\role_healer.tga]],
        DAMAGER = [[Interface\AddOns\ElvUI_EleEnhance\media\textures\AzeriteUI\role_dps.tga]],
    },
    DEFAULT = {
        TANK = E.Media.Textures.Tank,
        HEALER = E.Media.Textures.Healer,
        DAMAGER = E.Media.Textures.DPS
    }
}

local function HandleMeetingStone()
    if IsAddOnLoaded("MeetingStone") or IsAddOnLoaded("MeetingStonePlus") then
        local NetEaseEnv = LibStub("NetEaseEnv-1.0")

        for k in pairs(NetEaseEnv._NSInclude) do
            if type(k) == "table" then
                local module = k.Addon and k.Addon.GetClass and k.Addon:GetClass("MemberDisplay")
                if module and module.SetActivity then
                    local original = module.SetActivity
                    module.SetActivity = function(self, activity)
                        self.resultID = activity and activity.GetID and activity:GetID() or nil
                        original(self, activity)
                    end
                end
            end
        end
    end
end

function LL:ReskinIcon(parent, icon, role, class)
    -- Beautiful square icons
    if role then
        if self.db.icon.reskin then
            icon:SetTexture(RoleIconTextures[self.db.icon.pack][role])
            icon:SetTexCoord(0, 1, 0, 1)
        end

        icon:Size(self.db.icon.size)

        if self.db.icon.border and not icon.backdrop then
            icon:CreateBackdrop("Transparent")
        end

        icon:SetAlpha(self.db.icon.alpha)
        if icon.backdrop then
            icon.backdrop:SetAlpha(self.db.icon.alpha)
        end
    else
        icon:SetAlpha(0)
        if icon.backdrop then
            icon.backdrop:SetAlpha(0)
        end
    end

    -- Create bar in class color behind
    if class and self.db.line.enabled then
        if not icon.line then
            local line = parent:CreateTexture(nil, "ARTWORK")
            line:SetTexture(LSM:Fetch("statusbar", self.db.line.tex) or E.media.normTex)
            line:Size(self.db.line.width, self.db.line.height)
            line:Point("TOP", icon, "BOTTOM", self.db.line.offsetX, self.db.line.offsetY)
            icon.line = line
        end

        local color = E:ClassColor(class, false)
        icon.line:SetVertexColor(color.r, color.g, color.b)
        icon.line:SetAlpha(self.db.line.alpha)
    elseif icon.line then
        icon.line:SetAlpha(0)
    end
end

local function GetCorrectRoleInfo(frame, i)
    if frame.resultID then
        return C_LFGList_GetSearchResultMemberInfo(frame.resultID, i)
    elseif frame == ApplicationViewerFrame then
        return GetPartyMemberInfo(i)
    end
end

local function UpdateGroupRoles(self)
    wipe(roleCache)
    
    if not self.__owner then
        self.__owner = self:GetParent():GetParent()
    end
    
    local count = 0
    for i = 1, 5 do
        local role, class = GetCorrectRoleInfo(self.__owner, i)
        local roleIndex = role and roleOrder[role]
        if roleIndex then
            count = count + 1
            if not roleCache[count] then roleCache[count] = {} end
            roleCache[count][1] = roleIndex
            roleCache[count][2] = class
            roleCache[count][3] = i == 1
        end
    end
    
    sort(roleCache, function(a, b)
        if a and b then
            return a[1] < b[1]
        end
    end)
end

function LL:UpdateEnumerate(enumerate, numPlayers, _, disabled)
    UpdateGroupRoles(enumerate)
    for i = 1, 5 do
        local icon = enumerate.Icons[i]
        if not icon.role then
            if i == 1 then
                icon:SetPoint("RIGHT", -5, -2)
            else
                icon:ClearAllPoints()
                icon:SetPoint("RIGHT", enumerate.Icons[i - 1], "LEFT", 2, 0)
            end
            icon:SetSize(26, 26)
            
            icon.role = enumerate:CreateTexture(nil, "OVERLAY")
            icon.role:SetSize(16, 16)
            icon.role:SetPoint("TOPLEFT", icon, -4, 5)
            
            icon.leader = enumerate:CreateTexture(nil, "OVERLAY")
            icon.leader:SetSize(13, 13)
            icon.leader:SetPoint("TOP", icon, 3, 7)
            icon.leader:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
            icon.leader:SetRotation(rad(-15))
        end
        
        if i > numPlayers then
            icon.role:Hide()
        else
            icon.role:Show()
            icon.role:SetDesaturated(disabled)
            icon.role:SetAlpha(disabled and .5 or 1)
            icon.leader:SetDesaturated(disabled)
            icon.leader:SetAlpha(disabled and .5 or 1)
        end
        icon.leader:Hide()
    end
    
    local iconIndex = numPlayers
    for i = 1, #roleCache do
        local roleInfo = roleCache[i]
        if roleInfo then
            local icon = enumerate.Icons[iconIndex]
            icon.tex:SetAtlas(LFG_LIST_GROUP_DATA_ATLASES[roleInfo[2]])
            icon.role:SetTexture(RoleIconTextures[self.db.icon.pack][rolestr[roleInfo[1]]])
            icon.leader:SetShown(roleInfo[3])
            iconIndex = iconIndex - 1
        end
    end
    
    for i = 1, iconIndex do
        enumerate.Icons[i].role:SetAtlas(nil)
    end
end

function LL:UpdateRoleCount(RoleCount)
    if RoleCount.TankIcon then
        self:ReskinIcon(nil, RoleCount.TankIcon, "TANK")
    end
    if RoleCount.HealerIcon then
        self:ReskinIcon(nil, RoleCount.HealerIcon, "HEALER")
    end
    if RoleCount.DamagerIcon then
        self:ReskinIcon(nil, RoleCount.DamagerIcon, "DAMAGER")
    end
end

function LL:Initialize()
	if not EleE.initialized then return end
	
	if not E.db.elee["misc"] then E.db.elee["misc"] = {} end
    if not E.db.elee.misc["LFGlist"] then
        E.db.elee.misc["LFGlist"] = {}
        E:CopyTable(E.db.elee.misc.LFGlist, P.elee.misc.LFGlist)
	end
	
	self.db = E.db.elee.misc.LFGlist
	if not self.db.enabled then return end

    HandleMeetingStone()
    self:SecureHook("LFGListGroupDataDisplayEnumerate_Update", "UpdateEnumerate")
    self:SecureHook("LFGListGroupDataDisplayRoleCount_Update", "UpdateRoleCount")
end

EleE:RegisterModule(LL:GetName())