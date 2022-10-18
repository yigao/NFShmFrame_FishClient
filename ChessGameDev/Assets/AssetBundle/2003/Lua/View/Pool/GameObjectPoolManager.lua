GameObjectPoolManager=Class()

local Instance=nil
function GameObjectPoolManager:ctor(obj)
	Instance=self
	self:Init(obj)
end


function GameObjectPoolManager.GetInstance()
	return Instance
end



function GameObjectPoolManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
end


GameObjectPoolManager.PoolType={--pool类型
	FishPool=1,
	BulletPool=2,
	NetPool=3,
	GoldPool=4,
	ScorePool=5,
	PlusTips =6,
	EffectPool=7,
	FishOutTipsPool=8,
	BigAwardTipsPool = 9,
	LightningPool = 10,
	OtherPool=11,
	TipsContent=12,
}


function GameObjectPoolManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
end

function GameObjectPoolManager:AddScripts()
	self.ScriptsPathList={
		"/View/Pool/PoolPanel",
		"/View/Pool/ObjectPool",
		}
end


function GameObjectPoolManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function GameObjectPoolManager:InitView(gameObj)
	self.gameObject=gameObj.transform:Find("FishPanel/GameObjectPool").gameObject
end


function GameObjectPoolManager:InitInstance()
	self.PoolPanel=PoolPanel.New(self.gameObject)
	self.ObjectPool=ObjectPool.New()
	
end


function GameObjectPoolManager:InitViewData()	
	self.PoolList=self.PoolPanel.PoolList
	
end

function GameObjectPoolManager:GetPoolFishRootObj()
	return self.PoolPanel.ShakeCamera
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
	self.ObjectPool:Destroy()
	self.PoolPanel=nil
	self.ObjectPool=nil
	self.PoolList=nil
end
