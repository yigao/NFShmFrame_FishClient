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

function NormalBombFishType:SetCustomEffectPos(fishIns,playerIns,hitFishMsg)
	local effectPosList = fishIns:GetEffectPoint()
	if effectPosList then
		self.customEffectPosList = effectPosList
	end
end


function NormalBombFishType:SetFishDieProcess(hitFishMsg,fishIns,playerIns)
	self:BaseFishDie(fishIns,playerIns,hitFishMsg)
	-- self:BaseShowPlusTipsEffect(fishIns,playerIns,hitFishMsg)
	self:BaseShakeOrVibrate(hitFishMsg,fishIns)

	self:SubFishDieProcess(fishIns,playerIns,hitFishMsg)

	self:BaseShowFishSpecialEffect(fishIns,playerIns,hitFishMsg)

	self:Destroy()
end

function NormalBombFishType:SubFishDieProcess(fishIns,playerIns,hitFishMsg)
	if  hitFishMsg.subFishCount and hitFishMsg.subFishCount>0 then
		for i=1,#hitFishMsg.SubFishes do
			BombManager.GetInstance():CheckFishState(hitFishMsg.SubFishes[i])
		end
	end
end
