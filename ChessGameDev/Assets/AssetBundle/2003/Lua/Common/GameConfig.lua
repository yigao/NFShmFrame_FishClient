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
	self:GameStateConfig()
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
	self:InitEffectConfig()
	self:InitAudioConfig()
	self:InitGameBGConfig()
	self:InitFishOutTipsConfig()
	self:InitBigAwardTipsConfig()
	self:InitLightningConfig()
	self:InitTipsContentConfig()
end


function GameConfig:InitGameBaseConfig()
	self.Coordinate_ROW=1			--��
	self.Coordinate_COL=4			--��
	self.IconItemTotalCount=10		--ͼ������
	
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
		[1] = {name = "FishConfigList",path = "Common/config/FishConfig/FishConfigData.bytes",data="FishConfig_2003.FishConfigData"},
		[2] = {name = "CoinEffectConfigList",path = "Common/config/FishConfig/CoinEffectConfigData.bytes",data="CoinEffectConfig_2003.CoinEffectConfigData"},
		[3] = {name = "DieEffectConfigList",path = "Common/config/FishConfig/DieEffectConfigData.bytes",data="DieEffectConfig_2003.DieEffectConfigData"},
		[4] = {name = "GunConfigList",path = "Common/config/FishConfig/GunConfigData.bytes",data="GunConfig_2003.GunConfigData"},
		[5] = {name = "RoomConfigList",path = "Common/config/FishConfig/RoomConfigData.bytes",data="RoomConfig_2003.RoomConfigData"},
		[6] = {name = "ScoreEffectConfigList",path = "Common/config/FishConfig/ScoreEffectConfigData.bytes",data="ScoreEffectConfig_2003.ScoreEffectConfigData"},
		[7] = {name = "SoundConfigList",path = "Common/config/FishConfig/SoundConfigData.bytes",data="SoundConfig_2003.SoundConfigData"},
		[8] = {name = "PlusTipsEffectConfigList",path = "Common/config/FishConfig/PlusTipsEffectConfigData.bytes",data="PlusTipsEffectConfig_2003.PlusTipsEffectConfigData"},
		[9] = {name = "BigAwardTipsEffectConfigList",path = "Common/config/FishConfig/BigAwardTipsEffectConfigData.bytes",data="BigAwardTipsEffectConfig_2003.BigAwardTipsEffectConfigData"},
	}
end



function GameConfig:InitFishConfig()
	self.FishPackRes={
		[1] = {name = "Fish_Pack_01",path = "Prefabs/FishPack/Fish_Pack_01.prefab"},
		[2] = {name = "Fish_Pack_02",path = "Prefabs/FishPack/Fish_Pack_02.prefab"},
		[3] = {name = "Fish_Pack_03",path = "Prefabs/FishPack/Fish_Pack_03.prefab"},
		[4] = {name = "Fish_Pack_04",path = "Prefabs/FishPack/Fish_Pack_04.prefab"},
	}
	
	--  22 29 38 39 40 �⼸����ʱ����
	------------------------------------------------------------------------------------------
	self.FishRes={
		[1] = {name = "Fish_01",ParentName = "Fish_Pack_01",amout = 15,},
		[2] = {name = "Fish_02",ParentName = "Fish_Pack_01",amout = 15,},
		[3] = {name = "Fish_03",ParentName = "Fish_Pack_01",amout = 15,},
		[4] = {name = "Fish_04",ParentName = "Fish_Pack_01",amout = 15,},
		[5] = {name = "Fish_05",ParentName = "Fish_Pack_01",amout = 15,},
		[6] = {name = "Fish_06",ParentName = "Fish_Pack_01",amout = 15,},
		[7] = {name = "Fish_07",ParentName = "Fish_Pack_01",amout = 15,},
		[8] = {name = "Fish_08",ParentName = "Fish_Pack_01",amout = 15,},
		[9] = {name = "Fish_09",ParentName = "Fish_Pack_01",amout = 15,},
		[10] = {name = "Fish_10",ParentName = "Fish_Pack_01",amout = 15, },
		
		[11] = {name = "Fish_11",ParentName = "Fish_Pack_02",amout = 15, },
		[12] = {name = "Fish_12",ParentName = "Fish_Pack_02",amout = 15, },
		[13] = {name = "Fish_13",ParentName = "Fish_Pack_02",amout = 15, },
		[14] = {name = "Fish_14",ParentName = "Fish_Pack_02",amout = 15, },
		[15] = {name = "Fish_15",ParentName = "Fish_Pack_02",amout = 15, },
		[16] = {name = "Fish_16",ParentName = "Fish_Pack_02",amout = 15, },
		[17] = {name = "Fish_17",ParentName = "Fish_Pack_02",amout = 15, },
		[18] = {name = "Fish_18",ParentName = "Fish_Pack_02",amout = 15, },
		[19] = {name = "Fish_19",ParentName = "Fish_Pack_02",amout = 15, },
		[20] = {name = "Fish_20",ParentName = "Fish_Pack_02",amout = 15, },
		
		[21] = {name = "Fish_21",ParentName = "Fish_Pack_03",amout = 15, },
		[22] = {name = "Fish_22",ParentName = "Fish_Pack_03",amout = 15, },
		[23] = {name = "Fish_23",ParentName = "Fish_Pack_03",amout = 15, },
		[24] = {name = "Fish_24",ParentName = "Fish_Pack_03",amout = 15, },
		[25] = {name = "Fish_25",ParentName = "Fish_Pack_03",amout = 15, },
		[26] = {name = "Fish_26",ParentName = "Fish_Pack_03",amout = 15, },
		[27] = {name = "Fish_27",ParentName = "Fish_Pack_03",amout = 15, },
		[28] = {name = "Fish_28",ParentName = "Fish_Pack_03",amout = 15, },
		[29] = {name = "Fish_29",ParentName = "Fish_Pack_03",amout = 15, },
		[30] = {name = "Fish_30",ParentName = "Fish_Pack_03",amout = 15, },
		
		[31] = {name = "Fish_31",ParentName = "Fish_Pack_04",amout = 15, },
		[32] = {name = "Fish_32",ParentName = "Fish_Pack_04",amout = 15, },
		[33] = {name = "Fish_33",ParentName = "Fish_Pack_04",amout = 15, },
		[34] = {name = "Fish_34",ParentName = "Fish_Pack_04",amout = 15, },
		[35] = {name = "Fish_35",ParentName = "Fish_Pack_04",amout = 15, },
		[36] = {name = "Fish_36",ParentName = "Fish_Pack_04",amout = 15, },
		[37] = {name = "Fish_37",ParentName = "Fish_Pack_04",amout = 15, },
		[38] = {name = "Fish_38",ParentName = "Fish_Pack_04",amout = 15, },
		[39] = {name = "Fish_39",ParentName = "Fish_Pack_04",amout = 15, },
		[40] = {name = "Fish_40",ParentName = "Fish_Pack_04",amout = 15, },
		[41] = {name = "Fish_41",ParentName = "Fish_Pack_04",amout = 15, },
		
		
	}
	-----------------------------------------------------------------------------------------------
	
end


function GameConfig:InitBulletConfig()
	self.BulletRes={
		[1] = {name = "Bullet1",path = "Prefabs/Bullet/Bullet1.prefab",amout = 45, },
		[2] = {name = "Bullet2",path = "Prefabs/Bullet/Bullet2.prefab",amout = 45, },
		[3] = {name = "Bullet3",path = "Prefabs/Bullet/Bullet3.prefab",amout = 45, },
		[4] = {name = "Bullet4",path = "Prefabs/Bullet/Bullet4.prefab",amout = 45, },
	}
end

function GameConfig:InitNetConfig()
	self.NetRes={
		[1] = {name = "Net1",path = "Prefabs/Net/Net1.prefab",amout = 20, },
		[2] = {name = "Net2",path = "Prefabs/Net/Net2.prefab",amout = 20, },
		[3] = {name = "Net3",path = "Prefabs/Net/Net3.prefab",amout = 20, },
		[4] = {name = "Net4",path = "Prefabs/Net/Net4.prefab",amout = 20, },
	}
end


function GameConfig:InitPlayerConfig()
	self.PlayerRes={
		[1] = {name = "PlayerPanelDown1",path = "Prefabs/Panel/PlayerPanelDown1.prefab",amout= 1,},
		[2] = {name = "PlayerPanelDown2",path = "Prefabs/Panel/PlayerPanelDown2.prefab",amout= 1,},
		[3] = {name = "PlayerPanelUp1",path = "Prefabs/Panel/PlayerPanelUp1.prefab",amout= 1,},
		[4] = {name = "PlayerPanelUp2",path = "Prefabs/Panel/PlayerPanelUp2.prefab",amout= 1,},
	}
end

function GameConfig:InitPanelConfig()
	self.GamePanelRes={
		GameSetPanel="Prefabs/Panel/GameSetPanel.prefab"
		
}
end


function GameConfig:InitGoldConfig()
	self.GoldRes={
		[1] = {name = "Coin01",path = "Prefabs/Gold/Coin01.prefab",amout= 40,},
		[2] = {name = "BigWinCoinEffect",path = "Prefabs/Gold/BigWinCoinEffect.prefab",amout= 10,},
}
end


function GameConfig:InitScoreConfig()
	self.ScoreRes={
		[1] = {name = "Score",path = "Prefabs/Score/Score.prefab",amout= 20,},
	}
end

function GameConfig:InitPlusTipsConfig(  )
	self.PlusTipsRes={
		[1] = {name = "PlusTips",path = "Prefabs/PlusTips/PlusTips.prefab",amout= 20,},
	}
end


function GameConfig:InitEffectConfig()
	self.EffectRes={
		[1] = {name = "HeMaBomb",path = "Prefabs/Effect/HeMaBomb.prefab",amout= 1,},
		[2] = {name = "BlackHole_CannonXZK",path = "Prefabs/Effect/BlackHole_CannonXZK.prefab",amout= 1,},
		[3] = {name = "BlackholeFly",path = "Prefabs/Effect/BlackholeFly.prefab",amout= 1,},
		[4] = {name = "Blackhole_Effect",path = "Prefabs/Effect/Blackhole_Effect.prefab",amout= 1,},
		[5] = {name = "HaiShenEffect",path = "Prefabs/Effect/HaiShenEffect.prefab",amout= 1,},
		[6] = {name = "JinNiuEffect",path = "Prefabs/Effect/JinNiuEffect.prefab",amout= 1,},
		[7] = {name = "CaiShenEffect",path = "Prefabs/Effect/CaiShenEffect.prefab",amout= 1,},
		
	}
end


function GameConfig:InitAudioConfig()
	self.AudioRes={
		[1] = {name = "Audio",path = "Prefabs/Audio/AuidoPanel.prefab",amout= 1,},
}
end


function GameConfig:InitGameAtlasConfig()
	self.GameSetRes={
		["GameSetSpriteAtlas"]="Common/Atlas/GameSet/GameSetSpriteAtlas.spriteatlas",
		["Cannon1SpriteAtlas"]="Common/Atlas/Cannon/Cannon1SpriteAtlas.spriteatlas",
		["Cannon2SpriteAtlas"]="Common/Atlas/Cannon/Cannon2SpriteAtlas.spriteatlas",
		["Cannon3SpriteAtlas"]="Common/Atlas/Cannon/Cannon3SpriteAtlas.spriteatlas",
		["Cannon4SpriteAtlas"]="Common/Atlas/Cannon/Cannon4SpriteAtlas.spriteatlas",
		["GoldSpriteAtlas"]="Common/Atlas/Gold/GoldSpriteAtlas.spriteatlas",
		["PlayerSpriteAtlas"]="Common/Atlas/Player/PlayerSpriteAtlas.spriteatlas",
		--["TideSpriteAtlas"]="Common/Atlas/Tide/TideSpriteAtlas.spriteatlas",
		["TipsFishSpriteAtlas"]="Common/Atlas/BossFishTips/TipsFishSpriteAtlas.spriteatlas",
		["TipsFontSpriteAtlas"]="Common/Atlas/Font/TipsFontSpriteAtlas.spriteatlas",
}
end

function GameConfig:InitGameBGConfig(  )
	self.BGRes={
		[1] = {name = "bg_1",path = "Common/Texture/BG/bg_1.png",amout= 1,},	
		[2] = {name = "bg_2",path = "Common/Texture/BG/bg_2.png",amout= 1,},	
		[3] = {name = "bg_3",path = "Common/Texture/BG/bg_3.png",amout= 1,},	
		[4] = {name = "bg_4",path = "Common/Texture/BG/bg_4.png",amout= 1,},	
		[5] = {name = "bg_5",path = "Common/Texture/BG/bg_5.png",amout= 1,},	
		[6] = {name = "bg_6",path = "Common/Texture/BG/bg_6.png",amout= 1,},	
	}
end

function GameConfig:InitFishOutTipsConfig(  )
	self.FishOutTipsRes={
		 [1] = {name = "FishOutTips_Tide",path = "Prefabs/FishOutTips/FishOutTips_Tide.prefab",amout= 1,},
		 [2] = {name = "FishOutTips_26",path = "Prefabs/FishOutTips/FishOutTips_26.prefab",amout= 1,},
		 [3] = {name = "FishOutTips_27",path = "Prefabs/FishOutTips/FishOutTips_27.prefab",amout= 1,},
		 [4] = {name = "FishOutTips_28",path = "Prefabs/FishOutTips/FishOutTips_28.prefab",amout= 1,},
		 [5] = {name = "FishOutTips_30",path = "Prefabs/FishOutTips/FishOutTips_30.prefab",amout= 1,},
		 [6] = {name = "FishOutTips_31",path = "Prefabs/FishOutTips/FishOutTips_31.prefab",amout= 1,},
		 [7] = {name = "FishOutTips_32",path = "Prefabs/FishOutTips/FishOutTips_32.prefab",amout= 1,},
		 [8] = {name = "FishOutTips_33",path = "Prefabs/FishOutTips/FishOutTips_33.prefab",amout= 1,},
		 [9] = {name = "FishOutTips_34",path = "Prefabs/FishOutTips/FishOutTips_34.prefab",amout= 1,},
		 [10] = {name = "FishOutTips_37",path = "Prefabs/FishOutTips/FishOutTips_37.prefab",amout= 1,},
		 [11] = {name = "FishOutTips_36",path = "Prefabs/FishOutTips/FishOutTips_36.prefab",amout= 1,},
	}
end


function GameConfig:InitBigAwardTipsConfig(  )
	self.BigAwardTipsRes={
		[1] = {name = "BigAwardTips",path = "Prefabs/BigAwardTips/BigAwardTips.prefab",amout= 4,},
	}
end

function GameConfig:InitLightningConfig()
	self.LightningRes={
		[1] = {name = "Lightning_01",path = "Prefabs/Lightning/Lightning_01.prefab",amout= 10,},
	}
end

function GameConfig:InitTipsContentConfig()
	self.TipsContentRes={
		[1] = {name = "TipsContent",path = "Prefabs/Tips/TipsContent.prefab",amout= 10,},
	}
end




function GameConfig:InitLockFishConfig()
	self.LockFishList={
		41,40,39,
		38,37,36,35,34,
		33,32,31,30,29,
		28,27,26,25,24,
		23,22,21,20,19,
		--[[18,17,16,15,14,
		13,12,11,10,9,
		8,7,6,5,4,
		3,2,1	--]]
	}
end