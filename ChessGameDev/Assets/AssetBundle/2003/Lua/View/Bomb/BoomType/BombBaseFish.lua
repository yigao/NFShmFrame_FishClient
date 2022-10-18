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
end


function BombBaseFish:BaseInitView()
	
	
end


function BombBaseFish:BaseFishDie(fishIns,hitFishMsg)
	if self.gameData.PlayerChairId==hitFishMsg.chairId then
		self:PlayBaseFishDieAudio(fishIns,hitFishMsg.bombUID)
	end
	fishIns:FishNormalDie()
end


function BombBaseFish:PlayBaseFishDieAudio(fishIns,bombUID)
	--print(bombUID)
	if bombUID==0 then
		local count=#fishIns.FishVo.FishConfig.FishDieAudio
		if count>0 then
			local audioIndex=fishIns.FishVo.FishConfig.FishDieAudio[CommonHelper.GetRandomTwo(1,count)]
			AudioManager.GetInstance():PlayNormalAudio(audioIndex)
		end
		
	end
	
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


function BombBaseFish:BaseShowCoinEffect(fishIns,playerIns,hitFishMsg)
	local parentFishID=hitFishMsg.bombUID
	local coinEffectId=0		
	if parentFishID then
		if parentFishID==0 then
			coinEffectId=fishIns.FishVo.FishConfig.coinEffectId
		else
			coinEffectId=fishIns.FishVo.FishConfig.fishKillFishCoinEffectID
		end
	end
	
	local fishConfigData = fishIns.FishVo.FishConfig
	if coinEffectId==nil then return end
	local goldEffectConfig=GoldEffectManager.GetInstance():GetGoldEffectConfig(coinEffectId)
	local coinType=goldEffectConfig.coinType
	if coinType==GoldEffectManager.GetInstance().GoldEffectType.createCoinType then
		local coinEffectCount=fishConfigData.coinEffectCount or 0
		if coinEffectId and  coinEffectId~=0  and  coinEffectCount>0 then	
			local endPos=playerIns:GetFlyCoinPos()
			GoldEffectManager.GetInstance():SetCoinEffectShowMode(fishIns.gameObject.transform,playerIns.ChairdID,fishIns.FishVo.UID,fishConfigData.coinEffectId,fishConfigData.coinEffectCount,endPos)
		else
			Debug.LogError("显示的金币ID不存在或数量为nil")
		end
	elseif coinType==GoldEffectManager.GetInstance().GoldEffectType.showCoinEffectType then
		GoldEffectManager.GetInstance():ShowCoinEffectMode(fishIns,playerIns,goldEffectConfig)
	end
	
end


function BombBaseFish:BaseShowWinScoreEffect(fishIns,playerIns,hitFishMsg)
	local scoreM=ScoreEffectManager.GetInstance()
	local tempConfig=scoreM:GetScoreEffectConfig(fishIns.FishVo.FishConfig.winScoreID)
	if tempConfig then
		local scoreType=tempConfig.scoreType
		local parentFishID=hitFishMsg.bombUID
		if parentFishID and parentFishID==0 then
			if scoreType==scoreM.ScoreType.AllShow then
				scoreM:SetScoreEffectShowMode(fishIns.gameObject.transform,playerIns.ChairdID,hitFishMsg.mainScore,tempConfig.scoreDelayTime,tempConfig)
			elseif scoreType==scoreM.ScoreType.OnlyShow then
				scoreM:SetScoreEffectShowMode(fishIns.gameObject.transform,playerIns.ChairdID,hitFishMsg.totalScore,tempConfig.scoreDelayTime,tempConfig)
				if self.gameData.PlayerChairId==hitFishMsg.chairId then
					--[[local audioIndex = 0
					local totalRatio = hitFishMsg.totalRatio
					if totalRatio > 0 and totalRatio<30 then
						audioIndex = 32
					elseif totalRatio>=30 and totalRatio<60 then
						audioIndex = 33
					else 
						audioIndex = 34
					end--]]
					AudioManager.GetInstance():PlayNormalAudio(54)
				end
			end	
		else
			if scoreType==scoreM.ScoreType.AllShow then
				scoreM:SetScoreEffectShowMode(fishIns.gameObject.transform,playerIns.ChairdID,hitFishMsg.mainScore,tempConfig.scoreDelayTime,tempConfig)
			end
		end
	end
end

function BombBaseFish:BaseShowPlusTipsEffect(fishIns,playerIns,hitFishMsg)
	local plusTipsM=PlusTipsEffectManager.GetInstance()
	local tempConfig=plusTipsM:GetPlusTipsEffectConfig(fishIns.FishVo.FishConfig.plusTipsID)
	if tempConfig then
		local parentFishID=hitFishMsg.bombUID
		if parentFishID and parentFishID==0 then
			plusTipsM:SetPlusTipsEffectShowMode(playerIns.ChairdID,playerIns.FlyScorePos,hitFishMsg.totalScore,tempConfig)
		end		
	end
end

function BombBaseFish:BaseShowBigAwardTipsEffect(fishIns,playerIns,hitFishMsg)
	local BigAwardTipsM = BigAwardTipsEffectManager.GetInstance()
	local parentFishID=hitFishMsg.bombUID
	if parentFishID and parentFishID==0 then
		local totalRatio = hitFishMsg.totalRatio
		local dieEffectConfig = FishEffectManager.GetInstance():GetFishEffectConfig(fishIns.FishVo.FishConfig.dieEffectId)
		if totalRatio >= dieEffectConfig.showRewardRatio[1] then
			local tempConfig=BigAwardTipsM:GetBigAwardTipsEffectConfig(dieEffectConfig.bigAwardTipsID[1])
			BigAwardTipsM:SetBigAwardTipsEffectShowMode(playerIns.ChairdID,playerIns.BigAwardPosList,hitFishMsg.totalScore,tempConfig)
		end
	end
end

function BombBaseFish:BaseShowFishSpecialEffect(fishIns,playerIns,hitFishMsg)
	local fishEffectM=FishEffectManager.GetInstance()
	local tempConfig=fishEffectM:GetFishEffectConfig(fishIns.FishVo.FishConfig.dieEffectId)
	if tempConfig then
		local parentFishID=hitFishMsg.bombUID
		if parentFishID and parentFishID==0 then
			fishEffectM:SetFishEffectShowMode(fishIns.gameObject.transform,playerIns.ChairdID,fishIns.FishVo.UID,tempConfig)
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
						local tempSubFish = FishManager.GetInstance():GetUsingFishByFishUID(hitFishMsg.SubFishes[i].mainFishUID)
						if tempSubFish then
							lightningEffectM:SetLightningEffectShowMode(fishIns.gameObject.transform,tempSubFish.gameObject.transform,playerIns.ChairdID,fishIns.FishVo.UID,tempConfig)
						else
							Debug.LogError("获取tempSubFish为nil==>"..fishIns.FishVo.UID)
						end
						
						
					end
				end
			end
		end		
	end	
end

function BombBaseFish:__delete()
	self.IsUsing=false
end

