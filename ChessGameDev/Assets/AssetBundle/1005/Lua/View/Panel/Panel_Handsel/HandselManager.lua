HandselManager=Class()

local Instance=nil
function HandselManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function HandselManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Handsel
		local BuildHandselPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				HandselManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildHandselPanelCallBack)
		
	else
		return Instance
	end
	
	
end


function HandselManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function HandselManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function HandselManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
	self:InitHandselIns()
end


function HandselManager:InitData()
	self.HandselInsList={}
	
end


function HandselManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_Handsel/View/HandselView",
		"View/Panel/Panel_Handsel/Item/HandselItem",
	}
end


function HandselManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function HandselManager:InitInstance()
	self.HandselView=HandselView.New(self.gameObject)
	self.HandselItem=HandselItem
end


function HandselManager:InitView()
	self.CollectJackpotSpineAnim=self.HandselView.OpenJackpotSpineAnim
	self.HandselObjList=self.HandselView.HandselObjList
end


function HandselManager:InitHandselIns()
	for i=1,4 do
		local tempIns=self.HandselItem.New(self.HandselObjList[i])
		table.insert(self.HandselInsList,tempIns)
	end
end


function HandselManager:SetHandselData(index,data)
	if index<=#self.HandselInsList then
		self.HandselInsList[index]:SetHandselProcess(data)
	end
end


function HandselManager:ChangeHandselState(isSmalGmae)
	self.HandselView:IsShowHandselPanel(not isSmalGmae)
	self.HandselView:IsShowSmallGamePanel(isSmalGmae)
end


function HandselManager:SetSetAccountsData(setAccountsDataList)
	self.HandselView:SetSettleAccountsScore(setAccountsDataList)
end


function HandselManager:SetFFCJAddScore(score)
	self.HandselView:SetFXJJScore(score)
end


function HandselManager:GetFFCJPostion()
	return self.HandselView.FXJJScoreText.transform.parent.position
end


function HandselManager:GetFreeFFCJPostion()
	return self.HandselView.FreeGameTipsScore.transform.parent.position
end


function HandselManager:SetFreeFFCJAddScore(score)
	self.HandselView:SetFreeGameTipsScore(score)
end