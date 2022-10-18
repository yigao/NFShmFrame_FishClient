GameObjectPoolManager=Class()

local Instance=nil
function GameObjectPoolManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end

--对象池必须使用同步加载
function GameObjectPoolManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Pool		
		local gameObj=GameManager.GetInstance():LoadGameResuorce(aseetPath,false,true)
		if gameObj then
			local gameObject=CommonHelper.Instantiate(gameObj)
			gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
			GameObjectPoolManager.New(gameObject)
			Instance:LoadComplete()
		else
			Debug.LogError("资源加载失败==>"..aseetPath)
		end
	
	end
	
	return Instance
end


function GameObjectPoolManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end



GameObjectPoolManager.PoolType={--pool类型
	BetChipPool=1,
	--EffectPool=2,
}




function GameObjectPoolManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function GameObjectPoolManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
end


function GameObjectPoolManager:InitData()
	
	
end


function GameObjectPoolManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_Pool/View/PoolView",
		"View/Panel/Panel_Pool/ObjectPool/ObjectPool",
	}
end


function GameObjectPoolManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function GameObjectPoolManager:InitInstance()
	self.PoolView=PoolView.New(self.gameObject)
	self.ObjectPool=ObjectPool.New()
end


function GameObjectPoolManager:InitView()
	self.PoolList=self.PoolView.PoolList
end



function GameObjectPoolManager:AddGameObjectPool(obj,number,keyName,poolType)
	self.ObjectPool:AddObjectPool(obj,number,keyName,poolType)
end

function GameObjectPoolManager:SetPoolParent(targetObj,poolType)
	self.ObjectPool:SetPoolParent(targetObj,poolType)
end


function GameObjectPoolManager:GetGameObject(gameObjName,poolType)
	return self.ObjectPool:GetGameObject(gameObjName,poolType)
end

function GameObjectPoolManager:ReCycleToGameObject(gameObj,poolType)
	self.ObjectPool:ReCycleToGameObject(gameObj,poolType)
end





function GameObjectPoolManager:__delete()
	Instance=nil
	self.ObjectPool:Destroy()
	self.PoolView=nil
	self.ObjectPool=nil
end
