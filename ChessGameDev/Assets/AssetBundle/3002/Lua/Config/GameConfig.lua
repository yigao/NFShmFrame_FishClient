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
		"ChessTBNN_Msg",
		"SoundConfig"
	}
	
	self.LineConfigByte={
		[1] = {name = "SoundConfigList",path = "Common/config/SoundConfigData.bytes",data="SoundConfig_3002.SoundConfigData"},
	}
end


function GameConfig:InitModuleAssetPathConfig()
	self.ModuleAssetPathList={
		Panel_Root="Prefabs/Game/GamePanel.prefab",
		Panel_Pool="Prefabs/Game/PoolPanel.prefab",
		Panel_BG="Prefabs/Game/BGPanel.prefab",
		Panel_Audio="Prefabs/Game/AudioPanel.prefab",
		Panel_Help="Prefabs/Game/HelpPanel.prefab",
		Panel_Player="Prefabs/Game/PlayerPanel.prefab",
		Panel_Set="Prefabs/Game/SetPanel.prefab",
		Panel_Tips="Prefabs/Game/TipsPanel.prefab",
		Panel_Particle="Prefabs/Game/ParticlePanel.prefab",
	}
end


function GameConfig:InitGameAtlasConfig()
	self.GameSpriteAtlas={
		["TBNNBaseSpriteAtlas"]="Common/Atlas/TBNNBaseSpriteAtlas.spriteatlas",
		["TBNNCardSpriteAtlas"]="Common/Atlas/TBNNCardSpriteAtlas.spriteatlas",
}
end

