IconSelectManager=Class()

local Instance=nil
function IconSelectManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function IconSelectManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_IconSelect
		local BuildIconSelectPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				IconSelectManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildIconSelectPanelCallBack)
		
	else
		return Instance
	end
	
	
end


function IconSelectManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function IconSelectManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function IconSelectManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
end


function IconSelectManager:InitData()
	self.IconSelectState={false,false,false,false,false}
	
end


function IconSelectManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_IconSelect/View/IconSelectView",
		
	}
end


function IconSelectManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function IconSelectManager:InitInstance()
	self.IconSelectView=IconSelectView.New(self.gameObject)
end


function IconSelectManager:InitView()
	
end


function IconSelectManager:SetIconSelectProcess(index,isSelect)
	self.IconSelectState[index]=isSelect
	TimerManager.GetInstance():RecycleTimerIns(self.HideMidPanelTimer)
	self.IconSelectView:IsShowMidPanel(true)
	self.IconSelectView:SetRightSelectIconImage(index,isSelect)
	self.IconSelectView:SetMidSelectIconImage(index,isSelect)
	self:ChangGoldenToMainIcon(index,isSelect)
	local DelayHideMidPanelFunc=function ()
		TimerManager.GetInstance():RecycleTimerIns(self.HideMidPanelTimer)
		self.IconSelectView:IsShowMidPanel(false)
	end
	self.HideMidPanelTimer=TimerManager.GetInstance():CreateTimerInstance(2,DelayHideMidPanelFunc)
end


function IconSelectManager:SelectAllIcon()
	for i=1,5 do
		if self.IconSelectState[i]==false then
			self:SetIconSelectProcess(i,true)
		end
	end
end


function IconSelectManager:ChangGoldenToMainIcon(index,isSelect)
	IconManager.GetInstance():ChangeMainIconToGolden(index+2,isSelect)
end
