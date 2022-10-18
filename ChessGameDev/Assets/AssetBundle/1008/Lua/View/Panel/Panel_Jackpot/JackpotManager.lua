JackpotManager=Class()

local Instance=nil
function JackpotManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function JackpotManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Jackpot
		local BuildJackpotPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				JackpotManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildJackpotPanelCallBack)
		
	else
		return Instance
	end
	
	
end


function JackpotManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function JackpotManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function JackpotManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
end


function JackpotManager:InitData()
	
end


function JackpotManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_Jackpot/View/JackpotView",
	}
end


function JackpotManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function JackpotManager:InitInstance()
	self.JackpotView=JackpotView.New(self.gameObject)
	
end


function JackpotManager:InitView()
	self:IsShowGamePanel(false)
	
end


function JackpotManager:IsShowGamePanel(isShow)
	CommonHelper.SetActive(self.gameObject,isShow)
end


function JackpotManager:SetJackpotProcess(score,totalTime)
	self.JackpotView:SetJackpotProcess(score,totalTime)
end