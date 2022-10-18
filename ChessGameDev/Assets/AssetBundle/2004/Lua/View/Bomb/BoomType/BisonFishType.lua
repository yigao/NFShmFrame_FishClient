BisonFishType=Class(BombBaseFish)

function BisonFishType:ctor()
	self:Init()
	
end


function BisonFishType:Init ()
	self:InitData()
	self:InitView()

end


function BisonFishType:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
end


function BisonFishType:InitView(gameObj)
	
	
end


function BisonFishType:SetFishDieProcess(hitFishMsg,fishIns,playerIns)
	self:BaseFishDie(fishIns,playerIns,hitFishMsg)
	
	self:BaseShakeOrVibrate(hitFishMsg,fishIns)

	self:SubFishDieProcess(fishIns,playerIns,hitFishMsg)

	self:BaseShowFishSpecialEffect(fishIns,playerIns,hitFishMsg)
	
	self:Destroy()
end

function BisonFishType:SubFishDieProcess(fishIns,playerIns,hitFishMsg)
	if  hitFishMsg.subFishCount and hitFishMsg.subFishCount>0 then
		for i=1,#hitFishMsg.SubFishes do
			
			BombManager.GetInstance():CheckFishState(hitFishMsg.SubFishes[i])
		end
	end
end

