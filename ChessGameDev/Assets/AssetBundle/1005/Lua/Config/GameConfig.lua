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
	self.Coordinate_ROW=3			--行
	self.Coordinate_COL=5			--列
	self.IconItemTotalCount=13		--图标总数
	
end



function GameConfig:InitProtoConfig()
	self.LineConfig={
		"Link_Msg",
		"RoomConfig_1005",
		"SoundConfig"
	}
	
	self.LineConfigByte={
		[1] = {name = "RoomConfig_1005List",path = "Common/config/RoomConfig_1005Data.bytes",data="RoomConfig_1005.RoomConfig_1005Data"},
		[2] = {name = "SoundConfigList",path = "Common/config/SoundConfigData.bytes",data="SoundConfig_1005.SoundConfigData"},
	}
end


function GameConfig:InitModuleAssetPathConfig()
	self.ModuleAssetPathList={
		Panel_Root="Prefabs/Game/GamePanel.prefab",
		Panel_Pool="Prefabs/Game/PoolPanel.prefab",
		Panel_BG="Prefabs/Game/BGPanel.prefab",
		Panel_Icon="Prefabs/Game/IconPanel.prefab",
		Panel_Base="Prefabs/Game/BasePanel.prefab",
		Panel_FreeGame="Prefabs/Game/FreeGamePanel.prefab",
		Panel_Bonus="Prefabs/Game/BonusPanel.prefab",
		Panel_Win="Prefabs/Game/WinPanel.prefab",
		Panel_Line="Prefabs/Game/LinePanel.prefab",
		Panel_Audio="Prefabs/Game/AudioPanel.prefab",
		Panel_Help="Prefabs/Game/HelpPanel.prefab",
		Panel_IconSelect="Prefabs/Game/IconSelectPanel.prefab",
		Panel_Handsel="Prefabs/Game/HandselPanel.prefab",
		Panel_SelectGame="Prefabs/Game/SelectGamePanel.prefab",
		Panel_Particle="Prefabs/Game/ParticlePanel.prefab",
	}
end


function GameConfig:InitGameAtlasConfig()
	self.GameSpriteAtlas={
		["FXGZSpriteAtlas"]="Common/Atlas/FXGZSpriteAtlas.spriteatlas",
		["Icon1SpriteAtlas"]="Common/Atlas/Icon1SpriteAtlas.spriteatlas",
		["Icon2SpriteAtlas"]="Common/Atlas/Icon2SpriteAtlas.spriteatlas",
		["Icon3SpriteAtlas"]="Common/Atlas/Icon3SpriteAtlas.spriteatlas",
		["Icon4SpriteAtlas"]="Common/Atlas/Icon4SpriteAtlas.spriteatlas",
}
end

