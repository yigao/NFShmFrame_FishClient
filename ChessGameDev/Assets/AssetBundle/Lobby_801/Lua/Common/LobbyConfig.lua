	LobbyConfig=Class()

function LobbyConfig:ctor()
	self:Init()

end


function LobbyConfig:Init ()
	self:InitData()
end


function LobbyConfig:InitData()
	self:InitProtoConfig()
	self:InitLobbyAtlasConfig()
	self:InitLobbyFontsConfig()
	self:InitLobbyBGConfig()
	self:InitFormConfig()
	self:InitGameItemConfig()
	self:InitAudioConfig()
end


function LobbyConfig:InitProtoConfig()
	self.LobbyExcelConfig={
		-- "Fish_Msg",
		-- "FishConfig",
		-- "CoinEffectConfig",
		-- "DieEffectConfig",
		-- "GunConfig",
		-- "RoomConfig_2001",
		-- "ScoreEffectConfig",
		"Lobby_SoundConfig",
		"Lobby_GameItemConfig",
		-- "SpecialDeclareConfig",
	}
	
	self.LobbyExcelConfigByte={
		[1] = {name = "Lobby_SoundConfigList",path = "Common/Config/Lobby_SoundConfigData.bytes",data="Lobby_SoundConfig.Lobby_SoundConfigData"},
		[2] = {name = "Lobby_GameItemConfigList",path = "Common/Config/Lobby_GameItemConfigData.bytes",data="Lobby_GameItemConfig.Lobby_GameItemConfigData"},
		-- [3] = {name = "DieEffectConfigList",path = "Common/config/FishConfig/DieEffectConfigData.bytes",data="DieEffectConfig_2004.DieEffectConfigData"},
		-- [4] = {name = "GunConfigList",path = "Common/config/FishConfig/GunConfigData.bytes",data="GunConfig_2004.GunConfigData"},
		-- [5] = {name = "RoomConfig_2001List",path = "Common/config/FishConfig/RoomConfig_2001Data.bytes",data="RoomConfig_2001Data"},
		-- [6] = {name = "ScoreEffectConfigList",path = "Common/config/FishConfig/ScoreEffectConfigData.bytes",data="ScoreEffectConfig_2004.ScoreEffectConfigData"},
		-- [7] = {name = "SoundConfigList",path = "Common/config/FishConfig/SoundConfigData.bytes",data="SoundConfig_2001.SoundConfigData"},
		-- [8] = {name = "PlusTipsEffectConfigList",path = "Common/config/FishConfig/PlusTipsEffectConfigData.bytes",data="PlusTipsEffectConfig_2001.PlusTipsEffectConfigData"},
		-- [9] = {name = "SpecialDeclareConfigList",path = "Common/config/FishConfig/SpecialDeclareConfigData.bytes",data="SpecialDeclareConfig_2004.SpecialDeclareConfigData"},
	}	
end


function LobbyConfig:InitGameItemConfig()
	 self.GameItemRes={
		[1] = {name = "2001",path = "Prefabs/GameItem/2001.prefab",amout= 1,count = 1},
		[2] = {name = "2002",path = "Prefabs/GameItem/2002.prefab",amout= 1,count = 1},
		[3] = {name = "2003",path = "Prefabs/GameItem/2003.prefab",amout= 1,count = 1},
		[4] = {name = "2004",path = "Prefabs/GameItem/2004.prefab",amout= 1,count = 1},
		[5] = {name = "1001",path = "Prefabs/GameItem/1001.prefab",amout= 1,count = 1},
		[6] = {name = "1002",path = "Prefabs/GameItem/1002.prefab",amout= 1,count = 1},
		[7] = {name = "1003",path = "Prefabs/GameItem/1003.prefab",amout= 1,count = 1},
		[8] = {name = "1004",path = "Prefabs/GameItem/1004.prefab",amout= 1,count = 1},
		[9] = {name = "1005",path = "Prefabs/GameItem/1005.prefab",amout= 1,count = 1},
		[10] = {name = "3001",path = "Prefabs/GameItem/3001.prefab",amout= 1,count = 1},
		[11] = {name = "3002",path = "Prefabs/GameItem/3002.prefab",amout= 1,count = 1},
		[12] = {name = "4001",path = "Prefabs/GameItem/4001.prefab",amout= 1,count = 1},
		[13] = {name = "4002",path = "Prefabs/GameItem/4002.prefab",amout= 1,count = 1},
}
end

function LobbyConfig:InitFormConfig()
	self.LobbyFormRes={
		[1] = {name = "LobbyHallCoreForm",path = "Prefabs/LobbyHallCoreForm/LobbyHallCoreForm.prefab",amout= 1,count = 1},
}
end

function LobbyConfig:InitAudioConfig()
	self.AudioRes={
		[1] = {name = "Audio",path = "Prefabs/Audio/Lobby_AuidoPanel.prefab",amout= 1,count = 1},
}
end

function LobbyConfig:InitLobbyAtlasConfig()
	self.SpriteAtalsRes={
		["CommonSpriteAtlas"]="Common/Atlas/Common/CommonSpriteAtlas.spriteatlas",
		["MainLobbySpriteAtlas"]= "Common/Atlas/MainLobby/MainLobbySpriteAtlas.spriteatlas",
		["MessageSpriteAtlas"]="Common/Atlas/Message/MessageSpriteAtlas.spriteatlas",
		["PersonalInformationSpriteAtlas"]= "Common/Atlas/PersonalInformation/PersonalInformationSpriteAtlas.spriteatlas",
		["RanklistSpriteAtlas"]="Common/Atlas/Ranklist/RanklistSpriteAtlas.spriteatlas",
		["BankSpriteAtlas"]= "Common/Atlas/Bank/BankSpriteAtlas.spriteatlas",
		["FontSpriteAtlas"]= "Common/Atlas/Font/FontSpriteAtlas.spriteatlas",
}
end


function LobbyConfig:InitLobbyFontsConfig()
	self.FontsRes={
		[1] = {name = "FZHTJW",path = "Common/Fonts/FZHTJW.TTF",amout= 1,count = 1},	
		[2] = {name = "FZZY_GBK",path = "Common/Fonts/FZZY_GBK.ttf",amout= 1,count = 1},
		[3] = {name = "ZZGFLH",path = "Common/Fonts/ZZGFLH.otf",amout= 1,count = 1},
	}
end

function LobbyConfig:InitLobbyBGConfig(  )
	self.BGRes={
		[1] = {name = "gg_bg_01",path = "Common/Texture/BG/gg_bg_01.png",amout= 1,count = 1},	
		[2] = {name = "gg_bg_08",path = "Common/Texture/BG/gg_bg_08.png",amout= 1,count = 1},
	}
end
