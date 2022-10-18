BaseFctManager=Class()

local Instance=nil
function BaseFctManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function BaseFctManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Base
		local BuildBasePanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				BaseFctManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildBasePanelCallBack)
		
	else
		return Instance
	end
	
	
end


function BaseFctManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function BaseFctManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function BaseFctManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
end


function BaseFctManager:InitData()
	
	
end


function BaseFctManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_Base/Player/PlayerView",
		"View/Panel/Panel_Base/Player/PlayerWinScoreView",
		"View/Panel/Panel_Base/Bet/PlayerBetView",
		"View/Panel/Panel_Base/Start/PlayerStartView",
		"View/Panel/Panel_Base/Auto/AutoView",
		"View/Panel/Panel_Base/Set/SetView",
	}
end


function BaseFctManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function BaseFctManager:InitInstance()
	self.PlayerView=PlayerView.New(self.gameObject)
	self.PlayerWinScoreView=PlayerWinScoreView.New(self.gameObject)
	self.PlayerBetView=PlayerBetView.New(self.gameObject)
	self.PlayerStartView=PlayerStartView.New(self.gameObject)
	self.AutoView=AutoView.New(self.gameObject)
	self.SetView=SetView.New(self.gameObject)
end


function BaseFctManager:InitView()
	
end



function BaseFctManager:SetPlayerMoney(score)
	self.PlayerView:SetPlayerMoney(score)
end


function BaseFctManager:SetPlayerName(name)
	self.PlayerView:SetPlayerName(name)
end


function BaseFctManager:SetPlayerWinScore(score,showTime,isShowAddScore)
	self.PlayerWinScoreView:SetPlayerWinScore(score,showTime,isShowAddScore)
end


function BaseFctManager:ResetAddScoreState(score)
	self.PlayerWinScoreView:ResetAddScoreState(score)
end


function BaseFctManager:InitBetInfo(betInfo)
	self.PlayerBetView:InitBetInfo(betInfo)
end


function BaseFctManager:SetStartState(isRun)
	self.PlayerStartView:SetStartState(isRun)
end


function BaseFctManager:IsEnableStartButton(isEnable)
	self.PlayerStartView:IsEnableStartButton(isEnable)
end

function BaseFctManager:IsEnableStopButton(isEnable)
	self.PlayerStartView:IsEnableStopButton(isEnable)
end


function BaseFctManager:ResetStartBtnStateTimer()
	self.PlayerStartView:ResetStartBtnStateTimer()
end


function BaseFctManager:GetCurrentBetChipValue()
	return self.PlayerBetView:GetCurrentBetChipValue()
end



function BaseFctManager:GetCurrentBetChipIndex()
	return self.PlayerBetView:GetCurrentBetChipIndex()
end



function BaseFctManager:SetAutoProcess(autoCount)
	self.AutoView:SetAutoProcess(autoCount)
end


function BaseFctManager:AutoStartGame()
	self.AutoView:AutoStartGame()
end


function BaseFctManager:StopAutoGame()
	self.AutoView:SetStopAutoState()
end


function BaseFctManager:IsShowFreeGameBtn(isShow)
	self.PlayerStartView:IsShowFreePanel(isShow)
end

function BaseFctManager:SetFreeGameCountTips(count)
	self.PlayerStartView:SetFreeGameCount(count)
end



function BaseFctManager:IsEnableBetButton(isEnable)
	self.PlayerBetView:IsEnableBetButton(isEnable)
end

function BaseFctManager:OpenHelpPanel()
	self.SetView:OnclickHelp()
end


function BaseFctManager:InitSoundState()
	self.SetView:ResetSound()
end


function BaseFctManager:QuitGameProcess(data)
	if data.exit_type==0 then
		self:QuitGame()
	else
		Debug.LogError("退出游戏失败==>"..data.exit_type)
	end
end


function BaseFctManager:QuitGame()
	self:BaseResetState()
	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.QuitGame_EventName)
end


function BaseFctManager:BaseResetState()
	StopAllCorotines()
	TimerManager.GetInstance():RecycleAllTimerIns()
	IconManager.GetInstance():ClearAllIconItemInsListState()
	AudioManager.GetInstance():StopAllNormalAudio()
end


function BaseFctManager:__delete()
	Instance=nil
end