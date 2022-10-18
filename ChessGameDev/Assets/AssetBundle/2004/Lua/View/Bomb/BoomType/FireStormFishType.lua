FireStormFishType=Class(BombBaseFish)

function FireStormFishType:ctor()
	self:Init()
	
end


function FireStormFishType:Init ()
	self:InitData()
	self:InitView()

end


function FireStormFishType:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData

end


function FireStormFishType:InitView(gameObj)
	
	
end


function FireStormFishType:SetFishDieProcess(hitFishMsg,fishIns,playerIns)
	self:BaseFishDie(fishIns,playerIns,hitFishMsg)
	-- self:BaseShowPlusTipsEffect(fishIns,playerIns,hitFishMsg)
	self:BaseShakeOrVibrate(hitFishMsg,fishIns)

	self:SubFishDieProcess(fishIns,playerIns,hitFishMsg)

	self:BaseShowFishSpecialEffect(fishIns,playerIns,hitFishMsg)

	self:Destroy()
end

function FireStormFishType:SubFishDieProcess(fishIns,playerIns,hitFishMsg)
	if  hitFishMsg.subFishCount and hitFishMsg.subFishCount>0 then
		for i=1,#hitFishMsg.SubFishes do
			BombManager.GetInstance():CheckFishState(hitFishMsg.SubFishes[i])
		end
	end
end
