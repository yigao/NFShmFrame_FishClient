TipsContentManager=Class()

local Instance=nil
function TipsContentManager:ctor(obj)
	Instance=self
	self.gameObject=obj
	self:Init(obj)
	CommonHelper.AddUpdate(self)
end


function TipsContentManager.GetInstance()
	return Instance
end


function TipsContentManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
end



function TipsContentManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.AllUsedTipsInsList={}	
	self.CurrentUseTipsList={}
	self.UID=0
	self.TipsContentName="TipsContent"
end

function TipsContentManager:AddScripts()
	self.ScriptsPathList={
			"/View/TipsContent/TipsVo/TipsContentItem",
		}
end


function TipsContentManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function TipsContentManager:InitView(gameObj)
	
end


function TipsContentManager:InitInstance()
	self.TipsContentItem=TipsContentItem
end


function TipsContentManager:InitViewData()	
	
end


function TipsContentManager:GetUID()
	self.UID=self.UID+1
	if self.UID>200 then
		self.UID=1
	end
	return self.UID
end


function TipsContentManager:SetShowTipsContent(fishIns)
	self:GetTipsContent(fishIns)
end



function TipsContentManager:GetTipsContent(fishIns)
	if self.AllUsedTipsInsList and next(self.AllUsedTipsInsList) then
		local tipsContent=table.remove(self.AllUsedTipsInsList,1)
		if tipsContent then
			local uID=self:GetUID()
			self.CurrentUseTipsList[uID]=tipsContent
			tipsContent:ResetState(fishIns,uID)
			return tipsContent
		else
			Debug.LogError("获取存在中的TipsContent为nil==>")
			return nil
		end
	else
		local tipsContentObj=GameObjectPoolManager.GetInstance():GetGameObject(self.TipsContentName,GameObjectPoolManager.PoolType.TipsContent)
		if tipsContentObj then
			local tipsContent=self.TipsContentItem.New(tipsContentObj)
			if tipsContent then
				local uID=self:GetUID()
				self.CurrentUseTipsList[uID]=tipsContent
				tipsContent:ResetState(fishIns,uID)
				return tipsContent
			else
				Debug.LogError("创建TipsContent实例失败==>>>")
				GameObjectPoolManager.GetInstance():ReCycleToGameObject(tipsContentObj,GameObjectPoolManager.PoolType.TipsContent)
			end
		else
			Debug.LogError("获取失败==>>>"..self.TipsContentName)
			return nil
		end
		
	end
end



function TipsContentManager:RemoveTipsContent(tipsContent)
	local tempTips=self.CurrentUseTipsList[tipsContent.UID]
	if tempTips then
		if not self.AllUsedTipsInsList then
			self.AllUsedTipsInsList={}
		end
		table.insert(self.AllUsedTipsInsList,tempTips)
		self.CurrentUseTipsList[tipsContent.UID]=nil
	else
		Debug.LogError("移除的TipsContentUID为nil==>"..tipsContent.UID)
	end
end


function TipsContentManager:ClearAllUsingTipsContent()
	if self.CurrentUseTipsList  then
		for k,v in pairs(self.CurrentUseTipsList) do
			 v:Destroy()
			 self:RemoveTipsContent(v)	
		end
	end
	self.CurrentUseTipsList={}
end



function TipsContentManager:UpdateTipsContentAutoDestory()
	if self.CurrentUseTipsList and next(self.CurrentUseTipsList) then
		for k,v in pairs(self.CurrentUseTipsList) do
			if v.isCanDestroy then
				v:Destroy()
				self:RemoveTipsContent(v)	
			end
		end
	end
end


function TipsContentManager:Update()
	self:UpdateTipsContentAutoDestory()
end



function TipsContentManager:__delete()
	self.CurrentUseTipsList=nil
	self.AllUsedTipsInsList=nil
end
