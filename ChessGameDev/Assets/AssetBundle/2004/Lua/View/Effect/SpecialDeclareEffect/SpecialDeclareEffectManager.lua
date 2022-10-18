SpecialDeclareEffectManager=Class()

local Instance=nil
function SpecialDeclareEffectManager:ctor(obj)
	Instance=self
	self.gameObject=obj
	self:Init(obj)
	CommonHelper.AddUpdate(self)
end

function SpecialDeclareEffectManager.GetInstance()
	return Instance
end

function SpecialDeclareEffectManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
end

function SpecialDeclareEffectManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	
	self.AllUseEffectInsList={}
	self.CurrentUseEffectInsList={}
	self.UID=1
	self.Vector2 = CS.UnityEngine.Vector2
	self.Animator=CS.UnityEngine.Animator
	self.Text=CS.UnityEngine.UI.Text
	self.Random = CS.UnityEngine.Random
	self.Tween = CS.DG.Tweening.Tween
	self.Sequence = CS.DG.Tweening.Sequence
	self.Ease = CS.DG.Tweening.Ease
	self.DOTween = CS.DG.Tweening.DOTween
	self.TweenExtensions = CS.DG.Tweening.TweenExtensions
end
	

function SpecialDeclareEffectManager:AddScripts()
	self.ScriptsPathList={
		"/View/Effect/SpecialDeclareEffect/Effect/SpecialDeclareEffectItem",
	}
end


function SpecialDeclareEffectManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function SpecialDeclareEffectManager:InitView(gameObj)
	
end


function SpecialDeclareEffectManager:InitInstance()
	self.SpecialDeclareEffectItem=SpecialDeclareEffectItem
end


function SpecialDeclareEffectManager:InitViewData()	
	
end


function SpecialDeclareEffectManager:GetSpecialDeclareEffectUID()
	self.UID=self.UID+1
	return self.UID
end



function SpecialDeclareEffectManager:GetSpecialDeclareEffectConfig(specialDeclareID)
	local tempConfig=self.gameData.gameConfigList.SpecialDeclareConfigList[specialDeclareID]
	if tempConfig then
		return tempConfig
	else
		Debug.LogError("获取得分提示配置失败==>"..specialDeclareID)
	end
end


function SpecialDeclareEffectManager:GetSpecialDeclareEffectVo(specialDeclareEffectConfig,chairID)
	local vo={}
	vo.SpecialDeclareEffectConfig=specialDeclareEffectConfig
	vo.UID=self:GetSpecialDeclareEffectUID()
	vo.ChairID = chairID
	vo.AnimType = vo.SpecialDeclareEffectConfig.specialDeclareAnimType
	vo.IsMe = (chairID == self.gameData.PlayerChairId)
	return vo
end


function SpecialDeclareEffectManager:SetSpecialDeclareEffectShowMode(chairID,specialDeclarePos,specialDeclareEffectConfig)
	local specialDeclareEffectVo=self:GetSpecialDeclareEffectVo(specialDeclareEffectConfig,chairID)
	local tempSpecialDeclareEffectIns=self:GetSpecialDeclareEffect(specialDeclareEffectVo)
	local targetPos = specialDeclarePos
	
	if tempSpecialDeclareEffectIns then
		tempSpecialDeclareEffectIns:ResetState(targetPos)
	end
	return specialDeclareEffectVo.UID
end

function SpecialDeclareEffectManager:BeginSpecialDeclareEffectChangeScore(UID,score,mul)
	local specialDeclareEffect = self.CurrentUseEffectInsList[UID]
	if specialDeclareEffect then
		specialDeclareEffect.EffectVo.Score = score
		specialDeclareEffect.EffectVo.Multiple = mul
		specialDeclareEffect:BeginShowScore()
	end
end

function SpecialDeclareEffectManager:GetSpecialDeclareEffect(specialDeclareEffectVo)
	if self.AllUseEffectInsList[specialDeclareEffectVo.SpecialDeclareEffectConfig.id] and #(self.AllUseEffectInsList[specialDeclareEffectVo.SpecialDeclareEffectConfig.id])>0 then
		local tempEffectIns=table.remove(self.AllUseEffectInsList[specialDeclareEffectVo.SpecialDeclareEffectConfig.id],1)
		if tempEffectIns then
			tempEffectIns:ResetEffectVo(specialDeclareEffectVo)
			self.CurrentUseEffectInsList[specialDeclareEffectVo.UID]=tempEffectIns
			return tempEffectIns
		else
			Debug.LogError("创建得分提示失败==>"..specialDeclareEffectVo.SpecialDeclareEffectConfig.id)
		end
		
	else
		local effectItem=GameObjectPoolManager.GetInstance():GetGameObject(specialDeclareEffectVo.SpecialDeclareEffectConfig.specialDeclareRes,GameObjectPoolManager.PoolType.SpecialDeclarePool)
		local tempEffectIns=self.SpecialDeclareEffectItem.New(effectItem)
		if tempEffectIns then
			tempEffectIns:ResetEffectVo(specialDeclareEffectVo)
			self.CurrentUseEffectInsList[specialDeclareEffectVo.UID]=tempEffectIns
			return tempEffectIns
		else
			GameObjectPoolManager.GetInstance():ReCycleToGameObject(effectItem,GameObjectPoolManager.PoolType.SpecialDeclarePool)
			Debug.LogError("创建得分提示失败==>"..specialDeclareEffectVo.SpecialDeclareEffectConfig.id)
		end
	end
	return nil
end

function SpecialDeclareEffectManager:RecycleSpecialDeclareEffect(specialDeclareEffectIns)
	local tempEffectIns=self.CurrentUseEffectInsList[specialDeclareEffectIns.EffectVo.UID]
	if tempEffectIns then
		if self.AllUseEffectInsList[specialDeclareEffectIns.EffectVo.SpecialDeclareEffectConfig.id]==nil then
			self.AllUseEffectInsList[specialDeclareEffectIns.EffectVo.SpecialDeclareEffectConfig.id]={}
		end
		table.insert(self.AllUseEffectInsList[specialDeclareEffectIns.EffectVo.SpecialDeclareEffectConfig.id],specialDeclareEffectIns)
		self.CurrentUseEffectInsList[specialDeclareEffectIns.EffectVo.UID]=nil
	else
		Debug.LogError("移除的specialDeclareEffectIns为nil==>UID"..specialDeclareEffectIns.EffectVo.UID)
	end
end

function SpecialDeclareEffectManager:ClearAllSpecialDeclareEffect()
	if self.CurrentUseEffectInsList  then
		for k,v in pairs(self.CurrentUseEffectInsList) do
			v.isCanDestory=true
		end
		self:UpdateRemoveSpecialDeclareEffect()
	end
	self.CurrentUseEffectInsList = {}
end

function SpecialDeclareEffectManager:ClearOtherPlayerSpecialDeclareEffect(charidID)
	if self.CurrentUseEffectInsList  then
		for k,v in pairs(self.CurrentUseEffectInsList) do
			if v.EffectVo.ChairID == charidID then
				v.isCanDestory=true
			end
		end
		self:UpdateRemoveSpecialDeclareEffect()
	end
end


function SpecialDeclareEffectManager:UpdateRemoveSpecialDeclareEffect()
	if self.CurrentUseEffectInsList and next(self.CurrentUseEffectInsList) then
		for k,v in pairs(self.CurrentUseEffectInsList) do
			if v.isCanDestory then
				v:Destroy()
				self:RecycleSpecialDeclareEffect(v)
			end
		end
	end
end

function SpecialDeclareEffectManager:Update()
	self:UpdateRemoveSpecialDeclareEffect()
end

function SpecialDeclareEffectManager:__delete()
	self.AllUseEffectInsList= nil
	self.CurrentUseEffectInsList=nil
	self.Vector2 = nil
	self.Animator= nil
	self.Text= nil
	self.Random = nil
	self.Tween = nil
	self.Sequence = nil
	self.Ease = nil
	self.DOTween = nil
	self.TweenExtensions = nil
end




