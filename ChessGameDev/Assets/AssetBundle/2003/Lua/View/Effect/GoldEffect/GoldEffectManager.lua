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
	
	self.width = 120  
	self.height =120
	self.radius = 35 
	self.offset = 70
	self.moveToTargetTime = 0.3

	self.JumpGoldMap = {}
	self.GoldCountMap ={}

	self.Animator=CS.UnityEngine.Animator
	self.Random = CS.UnityEngine.Random
	self.Tween = CS.DG.Tweening.Tween
	self.Sequence = CS.DG.Tweening.Sequence
	self.Ease = CS.DG.Tweening.Ease
	self.DOTween = CS.DG.Tweening.DOTween
	self.TweenExtensions = CS.DG.Tweening.TweenExtensions
	
	self.GoldEffectType={
		createCoinType=1,		--创建金币类型
		showCoinEffectType=2,	--显示金币特效类型
	}
end

function GoldEffectManager:AddScripts()
	self.ScriptsPathList={
		"/View/Effect/GoldEffect/Effect/SingleGoldEffect",
		"/View/Effect/GoldEffect/Effect/ParticleGoldEffectItem",
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
	self.ParticleGoldEffectItem=ParticleGoldEffectItem
	self.SingleCoinAlgorithm=SingleCoinAlgorithm.New()
end


function GoldEffectManager:InitViewData()	
	
end


function GoldEffectManager:GetGoldEffectUID()
	self.UID=self.UID+1
	return self.UID
end


function GoldEffectManager:ShowCoinEffectMode(tempFishIns,playerIns,goldEffectConfig)
	local vo={}
	vo.GoldEffectConfig=goldEffectConfig
	vo.UID=self:GetGoldEffectUID()
	vo.IsMe=(playerIns.ChairdID==self.gameData.PlayerChairId)
	vo.beginPos=tempFishIns.gameObject.transform.position
	local tempEffectIns=self:GetGoldEffect(vo)
	if tempEffectIns then
		tempEffectIns:ResetState()
	else
		Debug.LogError("获取GoldEffectIns失败==>"..goldEffectConfig.id)
	end
end



function GoldEffectManager:SetCoinEffectShowMode(tempFishTF,chairID,fishUID,goldEffectID,effectCount,endPos)
	local bornPosList=self.SingleCoinAlgorithm:GetMuiltpleGoldEffect(tempFishTF,self.width,self.height,self.radius,self.offset)
	local bornPosCount = bornPosList.Count
	self.GoldCountMap[fishUID] = effectCount
	local durationTime = self.moveToTargetTime * CSScript.Vector3.Distance(tempFishTF.position,endPos)/(CSScript.Vector3.Distance(tempFishTF.parent:TransformPoint(CSScript.Vector3.zero),endPos))
	for i = 1,effectCount do
		local beginPos = nil
		if i>= bornPosCount then
			local x = self.Random.Range(-self.radius,self.radius)
			local y = self.Random.Range(-self.radius,self.radius)
			beginPos = bornPosList[i%bornPosCount] + CSScript.Vector3(x,y,0)
		else
			beginPos = bornPosList[i]
		end
		beginPos = tempFishTF.parent:TransformPoint(beginPos)
		self:ShowGoldEffect(goldEffectID,fishUID,chairID,beginPos,endPos,durationTime)
	end
end


function GoldEffectManager:ShowGoldEffect(goldEffectID,fishUID,chairID,beginPos,endPos,durationTime,callBack)
	local vo=self:GetGoldEffectVo(goldEffectID,fishUID,chairID,durationTime)
	local tempEffectIns=self:GetGoldEffect(vo)
	if tempEffectIns then
		tempEffectIns:ResetState(beginPos,endPos,callBack)
	else
		Debug.LogError("获取GoldEffectIns失败==>"..goldEffectID)
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
			Debug.LogError("创建GoldEffect失败==>"..goldEffectVo.UID)
		end
		
	else
		local effectItem=GameObjectPoolManager.GetInstance():GetGameObject(goldEffectVo.GoldEffectConfig.coinRes,GameObjectPoolManager.PoolType.GoldPool)
		local effectType=goldEffectVo.GoldEffectConfig.coinType
		local tempEffectIns=nil
		if effectType==self.GoldEffectType.createCoinType then
			tempEffectIns=self.SingleGoldEffect.New(effectItem)
		elseif effectType==self.GoldEffectType.showCoinEffectType then
			tempEffectIns=self.ParticleGoldEffectItem.New(effectItem,goldEffectVo)
		end
		
		if tempEffectIns then
			tempEffectIns:ResetEffectVo(goldEffectVo)
			self.CurrentUseEffectInsList[goldEffectVo.UID]=tempEffectIns
			return tempEffectIns
		else
			GameObjectPoolManager.GetInstance():ReCycleToGameObject(effectItem,GameObjectPoolManager.PoolType.GoldPool)
			Debug.LogError("EffectIns生成失败==>"..effectType)
		end
	end
	return nil
end

function GoldEffectManager:GoldCenterToJumpOver(goldItem)
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
	local delay = 0
	local index = 1
	local count = #self.JumpGoldMap[fishUID]
	while index <= count do
		if index <= 1 then
			self.JumpGoldMap[fishUID][index]:MoveToEndPoint(delay)
			delay =delay + 0.15
		else
			local rand = math.random( 1,2)
			if (rand + index) >= count then
				rand = count - index
			end
			for j = 0,rand do
				local temp = delay --+ self.Random.Range(0.05,0.01)
				self.JumpGoldMap[fishUID][index + j]:MoveToEndPoint(temp)
			end
			index = index + rand
			delay = delay + 0.15
		end
		index = index+1
	end
	self.JumpGoldMap[fishUID] = nil
end

function GoldEffectManager:RecycleGoldEffect(goldEffectIns)
	--Debug.LogError("移除UID==>"..goldEffectIns.EffectVo.UID)
	local tempEffectIns=self.CurrentUseEffectInsList[goldEffectIns.EffectVo.UID]
	if tempEffectIns then
		if self.AllUseEffectInsList[goldEffectIns.EffectVo.GoldEffectConfig.id]==nil then
			self.AllUseEffectInsList[goldEffectIns.EffectVo.GoldEffectConfig.id]={}
		end
		table.insert(self.AllUseEffectInsList[goldEffectIns.EffectVo.GoldEffectConfig.id],goldEffectIns)
		self.CurrentUseEffectInsList[goldEffectIns.EffectVo.UID]=nil
	else
		Debug.LogError("移除的goldEffectIns为nil==>UID"..goldEffectIns.EffectVo.UID)
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