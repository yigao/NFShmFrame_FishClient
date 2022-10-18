SerialDrillGunFishType=Class(BombBaseFish)

function SerialDrillGunFishType:ctor()
	self:Init()
	
end


function SerialDrillGunFishType:Init ()
	self:InitData()
	self:InitView()

end


function SerialDrillGunFishType:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
end


function SerialDrillGunFishType:InitView(gameObj)
	
	
end


function SerialDrillGunFishType:SetFishDieProcess(hitFishMsg,fishIns,playerIns)
	self:BaseFishDie(fishIns,playerIns,hitFishMsg)
	
	-- self:BaseShowCoinEffect(fishIns,playerIns,hitFishMsg)

	-- self:BaseShowWinScoreEffect(fishIns,playerIns,hitFishMsg)
	
	-- self:BaseShowPlusTipsEffect(fishIns,playerIns,hitFishMsg)

	-- self:BaseShowFishSpecialEffect(fishIns,playerIns,hitFishMsg)
	
	-- self:BaseShowLightningEffect(fishIns,playerIns,hitFishMsg)

	self:SubFishDieProcess(fishIns,playerIns,hitFishMsg)

	self:Destroy()
end

function SerialDrillGunFishType:SubFishDieProcess(fishIns,playerIns,hitFishMsg)
	local fishDamageSmallFishDieEffectConfig = self.gameData.gameConfigList.DieEffectConfigList[fishIns.FishVo.FishConfig.fishDamageSmallFishDieEffectID]
	local fishDamageBigFishDieEffectConfig = self.gameData.gameConfigList.DieEffectConfigList[fishIns.FishVo.FishConfig.fishDamageBigFishDieEffectID]
	if  hitFishMsg.subFishCount and hitFishMsg.subFishCount>0 then
		for i=1,hitFishMsg.subFishs do
			local tempFish,playerIns=FishManager.GetInstance():GetCheckLockSaveFish(hitFishMsg.subFishs[i])
			tempFish:FishBombDie(playerIns,self.hitFishMsg.subFishs[i],fishDamageSmallFishDieEffectConfig,fishDamageBigFishDieEffectConfig)
		end
	end
end

function SerialDrillGunFishType:SubFishDieProcessByFishID(FishID,playerIns,hitFishMsg)

	-- local fishConfig = self.gameData.gameConfigList.FishConfigList[FishID]
	-- local fishDamageSmallFishDieEffectConfig = self.gameData.gameConfigList.DieEffectConfigList[fishConfig.fishDamageSmallFishDieEffectID]
	-- local fishDamageBigFishDieEffectConfig = self.gameData.gameConfigList.DieEffectConfigList[fishConfig.fishDamageBigFishDieEffectID]
	-- if  hitFishMsg.subFishCount and hitFishMsg.subFishCount>0 then
	-- 	for i=1,#hitFishMsg.SubFishes do
	-- 		local tempFish,playerIns=FishManager.GetInstance():GetCheckLockSaveFish(hitFishMsg.SubFishes[i])
	-- 		tempFish:FishBombDie(playerIns,hitFishMsg.SubFishes[i],fishDamageSmallFishDieEffectConfig,fishDamageBigFishDieEffectConfig)
	-- 	end
	-- end
end

