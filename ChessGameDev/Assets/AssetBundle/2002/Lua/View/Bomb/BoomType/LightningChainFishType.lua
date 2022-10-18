LightningChainFishType=Class(BombBaseFish)

function LightningChainFishType:ctor()
	self:Init()
	
end


function LightningChainFishType:Init ()
	self:InitData()
	self:InitView()

end


function LightningChainFishType:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData

end


function LightningChainFishType:InitView(gameObj)
	
	
end


function LightningChainFishType:SetFishDieProcess(hitFishMsg,fishIns,playerIns)
	self:BaseFishDie(fishIns,hitFishMsg)
	
	self:BaseShakeOrVibrate(hitFishMsg,fishIns)
	
	self:BaseShowCoinEffect(fishIns,playerIns,hitFishMsg)

	self:BaseShowWinScoreEffect(fishIns,playerIns,hitFishMsg)
	
	self:BaseShowPlusTipsEffect(fishIns,playerIns,hitFishMsg)

	self:BaseShowBigAwardTipsEffect(fishIns,playerIns,hitFishMsg)

	self:BaseShowFishSpecialEffect(fishIns,playerIns,hitFishMsg)

	self:BaseShowLightningEffect(fishIns,playerIns,hitFishMsg)

	if  hitFishMsg.subFishCount and hitFishMsg.subFishCount>0 then
		self:SubFishDieProcess(hitFishMsg.SubFishes,fishIns.FishVo.fishKillFishCoinEffectID)
	end
	self:Destroy()
end


function LightningChainFishType:SubFishDieProcess(subFishs,fishKillFishCoinEffectID)
	if #subFishs>0 then
		for i=1,#subFishs do
			BombManager.GetInstance():CheckFishState(subFishs[i],fishKillFishCoinEffectID)
		end
		
	end
end