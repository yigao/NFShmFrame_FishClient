GoldEffectManager=Class()



local Instance=nil
function GoldEffectManager:ctor(obj)
	Instance=self
	self.gameObject=obj
	self:Init(obj)
	CommonHelper.AddUpdate(self)
end


function GoldEffectManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
	
end



function GoldEffectManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.AllUseEffectInsList={}
	self.CurrentUseEffectInsList={}
	self.UID=1
	
	self.radius = 35 
	self.bWidth = 120
	self.bHeight = 120
	self.tWidth = 250
	self.tHeight = 250
	self.offset = 0
	self.moveToTargetTime = 0.4

	self.JumpGoldMap = {}
	self.GoldCountMap ={}

	self.Animator=CS.UnityEngine.Animator
	self.Random = CS.UnityEngine.Random
	self.Tween = CS.DG.Tweening.Tween
	self.Sequence = CS.DG.Tweening.Sequence
	self.Ease = CS.DG.Tweening.Ease
	self.DOTween = CS.DG.Tweening.DOTween
	self.TweenExtensions = CS.DG.Tweening.TweenExtensions
end

function GoldEffectManager:AddScripts()
	self.ScriptsPathList={
		"/View/Effect/GoldEffect/Effect/SingleGoldEffect",
		"/View/Effect/GoldEffect/Algorithm/SingleCoinAlgorithm",
		
	}
end


function GoldEffectManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function GoldEffectManager:InitView(gameObj)
	
end


function GoldEffectManager:InitInstance()
	self.SingleGoldEffect=SingleGoldEffect
	self.SingleCoinAlgorithm=SingleCoinAlgorithm.New()
end


function GoldEffectManager:InitViewData()	
	
end


function GoldEffectManager:GetGoldEffectUID()
	self.UID=self.UID+1
	return self.UID
end


function GoldEffectManager:SetCoinEffectShowMode(tempFishTF,chairID,fishUID,goldEffectID,effectCount,endPos)
	local bornPosList=self.SingleCoinAlgorithm:GetMuiltpleGoldEffect(tempFishTF,self.bWidth,self.bHeight,self.radius,self.offset)
	local tarPosList=self.SingleCoinAlgorithm:GetMuiltpleGoldEffect(tempFishTF,self.tWidth,self.tHeight,self.radius,self.offset)
	local bornPosCount = bornPosList.Count
	local tarPosCount = tarPosList.Count
	self.GoldCountMap[fishUID] = effectCount

	local durationTime = self.moveToTargetTime * CSScript.Vector3.Distance(tempFishTF.position,endPos)/(CSScript.Vector3.Distance(tempFishTF.parent:TransformPoint(CSScript.Vector3.zero),endPos))
	local index = 1
	local delayTime = 0
	while index <= effectCount do
		local creatCount = math.random(2,5)
		for i =1,creatCount do
			local beginPos = nil
			if index>= bornPosCount then
				local bornOffsetX = self.Random.Range(-self.radius,self.radius)
				local bornOffsetY = self.Random.Range(-self.radius,self.radius)
				beginPos = bornPosList[index%bornPosCount] + CSScript.Vector3(bornOffsetX,bornOffsetY,0)
			else
				beginPos = bornPosList[index]
			end
			beginPos = tempFishTF.parent:TransformPoint(beginPos)

			local targetIndex =math.random(0,tarPosCount-1)
			local targetOffsetX = self.Random.Range(-self.radius,self.radius)
			local targetOffsetY = self.Random.Range(-self.radius,self.radius)
			local targetPos = tarPosList[targetIndex] + CSScript.Vector3(targetOffsetX,targetOffsetY,0)
			targetPos = tempFishTF.parent:TransformPoint(targetPos)

			delayTime = delayTime + self.Random.Range(0.05,0.07)
			self:ShowGoldEffect(goldEffectID,fishUID,chairID,beginPos,targetPos,endPos,delayTime,durationTime)
			index = index + 1
			if index > effectCount then
				return
			end
		end
		delayTime = delayTime + 0.1
	end
end


function GoldEffectManager:ShowGoldEffect(goldEffectID,fishUID,chairID,beginPos,targetPos,endPos,delayTime,durationTime,callBack)
	local vo=self:GetGoldEffectVo(goldEffectID,fishUID,chairID,durationTime)
	local tempEffectIns=self:GetGoldEffect(vo)
	if tempEffectIns then
		tempEffectIns:ResetState(beginPos,targetPos,endPos,delayTime,callBack)
	else
		Debug.LogError("??????GoldEffectIns??????==>"..goldEffectID)
	end
end

function GoldEffectManager:GetGoldEffectVo(goldEffectID,fishUID,chairID,durationTime)
	local vo={}
	vo.GoldEffectConfig=self:GetGoldEffectConfig(goldEffectID)
	vo.UID=self:GetGoldEffectUID()
	vo.fishUID = fishUID
	vo.ChairID = chairID
	vo.IsMe = (chairID == self.gameData.PlayerChairId)
	vo.DurationTime = durationTime
	if self.JumpGoldMap[fishUID] == nil then
		self.JumpGoldMap[fishUID] ={}
	end
	return vo
end


function GoldEffectManager:GetGoldEffectConfig(goldEffectID)
	return self.gameData.gameConfigList.CoinEffectConfigList[goldEffectID]
end

function GoldEffectManager:GetGoldEffect(goldEffectVo)
	if self.AllUseEffectInsList[goldEffectVo.GoldEffectConfig.id] and #(self.AllUseEffectInsList[goldEffectVo.GoldEffectConfig.id])>0 then
		local tempEffectIns=table.remove(self.AllUseEffectInsList[goldEffectVo.GoldEffectConfig.id],1)
		if tempEffectIns then
			tempEffectIns:ResetEffectVo(goldEffectVo)
			self.CurrentUseEffectInsList[goldEffectVo.UID]=tempEffectIns
			return tempEffectIns
		else
			Debug.LogError("??????GoldEffect??????==>"..goldEffectVo.UID)
		end
		
	else
		local effectItem=GameObjectPoolManager.GetInstance():GetGameObject(goldEffectVo.GoldEffectConfig.coinRes,GameObjectPoolManager.PoolType.GoldPool)
		local effectType=goldEffectVo.GoldEffectConfig.id
		local tempEffectIns=self.SingleGoldEffect.New(effectItem)
		if tempEffectIns then
			tempEffectIns:ResetEffectVo(goldEffectVo)
			self.CurrentUseEffectInsList[goldEffectVo.UID]=tempEffectIns
			return tempEffectIns
		else
			GameObjectPoolManager.GetInstance():ReCycleToGameObject(effectItem,GameObjectPoolManager.PoolType.GoldPool)
			Debug.LogError("EffectIns????????????==>"..effectType)
		end
	end
	return nil
end

function GoldEffectManager:GoldCenterToBounds(goldItem)
	local fishUID = goldItem.EffectVo.fishUID
	if self.GoldCountMap[fishUID] == nil then
		return
	end
	
	table.insert(self.JumpGoldMap[fishUID],goldItem)
	self.GoldCountMap[fishUID]= self.GoldCountMap[fishUID]-1
	if self.GoldCountMap[fishUID] == 0 then
		self:GoldMoveToEndPoint(fishUID)
		self.GoldCountMap[fishUID] = nil
	end
end

function GoldEffectManager:GoldMoveToEndPoint(fishUID)
	local delay = 0.25
	local index = 1
	local count = #self.JumpGoldMap[fishUID]
	while index <= count do
	
		local rand = math.random( 1,4)
		if (rand + index) >= count then
			rand = count - index
		end
		for j = 0,rand do
			local temp = delay
			self.JumpGoldMap[fishUID][index + j]:MoveToEndPoint(temp)
		end
		index = index + rand
		delay = delay + 0.25
		index = index+1
	end
	self.JumpGoldMap[fishUID] = nil
end

function GoldEffectManager:RecycleGoldEffect(goldEffectIns)
	--Debug.LogError("??????UID==>"..goldEffectIns.EffectVo.UID)
	local tempEffectIns=self.CurrentUseEffectInsList[goldEffectIns.EffectVo.UID]
	if tempEffectIns then
		if self.AllUseEffectInsList[goldEffectIns.EffectVo.GoldEffectConfig.id]==nil then
			self.AllUseEffectInsList[goldEffectIns.EffectVo.GoldEffectConfig.id]={}
		end
		table.insert(self.AllUseEffectInsList[goldEffectIns.EffectVo.GoldEffectConfig.id],goldEffectIns)
		self.CurrentUseEffectInsList[goldEffectIns.EffectVo.UID]=nil
	else
		Debug.LogError("?????????goldEffectIns???nil==>UID"..goldEffectIns.EffectVo.UID)
	end
end


function GoldEffectManager:ClearAllGoldEffect()
	if self.CurrentUseEffectInsList  then
		for k,v in pairs(self.CurrentUseEffectInsList) do
			v.isCanDestory=true
		end
		self:UpdateRemoveGoldEffect()
	end
end



function GoldEffectManager:UpdateRemoveGoldEffect()
	if self.CurrentUseEffectInsList and next(self.CurrentUseEffectInsList) then
		for k,v in pairs(self.CurrentUseEffectInsList) do
			if v.isCanDestory then
				v:Destroy()
				self:RecycleGoldEffect(v)
			end
		end
	end
end


function GoldEffectManager:Update()
	self:UpdateRemoveGoldEffect()
end



function GoldEffectManager.GetInstance()
	return Instance
end