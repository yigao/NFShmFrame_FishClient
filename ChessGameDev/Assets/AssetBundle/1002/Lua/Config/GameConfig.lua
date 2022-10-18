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
	self.Coordinate_ROW=2			--行
	self.Coordinate_COL=1			--列
	self.IconItemTotalCount=15		--图标总数
	
end



function GameConfig:InitProtoConfig()
	self.LineConfig={
		"Link_Msg",
		"RoomConfig_1002",
		"SoundConfig"
	}
	
	self.LineConfigByte={
		[1] = {name = "RoomConfig_1002List",path = "Common/config/RoomConfig_1002Data.bytes",data="RoomConfig_1002.RoomConfig_1002Data"},
		[2] = {name = "SoundConfigList",path = "Common/config/SoundConfigData.bytes",data="SoundConfig_1002.SoundConfigData"},
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
	}
end


function GameConfig:InitGameAtlasConfig()
	self.GameSpriteAtlas={
		["XYZLSpriteAtlas"]="Common/Atlas/XYZLSpriteAtlas.spriteatlas",
		
}
end

function GameConfig:__delete()
	self.GameSpriteAtlas=nil
	self.ModuleAssetPathList=nil
end

