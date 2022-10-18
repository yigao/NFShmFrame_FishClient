FishOutTipsEffectManager=Class()

local Instance=nil
function FishOutTipsEffectManager:ctor(obj)
	Instance=self
	self.gameObject=obj
	self:Init(obj)
	CommonHelper.AddUpdate(self)
end


function FishOutTipsEffectManager.GetInstance()
	return Instance
end


function FishOutTipsEffectManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
	
end



function FishOutTipsEffectManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.CurrentUseEffectInsList={}
	self.UID=1

	self.Animator=CS.UnityEngine.Animator
	self.Text=CS.UnityEngine.UI.Text
	self.SkeletonAnimation = CS.Spine.Unity.SkeletonAnimation
end

function FishOutTipsEffectManager:AddScripts()
	self.ScriptsPathList={
		"/View/Effect/FishOutTipsEffect/Effect/FishOutTipsEffecItem",
		
	}
end


function FishOutTipsEffectManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function FishOutTipsEffectManager:InitView(gameObj)
	
end


function FishOutTipsEffectManager:InitInstance()
	self.FishOutTipsEffecItem=FishOutTipsEffecItem
end


function FishOutTipsEffectManager:InitViewData()	
	
end


function FishOutTipsEffectManager:GetGoldEffectUID()
	self.UID=self.UID+1
	return self.UID
end

function FishOutTipsEffectManager:GetFishOutTipsEffectVo(resourceName,lifeTime)
	local vo={}
	vo.UID=self:GetGoldEffectUID()
	vo.ResourceName=resourceName
	vo.LifeTime=lifeTime
	return vo
end



function FishOutTipsEffectManager:SetFishOutTipsEffectShowMode(resourceName,lifeTime)
	local FishOutTipsEffectVo=self:GetFishOutTipsEffectVo(resourceName,lifeTime)
	local tempFishOutTipsEffectIns=self:GetFishOutTipsEffect(FishOutTipsEffectVo)
	if tempFishOutTipsEffectIns then
		tempFishOutTipsEffectIns:ResetState()
	end
end



function FishOutTipsEffectManager:GetFishOutTipsEffect(fishOutTipsEffectVo)
	local effectItem=GameObjectPoolManager.GetInstance():GetGameObject(fishOutTipsEffectVo.ResourceName,GameObjectPoolManager.PoolType.FishOutTipsPool)
	
	local tempEffectIns=self.FishOutTipsEffecItem.New(effectItem)
	if tempEffectIns then
		tempEffectIns:ResetEffectVo(fishOutTipsEffectVo)
		self.CurrentUseEffectInsList[fishOutTipsEffectVo.UID]=tempEffectIns
		return tempEffectIns
	else
		GameObjectPoolManager.GetInstance():ReCycleToGameObject(effectItem,GameObjectPoolManager.PoolType.FishOutTipsPool)
		Debug.LogError("EffectIns生成失败==>"..fishOutTipsEffectVo.ResourceName)
	end
	
	return nil
end



function FishOutTipsEffectManager:RecycleFishOutTipsEffect(FishOutTipsEffectIns)
	--Debug.LogError("移除UID==>"..FishOutTipsEffectIns.EffectVo.UID)
	local tempEffectIns=self.CurrentUseEffectInsList[FishOutTipsEffectIns.EffectVo.UID]
	if tempEffectIns then
		GameObjectPoolManager.GetInstance():ReCycleToGameObject(FishOutTipsEffectIns.gameObject,GameObjectPoolManager.PoolType.FishOutTipsPool)
		self.CurrentUseEffectInsList[FishOutTipsEffectIns.EffectVo.UID]=nil
	else
		Debug.LogError("移除的FishOutTipsEffect为nil==>UID"..FishOutTipsEffectIns.EffectVo.UID)
	end
end


function FishOutTipsEffectManager:ClearAllFishOutTipsEffect()
	if self.CurrentUseEffectInsList  then
		for k,v in pairs(self.CurrentUseEffectInsList) do
			v.isCanDestory=true
		end
		self:UpdateRemoveFishOutTipsEffect()
	end
end



function FishOutTipsEffectManager:UpdateRemoveFishOutTipsEffect()
	if self.CurrentUseEffectInsList and next(self.CurrentUseEffectInsList) then
		for k,v in pairs(self.CurrentUseEffectInsList) do
			if v.isCanDestory then
				v:Destroy()
				self:RecycleFishOutTipsEffect(v)
			end
		end
	end
end


function FishOutTipsEffectManager:Update()
	self:UpdateRemoveFishOutTipsEffect()
end



