NormalBombFishType=Class(BombBaseFish)

function NormalBombFishType:ctor()
	self:Init()
	
end


function NormalBombFishType:Init ()
	self:InitData()
	self:InitView()

end


function NormalBombFishType:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData

end


function NormalBombFishType:InitView(gameObj)
	
	
end


function NormalBombFishType:SetFishDieProcess(hitFishMsg,fishIns,playerIns)
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

function NormalBombFishType:SubFishDieProcess(subFishs)
	if #subFishs>0 then
		for i=1,#subFishs do
			BombManager.GetInstance():CheckFishState(subFishs[i])
		end
		
	end
end