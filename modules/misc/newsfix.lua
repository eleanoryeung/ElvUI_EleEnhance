local EleE, T, E, L, V, P, G = unpack(select(2, ...))

local GNF = EleE.GuildNewsFix

local CommunitiesGuildNewsFrame_OnEvent = CommunitiesGuildNewsFrame_OnEvent
local newsRequireUpdate, newsTimer

function GNF:Initialize()
	if not EleE.initialized then return end
	
	if not E.db.elee["misc"] then E.db.elee["misc"] = {} end
    if not E.db.elee.misc["newsfix"] then
        E.db.elee.misc["newsfix"] = {}
        E:CopyTable(E.db.elee.misc.newsfix, P.elee.misc.newsfix)
	end
	
	self.db = E.db.elee.misc.newsfix
	if not self.db.enabled then return end

    CommunitiesFrameGuildDetailsFrameNews:SetScript("OnEvent", function(frame, event)
        if event == "GUILD_NEWS_UPDATE" then
            if newsTimer then
                newsRequireUpdate = true
            else
                CommunitiesGuildNewsFrame_OnEvent(frame, event)
                
                newsTimer = C_Timer.NewTimer(1, function()
                    if newsRequireUpdate then
                        CommunitiesGuildNewsFrame_OnEvent(frame, event)
                    end
                    newsTimer = nil
                end)
            end
        else
            CommunitiesGuildNewsFrame_OnEvent(frame, event)
        end
    end)
end

EleE:RegisterModule(GNF:GetName())