BeBankerManager=Class()

local Instance=nil
function BeBankerManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function BeBankerManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_BeBanker
		local BuildHelpPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)			
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				BeBankerManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildHelpPanelCallBack)
	else
		return Instance
	end
end


function BeBankerManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function BeBankerManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function BeBankerManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
end


function BeBankerManager:InitData()
	self.gameData=GameManager.GetInstance().gameData
end


function BeBankerManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_BeBanker/View/BeBankerView",
		"View/Panel/Panel_BeBanker/View/BeBankerItem/BeBankerItem",
	}
end


function BeBankerManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end

function BeBankerManager:InitInstance()
	self.BeBankerItem = BeBankerItem
	self.BeBankerView=BeBankerView.New(self.gameObject)
end

function BeBankerManager:InitView()
	self:IsShowBeBankerPanel(false)
end

function BeBankerManager:IsMySelfWaitBankerList()
	for i = 1,#self.gameData.WaitBankerVoList do
		if self.gameData.WaitBankerVoList[i].usNtChairId  == self.gameData.PlayerChairId then
			return true
		end
	end
	return false
end

function BeBankerManager:EnterGameStart()
	self:UpdateBeBankerPanel()
end

function BeBankerManager:OpenBeBankerPanel()
	self:IsShowBeBankerPanel(true)
	self.BeBankerView:OpenBeBankerPanel()
end

function BeBankerManager:UpdateBeBankerPanel()
	if CommonHelper.IsActive(self.gameObject) == true then
		self.BeBankerView:UpdateBeBankerPanel()
	end
end

function BeBankerManager:IsShowBeBankerPanel(isShow)
	CommonHelper.SetActive(self.gameObject,isShow)
end

function BeBankerManager:Destroy()
	self.BeBankerView:Destroy()
end