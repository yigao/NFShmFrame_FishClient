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
	self.IconItemTotalCount=9		--图标总数
	
end



function GameConfig:InitProtoConfig()
	self.LineConfig={
		"Link_Msg",
		"RoomConfig_1003",
		"SoundConfig"
	}
	
	self.LineConfigByte={
		[1] = {name = "RoomConfig_1003List",path = "Common/config/RoomConfig_1003Data.bytes",data="RoomConfig_1003.RoomConfig_1003Data"},
		[2] = {name = "SoundConfigList",path = "Common/config/SoundConfigData.bytes",data="SoundConfig_1003.SoundConfigData"},
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
		Panel_Line="Prefabs/Game/LinePanel.prefab",
		Panel_Audio="Prefabs/Game/AudioPanel.prefab",
		Panel_Help="Prefabs/Game/HelpPanel.prefab",
		Panel_Guess="Prefabs/Game/GuessPanel.prefab",
		Panel_Earnings="Prefabs/Game/EarningsPanel.prefab",
	}
end


function GameConfig:InitGameAtlasConfig()
	self.GameSpriteAtlas={
		["SHZSpriteAtlas"]="Common/Atlas/SHZSpriteAtlas.spriteatlas",	
		["Icon1SpriteAtlas"]="Common/Atlas/Icon1SpriteAtlas.spriteatlas",	
		["Icon2SpriteAtlas"]="Common/Atlas/Icon2SpriteAtlas.spriteatlas",	
		["Icon3SpriteAtlas"]="Common/Atlas/Icon3SpriteAtlas.spriteatlas",	
		["Guess1SpriteAtlas"]="Common/Atlas/Guess1SpriteAtlas.spriteatlas",	
		["Guess2SpriteAtlas"]="Common/Atlas/Guess2SpriteAtlas.spriteatlas",	
		["Guess3SpriteAtlas"]="Common/Atlas/Guess3SpriteAtlas.spriteatlas",	
		["Guess4SpriteAtlas"]="Common/Atlas/Guess4SpriteAtlas.spriteatlas",	
		["LineSpriteAtlas"]="Common/Atlas/LineSpriteAtlas.spriteatlas",	
		
}
end

