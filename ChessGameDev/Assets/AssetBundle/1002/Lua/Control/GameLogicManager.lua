GameLogicManager=Class()

local Instance=nil
function GameLogicManager:ctor()
	Instance=self
	self:Init()
end

function GameLogicManager.GetInstance()
	return Instance
end



function GameLogicManager:Init()
	self:InitData()
	
end




function GameLogicManager:InitData()
	self.GameConfig=GameManager.GetInstance().GameConfig
	self.gameData=GameManager.GetInstance().gameData
	self.MaxBetMultiple=3000
	self.MidBetMultiple=20
	self.MinBetMultiple=10
	self.stopIntervalTime=0.5
	self.IconRunSpeedLevel=4
	self.IsOnclickStop=false		--是否手动点击快速停止
	self.IsStopRun=false			--是否停止滚动
	self.currentAutoState=false		--当前自动状态
	self.IsFreeGameState=false		--是否是免费游戏状态
	self.WinBeforeSubState=1
end




function GameLogicManager:ResetIconRunData()
	self.IsOnclickStop=false
	self.IsStopRun=false
	self.gameData.IsIconRuning=false
	self.gameData.IsRecieveSeverData=false
	
	IconManager.GetInstance():ClearAllIconItemInsListState()
	BaseFctManager.GetInstance():IsEnableBetButton(false)
	BaseFctManager.GetInstance():IsShowButtonEffect(false)
	
end


function GameLogicManager:SetSendState()
	local chipLevel=BaseFctManager.GetInstance():GetCurrentBetChipIndex()
	Debug.LogError("当前主游戏状态为：==>"..self.gameData.MainStation)
	GameUIManager.GetInstance():RequestGameResultMsg(chipLevel)
	self:CheckSendRequestGameResult()
end

function GameLogicManager:CheckPlayerBetValid()
	if self.gameData.MainStation==StateManager.MainState.Bonus then  return false end
	local chipValue=BaseFctManager.GetInstance():GetCurrentBetChipValue()
	if chipValue>self.gameData.PlayerMoney then
		Debug.LogError("下注值不够")
		GameManager.GetInstance():ShowUITips("下注金额不够，请充值",3)
		self:IsChangeStartBtnState()
		return true
	end
	return false
end


function GameLogicManager:CheckSendRequestGameResult()
	self:ResetAutoGameTimer()
	self.AutoGameTimer=TimerManager.GetInstance():CreateTimerInstance(5,self.CheckSendRequestGameResultCallBack,self)

end


function GameLogicManager:CheckSendRequestGameResultCallBack()
	GameManager.GetInstance():ShowUITips("网络异常，请检查网络！",2)
	BaseFctManager.GetInstance():IsEnableStartButton(true)
	self.gameData.IsIconRuning=false
end


function GameLogicManager:StartGameIconRun()
	if self:CheckPlayerBetValid() then  return 	end
	StopAllCorotines()
	self:ResetIconRunData()
	self:SetSendState()
	self:SetStart()
	self:ResetBeforeRunStateTimer()
end


function GameLogicManager:SetStart()
	self.gameData.IsIconRuning=true
	--self:StartAllIconRun(self.IconRunSpeedLevel)
	BaseFctManager.GetInstance():IsEnableStartButton(false)
	BaseFctManager.GetInstance():IsEnableRecieveButton(false)
	
end


function GameLogicManager:ResetStartIconRunProcess()
	self:ResetAutoGameTimer()
	
end


function GameLogicManager:ResetBeforeRunStateTimer()
	BaseFctManager.GetInstance():ResetStartBtnStateTimer()
	
end

function GameLogicManager:ResetAutoGameTimer()
	if self.AutoGameTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.AutoGameTimer)
		self.AutoGameTimer=nil
	end
end


function GameLogicManager:RecieveGameIconResultCallBack()
	self:ResetStartIconRunProcess()
	self:StartAllIconRun(self.IconRunSpeedLevel)
	AudioManager.GetInstance():PlayNormalAudio(14)
	self:AutoStopIconRun()
	self.gameData.IsRecieveSeverData=true
end


function GameLogicManager:AutoStopIconRun()
	local delayStopTime=1
	if self.gameData.IsQuickState then
		delayStopTime=0.5
	end
	self.delayStopTimer=TimerManager.GetInstance():CreateTimerInstance(delayStopTime,self.StopGame,self)
end



function GameLogicManager:OnclickStopIconRun()
	self.IsOnclickStop=true
	self:SetStopIntervalTime(0.01)
	if self.delayStopTimer then
		local remainTime=self.delayStopTimer:GetRemainTime()
		if remainTime>0.2 then
			self.delayStopTimer:ModifyDelayTime(0.02)	
		end
	end
end


function GameLogicManager:StopGame()
	TimerManager.GetInstance():RecycleTimerIns(self.delayStopTimer)
	self.delayStopTimer=nil
	if self.gameData.IsQuickState or self.IsOnclickStop then
		self:SetStopIntervalTime(0.02)
	else
		self:SetStopIntervalTime(0.3)
	end
	self:StopGameIconRunProcess()
end

function GameLogicManager:SetStopIntervalTime(value)
	self.stopIntervalTime=value
end



function GameLogicManager:StartAllIconRun(speed)
	for i=1,self.GameConfig.Coordinate_COL do
		self:StartSingleColumnIconRun(i,speed)
	end
end


function GameLogicManager:StartSingleColumnIconRun(columnIndex,speed)
	IconManager.GetInstance():StartSingleColumnIconRun(columnIndex,speed)
end



function GameLogicManager:StopGameIconRunProcess()
	
	local StopGameIconRunProcessFunc=function ()
		for i=1,self.GameConfig.Coordinate_COL do
			local tempColumnIconResult=self.gameData.GameIconResult[i]
			if tempColumnIconResult then
				self:StopSingleColumnIconRun(i,tempColumnIconResult)
				yield_return(WaitForSeconds(self.stopIntervalTime))
				
			else
				Debug.LogError("停止滚动时游戏结果获取失败==>"..i)
			end
			
		end
		
	end
	startCorotine(StopGameIconRunProcessFunc)
end

function GameLogicManager:StopSingleColumnIconRun(columnIndex,iconResultList)
	IconManager.GetInstance():StopSingleCoumnIconRun(columnIndex,iconResultList)
end


--每列停止后回调
function GameLogicManager:SingleColumnIconStopRunCallBack(columnIndex)
	--AudioManager.GetInstance():PlayNormalAudio(6)
	
end



--停止所有滚动回调
function GameLogicManager:AllIconStopRunProcess()
	self.IsStopRun=true
	self.gameData.IsIconRuning=false
	
	self:PlayEndAudio()
	self:PrizeLineProcess()
	
end


function GameLogicManager:PlayEndAudio()
	local audioIndex=6
	if self.gameData.IsBang then
		audioIndex=CommonHelper.GetRandom(19,21)
	elseif self.gameData.GameIconResult[1][1]<=6 then
		audioIndex=CommonHelper.GetRandom(3,5)
	elseif self.gameData.GameIconResult[1][1]>=9 then
		audioIndex=CommonHelper.GetRandom(22,24)
	elseif self.gameData.GameIconResult[1][1] ==8 then
		audioIndex=25
	end

	AudioManager.GetInstance():PlayNormalAudio(audioIndex)
end

function GameLogicManager:IsChangeStartBtnState()
	BaseFctManager.GetInstance():IsEnableStartButton(true)
	BaseFctManager.GetInstance():IsEnableBetButton(true)
	if self.gameData.AddPlayerWinScore>0 then
		BaseFctManager.GetInstance():IsEnableRecieveButton(true)
		BaseFctManager.GetInstance():IsShowRecieveBtnEffect(true)
		BaseFctManager.GetInstance():IsShowPlayerWinScoreEffect(true)
	end
	BaseFctManager.GetInstance():IsShowStartBtnEffect(true)
end


function GameLogicManager:PrizeLineProcess()
	self:SetGameProcess()
end




function GameLogicManager:SetWinBeforeState()
	self.WinBeforeSubState=self.gameData.SubStation
end



function GameLogicManager:SetGameProcess()
	
	local StartGameProcessFunc=function ()
		self:SetWinBeforeState()
		self:SetBaseWinScoreProcess()
		self:ContinueStateProcess()
		
	end
	startCorotine(StartGameProcessFunc)
	
end


function GameLogicManager:SetBaseWinScoreProcess()
	IconManager.GetInstance():GetSingleRunIconInsByCoordinate(1,2):PlayBaseIconAnim()
	if self.gameData.PlayerWinScore>0 then
		BaseFctManager.GetInstance():SetPlayerWinScore(self.gameData.PlayerWinScore,0.5,true)
		yield_return(WaitForSeconds(1.5))
	end
	
	if self.gameData.IsBang then
		BaseFctManager.GetInstance():ClearWinScore()
	end
end



function GameLogicManager:ContinueStateProcess()
	if self.gameData.MainStation==StateManager.MainState.Bonus then
		local BonusCallBackFunc=function ()
			self:StartGameIconRun()
		end
		BaseFctManager.GetInstance():SetBonusProcess(BonusCallBackFunc)
	elseif self.gameData.MainStation==StateManager.MainState.Jackpot then
		local JackpotCallBackFunc=function ()
			self:IsChangeStartBtnState()
			self.gameData.MainStation=StateManager.MainState.Normal
		end
		BaseFctManager.GetInstance():SetJackpotProcess(self.gameData.PlayerWinScore,JackpotCallBackFunc)
	else
		self:IsChangeStartBtnState()
	end
	
	
end






function GameLogicManager:GetCurrentExitState()
	local IsRun=(not self.gameData.IsIconRuning and not StateManager.GetInstance():GetGameStateWaitResult() 
				and self.gameData.MainStation==StateManager.MainState.Normal and self.gameData.NextMainStation==StateManager.MainState.Normal 
				 and self.gameData.AddPlayerWinScore<=0 )
				
	return IsRun
end



function GameLogicManager:__delete()

end


