BGManager=Class()

local Instance=nil
function BGManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
	CommonHelper.AddUpdate(self)
end


function BGManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_BG
		local BuildBGPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				BGManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildBGPanelCallBack)
		
	else
		return Instance
	end
	
	
end


function BGManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function BGManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function BGManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
end


function BGManager:InitData()
	self.isPlay=true
	self.currentTime=0
	self.totalTime=8
	self.curretIndex=1
end


function BGManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_BG/View/BGView",
	}
end


function BGManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function BGManager:InitInstance()
	self.BGView=BGView.New(self.gameObject)
end


function BGManager:InitView()
	self:IsShowBGTipsPanel(1,true)
end


function BGManager:IsShowMainBGPanel(index,isShow)
	local mainBG=self.BGView.MainBGList[index]
	if mainBG then
		CommonHelper.SetActive(mainBG,isShow)
	end
end


function BGManager:IsShowIconBGPanel(index,isShow)
	local iconBG=self.BGView.IconBGList[index]
	if iconBG then
		CommonHelper.SetActive(iconBG,isShow)
	end
end



function BGManager:IsShowSLBBKBGPanel(index,isShow)
	local BKBG=self.BGView.BKBGList[index]
	if BKBG then
		CommonHelper.SetActive(BKBG,isShow)
	end
end


function BGManager:IsShowBGTipsPanel(index,isShow)
	CommonHelper.IsShowPanel(index,self.BGView.BGTipsList,isShow,true,false)
end



function BGManager:Update()
	if self.isPlay then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		if self.currentTime>=self.totalTime then
			self.currentTime=0
			self.curretIndex=self.curretIndex+1
			if self.curretIndex>=4 then
				self.curretIndex=1
			end
			self:IsShowBGTipsPanel(self.curretIndex,true)
		end
	end
	
end


function BGManager:__delete()
	Instance=nil
end