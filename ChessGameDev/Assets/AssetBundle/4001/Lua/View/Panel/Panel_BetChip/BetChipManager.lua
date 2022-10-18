BetChipManager=Class()

local Instance=nil
function BetChipManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function BetChipManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_BetChip
		local BuildIconPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				BetChipManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildIconPanelCallBack)
	else
		return Instance
	end
end


function BetChipManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function BetChipManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function BetChipManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
	self:InitViewData()
end


function BetChipManager:InitData()
	self.gamedata=GameManager.GetInstance().gameData
	self.GameConfig=GameManager.GetInstance().GameConfig
end


function BetChipManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_BetChip/View/BetChipView",
		"View/Panel/Panel_BetChip/BetChipItem/BetChipItem",
	}
end


function BetChipManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function BetChipManager:InitInstance()
	self.BetChipView=BetChipView.New(self.gameObject)
	self.BetChipItem=BetChipItem
end

function BetChipManager:InitView()
	self.BetChipItemList=self.BetChipView.BetChipItemList
end


function BetChipManager:InitViewData()
	self:CreateBetChipItemPool()
end

function BetChipManager:RecycleAllBetChipItem()
	self.BetChipView:ClearAllBetChipItem()
end

function BetChipManager:CreateBetChipItemPool()
	for i=1,#self.BetChipItemList do
		GameObjectPoolManager.GetInstance():AddGameObjectPool(self.BetChipItemList[i],100,self.BetChipItemList[i].gameObject.name,GameObjectPoolManager.PoolType.BetChipPool)
	end
end

function BetChipManager:EnterGameStart()
	self.BetChipView:EnterGameStart()
end

function BetChipManager:EnterBetChip(ownBetChipMoney,allBetChipMoney)
	self.BetChipView:EnterBetChip(ownBetChipMoney,allBetChipMoney)
end

function BetChipManager:PrizeBetChip(ownBetChipMoney,allBetChipMoney)
	self.BetChipView:PrizeBetChip(ownBetChipMoney,allBetChipMoney)
end

function BetChipManager:EnterOpenPrize()
	
end

function BetChipManager:CrateBetChip(isMe,OneBet,beginPos,areaIndex,chipIndex,addBetChipMoney,ownBetChipMoney,allBetChipMoney)
	self.BetChipView:BeginCreateBetChipItem(isMe,OneBet,beginPos,areaIndex,chipIndex,addBetChipMoney,ownBetChipMoney,allBetChipMoney)
end

function BetChipManager:BeginMoveBetChipToWinArea(prizeType)
	self.BetChipView:MoveBetChipToWin(prizeType)
end

function BetChipManager:__delete()
	Instance=nil
	self.BetChipView:Destroy()
end
