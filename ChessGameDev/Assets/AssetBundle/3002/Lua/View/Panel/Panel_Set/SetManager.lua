SetManager=Class()

local Instance=nil
function SetManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function SetManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Set
		local BuildSetPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				SetManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildSetPanelCallBack)
		
	else
		return Instance
	end
	
	
end


function SetManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function SetManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function SetManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
end


function SetManager:InitData()
	
	
end


function SetManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_Set/SystemSet/SystemSetView",
		"View/Panel/Panel_Set/PlayerSet/PlayerSetView",
	}
end


function SetManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function SetManager:InitInstance()
	self.SystemSetView=SystemSetView.New(self.gameObject)
	self.PlayerSetView=PlayerSetView.New(self.gameObject)
end


function SetManager:InitView()
	
end



function SetManager:InitSoundState()
	self.SystemSetView:ResetSound()
end


function SetManager:InitPlayerSetPanel()
	self.PlayerSetView:InitViewData()
end


function SetManager:InitQZAndBetValue(tempQZValue,tempBetValue)
	self.PlayerSetView:InitQZAndBetValue(tempQZValue,tempBetValue)
end


function SetManager:IsShowQiangZhunagBtnPanel(isShow)
	self.PlayerSetView:IsShowQiangZhunagBtnPanel(isShow)
end

function SetManager:IsShowBetBtnPanel(isShow)
	self.PlayerSetView:IsShowBetBtnPanel(isShow)
end

function SetManager:IsShowTanPaiBtnPanel(isShow)
	self.PlayerSetView:IsShowTanPaiBtnPanel(isShow)
end



function SetManager:QuitGameProcess(data)
	if data.exit_type==0 then
		self:QuitGame()
	else
		Debug.LogError("退出游戏失败==>"..data.exit_type)
		GameManager.GetInstance():ShowUITips("游戏进行中，不能退出！",2)
	end
end


function SetManager:QuitGame()
	self:BaseResetState()
	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.QuitGame_EventName)
end

function SetManager:BaseResetState()
	StopAllCorotines()
	GameLogicManager.GetInstance():HideAllGamePanel()
	TimerManager.GetInstance():RecycleAllTimerIns()
	AudioManager.GetInstance():StopAllNormalAudio()
	ParticleManager.GetInstance():RecycleAllGoldFlyEffect()
end



function SetManager:SetOpenHelpPanel()
	self.SystemSetView:OnclickHelp()
end



function SetManager:__delete()

end