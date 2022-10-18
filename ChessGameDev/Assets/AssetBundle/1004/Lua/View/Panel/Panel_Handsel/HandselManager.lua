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
	self.handselCount=4
	self.handselInsList={}
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
	self.HandselObjList=self.HandselView.HandselObjList
	
end


function HandselManager:IsShowGamePanel(isShow)
	CommonHelper.SetActive(self.gameObject,isShow)
end


function HandselManager:InitHandselIns()
	for i=1,self.handselCount do
		local ItemObj=self.HandselObjList[i]
		if ItemObj then
			local tempItemIns=self.HandselItem.New(ItemObj)
			table.insert(self.handselInsList,tempItemIns)
		else
			Debug.LogError("生成HandselItem异常==>"..i)
		end
	end
end


function HandselManager:GetSingleHandselIns(index)
	if index<=#self.handselInsList then
		return self.handselInsList[index]
	else
		Debug.LogError("Index超出handselInsList长度"..index)
	end
end


function HandselManager:SetSingleHandselInsValue(index,score)
	local tempIns=self:GetSingleHandselIns(index)
	if tempIns then
		tempIns:SetHandselValue(score)
	end
end



function HandselManager:ShowTips(content)
	self.HandselView:SetTips(content)
end
