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
	self:UpdateFishDieEffectConfig(fishIns,playerIns,hitFishMsg)
	self:BaseShakeOrVibrate(hitFishMsg,fishIns)
	self:BaseFishDie(fishIns,playerIns,hitFishMsg)
	self:ShowFishDieEffect(fishIns,playerIns)
	self:BaseShowPlusTipsEffect(fishIns,playerIns,hitFishMsg)
	self:Destroy()
end

function NormalFishType:SubFishDieProcess(fishIns,playerIns,hitFishMsg)
	
end


function NormalFishType:ShowFishDieEffect(fishIns,playerIns)
	if playerIns.ChairdID == self.gameData.PlayerChairId or fishIns.FishVo.FishConfig.clientBuildFishType == self.gameData.GameConfig.FishType.Dragon then
		self.customEffectPosList = fishIns:GetEffectPoint()
		local dieEffectConfig = fishIns.FishVo.DieEffectConfig
		if dieEffectConfig then
			for i = 1,#dieEffectConfig.dieEffectName do
				local name =dieEffectConfig.dieEffectName[i] 
				local type = dieEffectConfig.dieEffectType[i]
				local delayTime = dieEffectConfig.dieEffectDelyTime[i]
				local lifeTime = dieEffectConfig.dieEffectLifeTime[i]
				local audio = dieEffectConfig.dieAudio[i]
				local positionFlag = dieEffectConfig.dieEffectPositionFlag[i]
				if name ~= "nil" then
					local beginPos = CSScript.Vector3.zero
					if positionFlag == 1 then
						beginPos = fishIns.gameObject.transform.position
					elseif positionFlag == 2 then
						beginPos = GameObjectPoolManager.GetInstance():GetPoolParent(GameObjectPoolManager.PoolType.EffectPool).transform.position
					elseif positionFlag == 3 then
						beginPos = self:GetCustormEffectPos(i)
						if beginPos == nil then
							beginPos = fishIns.gameObject.transform.position	
							print("Excel的配置坐标类型和实际没有对应")
						end
					end
					FishEffectManager.GetInstance():ShowFishEffect(beginPos,type,name,delayTime,lifeTime,audio)
				end
			end
		end
	end
end
