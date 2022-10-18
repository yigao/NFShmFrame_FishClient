LaserGunFishType=Class(BombBaseFish)

function LaserGunFishType:ctor()
	self:Init()
	
end


function LaserGunFishType:Init ()
	self:InitData()
	self:InitView()

end


function LaserGunFishType:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
end


function LaserGunFishType:InitView(gameObj)
	
	
end


function LaserGunFishType:SetFishDieProcess(hitFishMsg,fishIns,playerIns)
	self:BaseFishDie(fishIns,playerIns,hitFishMsg)
	
	self:BaseShakeOrVibrate(hitFishMsg,fishIns)

	self:SubFishDieProcess(fishIns,playerIns,hitFishMsg)

	self:BaseShowFishSpecialEffect(fishIns,playerIns,hitFishMsg,playerIns)
	
	self:Destroy()
end

function LaserGunFishType:SubFishDieProcess(fishIns,playerIns,hitFishMsg)
	if  hitFishMsg.subFishCount and hitFishMsg.subFishCount>0 then
		for i=1,#hitFishMsg.SubFishes do
			BombManager.GetInstance():CheckFishState(hitFishMsg.SubFishes[i])
		end
	end
end

