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
	self.IconItemTotalCount=10		--图标总数
	
end



function GameConfig:InitProtoConfig()
	self.LineConfig={
		"Link_Msg",
		"SoundConfig",
	}
	
	self.LineConfigByte={
		[1] = {name = "SoundConfigList",path = "Common/config/SoundConfigData.bytes",data="SoundConfig_1006.SoundConfigData"},
	}
end


function GameConfig:InitModuleAssetPathConfig()
	self.ModuleAssetPathList={
		Panel_Root="Prefabs/Game/GamePanel.prefab",
		Panel_Pool="Prefabs/Game/PoolPanel.prefab",
		Panel_BG="Prefabs/Game/BGPanel.prefab",
		Panel_Icon="Prefabs/Game/IconPanel.prefab",
		Panel_Base="Prefabs/Game/BasePanel.prefab",
		Panel_Audio="Prefabs/Game/AudioPanel.prefab",
		Panel_Help="Prefabs/Game/HelpPanel.prefab",
		Panel_Handsel="Prefabs/Game/HandselPanel.prefab",
		Panel_Win="Prefabs/Game/WinPanel.prefab",
		Panel_Jackpot="Prefabs/Game/JackpotPanel.prefab",
		Panel_FreeGame="Prefabs/Game/FreeGamePanel.prefab",
	}
end


function GameConfig:InitGameAtlasConfig()
	self.GameSpriteAtlas={
		["TGGSpriteAtlas"]="Common/Atlas/TGGSpriteAtlas.spriteatlas",	
		
}
end

