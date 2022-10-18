SpawnFishType=Class(BombBaseFish)

function SpawnFishType:ctor()
	self:Init()
	
end


function SpawnFishType:Init ()
	self:InitData()
	self:InitView()

end


function SpawnFishType:InitData()
	

end


function SpawnFishType:InitView(gameObj)
	
	
end


function SpawnFishType:SetFishDieProcess(hitFishMsg,fishIns,playerIns)
	self:BaseFishDie(fishIns,hitFishMsg)
	
	self:BaseShakeOrVibrate(hitFishMsg,fishIns)
	
	self:BaseShowCoinEffect(fishIns,playerIns,hitFishMsg)
	
	self:BaseShowWinScoreEffect(fishIns,playerIns,hitFishMsg)
	
	self:BaseShowPlusTipsEffect(fishIns,playerIns,hitFishMsg)

	self:BaseShowBigAwardTipsEffect(fishIns,playerIns,hitFishMsg)

	self:BaseShowFishSpecialEffect(fishIns,playerIns,hitFishMsg)
		
	if  hitFishMsg.subFishCount and hitFishMsg.subFishCount>0 then
		self:SubFishDieProcess(hitFishMsg.SubFishes)
	end
	
	self:Destroy()
end


function SpawnFishType:SubFishDieProcess(subFishs)
	if #subFishs>0 then
		for i=1,#subFishs do
			BombManager.GetInstance():CheckFishState(subFishs[i])
		end
		
	end
end