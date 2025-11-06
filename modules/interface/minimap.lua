local EleE, T, E, L, V, P, G = unpack(select(2, ...))

local MMap = EleE.Minimap

local MinimapCluster = _G.MinimapCluster
local BorderTop = MinimapCluster.BorderTop
local Minimap = _G.Minimap


function MMap:SkinMiniMap()
  if not Minimap then return end
  if Minimap.EleSkinned then return end

  -- Apply mask using config
  Minimap:SetMaskTexture("Interface\\AddOns\\ElvUI_EleEnhance\\media\\mask.tga")
  Minimap:SetHitRectInsets(0, 0, 0, 0)
  Minimap:SetClampRectInsets(0, 0, 0, 0)
  Minimap.backdrop:Hide()

  -- Border overlay
  local borderFrame = CreateFrame("Frame", nil, Minimap)
  borderFrame:SetFrameLevel(Minimap:GetFrameLevel() + 10)

  local borderTexture = borderFrame:CreateTexture(nil, "OVERLAY")
  borderTexture:SetTexture("Interface\\AddOns\\ElvUI_EleEnhance\\media\\border2.blp")
  borderTexture:SetAllPoints(borderFrame)
  borderTexture:SetBlendMode("BLEND")
  -- Trim edges slightly to avoid mip/bleed artifacts that can look like warping on some BLPs
  if borderTexture.SetTexCoord then
    borderTexture:SetTexCoord(0.002, 0.998, 0.002, 0.998)
  end
  Minimap.EleSkinned = true

  -- Use hardcoded absolute values
  local mapsize = math.floor(Minimap:GetWidth()*1.07)
  borderFrame:SetSize(mapsize, mapsize)
  borderFrame:SetPoint("CENTER", Minimap, "CENTER", 0, 0)
end

function MMap:Initialize()
	if not EleE.initialized then return end

	if not E.db.elee["interface"] then E.db.elee["interface"] = {} end
    if not E.db.elee.interface["minimap"] then
        E.db.elee.interface["minimap"] = {}
        E:CopyTable(E.db.elee.interface.minimap, P.elee.interface.minimap)
	end
  E:CopyTable(E.db.elee.interface.minimap, P.elee.interface.minimap)

	MMap.db = E.db.elee.interface.minimap
	if not self.db.enabled then return end

  if self.db.skin then
    self:SkinMiniMap()
  end

  if self.db.res then
    if self.db.expand then
      BorderTop:ClearAllPoints()
      BorderTop:SetPoint("TOP", MinimapCluster, "TOP", 14, 3)
      BorderTop:SetSize(180, 22)

      local TimeManagerClockButton = _G.TimeManagerClockButton
      TimeManagerClockButton:ClearAllPoints()
      TimeManagerClockButton:SetPoint("TOPRIGHT", BorderTop, "TOPRIGHT", -5, -3)

      local GameTimeFrame = _G.GameTimeFrame
      GameTimeFrame:ClearAllPoints()
      GameTimeFrame:SetPoint("TOPLEFT", BorderTop, "TOPRIGHT", 1, -2)
    end

    NineSliceUtil.ApplyUniqueCornersLayout(BorderTop, "ui-hud-minimap-button")
  end

end

EleE:RegisterModule(MMap:GetName())