kingCrabFishType=Class(BombBaseFish)

function kingCrabFishType:ctor()
	self:Init()
	
end


function kingCrabFishType:Init ()
	self:InitData()
	self:InitView()

end


function kingCrabFishType:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
end


function kingCrabFishType:InitView(gameObj)
	
	
end

function kingCrabFishType:SetCustomEffectPos(fishIns,playerIns,hitFishMsg)
	--self.customEffectPosList[1] = fishIns.effectPointList[1].position
	self.customEffectPosList[1] = fishIns.effectPointList[2].position
	--self.customEffectPosList[3] = fishIns.effectPointList[3].position
end

function kingCrabFishType:SetFishDieProcess(hitFishMsg,fishIns,playerIns)
	self:BaseFishDie(fishIns,playerIns,hitFishMsg)
	self:BaseShakeOrVibrate(hitFishMsg,fishIns)
	self:SetCustomEffectPos(fishIns,playerIns,hitFishMsg)
	self:SubFishDieProcess(fishIns,playerIns,hitFishMsg)
	self:BaseShowPlusTipsEffect(fishIns,playerIns,hitFishMsg)
	self:BaseShowFishSpecialEffect(fishIns,playerIns,hitFishMsg,playerIns)
	self:Destroy()
end


function kingCrabFishType:SubFishDieProcess(fishIns,playerIns,hitFishMsg)
	if  hitFishMsg.subFishCount and hitFishMsg.subFishCount>0 then
		for i=1,#hitFishMsg.SubFishes do
			BombManager.GetInstance():CheckFishState(hitFishMsg.SubFishes[i])
		end
	end
end

function kingCrabFishType:RemoveFishPartProcess(fishIns,aryKilledParts)
	AudioManager.GetInstance():PlayNormalAudio(62)
	if #aryKilledParts == 1 then
		local playerIns=PlayerManager.GetInstance():GetPlayerInsByChairdId(aryKilledParts[1].usChairId)
		fishIns:RemoveFishPart(aryKilledParts[1].usPartId)
		SpiderCrabEffectManager.GetInstance():CreateSpiderCrabBosshurt(aryKilledParts[1].usChairId,1,aryKilledParts[1].usScore,playerIns.SpecialDeclarePanel.position)
	elseif #aryKilledParts == 2 then
		local playerIns=PlayerManager.GetInstance():GetPlayerInsByChairdId(aryKilledParts[2].usChairId)
		fishIns:RemoveFishPart(aryKilledParts[2].usPartId)
		SpiderCrabEffectManager.GetInstance():CreateSpiderCrabBosshurt(aryKilledParts[2].usChairId,2,aryKilledParts[2].usScore,playerIns.SpecialDeclarePanel.position)
	 end
end


function kingCrabFishType:ShowFishSpecialEffect(fishIns,playerIns,partId)
	local fishEffectM=FishEffectManager.GetInstance()
	local name ="burst_coin_small"   
	local type = 1 
	local positionFlag =0 
	local delayTime =0 
	local lifeTime =2 
	local effectAudio = nil
	local beginPos =  fishIns:GetEffectPoint(partId)
	fishEffectM:ShowFishEffect(beginPos,type,name,delayTime,lifeTime,effectAudio)
end

function kingCrabFishType:ShowPlusTipsEffect(fishIns,playerIns,score)
	-- local dieEffectConfig=FishEffectManager.GetInstance():GetFishEffectConfig(fishIns.FishVo.FishConfig.dieEffectId)
	-- if dieEffectConfig then
	-- 	local plusTipsM=PlusTipsEffectManager.GetInstance()
	-- 	local tempConfig=plusTipsM:GetPlusTipsEffectConfig(dieEffectConfig.plusTipsID)
	-- 	if tempConfig then
	-- 		local parentFishID=hitFishMsg.bombUID
	-- 		if parentFishID and parentFishID==0 then
	-- 			plusTipsM:SetPlusTipsEffectShowMode(playerIns.ChairdID,playerIns.FlyScorePos,score,tempConfig)
	-- 		end		
	-- 	end
	-- end
end
