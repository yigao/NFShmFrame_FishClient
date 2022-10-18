PlayerStartView=Class()

function PlayerStartView:ctor(gameObj)
	self:Init(gameObj)

end

function PlayerStartView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end


function PlayerStartView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Text=GameManager.GetInstance().Text
	self.Button=GameManager.GetInstance().Button
	
end



function PlayerStartView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function PlayerStartView:FindView(tf)
	self:FindPlayerStartView(tf)
end


function PlayerStartView:FindPlayerStartView(tf)
	self.StartBtn=tf:Find("Down/Start/StartBtn"):GetComponent(typeof(self.Button))
	self.StartBtnEvent=self.StartBtn.gameObject:AddComponent(typeof(CS.UIEventScript))
	self.StopBtn=tf:Find("Down/Stop/StopBtn"):GetComponent(typeof(self.Button))
	self.AutoText=tf:Find("Down/Stop/StopBtn/Text"):GetComponent(typeof(self.Text))
	self.FreePanel=tf:Find("Down/Free").gameObject
	self.FreeGameCountText=tf:Find("Down/Free/Text"):GetComponent(typeof(self.Text))
end


function PlayerStartView:InitViewData()
	self:IsShowStopBtn(false)
	self:IsShowStartBtn(true)
	self:IsShowFreePanel(false)
	self:IsShowAutoTextPanel(false)
end


function PlayerStartView:AddEventListenner()
	self.StartBtnEvent.onPressCallBack=function (isPress) self:OnclickStart(isPress) end
	self.StopBtn.onClick:AddListener(function () self:OnclickStop() end)
	
end


function PlayerStartView:OnclickStart(isPress)
	if self.StartBtn.interactable==false then  return end
	if StateManager.GetInstance():GetGameStateWaitResult() then
		Debug.LogError("状态等待中...无法点击开始游戏")
		return
	end
	
	if self.gameData.MainStation~=StateManager.MainState.Normal  then
		Debug.LogError("免费游戏中...无法点击开始游戏")
		return
	end
	
	if self.gameData.NextMainStation~=StateManager.MainState.Normal  then
		Debug.LogError("下一个状态不为普通状态...无法点击开始游戏")
		return
	end
	
	
	if isPress then
		--AudioManager.GetInstance():PlayNormalAudio(17)
		self.AutoStartTimer=TimerManager.GetInstance():CreateTimerInstance(1,self.AutoGame,self)
	else
		local remainTime=TimerManager.GetInstance():GetRemainTime(self.AutoStartTimer)
		self:ResetAutoStartTimer()
		if remainTime>0 then
			GameLogicManager.GetInstance():StartGameIconRun()
			--self:CheckStartBtnState()
			--self:IsEnableStartButton(false)
		end
		
	end
	
end

function PlayerStartView:CheckStartBtnState()
	self:IsEnableStartButton(false)
	local DelayCheckStartBtnEnabledStateFunc=function ()
		self:ResetStartBtnStateTimer()
		self:IsEnableStartButton(true)
		Debug.LogError("3s内未收到游戏结果")
	end
	self.checkStartBtnTimer=TimerManager.GetInstance():CreateTimerInstance(3,DelayCheckStartBtnEnabledStateFunc)
end


function PlayerStartView:ResetStartBtnStateTimer()
	if self.checkStartBtnTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.checkStartBtnTimer)
		self.checkStartBtnTimer=nil
	end
end

function PlayerStartView:ResetAutoStartTimer()
	if self.AutoStartTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.AutoStartTimer)
		self.AutoStartTimer=nil
	end
end


function PlayerStartView:OnclickStop()
	if self.gameData.MainStation==StateManager.MainState.FreeGame then  Debug.LogError("免费游戏中不能点击停止")  return end
	if self.gameData.IsRecieveSeverData==false then  Debug.LogError("服务端数据未收到不能点击停止")  return end
	
	self:IsShowAutoTextPanel(false)
	BaseFctManager.GetInstance():StopAutoGame()
	GameLogicManager.GetInstance():OnclickStopIconRun()

end



function PlayerStartView:IsShowStartBtn(isShow)
	CommonHelper.SetActive(self.StartBtn.gameObject,isShow)
end

function PlayerStartView:IsShowStopBtn(isShow)
	CommonHelper.SetActive(self.StopBtn.gameObject,isShow)
end


function PlayerStartView:SetStartState(isRun)
	self:IsShowStartBtn(not isRun)
	self:IsShowStopBtn(isRun)
end



function PlayerStartView:IsEnableButton(button,isEnable)
	button.interactable=isEnable
end


function PlayerStartView:IsEnableStartButton(isEnable)
	self:IsEnableButton(self.StartBtn,isEnable)
end


function PlayerStartView:IsEnableStopButton(isEnable)
	self:IsEnableButton(self.StopBtn,isEnable)
end


function PlayerStartView:AutoGame()
	BaseFctManager.GetInstance().AutoView:PlayAutoAnim(1)
end


function PlayerStartView:IsShowFreePanel(isShow)
	CommonHelper.SetActive(self.FreePanel,isShow)
end

function PlayerStartView:SetFreeGameCount(count)
	self.FreeGameCountText.text=count.."/"..self.gameData.FreeGameTotalCount
end


function PlayerStartView:IsShowAutoTextPanel(isShow)
	CommonHelper.SetActive(self.AutoText.gameObject,isShow)
end


function PlayerStartView:SetAutoCount(count)
	self.AutoText.text=count
end