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
	self.CurrentUseEffectInsList={}
	self.UID=1
	self.Animator=CS.UnityEngine.Animator
	self.SkeletonAnimation = CS.Spine.Unity.SkeletonAnimation
	self.FishEffectType={			--特效类型
		ParticleType=1,
		SpineType=2,
	}
end

function FishEffectManager:AddScripts()
	self.ScriptsPathList={
		"/View/Effect/FishEffect/Effect/ParticleEffectItem",
		"/View/Effect/FishEffect/Effect/SpineEffectItem",
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
	self.ParticleEffectItem=ParticleEffectItem
	self.SpineEffectItem=SpineEffectItem
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

function FishEffectManager:SetFishEffectShowMode(tempFishTF,chairID,fishUID,dieEffectConfig,callBack)
	for i = 1,#dieEffectConfig.dieEffectName do
		local effectName =dieEffectConfig.dieEffectName[i] 
		local effectType = dieEffectConfig.dieEffectType[i]
		local effectPositionFlag = dieEffectConfig.dieEffectPositionFlag[i]
		local effectDelayTime = dieEffectConfig.dieEffectDelyTime[i]
		local effectLifeTime = dieEffectConfig.dieEffectLifeTime[i]
		local effectAudio = dieEffectConfig.dieAudio[i]
		local beginPos = tempFishTF.position
		if effectName ~= "nil" then
			self:ShowFishEffect(chairID,fishUID,beginPos,effectType,effectName,effectPositionFlag,effectDelayTime,effectLifeTime,effectAudio,callBack)
		end
	end
end

function FishEffectManager:ShowFishEffect(chairID,fishUID,beginPos,effectType,effectName,effectPositionFlag,effectDelayTime,effectLifeTime,effectAudio,callBack)
	local vo=self:GetFishEffectVo(fishUID,chairID,effectType,effectName,effectPositionFlag,effectDelayTime,effectLifeTime,effectAudio)
	local tempEffectIns=self:GetFishEffect(vo)
	if tempEffectIns then
		tempEffectIns:ResetState(beginPos,callBack)
	else
		Debug.LogError("获取effectName失败==>"..effectName)
	end
end


function FishEffectManager:GetFishEffectVo(fishUID,chairID,effectType,effectName,effectPositionFlag,effectDelayTime,effectLifeTime,effectAudio)
	local vo={}
	vo.UID=self:GetFishEffectUID()
	vo.fishUID = fishUID
	vo.ChairID = chairID
	vo.IsMe = (chairID == self.gameData.PlayerChairId)
	vo.EffectType = effectType
	vo.EffectName = effectName
	vo.EffectPositionFlag =effectPositionFlag
	vo.EffectDelayTime = effectDelayTime
	vo.EffectLifeTime = effectLifeTime
	vo.EffectAudio = effectAudio
	return vo
end


function FishEffectManager:GetFishEffect(fishEffectVo)
	local effectItem=GameObjectPoolManager.GetInstance():GetGameObject(fishEffectVo.EffectName,GameObjectPoolManager.PoolType.EffectPool)
	local tempEffectIns= self:BuildFishEffectInstance(fishEffectVo.EffectType,effectItem)
	if tempEffectIns then
		tempEffectIns:ResetEffectVo(fishEffectVo)
		self.CurrentUseEffectInsList[fishEffectVo.UID]=tempEffectIns
		return tempEffectIns
	end
	return nil
	
end

function FishEffectManager:BuildFishEffectInstance(effectType,go)
	local effectIns = nil
	if effectType==self.FishEffectType.ParticleType then
		effectIns=self.ParticleEffectItem.New(go)
	elseif effectType==self.FishEffectType.SpineType then
		effectIns=self.SpineEffectItem.New(go)
	else
		Debug.LogError("未定义类型EffectType==>"..effectType)
		return nil
	end		
	return effectIns
end



function FishEffectManager:RecycleFishEffect(fishEffectInfo)
	local tempFishEffect=self.CurrentUseEffectInsList[fishEffectInfo.UID]
	if tempFishEffect then
		GameObjectPoolManager.GetInstance():ReCycleToGameObject(tempFishEffect.gameObject,GameObjectPoolManager.PoolType.EffectPool)
		self.CurrentUseEffectInsList[fishEffectInfo.UID]=nil
	else
		Debug.LogError("回收FishEffect失败==>"..fishEffectInfo.FishEffect.name)
	end
end



function FishEffectManager:RecycleAllFishEffect()
	for k,v in pairs(self.CurrentUseEffectInsList) do
		GameObjectPoolManager.GetInstance():ReCycleToGameObject(v,GameObjectPoolManager.PoolType.EffectPool)
	end
	self.CurrentUseEffectInsList={}
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
