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
	self:InitSpecialDeclareConfig()
	self:InitEffectConfig()
	self:InitAudioConfig()
	self:InitGameBGConfig()
	self:InitFishOutTipsConfig()
	self:InitLightningConfig()
	self:InitSkillConfig()
	self:InitTipsContentConfig()
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
		Part= 5,
		Dragon=6,
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
		"SpecialDeclareConfig",
	}
	
	self.FishConfigByte={
		[1] = {name = "FishConfigList",path = "Common/config/FishConfig/FishConfigData.bytes",data="FishConfig_2004.FishConfigData"},
		[2] = {name = "CoinEffectConfigList",path = "Common/config/FishConfig/CoinEffectConfigData.bytes",data="CoinEffectConfig_2004.CoinEffectConfigData"},
		[3] = {name = "DieEffectConfigList",path = "Common/config/FishConfig/DieEffectConfigData.bytes",data="DieEffectConfig_2004.DieEffectConfigData"},
		[4] = {name = "GunConfigList",path = "Common/config/FishConfig/GunConfigData.bytes",data="GunConfig_2004.GunConfigData"},
		[5] = {name = "RoomConfigList",path = "Common/config/FishConfig/RoomConfigData.bytes",data="RoomConfig_2004.RoomConfigData"},
		[6] = {name = "ScoreEffectConfigList",path = "Common/config/FishConfig/ScoreEffectConfigData.bytes",data="ScoreEffectConfig_2004.ScoreEffectConfigData"},
		[7] = {name = "SoundConfigList",path = "Common/config/FishConfig/SoundConfigData.bytes",data="SoundConfig_2004.SoundConfigData"},
		[8] = {name = "PlusTipsEffectConfigList",path = "Common/config/FishConfig/PlusTipsEffectConfigData.bytes",data="PlusTipsEffectConfig_2004.PlusTipsEffectConfigData"},
		[9] = {name = "SpecialDeclareConfigList",path = "Common/config/FishConfig/SpecialDeclareConfigData.bytes",data="SpecialDeclareConfig_2004.SpecialDeclareConfigData"},
	}
	
end



function GameConfig:InitFishConfig()
	self.FishPackRes={
		[1] = {name = "Fish_Pack_01",path = "Prefabs/FishPack/Fish_Pack_01.prefab"},
		[2] = {name = "Fish_Pack_02",path = "Prefabs/FishPack/Fish_Pack_02.prefab"},
		[3] = {name = "Fish_Pack_03",path = "Prefabs/FishPack/Fish_Pack_03.prefab"},
		[4] = {name = "Fish_Pack_04",path = "Prefabs/FishPack/Fish_Pack_04.prefab"},
		[5] = {name = "Fish_Pack_05",path = "Prefabs/FishPack/Fish_Pack_05.prefab"},
		[6] = {name = "Fish_Pack_06",path = "Prefabs/FishPack/Fish_Pack_06.prefab"},

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
		[38] = {name = "Fish_38",ParentName = "Fish_Pack_05",amout = 15, count = 1},
		[39] = {name = "Fish_39",ParentName = "Fish_Pack_05",amout = 15, count = 1},
		[40] = {name = "Fish_40",ParentName = "Fish_Pack_05",amout = 15, count = 1},

		[41] = {name = "Fish_41",ParentName = "Fish_Pack_06",amout = 15, count = 1},
		[42] = {name = "Fish_42",ParentName = "Fish_Pack_06",amout = 15, count = 1},
		[43] = {name = "Fish_43",ParentName = "Fish_Pack_06",amout = 15, count = 1},
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
		[1] = {name = "Score01",path = "Prefabs/Score/Score01.prefab",amout= 30,count = 1},
		[2] = {name = "Score02",path = "Prefabs/Score/Score02.prefab",amout= 30,count = 1},
	}
end

function GameConfig:InitPlusTipsConfig(  )
	self.PlusTipsRes={
		[1] = {name = "PlusTips",path = "Prefabs/PlusTips/PlusTips.prefab",amout= 20,count = 1},
	}
end

function GameConfig:InitSpecialDeclareConfig(  )
	self.SpecialDeclareRes={
		[1] = {name = "SpecialDeclare_Bomb",path = "Prefabs/SpecialDeclare/SpecialDeclare_Bomb.prefab",amout= 1,count = 1},
		[2] = {name = "SpecialDeclare_Drill",path = "Prefabs/SpecialDeclare/SpecialDeclare_Drill.prefab",amout= 1,count = 1},
		[3] = {name = "SpecialDeclare_Electric",path = "Prefabs/SpecialDeclare/SpecialDeclare_Electric.prefab",amout= 1,count = 1},
		[4] = {name = "SpecialDeclare_Flash",path = "Prefabs/SpecialDeclare/SpecialDeclare_Flash.prefab",amout= 1,count = 1},
		[5] = {name = "SpecialDeclare_MultBomb",path = "Prefabs/SpecialDeclare/SpecialDeclare_MultBomb.prefab",amout= 1,count = 1},
		[6] = {name = "SpecialDeclare_Vortex",path = "Prefabs/SpecialDeclare/SpecialDeclare_Vortex.prefab",amout= 1,count = 1},
		[7] = {name = "SpecialDeclare_FireStorm",path = "Prefabs/SpecialDeclare/SpecialDeclare_FireStorm.prefab",amout= 1,count = 1},
		[8] = {name = "FireStormYouWin",path = "Prefabs/SpecialDeclare/FireStormYouWin.prefab",amout= 1,count = 1},
		[9] = {name = "Bison_CutIn",path = "Prefabs/SpecialDeclare/Bison_CutIn.prefab",amout= 1,count = 1},
		[10] = {name = "SpecialDeclare_Bison",path = "Prefabs/SpecialDeclare/SpecialDeclare_Bison.prefab",amout= 1,count = 1},
		[11] = {name = "SpecialDeclare_BisonsOther",path = "Prefabs/SpecialDeclare/SpecialDeclare_BisonsOther.prefab",amout= 1,count = 1},
		[12] = {name = "SpiderCrabBossHurt",path = "Prefabs/SpecialDeclare/SpiderCrabBossHurt.prefab",amout= 1,count = 1},
		[13] = {name = "SpiderCrabKillInfo",path = "Prefabs/SpecialDeclare/SpiderCrabKillInfo.prefab",amout= 1,count = 1},
		[14] = {name = "SpiderCrabBoardScore",path = "Prefabs/SpecialDeclare/SpiderCrabBoardScore.prefab",amout= 1,count = 1},
		[15] = {name = "SpecialDeclare_Dragon",path = "Prefabs/SpecialDeclare/SpecialDeclare_Dragon.prefab",amout= 1,count = 1},
	}
end

function GameConfig:InitLightningConfig()
	self.LightningRes={
		[1] = {name = "Effect_FlashLine",path = "Prefabs/LightningEffect/Effect_FlashLine.prefab",amout= 30,count = 1},
	}
end


function GameConfig:InitEffectConfig()
	self.EffectRes={
		[1] = {name = "Effect_Swirl",path = "Prefabs/Effect/Effect_Swirl.prefab",amout= 1,count = 1},
		[2] = {name = "Effect_Flash",path = "Prefabs/Effect/Effect_Flash.prefab",amout= 1,count = 1},
		[3] = {name = "Effect_FlashBall",path = "Prefabs/Effect/Effect_FlashBall.prefab",amout= 1,count = 1},
		[4] = {name = "burst_coin_small",path = "Prefabs/Effect/burst_coin_small.prefab",amout= 30,count =1},
		[5] = {name = "Effect_Bomb",path = "Prefabs/Effect/Effect_Bomb.prefab",amout= 1,count = 1},
		[6] = {name = "burst_coin_bison",path = "Prefabs/Effect/burst_coin_bison.prefab",amout= 30,count = 1},
		[7] = {name = "burst_coin_large_luckyCat",path = "Prefabs/Effect/burst_coin_large_luckyCat.prefab",amout= 1,count = 1},
		[8] = {name = "KingCrabcoinPrefab",path = "Prefabs/Effect/KingCrabcoinPrefab.prefab",amout= 1,count = 1},
		[9] = {name = "burst_coin_long",path = "Prefabs/Effect/burst_coin_long.prefab",amout= 1,count = 5},
		[10] = {name = "Effect_Warning",path = "Prefabs/Effect/Effect_Warning.prefab",amout= 1,count = 5},
	}
end


function GameConfig:InitSkillConfig()
	self.SkillRes={
		[1] = {name = "Skill_Electric",path = "Prefabs/Skill/Skill_Electric.prefab",amout= 1,count = 1},
		[2] = {name = "Gun_Electric",path = "Prefabs/Skill/Gun_Electric.prefab",amout= 1,count = 1},
		[3] = {name = "Skill_FireStorm",path = "Prefabs/Skill/Skill_FireStorm.prefab",amout= 1,count = 1},
		[4] = {name = "Skill_Drill",path = "Prefabs/Skill/Skill_Drill.prefab",amout= 1,count = 1},
		[5] = {name = "Gun_Drill",path = "Prefabs/Skill/Gun_Drill.prefab",amout= 1,count = 1},
		[6] = {name = "Bullet_Drill",path = "Prefabs/Skill/Bullet_Drill.prefab",amout= 1,count = 1},
		[7] = {name = "Gun_SerialDrill",path = "Prefabs/Skill/Gun_SerialDrill.prefab",amout= 1,count = 1},
		[8] = {name = "Bullet_SerialDrill",path = "Prefabs/Skill/Bullet_SerialDrill.prefab",amout= 1,count = 1},
		[9] = {name = "Skill_Bison",path = "Prefabs/Skill/Skill_Bison.prefab",amout= 1,count = 1},
		[10] = {name = "Skill_CountdownTimer",path = "Prefabs/Skill/Skill_CountdownTimer.prefab",amout= 1,count = 1},
		[11] = {name = "Skill_Bomb",path = "Prefabs/Skill/Skill_Bomb.prefab",amout= 1,count = 1},
		[12] = {name = "Skill_MultiBomb",path = "Prefabs/Skill/Skill_MultiBomb.prefab",amout= 1,count = 1},
		
		
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
		["Fish6SpriteAtlas"]="Common/Atlas/Fish/Fish6SpriteAtlas.spriteatlas",
		["Fish7SpriteAtlas"]="Common/Atlas/Fish/Fish7SpriteAtlas.spriteatlas",
		["Fish8SpriteAtlas"]="Common/Atlas/Fish/Fish8SpriteAtlas.spriteatlas",
		["Fish9SpriteAtlas"]="Common/Atlas/Fish/Fish9SpriteAtlas.spriteatlas",
		["Fish10SpriteAtlas"]="Common/Atlas/Fish/Fish10SpriteAtlas.spriteatlas",
		["GoldSpriteAtlas"]="Common/Atlas/Gold/GoldSpriteAtlas.spriteatlas",
		["PlayerSpriteAtlas"]="Common/Atlas/Player/PlayerSpriteAtlas.spriteatlas",
		["FontSpriteAtlas"]="Common/Atlas/Font/FontSpriteAtlas.spriteatlas",
		["DeclareSpriteAtlas"]="Common/Atlas/Declare/DeclareSpriteAtlas.spriteatlas",
		["SkillSpriteAtlas"]="Common/Atlas/Skill/SkillSpriteAtlas.spriteatlas",
}
end

function GameConfig:InitGameBGConfig(  )
	self.BGRes={
		[1] = {name = "t_bg_1",path = "Common/Texture/BG/t_bg_1.png",amout= 1,count = 1},	
		[2] = {name = "t_bg_2",path = "Common/Texture/BG/t_bg_2.png",amout= 1,count = 1},	
		[3] = {name = "t_bg_3",path = "Common/Texture/BG/t_bg_3.png",amout= 1,count = 1},	
		[4] = {name = "t_bg_4",path = "Common/Texture/BG/t_bg_4.png",amout= 1,count = 1},	
		[5] = {name = "t_bg_5",path = "Common/Texture/BG/t_bg_5.png",amout= 1,count = 1},	
		[6] = {name = "t_bg_6",path = "Common/Texture/BG/t_bg_6.png",amout= 1,count = 1},	
		[7] = {name = "t_bg_7",path = "Common/Texture/BG/t_bg_7.png",amout= 1,count = 1},	
	}
end

function GameConfig:InitFishOutTipsConfig(  )
	self.FishOutTipsRes={
		[1] = {name = "YuChao_Coming",path = "Prefabs/FishOutTips/YuChao_Coming.prefab",amout= 1,count = 1},
		[2] = {name = "Bisons_Coming",path = "Prefabs/FishOutTips/Bisons_Coming.prefab",amout= 1,count = 1},
		[3] = {name = "SpiderCrabBoss_Coming",path = "Prefabs/FishOutTips/SpiderCrabBoss_Coming.prefab",amout= 1,count = 1},
		[4] = {name = "Fish_Coming_dianciyu",path = "Prefabs/FishOutTips/Fish_Coming_dianciyu.prefab",amout= 1,count = 1},
		[5] = {name = "Fish_Coming_dianguangshuimu",path = "Prefabs/FishOutTips/Fish_Coming_dianguangshuimu.prefab",amout= 1,count = 1},
		[6] = {name = "Fish_Coming_lianhuanzhadan",path = "Prefabs/FishOutTips/Fish_Coming_lianhuanzhadan.prefab",amout= 1,count = 1},
		[7] = {name = "Fish_Coming_xuanfengyu",path = "Prefabs/FishOutTips/Fish_Coming_xuanfengyu.prefab",amout= 1,count = 1},
		[8] = {name = "Fish_Coming_zhadanyu",path = "Prefabs/FishOutTips/Fish_Coming_zhadanyu.prefab",amout= 1,count = 1},
		[9] = {name = "Fish_Coming_zuantouxie",path = "Prefabs/FishOutTips/Fish_Coming_zuantouxie.prefab",amout= 1,count = 1},
		[10] = {name = "ComingUp_FireStorm",path = "Prefabs/FishOutTips/ComingUp_FireStorm.prefab",amout= 1,count = 1},
	}
end


function GameConfig:InitTipsContentConfig()
	self.TipsContentRes={
		[1] = {name = "TipsContent",path = "Prefabs/Tips/TipsContent.prefab",amout= 10,},
	}
end


function GameConfig:InitLockFishConfig()
	self.LockFishList={
		43,42,41,40,39,
		38,37,36,35,34,
		33,32,31,30,29,
		28,27,26,25,24,
		23,22,21,20
	}
end