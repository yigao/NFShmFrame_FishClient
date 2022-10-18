LightningChainFishType=Class(BombBaseFish)

function LightningChainFishType:ctor()
	self:Init()
	
end

function LightningChainFishType:Init ()
	self:InitData()
	self:InitView()

end


function LightningChainFishType:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.specialDeclareUID = 0
	self.Score = 0
	self.Multiple = 0
	self.specialDeclareM = SpecialDeclareEffectManager.GetInstance()
	self.specialDeclarewScoreTimer = nil
end

function LightningChainFishType:InitView(gameObj)
	
	
end

function LightningChainFishType:SetFishDieProcess(hitFishMsg,fishIns,playerIns)
	self:BaseFishDie(fishIns,playerIns,hitFishMsg)
	
	self:BaseShakeOrVibrate(hitFishMsg,fishIns)

	self:SubFishDieProcess(fishIns,playerIns,hitFishMsg)
	
	self:BaseShowPlusTipsEffect(fishIns,playerIns,hitFishMsg)

	self:ShowSpecialDeclareEffect(fishIns,playerIns,hitFishMsg)

	self:BaseShowFishSpecialEffect(fishIns,playerIns,hitFishMsg)

	self:BaseShowLightningEffect(fishIns,playerIns,hitFishMsg)

	self:Destroy()
end

function LightningChainFishType:SubFishDieProcess(fishIns,playerIns,hitFishMsg)
	if  hitFishMsg.subFishCount and hitFishMsg.subFishCount>0 then
		for i=1,#hitFishMsg.SubFishes do
			BombManager.GetInstance():CheckFishState(hitFishMsg.SubFishes[i])
		end
	end
end


function LightningChainFishType:ShowSpecialDeclareEffect(fishIns,playerIns,hitFishMsg)
	local parentFishID=hitFishMsg.bombUID
	self.Score  = hitFishMsg.totalScore
	self.Multiple = hitFishMsg.totalRatio

	if parentFishID and parentFishID==0 then
		local specialDeclareConfig = self.specialDeclareM.GetInstance():GetSpecialDeclareEffectConfig(fishIns.FishVo.DieEffectConfig.specialDeclareID)
		self.specialDeclareUID = self.specialDeclareM:SetSpecialDeclareEffectShowMode(playerIns.ChairdID,playerIns.SpecialDeclarePanel.position,specialDeclareConfig)
		if not self.specialDeclarewScoreTimer then
			local time = specialDeclareConfig.delayTime
			self.specialDeclarewScoreTimer = TimerManager.GetInstance():CreateTimerInstance(time,self.ShowSpecialDeclareScore,self) 
		end
	end
end

function LightningChainFishType:ShowSpecialDeclareScore(  )
	self.specialDeclareM:BeginSpecialDeclareEffectChangeScore(self.specialDeclareUID,self.Score,self.Multiple)
	TimerManager.GetInstance():RecycleTimerIns(self.specialDeclarewScoreTimer)
	self.specialDeclarewScoreTimer = nil
	self:Destroy()
end