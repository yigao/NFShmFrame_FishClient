SameFishType=Class(BombBaseFish)

function SameFishType:ctor()
	self:Init()
	
end

function SameFishType:Init ()
	self:InitData()
	self:InitView()

end

function SameFishType:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.specialDeclareUID = 0
	self.Score = 0
	self.Multiple = 0
	self.specialDeclareM = SpecialDeclareEffectManager.GetInstance()
	self.specialDeclarewScoreTimer = nil
	self.swirlLocalPos = CSScript.Vector3.zero
	self.swirlWorldPos = CSScript.Vector3.zero
end

function SameFishType:InitView(gameObj)
	
end

function SameFishType:SetFishDieProcess(hitFishMsg,fishIns,playerIns)

	self:BaseFishDie(fishIns,playerIns,hitFishMsg)
	
	self:BaseShakeOrVibrate(hitFishMsg,fishIns)

	self:SetCustomEffectPos(fishIns,playerIns,hitFishMsg)

	self:SubFishDieProcess(fishIns,playerIns,hitFishMsg)

	self:BaseShowFishSpecialEffect(fishIns,playerIns,hitFishMsg)

	self:BaseShowPlusTipsEffect(fishIns,playerIns,hitFishMsg)

	self:ShowSpecialDeclareEffect(fishIns,playerIns,hitFishMsg)
end

function SameFishType:SetCustomEffectPos(fishIns,playerIns,hitFishMsg)
	self.customEffectPosList[1] = playerIns.SwrilPanel.position
end

function SameFishType:SubFishDieProcess(fishIns,playerIns,hitFishMsg)
	if  hitFishMsg.subFishCount and hitFishMsg.subFishCount>0 then
		for i=1,#hitFishMsg.SubFishes do
			BombManager.GetInstance():CheckFishState(hitFishMsg.SubFishes[i])
		end
	end
end


function SameFishType:ShowSpecialDeclareEffect(fishIns,playerIns,hitFishMsg)
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

function SameFishType:ShowSpecialDeclareScore(  )
	self.specialDeclareM:BeginSpecialDeclareEffectChangeScore(self.specialDeclareUID,self.Score,self.Multiple)
	TimerManager.GetInstance():RecycleTimerIns(self.specialDeclarewScoreTimer)
	self.specialDeclarewScoreTimer = nil
	self:Destroy()
end
