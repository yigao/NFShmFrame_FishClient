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
	self.Coordinate_ROW=4			--行
	self.Coordinate_COL=5			--列
	self.IconItemTotalCount=14		--图标总数
	
end



function GameConfig:InitProtoConfig()
	self.LineConfig={
		"Link_Msg",
		"RoomConfig_1004",
		"SoundConfig"
	}
	
	self.LineConfigByte={
		[1] = {name = "RoomConfig_1004List",path = "Common/config/RoomConfig_1004Data.bytes",data="RoomConfig_1004.RoomConfig_1004Data"},
		[2] = {name = "SoundConfigList",path = "Common/config/SoundConfigData.bytes",data="SoundConfig_1004.SoundConfigData"},
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
		Panel_SLB="Prefabs/Game/SLBPanel.prefab",
		Panel_Win="Prefabs/Game/WinPanel.prefab",
		Panel_Line="Prefabs/Game/LinePanel.prefab",
		Panel_Audio="Prefabs/Game/AudioPanel.prefab",
		Panel_Help="Prefabs/Game/HelpPanel.prefab",
		Panel_Handsel="Prefabs/Game/HandselPanel.prefab",
		Panel_Particle="Prefabs/Game/ParticlePanel.prefab",
		Panel_Speed="Prefabs/Game/SpeedPanel.prefab",
	}
end


function GameConfig:InitGameAtlasConfig()
	self.GameSpriteAtlas={
		["SLBSpriteAtlas"]="Common/Atlas/SLBSpriteAtlas.spriteatlas",
		["Icon1SpriteAtlas"]="Common/Atlas/Icon1SpriteAtlas.spriteatlas",
		["Icon2SpriteAtlas"]="Common/Atlas/Icon2SpriteAtlas.spriteatlas",
		
}
end

