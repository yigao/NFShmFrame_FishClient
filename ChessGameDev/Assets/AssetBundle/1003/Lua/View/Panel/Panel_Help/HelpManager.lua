HelpManager=Class()

local Instance=nil
function HelpManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function HelpManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Help
		local BuildHelpPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				--gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				HelpManager.New(gameObject)
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


function HelpManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function HelpManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function HelpManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
end


function HelpManager:InitData()
	
	
end


function HelpManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_Help/View/HelpView",
		
	}
end


function HelpManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function HelpManager:InitInstance()
	self.HelpView=HelpView.New(self.gameObject)
end


function HelpManager:InitView()
	self:IsShowHelpPanel(false)
end


function HelpManager:IsShowHelpPanel(isShow)
	CommonHelper.SetActive(self.gameObject,isShow)
end