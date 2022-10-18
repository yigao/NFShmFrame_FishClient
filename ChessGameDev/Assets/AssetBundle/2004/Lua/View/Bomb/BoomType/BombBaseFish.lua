BombBaseFish=Class()

function BombBaseFish:ctor()
	self:BaseInit()
end


function BombBaseFish:BaseInit ()
	self:BaseInitData()
	self:BaseInitView()

end


function BombBaseFish:BaseInitData()
	self.gameData=GameManager.GetInstance().gameData
	self.IsUsing=false
	self.customEffectPosList ={CSScript.Vector3.zero,CSScript.Vector3.zero,CSScript.Vector3.zero}
end


function BombBaseFish:BaseInitView()
	
	
end

function BombBaseFish:GetCustormEffectPos(index)
	return self.customEffectPosList[index]
end


function BombBaseFish:BaseShakeOrVibrate(hitFishMsg,fishIns)
	if hitFishMsg.bombUID and hitFishMsg.bombUID ~=0  then return end
	if self.gameData.PlayerChairId == hitFishMsg.chairId then
		if fishIns.FishVo.FishConfig.IsShakeScreen == 1 then
			local isVibrate = false
			if fishIns.FishVo.FishConfig.IsPhoneVibrate == 1 then
				isVibrate = true
			end
			GameUIManager.GetInstance():SetShake(isVibrate)
		end
	end
end


function BombBaseFish:UpdateFishDieEffectConfig(fishIns,playerIns,hitFishMsg)
	if hitFishMsg.bombUID and hitFishMsg.bombUID ~=0 then
		local parentFish=FishManager.GetInstance():GetCacheFishByID(hitFishMsg.bombUID)
		local subFishDieEffectConfig = nil
		if parentFish then
			subFishDieEffectConfig = self.gameData.gameConfigList.DieEffectConfigList[parentFish.FishVo.FishConfig.fishDamageSmallFishDieEffectID]
		else
			local fishConfig = self.gameData.gameConfigList.FishConfigList[hitFishMsg.bombFishId]
			subFishDieEffectConfig = self.gameData.gameConfigList.DieEffectConfigList[fishConfig.fishDamageSmallFishDieEffectID]
		end
		fishIns:UpdateDieEffectConfig(subFishDieEffectConfig)
		return true
	end		
	return false
end


function BombBaseFish:BaseFishDie(fishIns,playerIns,hitFishMsg)
	if self.gameData.PlayerChairId==hitFishMsg.chairId then
		self:PlayBaseFishDieAudio(fishIns,hitFishMsg.bombUID)
	end
	fishIns:FishNormalDie(playerIns,hitFishMsg)
end


function BombBaseFish:PlayBaseFishDieAudio(fishIns,bombUID)
	if bombUID==0 then
		local count=#fishIns.FishVo.FishConfig.FishDieAudio
		if count>0 then
			local audioIndex=fishIns.FishVo.FishConfig.FishDieAudio[CommonHelper.GetRandomTwo(1,count)]
			AudioManager.GetInstance():PlayNormalAudio(audioIndex)
		end
	end
end


function BombBaseFish:BaseShowPlusTipsEffect(fishIns,playerIns,hitFishMsg)
	local dieEffectConfig=FishEffectManager.GetInstance():GetFishEffectConfig(fishIns.FishVo.FishConfig.dieEffectId)
	if dieEffectConfig then
		local plusTipsM=PlusTipsEffectManager.GetInstance()
		if dieEffectConfig.plusTipsID then
			local tempConfig=plusTipsM:GetPlusTipsEffectConfig(dieEffectConfig.plusTipsID)
			if tempConfig then
				local parentFishID=hitFishMsg.bombUID
				if parentFishID and parentFishID==0 then
					plusTipsM:SetPlusTipsEffectShowMode(playerIns.ChairdID,playerIns.FlyScorePos,hitFishMsg.mainScore,tempConfig)
				end		
			end
		end
	end
end


function BombBaseFish:BaseShowFishSpecialEffect(fishIns,playerIns,hitFishMsg)
	local fishEffectM=FishEffectManager.GetInstance()
	local dieEffectConfig=fishEffectM:GetFishEffectConfig(fishIns.FishVo.FishConfig.dieEffectId)
	if dieEffectConfig then
		for i = 1,#dieEffectConfig.dieEffectName do
			local name =dieEffectConfig.dieEffectName[i] 
			local type = dieEffectConfig.dieEffectType[i]
			local positionFlag = dieEffectConfig.dieEffectPositionFlag[i]
			local delayTime = dieEffectConfig.dieEffectDelyTime[i]
			local lifeTime = dieEffectConfig.dieEffectLifeTime[i]
			local effectAudio = dieEffectConfig.dieAudio[i]
			if name ~= "nil" then
				local beginPos = CSScript.Vector3.zero
				if positionFlag == 1 then
					beginPos = fishIns.gameObject.transform.position
				elseif positionFlag == 2 then
					beginPos = GameObjectPoolManager.GetInstance():GetPoolParent(GameObjectPoolManager.PoolType.EffectPool).transform.position
				elseif positionFlag == 3 then
					beginPos = self:GetCustormEffectPos(i)
				end
				
				fishEffectM:ShowFishEffect(beginPos,type,name,delayTime,lifeTime,effectAudio)
			end
		end
	end
end


function BombBaseFish:BaseShowLightningEffect(fishIns,playerIns,hitFishMsg)
	local lightningEffectM=LightningEffectManager.GetInstance()
	local tempConfig=lightningEffectM:GetFishEffectConfig(fishIns.FishVo.FishConfig.dieEffectId)
	if tempConfig then
		local parentFishID=hitFishMsg.bombUID
		if parentFishID and parentFishID==0 then
			if  hitFishMsg.subFishCount and hitFishMsg.subFishCount>0 then
				if #hitFishMsg.SubFishes>0 then
					for i=1,#hitFishMsg.SubFishes do
						local tempSubFish = FishManager.GetInstance():GetCacheFishByID(hitFishMsg.SubFishes[i].mainFishUID)
						lightningEffectM:SetLightningEffectShowMode(fishIns.gameObject.transform,tempSubFish.gameObject.transform,playerIns.ChairdID,fishIns.FishVo.UID,tempConfig)
					end
				end
			end
		end		
	end	
end

function BombBaseFish:__delete()
	self.IsUsing=false
end

