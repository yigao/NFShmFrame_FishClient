NormalFishType=Class(BombBaseFish)

function NormalFishType:ctor()
	self:Init()
	
end


function NormalFishType:Init ()
	self:InitData()
	self:InitView()

end


function NormalFishType:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData

end


function NormalFishType:InitView(gameObj)
	
	
end


function NormalFishType:SetFishDieProcess(hitFishMsg,fishIns,playerIns)
	self:BaseFishDie(fishIns,hitFishMsg)
	if hitFishMsg.mainScore>0 then
		self:BaseShowCoinEffect(fishIns,playerIns,hitFishMsg)
		
		self:BaseShakeOrVibrate(hitFishMsg,fishIns)
	
		self:BaseShowWinScoreEffect(fishIns,playerIns,hitFishMsg)
	end
	self:BaseShowPlusTipsEffect(fishIns,playerIns,hitFishMsg)

	self:BaseShowBigAwardTipsEffect(fishIns,playerIns,hitFishMsg)

	self:BaseShowFishSpecialEffect(fishIns,playerIns,hitFishMsg)

	self:Destroy()
end

