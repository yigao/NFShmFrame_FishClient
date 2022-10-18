ParticleManager=Class()

local Instance=nil
function ParticleManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function ParticleManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Particle
		local BuildParticlePanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				ParticleManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildParticlePanelCallBack)
		
	else
		return Instance
	end
	
	
end


function ParticleManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function ParticleManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function ParticleManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
	self:InitViewData()
	self:InitAllEffect()
end


function ParticleManager:InitData()
	self.gamedata=GameManager.GetInstance().gameData
	self.GameConfig=GameManager.GetInstance().GameConfig
	
end


function ParticleManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_Particle/View/ParticleView",
		"View/Panel/Panel_Particle/ParabolaItem/ParabolaItem",
		
	}
end


function ParticleManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function ParticleManager:InitInstance()
	self.ParticleView=ParticleView.New(self.gameObject)
	self.ParabolaItem=ParabolaItem
end

function ParticleManager:InitView()
	
end



function ParticleManager:InitViewData()
	self.AllEffectObjList=self.ParticleView.EffectObjList
end


function ParticleManager:InitAllEffect()
	for i=1,#self.AllEffectObjList do
		GameObjectPoolManager.GetInstance():AddGameObjectPool(self.AllEffectObjList[i],10,self.AllEffectObjList[i].name,GameObjectPoolManager.PoolType.EffectPool)
	end
end


function ParticleManager:GetAllocateEffect(effectName)
	return GameObjectPoolManager.GetInstance():GetGameObject(effectName,GameObjectPoolManager.PoolType.EffectPool)
end


function ParticleManager:RecycleEffect(effectObj)
	GameObjectPoolManager.GetInstance():ReCycleToGameObject(effectObj,GameObjectPoolManager.PoolType.EffectPool)
end



function ParticleManager:SetParabolaItemEffect(startPos,endPos)
	local tempEffect=self:GetAllocateEffect("GoldFlyEffect")
	if tempEffect then
		local effectIns=self.ParabolaItem.New(tempEffect)
		effectIns:SetParabola(startPos,endPos)
	end
end


function ParticleManager:RecycleAllGoldFlyEffect()
	GameObjectPoolManager.GetInstance():RecycleAllocateTypeGameObject("GoldFlyEffect",GameObjectPoolManager.PoolType.EffectPool)
end


function ParticleManager:__delete()
	self:RecycleAllGoldFlyEffect()
end