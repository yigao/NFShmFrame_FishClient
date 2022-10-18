FixedScreenFishType=Class(BombBaseFish)

function FixedScreenFishType:ctor()
	self:Init()
	
end


function FixedScreenFishType:Init ()
	self:InitData()
	self:InitView()

end


function FixedScreenFishType:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData

end


function FixedScreenFishType:InitView()
	
	
end


function FixedScreenFishType:SetFishDieProcess(hitFishMsg,fishIns,playerIns)
	self:BaseFishDie(fishIns,hitFishMsg)
	
	self:BaseShakeOrVibrate(hitFishMsg,fishIns)
	
	self:BaseShowCoinEffect(fishIns,playerIns,hitFishMsg)

	self:BaseShowWinScoreEffect(fishIns,playerIns,hitFishMsg)

	self:BaseShowPlusTipsEffect(fishIns,playerIns,hitFishMsg)

	self:BaseShowBigAwardTipsEffect(fishIns,playerIns,hitFishMsg)
	
	self:BaseShowFishSpecialEffect(fishIns,playerIns,hitFishMsg)
	
	if  hitFishMsg.subFishCount and hitFishMsg.subFishCount>0 then
		Debug.LogError("FixedScreenFishType数据异常，不应该存在subfish列表信息")
	end
	self:Destroy()
end


function FixedScreenFishType:FixedScreenProcess(fishMsg)
	local tempList={}
	if fishMsg.fishes and #fishMsg.fishes>0 then
		for i=1,#fishMsg.fishes do
			local tempFish=FishManager.GetInstance():GetUsingFishByFishUID(fishMsg.fishes[i].fish_uid)
			if tempFish then
				table.insert(tempList,tempFish)
			end
		end
	end
	
	if fishMsg.IsFreeze then
		FishManager.GetInstance():PauseAssignationFish(tempList)
	else
		FishManager.GetInstance():ResumeAssignationFish(tempList)
	end
	
	self:Destroy()
end







