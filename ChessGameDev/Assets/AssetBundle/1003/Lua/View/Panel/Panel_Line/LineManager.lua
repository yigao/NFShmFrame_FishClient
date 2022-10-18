LineManager=Class()

local Instance=nil
function LineManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function LineManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Line
		local BuildLinePanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				LineManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildLinePanelCallBack)
		
	else
		return Instance
	end
	
	
end


function LineManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function LineManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function LineManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
	self:InitLineIns()
end


function LineManager:InitData()
	self.LineInsList={}
	
end


function LineManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_Line/View/LineView",
		"View/Panel/Panel_Line/Item/LineItem",
	}
end


function LineManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function LineManager:InitInstance()
	self.LineView=LineView.New(self.gameObject)
	self.LineItem=LineItem
end


function LineManager:InitView()
	self.LineList=self.LineView.LineList
end


function LineManager:InitLineIns()
	for i=1,#self.LineList do
		local tempLineIns=self.LineItem.New(self.LineList[i])
		table.insert(self.LineInsList,tempLineIns)
	end
end



function LineManager:GetLineIns(index)
	if index and index>0 and index<=#self.LineInsList then
		return self.LineInsList[index]
	else
		Debug.LogError("LineIdex异常==>")
		Debug.LogError(index)
	end
end


function LineManager:SelectShowLine(index,isShow)
	local tempLineIns=self:GetLineIns(index)
	if tempLineIns then
		tempLineIns:IsShowLine(isShow)
	end
end

function LineManager:HideAllLine()
	for i=1,#self.LineInsList do
		self.LineInsList[i]:IsShowLine(false)
	end
end



function LineManager:__delete()

end
