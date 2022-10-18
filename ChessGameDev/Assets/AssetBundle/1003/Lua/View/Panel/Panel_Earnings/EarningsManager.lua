EarningsManager=Class()

local Instance=nil
function EarningsManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function EarningsManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Earnings
		local BuildEarningsPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				EarningsManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildEarningsPanelCallBack)
		
	else
		return Instance
	end
	
	
end


function EarningsManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function EarningsManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function EarningsManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView()
	self:InitInstance()
end


function EarningsManager:InitData()
	
	
end


function EarningsManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_Earnings/View/EarningsView",
	}
end


function EarningsManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function EarningsManager:InitView()
	self:IsShowEarningsPanel(false)
end





function EarningsManager:InitInstance()
	self.EarningsView=EarningsView.New(self.gameObject)
	
end


function EarningsManager:IsShowEarningsPanel(isShow)
	CommonHelper.SetActive(self.gameObject,isShow)
end



function EarningsManager:SetEarningsWinScoreProcess(totalScore,showTime,callBackFunc)
	self.EarningsView.currentWinScore=totalScore
	self.EarningsView.totalShowTime=showTime
	self.EarningsView.stayShowTime=showTime+2
	self.EarningsView.callBackFunc=callBackFunc
	self.EarningsView.currentTime=0
	self.EarningsView.IsUpdateWinScore=true
	self.EarningsView:ResetView()
end



function EarningsManager:GuessToEarningsWinScoreProcess(totalScore,showTime)
	self.EarningsView.currentWinScore=totalScore
	self.EarningsView.totalShowTime=showTime
	self.EarningsView.currentTime=0
	self.EarningsView:IsShowBtnPanel(false)
	self.EarningsView:IsEnableAllControlBtn(false)
	self.EarningsView.IsUpdateSpecialWinScore=true
end



function EarningsManager:EnterGuess()
	GuessManager.GetInstance():EnterGuess()
end



function EarningsManager:__delete()
	Instance=nil
end