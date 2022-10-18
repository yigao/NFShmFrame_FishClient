FreeGameManager=Class()

local Instance=nil
function FreeGameManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function FreeGameManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_FreeGame
		local BuildBGPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				FreeGameManager.New(gameObject)
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


function FreeGameManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function FreeGameManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function FreeGameManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
end


function FreeGameManager:InitData()
	
	
end


function FreeGameManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_FreeGame/View/FreeGameView",
		
	}
end


function FreeGameManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function FreeGameManager:InitInstance()
	self.FreeGameView=FreeGameView.New(self.gameObject)
end


function FreeGameManager:InitView()
	self:IsShowFreeGamePanel(false)
end


function FreeGameManager:IsShowFreeGamePanel(isShow)
	CommonHelper.SetActive(self.gameObject,isShow)
end



function FreeGameManager:EnterFreeGameProcess(freeGameCount)
	BaseFctManager.GetInstance():SetFreeGameCountTips(freeGameCount)
	BaseFctManager.GetInstance():IsShowFreeGameCount(true)
	self.FreeGameView:SetEnterFreeGameCountTips(freeGameCount)
	self.FreeGameView:IsShowEnterFreeGamePanel(false)
	self.FreeGameView:IsShowQuitFreeGamePanel(false)
	self:IsShowFreeGamePanel(true)
	self.FreeGameView:IsShowEnterFreeGamePanel(true)
	self.FreeGameView:PlayEnterFreeGameAnim(1)
	local DelayPlayEnterFreeGameAnimFunc=function ()
		self:ResetPlayEnterFreeGameAnimTimer()
		self.FreeGameView:PlayEnterFreeGameAnim(2)
		local DelayPlayEndEnterFreeGameAnimFunc=function ()
			self:ResetPlayEndEnterFreeGameAnimTimer()
			self.FreeGameView:IsShowEnterFreeGamePanel(false)
			self:EnterFreeGameCallBack()
		end
		self.PlayEndEnterFreeGameAnimTimer=TimerManager.GetInstance():CreateTimerInstance(1,DelayPlayEndEnterFreeGameAnimFunc)
	end
	self.PlayEnterFreeGameAnimTimer=TimerManager.GetInstance():CreateTimerInstance(1.5,DelayPlayEnterFreeGameAnimFunc)
end

function FreeGameManager:ResetPlayEnterFreeGameAnimTimer()
	if self.PlayEnterFreeGameAnimTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.PlayEnterFreeGameAnimTimer)
		self.PlayEnterFreeGameAnimTimer=nil
	end
end

function FreeGameManager:ResetPlayEndEnterFreeGameAnimTimer()
	if self.PlayEndEnterFreeGameAnimTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.PlayEndEnterFreeGameAnimTimer)
		self.PlayEndEnterFreeGameAnimTimer=nil
	end
end



function FreeGameManager:QuitFreeGameProcess(freeGameCount,freeGameWinScore)
	self.FreeGameView:SetQuitFreeGameCountTips(freeGameCount)
	self.FreeGameView:SetFreeGameTotalWinScoreTips(freeGameWinScore)
	self.FreeGameView:IsShowEnterFreeGamePanel(false)
	self.FreeGameView:IsShowQuitFreeGamePanel(true)
	self:IsShowFreeGamePanel(true)
end



function FreeGameManager:EnterFreeGameCallBack()
	self:FreeGameStateCallBack()
end


function FreeGameManager:QuitFreeGameCallBack()
	self.FreeGameView:IsShowQuitFreeGamePanel(false)
	self:IsShowFreeGamePanel(false)
	self:FreeGameStateCallBack()
end


function FreeGameManager:FreeGameStateCallBack()
	StateManager.GetInstance():GameStateOverCallBack()
end



function FreeGameManager:__delete()

end