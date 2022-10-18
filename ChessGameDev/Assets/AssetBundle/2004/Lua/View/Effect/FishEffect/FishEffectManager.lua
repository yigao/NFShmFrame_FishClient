FishEffectManager=Class()

local Instance=nil
function FishEffectManager:ctor(obj)
	Instance=self
	self.gameObject=obj
	self:Init(obj)
	CommonHelper.AddUpdate(self)
end


function FishEffectManager.GetInstance()
	return Instance
end


function FishEffectManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
	
end



function FishEffectManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.AllUseEffectInsList={}
	self.CurrentUseEffectInsList={}
	self.UID=1
	self.Animator=CS.UnityEngine.Animator
	self.SkeletonAnimation = CS.Spine.Unity.SkeletonAnimation
	self.FishEffectType={			--特效类型
		AnimatorType=1,
		SpineType=2,
		ParticleType = 3,
	}
end

function FishEffectManager:AddScripts()
	self.ScriptsPathList={
		"/View/Effect/FishEffect/Effect/AnimatorEffectItem",
		"/View/Effect/FishEffect/Effect/SpineEffectItem",
		"/View/Effect/FishEffect/Effect/ParticleEffectItem",
	}	
end


function FishEffectManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function FishEffectManager:InitView(gameObj)
	
end


function FishEffectManager:InitInstance()
	self.AnimatorEffectItem=AnimatorEffectItem
	self.SpineEffectItem=SpineEffectItem
	self.ParticleEffectItem=ParticleEffectItem
end


function FishEffectManager:InitViewData()	
	
end



function FishEffectManager:GetFishEffectUID()
	self.UID=self.UID+1
	return self.UID
end


function FishEffectManager:GetFishEffectConfig(fishEffectID)
	return self.gameData.gameConfigList.DieEffectConfigList[fishEffectID]
end

function FishEffectManager:ShowFishEffect(beginPos,type,name,delayTime,lifeTime,effectAudio,callBack)
	local vo=self:GetFishEffectVo(type,name,delayTime,lifeTime,effectAudio)
	local tempEffectIns=self:GetFishEffect(vo)
	if tempEffectIns then
		tempEffectIns:ResetState(beginPos)
	else
		Debug.LogError("获取effectName失败==>"..name)
	end
end

function FishEffectManager:GetFishEffectVo(effectType,effectName,effectDelayTime,effectLifeTime,effectPositionFlag ,effectAudio)
	local vo={}
	vo.UID=self:GetFishEffectUID()
	vo.EffectType = effectType
	vo.EffectName = effectName
	vo.EffectDelayTime = effectDelayTime
	vo.EffectLifeTime = effectLifeTime
	vo.EffectPositionFlag = effectPositionFlag
	vo.EffectAudio = effectAudio
	return vo
end


function FishEffectManager:GetFishEffect(fishEffectVo)
	if self.AllUseEffectInsList[fishEffectVo.EffectName] and #(self.AllUseEffectInsList[fishEffectVo.EffectName])>0 then
		local tempEffectIns=table.remove(self.AllUseEffectInsList[fishEffectVo.EffectName],1)
		if tempEffectIns then
			tempEffectIns:ResetEffectVo(fishEffectVo)
			self.CurrentUseEffectInsList[fishEffectVo.UID]=tempEffectIns
			return tempEffectIns
		else
			Debug.LogError("创建特效失败==>"..fishEffectVo.EffectName)
		end
		
	else
		local effectItem=GameObjectPoolManager.GetInstance():GetGameObject(fishEffectVo.EffectName,GameObjectPoolManager.PoolType.EffectPool)
		local tempEffectIns= self:BuildFishEffectInstance(fishEffectVo.EffectType,effectItem)
		if tempEffectIns then
			tempEffectIns:ResetEffectVo(fishEffectVo)
			self.CurrentUseEffectInsList[fishEffectVo.UID]=tempEffectIns
			return tempEffectIns
		else
			GameObjectPoolManager.GetInstance():ReCycleToGameObject(effectItem,GameObjectPoolManager.PoolType.EffectPool)
			Debug.LogError("创建特效失败==>"..fishEffectVo.EffectName)
		end
	end
	return nil
end

function FishEffectManager:BuildFishEffectInstance(effectType,go)
	local effectIns = nil
	if effectType==self.FishEffectType.AnimatorType then
		effectIns=self.AnimatorEffectItem.New(go)
	elseif effectType==self.FishEffectType.SpineType then
		effectIns=self.SpineEffectItem.New(go)
	elseif effectType==self.FishEffectType.ParticleType then
		effectIns=self.ParticleEffectItem.New(go)
	else
		Debug.LogError("未定义类型EffectType==>"..effectType)
		return nil
	end		
	return effectIns
end



function FishEffectManager:RecycleFishEffect(fishEffectVo)
	local tempEffectIns=self.CurrentUseEffectInsList[fishEffectVo.UID]
	if tempEffectIns then
		if self.AllUseEffectInsList[fishEffectVo.EffectName]==nil then
			self.AllUseEffectInsList[fishEffectVo.EffectName]={}
		end
		table.insert(self.AllUseEffectInsList[fishEffectVo.EffectName],tempEffectIns)
		self.CurrentUseEffectInsList[fishEffectVo.UID]=nil
	else
		Debug.LogError("移除的FishEffectItem为nil==>UID"..fishEffectVo.UID)
	end
end

function FishEffectManager:ClearAllFishEffect()
	if self.CurrentUseEffectInsList  then
		for k,v in pairs(self.CurrentUseEffectInsList) do
			v.isCanDestory=true
		end
		self:UpdateRemoveFishEffect()
	end
	self.CurrentUseEffectInsList = {}
end

function FishEffectManager:UpdateRemoveFishEffect()
	if self.CurrentUseEffectInsList and next(self.CurrentUseEffectInsList) then
		for k,v in pairs(self.CurrentUseEffectInsList) do
			if v.isCanDestory then
				v:Destroy()
				self:RecycleFishEffect(v.EffectVo)
			end
		end
	end
end

function FishEffectManager:Update()
	self:UpdateRemoveFishEffect()
end

function FishEffectManager:__delete()
	self.AllUseEffectInsList= nil
	self.CurrentUseEffectInsList= nil
	self.Animator = nil
	self.SkeletonAnimation = nil
end
