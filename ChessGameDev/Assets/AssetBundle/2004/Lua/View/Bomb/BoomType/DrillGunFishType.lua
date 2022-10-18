DrillGunFishType=Class(BombBaseFish)

function DrillGunFishType:ctor()
	self:Init()
	
end


function DrillGunFishType:Init ()
	self:InitData()
	self:InitView()

end


function DrillGunFishType:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
end


function DrillGunFishType:InitView(gameObj)
	
	
end


function DrillGunFishType:SetFishDieProcess(hitFishMsg,fishIns,playerIns)
	self:BaseFishDie(fishIns,playerIns,hitFishMsg)

	self:BaseShakeOrVibrate(hitFishMsg,fishIns)

	self:SubFishDieProcess(fishIns,playerIns,hitFishMsg)

	self:BaseShowFishSpecialEffect(fishIns,playerIns,hitFishMsg)
	
	self:Destroy()
end

function DrillGunFishType:SubFishDieProcess(fishIns,playerIns,hitFishMsg)
	if  hitFishMsg.subFishCount and hitFishMsg.subFishCount>0 then
		for i=1,#hitFishMsg.SubFishes do
			BombManager.GetInstance():CheckFishState(hitFishMsg.SubFishes[i])
		end
	end
end
