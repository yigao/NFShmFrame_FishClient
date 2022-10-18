GameConfig=Class()

function GameConfig:ctor()
	self:Init()

end


function GameConfig:Init ()
	self:InitData()
end


function GameConfig:InitData()
	self:InitProtoConfig()
	self:GameStateConfig()
	self:InitOtherTexConfig()
	self:InitFishConfig()
	self:InitBulletConfig()
	self:InitPlayerConfig()
	self:InitLockFishConfig()
	self:InitNetConfig()
	self:InitPanelConfig()
	self:InitGameAtlasConfig()
	self:InitGoldConfig()
	self:InitScoreConfig()
	self:InitPlusTipsConfig()
	self:InitBigAwardTipsConfig()
	self:InitEffectConfig()
	self:InitAudioConfig()
	self:InitGameBGConfig()
	self:InitFishOutTipsConfig()
	self:InitLightningConfig()
end


function GameConfig:GameStateConfig()
	self.GameState={
		Normal=0,
		SanYu=1,
		JieSuan=2,}
		
	
		
	self.FishType={
		Normal=1,
		Combo=2,
		Spine=3,
		Tips=4,
	}
	
	self.BombFishType={
		
		
	}
end



function GameConfig:InitProtoConfig()
	self.FishConfig={
		"Fish_Msg",
		"FishConfig",
		"CoinEffectConfig",
		"DieEffectConfig",
		"GunConfig",
		"RoomConfig",
		"ScoreEffectConfig",
		"SoundConfig",
		"PlusTipsEffectConfig",
		"BigAwardTipsEffectConfig",
	}
	
	self.FishConfigByte={
		[1] = {name = "FishConfigList",path = "Common/config/FishConfig/FishConfigData.bytes",data="FishConfig_2002.FishConfigData"},
		[2] = {name = "CoinEffectConfigList",path = "Common/config/FishConfig/CoinEffectConfigData.bytes",data="CoinEffectConfig_2002.CoinEffectConfigData"},
		[3] = {name = "DieEffectConfigList",path = "Common/config/FishConfig/DieEffectConfigData.bytes",data="DieEffectConfig_2002.DieEffectConfigData"},
		[4] = {name = "GunConfigList",path = "Common/config/FishConfig/GunConfigData.bytes",data="GunConfig_2002.GunConfigData"},
		[5] = {name = "RoomConfigList",path = "Common/config/FishConfig/RoomConfigData.bytes",data="RoomConfig_2002.RoomConfigData"},
		[6] = {name = "ScoreEffectConfigList",path = "Common/config/FishConfig/ScoreEffectConfigData.bytes",data="ScoreEffectConfig_2002.ScoreEffectConfigData"},
		[7] = {name = "SoundConfigList",path = "Common/config/FishConfig/SoundConfigData.bytes",data="SoundConfig_2002.SoundConfigData"},
		[8] = {name = "PlusTipsEffectConfigList",path = "Common/config/FishConfig/PlusTipsEffectConfigData.bytes",data="PlusTipsEffectConfig_2002.PlusTipsEffectConfigData"},
		[9] = {name = "BigAwardTipsEffectConfigList",path = "Common/config/FishConfig/BigAwardTipsEffectConfigData.bytes",data="BigAwardTipsEffectConfig_2002.BigAwardTipsEffectConfigData"},
	}
end



function GameConfig:InitFishConfig()
	self.FishPackRes={
		[1] = {name = "Fish_Pack_01",path = "Prefabs/FishPack/Fish_Pack_01.prefab"},
		[2] = {name = "Fish_Pack_02",path = "Prefabs/FishPack/Fish_Pack_02.prefab"},
		[3] = {name = "Fish_Pack_03",path = "Prefabs/FishPack/Fish_Pack_03.prefab"},
		[4] = {name = "Fish_Pack_04",path = "Prefabs/FishPack/Fish_Pack_04.prefab"},
		[5] = {name = "Fish_Pack_05",path = "Prefabs/FishPack/Fish_Pack_05.prefab"},

	}
	------------------------------------------------------------------------------------------
	self.FishRes={
		[1] = {name = "Fish_01",ParentName = "Fish_Pack_01",amout = 15, count = 1},
		[2] = {name = "Fish_02",ParentName = "Fish_Pack_01",amout = 15, count = 1},
		[3] = {name = "Fish_03",ParentName = "Fish_Pack_01",amout = 15, count = 1},
		[4] = {name = "Fish_04",ParentName = "Fish_Pack_01",amout = 15, count = 1},
		[5] = {name = "Fish_05",ParentName = "Fish_Pack_01",amout = 15, count = 1},
		[6] = {name = "Fish_06",ParentName = "Fish_Pack_01",amout = 15, count = 1},
		[7] = {name = "Fish_07",ParentName = "Fish_Pack_01",amout = 15, count = 1},
		[8] = {name = "Fish_08",ParentName = "Fish_Pack_01",amout = 15, count = 1},
		
		[9] = {name = "Fish_09",ParentName = "Fish_Pack_02",amout = 15, count = 1},
		[10] = {name = "Fish_10",ParentName = "Fish_Pack_02",amout = 15, count = 1},
		[11] = {name = "Fish_11",ParentName = "Fish_Pack_02",amout = 15, count = 1},
		[12] = {name = "Fish_12",ParentName = "Fish_Pack_02",amout = 15, count = 1},
		[13] = {name = "Fish_13",ParentName = "Fish_Pack_02",amout = 15, count = 1},
		[14] = {name = "Fish_14",ParentName = "Fish_Pack_02",amout = 15, count = 1},
		[15] = {name = "Fish_15",ParentName = "Fish_Pack_02",amout = 15, count = 1},
		[16] = {name = "Fish_16",ParentName = "Fish_Pack_02",amout = 15, count = 1},
		
		[17] = {name = "Fish_17",ParentName = "Fish_Pack_03",amout = 15, count = 1},
		[18] = {name = "Fish_18",ParentName = "Fish_Pack_03",amout = 15, count = 1},
		[19] = {name = "Fish_19",ParentName = "Fish_Pack_03",amout = 15, count = 1},
		[20] = {name = "Fish_20",ParentName = "Fish_Pack_03",amout = 15, count = 1},
		[21] = {name = "Fish_21",ParentName = "Fish_Pack_03",amout = 15, count = 1},
		[22] = {name = "Fish_22",ParentName = "Fish_Pack_03",amout = 15, count = 1},
		[23] = {name = "Fish_23",ParentName = "Fish_Pack_03",amout = 15, count = 1},
		[24] = {name = "Fish_24",ParentName = "Fish_Pack_03",amout = 15, count = 1},
		
		[25] = {name = "Fish_25",ParentName = "Fish_Pack_04",amout = 15, count = 1},
		[26] = {name = "Fish_26",ParentName = "Fish_Pack_04",amout = 15, count = 1},
		[27] = {name = "Fish_27",ParentName = "Fish_Pack_04",amout = 15, count = 1},
		[28] = {name = "Fish_28",ParentName = "Fish_Pack_04",amout = 15, count = 1},
		[29] = {name = "Fish_29",ParentName = "Fish_Pack_04",amout = 15, count = 1},
		[30] = {name = "Fish_30",ParentName = "Fish_Pack_04",amout = 15, count = 1},
		[31] = {name = "Fish_31",ParentName = "Fish_Pack_04",amout = 15, count = 1},
		[32] = {name = "Fish_32",ParentName = "Fish_Pack_04",amout = 15, count = 1},
	
		[33] = {name = "Fish_33",ParentName = "Fish_Pack_05",amout = 15, count = 1},	
		[34] = {name = "Fish_34",ParentName = "Fish_Pack_05",amout = 15, count = 1},
		[35] = {name = "Fish_35",ParentName = "Fish_Pack_05",amout = 15, count = 1},
		[36] = {name = "Fish_36",ParentName = "Fish_Pack_05",amout = 15, count = 1},
		[37] = {name = "Fish_37",ParentName = "Fish_Pack_05",amout = 15, count = 1},
	}
	-----------------------------------------------------------------------------------------------
	
end


function GameConfig:InitBulletConfig()
	self.BulletRes={
		[1] = {name = "bullet_1",ParentName = "Fish_Pack_01",amout = 45, count = 1},
	}
end

function GameConfig:InitNetConfig()
	self.NetRes={
		[1] = {name = "Net",path = "Prefabs/Net/Net.prefab",amout = 20, count = 1},
	}
end


function GameConfig:InitPlayerConfig()
	self.PlayerRes={
		[1] = {name = "PlayerPanelDown1",path = "Prefabs/Panel/PlayerPanelDown1.prefab",amout= 1,count = 1},
		[2] = {name = "PlayerPanelDown2",path = "Prefabs/Panel/PlayerPanelDown2.prefab",amout= 1,count = 1},
		[3] = {name = "PlayerPanelUp1",path = "Prefabs/Panel/PlayerPanelUp1.prefab",amout= 1,count = 1},
		[4] = {name = "PlayerPanelUp2",path = "Prefabs/Panel/PlayerPanelUp2.prefab",amout= 1,count = 1},
	}
end

function GameConfig:InitPanelConfig()
	self.GamePanelRes={
		GameSetPanel="Prefabs/Panel/GameSetPanel.prefab"
		
}
end


function GameConfig:InitGoldConfig()
	self.GoldRes={
		[1] = {name = "Coin01",path = "Prefabs/Gold/Coin01.prefab",amout= 40,count = 1},

}
end


function GameConfig:InitScoreConfig()
	self.ScoreRes={
		[1] = {name = "Score",path = "Prefabs/Score/Score.prefab",amout= 20,count = 1},
	}
end

function GameConfig:InitPlusTipsConfig(  )
	self.PlusTipsRes={
		[1] = {name = "PlusTips",path = "Prefabs/PlusTips/PlusTips.prefab",amout= 20,count = 1},
	}
end

function GameConfig:InitBigAwardTipsConfig(  )
	self.BigAwardTipsRes={
		[1] = {name = "BigAwardTips",path = "Prefabs/BigAwardTips/BigAwardTips.prefab",amout= 4,count = 1},
	}
end

function GameConfig:InitLightningConfig()
	self.LightningRes={
		[1] = {name = "Lightning_01",path = "Prefabs/Lightning/Lightning_01.prefab",amout= 1,count = 1},
		[2] = {name = "Lightning_02",path = "Prefabs/Lightning/Lightning_02.prefab",amout= 1,count = 1},
	}
end



function GameConfig:InitEffectConfig()
	self.EffectRes={
		[1] = {name = "Fish35_DieEffect",path = "Prefabs/Effect/Fish35_DieEffect.prefab",amout= 1,count = 1},
		[2] = {name = "Fish36_DieEffect",path = "Prefabs/Effect/Fish36_DieEffect.prefab",amout= 1,count = 1},
		[3] = {name = "Fish37_DieEffect",path = "Prefabs/Effect/Fish37_DieEffect.prefab",amout= 1,count = 1},
	}
end


function GameConfig:InitAudioConfig()
	self.AudioRes={
		[1] = {name = "Audio",path = "Prefabs/Audio/AuidoPanel.prefab",amout= 1,count = 1},
}
end


function GameConfig:InitGameAtlasConfig()
	self.GameSetRes={
		["GameSetSpriteAtlas"]="Common/Atlas/GameSet/GameSetSpriteAtlas.spriteatlas",
		["Bullet_NetSpriteAtlas"]="Common/Atlas/Bullet_Net/Bullet_NetSpriteAtlas.spriteatlas",
		["Fish1SpriteAtlas"]="Common/Atlas/Fish/Fish1SpriteAtlas.spriteatlas",
		["Fish2SpriteAtlas"]="Common/Atlas/Fish/Fish2SpriteAtlas.spriteatlas",
		["Fish3SpriteAtlas"]="Common/Atlas/Fish/Fish3SpriteAtlas.spriteatlas",
		["Fish4SpriteAtlas"]="Common/Atlas/Fish/Fish4SpriteAtlas.spriteatlas",
		["Fish5SpriteAtlas"]="Common/Atlas/Fish/Fish5SpriteAtlas.spriteatlas",
		["GoldSpriteAtlas"]="Common/Atlas/Gold/GoldSpriteAtlas.spriteatlas",
		["PlayerSpriteAtlas"]="Common/Atlas/Player/PlayerSpriteAtlas.spriteatlas",
		["TideSpriteAtlas"]="Common/Atlas/Tide/TideSpriteAtlas.spriteatlas",
		["WaveSpriteAtlas"]="Common/Atlas/Wave/WaveSpriteAtlas.spriteatlas",
		["FontSpriteAtlas"]="Common/Atlas/Font/FontSpriteAtlas.spriteatlas",
		["BigAwardSpriteAtlas"]="Common/Atlas/BigAward/BigAwardSpriteAtlas.spriteatlas",
		
}
end

function GameConfig:InitOtherTexConfig(  )
	self.OtherTexRes={
		[1] = {name ="fish_26",path ="Common/Texture/Fish/fish_26.png",amout= 1,count = 1},	
	}
end

function GameConfig:InitGameBGConfig(  )
	self.BGRes={
		[1] = {name = "t_bg_1",path = "Common/Texture/BG/t_bg_1.png",amout= 1,count = 1},	
		[2] = {name = "t_bg_2",path = "Common/Texture/BG/t_bg_2.png",amout= 1,count = 1},	
		[3] = {name = "t_bg_3",path = "Common/Texture/BG/t_bg_3.png",amout= 1,count = 1},	
	}
end

function GameConfig:InitFishOutTipsConfig(  )
	self.FishOutTipsRes={}
end

function GameConfig:InitLockFishConfig()
	self.LockFishList={
		33,32,31,30,29,
		28,27,26,25,24,
		23,22,21,20--[[,19,
		18,17,16,15,14,
		13,12,11,10,9,
		8,7,6,5,4,
		3,2,1	--]]
	}
end