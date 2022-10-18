SpeedManager=Class()

local Instance=nil
function SpeedManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function SpeedManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Speed
		local BuildSpeedPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				SpeedManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildSpeedPanelCallBack)
		
	else
		return Instance
	end
	
	
end


function SpeedManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function SpeedManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function SpeedManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
end


function SpeedManager:InitData()
	
end


function SpeedManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Speed_Panel/View/SpeedView",
	}
end


function SpeedManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function SpeedManager:InitInstance()
	self.SpeedView=SpeedView.New(self.gameObject)
end


function SpeedManager:InitView()
	--self:IsShowWinPanel(false)
end


function SpeedManager:IsShowWinPanel(isShow)
	CommonHelper.SetActive(self.gameObject,isShow)
end


function SpeedManager:ShowSpeedEffectPanel(index,isShow)
	self.SpeedView:IsShowSpeedEffectPanel(index,isShow)
end


function SpeedManager:HideAllSpeedEffectPanel()
	self.SpeedView:HideAllSpeedEffectPanel()
end



function SpeedManager:__delete()
	Instance=nil
end