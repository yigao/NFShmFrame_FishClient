GameConfig=Class()

function GameConfig:ctor()
	self:Init()

end


function GameConfig:Init ()
	self:InitData()
end


function GameConfig:InitData()
	self:InitGameBaseConfig()
	self:InitProtoConfig()
	self:InitModuleAssetPathConfig()
	self:InitGameAtlasConfig()
end


function GameConfig:InitGameBaseConfig()
	
	
end



function GameConfig:InitProtoConfig()
	self.LineConfig={
		"msg_lhd",
		"SoundConfig"
	}
	
	self.LineConfigByte={
		[1] = {name = "SoundConfigList",path = "Common/config/SoundConfigData.bytes",data="SoundConfig_4001.SoundConfigData"},
	}
end


function GameConfig:InitModuleAssetPathConfig()
	self.ModuleAssetPathList={
		Panel_Root="Prefabs/Game/GamePanel.prefab",
		Panel_Base="Prefabs/Game/BasePanel.prefab",
		Panel_Pool="Prefabs/Game/PoolPanel.prefab",
		Panel_BG="Prefabs/Game/BGPanel.prefab",
		Panel_Audio="Prefabs/Game/AudioPanel.prefab",
		Panel_Help="Prefabs/Game/HelpPanel.prefab",
		Panel_Player="Prefabs/Game/PlayerPanel.prefab",
		Panel_Banker= "Prefabs/Game/BankerPanel.prefab",
		Panel_PlayerListRank= "Prefabs/Game/PlayerListRankPanel.prefab",
		Panel_BetChip= "Prefabs/Game/BetChipPanel.prefab",
		Panel_BeBanker = "Prefabs/Game/BeBankerPanel.prefab",
		Panel_Road = "Prefabs/Game/RoadPanel.prefab",
	}
end


function GameConfig:InitGameAtlasConfig()
	self.GameSpriteAtlas={
		["LhdBaseSpriteAtlas"]="Common/Atlas/LhdBaseSpriteAtlas.spriteatlas",
		["LhdCardSpriteAtlas"]="Common/Atlas/LhdCardSpriteAtlas.spriteatlas",
		["LhdFontSpriteAtlas"]="Common/Atlas/LhdFontSpriteAtlas.spriteatlas"
}
end

