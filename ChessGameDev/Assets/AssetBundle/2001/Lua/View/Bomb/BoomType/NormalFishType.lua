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
	
	self:BaseShakeOrVibrate(hitFishMsg,fishIns)
	
	self:BaseShowCoinEffect(fishIns,playerIns,hitFishMsg)
	
	self:BaseShowWinScoreEffect(fishIns,playerIns,hitFishMsg)
	
	self:BaseShowPlusTipsEffect(fishIns,playerIns,hitFishMsg)

	self:BaseShowBigAwardTipsEffect(fishIns,playerIns,hitFishMsg)

	self:BaseShowFishSpecialEffect(fishIns,playerIns,hitFishMsg)

	self:Destroy()
end

