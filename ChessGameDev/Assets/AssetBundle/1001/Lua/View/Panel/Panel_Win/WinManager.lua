WinManager=Class()

local Instance=nil
function WinManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function WinManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Win
		local BuildWinPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				WinManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildWinPanelCallBack)
		
	else
		return Instance
	end
	
	
end


function WinManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function WinManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function WinManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
end


function WinManager:InitData()
	
end


function WinManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_Win/Win/WinView",
	}
end


function WinManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function WinManager:InitInstance()
	self.WinView=WinView.New(self.gameObject)
end


function WinManager:InitView()
	self:IsShowWinPanel(false)
end


function WinManager:IsShowWinPanel(isShow)
	CommonHelper.SetActive(self.gameObject,isShow)
end


function WinManager:SetWinState(winIndex,showTime,winScore)
	self.WinView:EnterWin(winIndex,showTime,winScore)
	self:IsShowWinPanel(true)
end



function WinManager:WinStateCallBack()
	self:IsShowWinPanel(false)
	StateManager.GetInstance():GameStateOverCallBack()
end


function WinManager:EnterSmallWinProcess(showTime,winScore)
	self.WinView:EnterSmallWinProcess(showTime,winScore)
	self:IsShowWinPanel(true)
end



function WinManager:__delete()
	Instance=nil
end