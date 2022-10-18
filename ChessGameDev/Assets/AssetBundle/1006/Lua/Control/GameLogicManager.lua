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
	self.MaxBetMultiple=10
	self.MidBetMultiple=8
	self.MinBetMultiple=5
	self.stopIntervalTime=0.5
	self.IconRunSpeedLevel=4
	self.IsOnclickStop=false		--是否手动点击快速停止
	self.IsStopRun=false			--是否停止滚动
	self.currentAutoState=false		--当前自动状态
	self.IsFreeGameState=false		--是否是免费游戏状态
	self.WinBeforeSubState=1
	self.winBeforeMainState=1
end




function GameLogicManager:ResetIconRunData()
	self.IsOnclickStop=false
	self.IsStopRun=false
	self.gameData.IsIconRuning=false
	self.gameData.IsRecieveSeverData=false
	
	if not self.IsFreeGameState then
		BaseFctManager.GetInstance():SetPlayerWinScore(0,0,false)
	end
	IconManager.GetInstance():ClearAllIconItemInsListState()
	BaseFctManager.GetInstance():IsEnableBetButton(false)
	IconManager.GetInstance():IsShowIconMask(false)
	IconManager.GetInstance():IsCloseSilderTipsPanel()
end


function GameLogicManager:SetSendState()
	local chipLevel=BaseFctManager.GetInstance():GetCurrentBetChipIndex()
	local currentGameTypeIndex=0
	if self.gameData.MainStation==StateManager.MainState.FreeGame then
		currentGameTypeIndex=1
	end
	Debug.LogError("当前主游戏状态为：==>"..self.gameData.MainStation)
	GameUIManager.GetInstance():RequestGameResultMsg(chipLevel,currentGameTypeIndex)
	self:CheckSendRequestGameResult()
end


function GameLogicManager:CheckPlayerBetValid()
	if self.gameData.MainStation==StateManager.MainState.FreeGame then  return false end
	local chipValue=BaseFctManager.GetInstance():GetCurrentBetChipValue()
	if chipValue>self.gameData.PlayerMoney then
		Debug.LogError("下注值不够")
		GameManager.GetInstance():ShowUITips("下注金额不够，请充值",3)
		self.gameData.IsAutoState=false
		self:IsChangeStartBtnState()
		return true
	end
	return false
end


function GameLogicManager:CheckSendRequestGameResult()
	self:ResetAutoGameTimer()
	self.AutoGameTimer=TimerManager.GetInstance():CreateTimerInstance(3,self.CheckSendRequestGameResultCallBack,self)

end


function GameLogicManager:CheckSendRequestGameResultCallBack()
	self:SetSendState()
	Debug.LogError("自动状态下网络异常，自动连接中...")
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
	self:StartAllIconRun(self.IconRunSpeedLevel)
	AudioManager.GetInstance():PlayNormalAudio(17)
	BaseFctManager.GetInstance():IsEnableStartButton(false)
end


function GameLogicManager:ResetStartIconRunProcess()
	self:ResetAutoGameTimer()
	
end


function GameLogicManager:ResetBeforeRunStateTimer()
	BaseFctManager.GetInstance():ResetStartBtnStateTimer()
	BaseFctManager.GetInstance():SetStartState(true)
end

function GameLogicManager:ResetAutoGameTimer()
	if self.AutoGameTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.AutoGameTimer)
		self.AutoGameTimer=nil
	end
end


function GameLogicManager:RecieveGameIconResultCallBack()
	self:ResetStartIconRunProcess()
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
		if remainTime>0.1 then
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
	IconManager.GetInstance():StartSingleColumnIconRun(columnIndex,speed,true)
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


local freeIconAudioIndex={26,27,28}
--每列停止后回调
function GameLogicManager:SingleColumnIconStopRunCallBack(columnIndex)
	local tempIconResult=self.gameData.GameIconResult[columnIndex]
	self:ShowSpecialIconAnim(columnIndex,tempIconResult)
	local aduioIndex=22
	if self.gameData.FreeIconPosInfoList[columnIndex].isFree then
		if self.gameData.FreeIconPosInfoList[columnIndex].freeIndex>3 then
			self.gameData.FreeIconPosInfoList[columnIndex].freeIndex=3
		end
		aduioIndex=freeIconAudioIndex[self.gameData.FreeIconPosInfoList[columnIndex].freeIndex]
	end
	
	AudioManager.GetInstance():PlayNormalAudio(aduioIndex)
end


function GameLogicManager:ShowSpecialIconAnim(columnIndex,tempIconResult)
	for i=1,#tempIconResult do
		if tempIconResult[i]==9 then
			local tempInconIns=IconManager.GetInstance():GetSingleRunIconInsByCoordinate(columnIndex,i+1)
			if tempInconIns then
				tempInconIns:PlayShowAnim()
			end
		end
	end
end



--停止所有滚动回调
function GameLogicManager:AllIconStopRunProcess()
	self.IsStopRun=true
	self.gameData.IsIconRuning=false
	AudioManager.GetInstance():StopNormalAudio(19)
	self:IsInitStartBtnState()
	self:PrizeLineProcess()
	
end


function GameLogicManager:IsInitStartBtnState()
	if self.gameData.IsAutoState==false then
		BaseFctManager.GetInstance():SetStartState(false)
		BaseFctManager.GetInstance():IsEnableBetButton(true)
		
	end
end


function GameLogicManager:IsChangeStartBtnState()
	BaseFctManager.GetInstance():IsEnableStartButton(true)
	self:IsInitStartBtnState()
end


function GameLogicManager:PrizeLineProcess()
	self:IsShowPrizeLine()
	self:SetGameProcess()
end


function GameLogicManager:IsShowPrizeLine()
	if #self.gameData.PrizeLineResultList>0 then
		local PrizeLineLoppFunc=function ()
			self:PlayAllPrizeLine(2)
			self:LoopPlayPrizeLine(2)
		end
		startCorotine(PrizeLineLoppFunc)
	end
end


function GameLogicManager:PlayAllPrizeLine(delayTime)
	local allPrizeLineIconInsList={}
	if #self.gameData.PrizeLineResultList>0 then
		IconManager.GetInstance():IsShowIconMask(true)
	end
	for i=1,#self.gameData.PrizeLineResultList do
		local linePoints=self.gameData.PrizeLineResultList[i].linePoints
		for j=1,#linePoints do
			local LineIconIns=IconManager.GetInstance():GetSingleRunIconInsByCoordinate(linePoints[j].posX+1,linePoints[j].posY+2)
			LineIconIns:PlayBaseIconAnim()
			table.insert(allPrizeLineIconInsList,LineIconIns)
		end
	end
	yield_return(WaitForSeconds(delayTime))
	for i=1,#allPrizeLineIconInsList do
		allPrizeLineIconInsList[i]:StopPlayBaseIconAnim()
	end
	yield_return(WaitForSeconds(0.3))
end


function GameLogicManager:LoopPlayPrizeLine(dealyTime)
	while self.IsStopRun do
		for i=1,#self.gameData.PrizeLineResultList do
			if self.IsStopRun==false then return end
			local singleLineIconInsList={}
			local linePoints=self.gameData.PrizeLineResultList[i].linePoints
			for j=1,#linePoints do
				local LineIconIns=IconManager.GetInstance():GetSingleRunIconInsByCoordinate(linePoints[j].posX+1,linePoints[j].posY+2)
				LineIconIns:PlayBaseIconAnim()
				table.insert(singleLineIconInsList,LineIconIns)
			end
			
			if self.gameData.SubStation==StateManager.SubState.Normal  then
				--AudioManager.GetInstance():PlayNormalAudio(1,0.5)
			end
			yield_return(WaitForSeconds(dealyTime))
			
			for k=1,#singleLineIconInsList do
				singleLineIconInsList[k]:StopPlayBaseIconAnim()
			end
			
			yield_return(WaitForSeconds(0.3))
		end
		yield_return(WaitForSeconds(0.1))
	end
end



function GameLogicManager:SetWinBeforeState()
	self.WinBeforeSubState=self.gameData.SubStation
	self.winBeforeMainState=self.gameData.MainStation
end



function GameLogicManager:SetGameProcess()
	self:SetWinBeforeState()
	self:SetPlayerWinScore()
	
	local StartGameProcessFunc=function ()
		local IsWin=self:IsWinScoreProcess()
		if IsWin then
			Debug.LogError("等待WinState")
		else
			self:SetBaseWinScoreProcess()
			if self.gameData.PlayerWinScore>0 then
				--AudioManager.GetInstance():PlayNormalAudio(23)
				yield_return(WaitForSeconds(1))
			end
			self:ContinueStateProcess()
		end
		
	end
	startCorotine(StartGameProcessFunc)
	
end


function GameLogicManager:SetPlayerWinScore()
	BaseFctManager.GetInstance():SetPlayerMoney(self.gameData.PlayerMoney)
end


function GameLogicManager:SetBaseWinScoreProcess()
	if self.IsFreeGameState then
		BaseFctManager.GetInstance():SetPlayerWinScore(self.gameData.PlayerWinScore,0.5,true)
	else
		BaseFctManager.GetInstance():SetPlayerWinScore(self.gameData.PlayerWinScore,0.5,false)
	end
	
end


function GameLogicManager:IsWinScoreProcess()
	local currentWinIndex=0
	local showTime=0
	local isWin=true
	if self.gameData.CurrentBetMultiple>=self.MaxBetMultiple then
		currentWinIndex=3
		showTime=21
	elseif self.gameData.CurrentBetMultiple>=self.MidBetMultiple then
		currentWinIndex=2
		showTime=16
	elseif self.gameData.CurrentBetMultiple>=self.MinBetMultiple then
		currentWinIndex=1
		showTime=10
	else 
		isWin=false
		if self.gameData.CurrentBetMultiple>0 then
			WinManager.GetInstance():EnterSmallWinProcess()
		end
	end
	
	if isWin then
		StateManager.GetInstance():EnableGameState(true)
		StateManager.GetInstance():SetSubGameStation(StateManager.SubState.Win)
		WinManager.GetInstance():SetWinState(currentWinIndex,showTime,self.gameData.PlayerWinScore)
	end
	
	return isWin
end



function GameLogicManager:ContinueStateProcess()
	self:SetOtherStateProcess()
	self:IsChangeStartBtnState()
	self:AutoStartGame()
end



function GameLogicManager:SetOtherStateProcess()
	self:IsFreeGameOverProcess()
	self:IsFreeGameProcess()
end



function GameLogicManager:IsFreeGameOverProcess()
	if self.gameData.SubStation==StateManager.SubState.FreeGameOver then
		StateManager.GetInstance():EnableGameState(true)
		Debug.LogError("退出免费游戏")
		FreeGameManager.GetInstance():QuitFreeGameProcess(self.gameData.FreeGameTotalCount,self.gameData.FreeGameTotalWinScore)
	end
end


function GameLogicManager:IsFreeGameProcess()
	self:CommonChangMainStateProcess(StateManager.MainState.FreeGame)
end

function GameLogicManager:SetEnterFreeGame(msg)
	self.gameData.FreeGameTotalCount=msg.freeGameCount
	self.gameData.RemainFreeGameCount=msg.freeGameCount-msg.freeGameIndex
	--print("免费游戏剩余次数==>"..self.gameData.RemainFreeGameCount)
	self.gameData.FreeGameTotalWinScore=msg.freeGameScore
	self.gameData.FreeGameMutiple=msg.freeGameMutiple
	FreeGameManager.GetInstance():SetFreeGameMultipleCountTips(self.gameData.FreeGameMutiple)
	StateManager.GetInstance():SetGameMainStation(StateManager.MainState.FreeGame)
	StateManager.GetInstance():SetSubGameStation(StateManager.SubState.FreeGame)
	
	FreeGameManager.GetInstance():EnterFreeGameProcess(self.gameData.RemainFreeGameCount)
	
end


function GameLogicManager:GetBeforeAutoState()
	if self.IsFreeGameState==false then
		self.currentAutoState=self.gameData.IsAutoState
	end
end

function GameLogicManager:RevivificationAutoState()
	self.gameData.IsAutoState=self.currentAutoState
end


function GameLogicManager:IsBonusProcess()
	self:CommonChangMainStateProcess(StateManager.MainState.Bonus)
end


function GameLogicManager:SetEnterBouns(msg)
	StateManager.GetInstance():SetSubGameStation(StateManager.SubState.Bonus)
	BonusManager.GetInstance():EnterBonus(msg)
end



function GameLogicManager:CommonChangMainStateProcess(nextMainState)
	if self.gameData.NextMainStation==nextMainState then
		GameUIManager.GetInstance():RequestMiniGameMsg(self.gameData.NextMainStation-1)
		if GameManager.GetInstance().isGamePlaying==true then return end
		StateManager.GetInstance():EnableGameState(true)
	end
end


function GameLogicManager:EndStateCallBack()
	
	if self.gameData.SubStation==StateManager.SubState.Win then
		Debug.LogError("Win状态回调")
		StateManager.GetInstance():SetGameMainStation(self.winBeforeMainState)
		StateManager.GetInstance():SetSubGameStation(self.WinBeforeSubState)
		self:ContinueStateProcess()
		return
	elseif self.gameData.SubStation==StateManager.SubState.FreeGame then
		Debug.LogError("免费游戏状态结束回调")
		StateManager.GetInstance():SetSubGameStation(StateManager.SubState.Normal)
		self:GetBeforeAutoState()
		self.gameData.IsAutoState=true
		self.IsFreeGameState=true
	elseif self.gameData.SubStation==StateManager.SubState.FreeGameOver then
		Debug.LogError("免费游戏结束状态结束回调")
		StateManager.GetInstance():SetGameMainStation(self.gameData.NextMainStation)
		StateManager.GetInstance():SetSubGameStation(self.gameData.NextMainStation)
		self:RevivificationAutoState()
		HandselManager.GetInstance():IsShowGamePanel(true)
		BaseFctManager.GetInstance():ChangSceneAnim(1)
		BGManager.GetInstance():IsShowFreeBGPanel(false)
		self.IsFreeGameState=false
		AudioManager.GetInstance():PlayBGAudio(1,0.3)
		BaseFctManager.GetInstance():SetPlayerWinScore(0,0,false)
	end
	
	self:AutoStartGame()
end



function GameLogicManager:AutoStartGame()
	if self.gameData.IsAutoState then
		local isWaitingState=StateManager.GetInstance():GetGameStateWaitResult()
		if isWaitingState then
			Debug.LogError("状态激活中,等待状态回调")
		else
			BaseFctManager.GetInstance():AutoStartGame()
		end
	else
		BaseFctManager.GetInstance():IsEnableBetButton(true)
		self:IsChangeStartBtnState()
	end
end





function GameLogicManager:IsCanIconRunState()
	local IsRun=(not self.gameData.IsIconRuning and not StateManager.GetInstance():GetGameStateWaitResult() 
				and self.gameData.MainStation==StateManager.MainState.Normal and self.gameData.NextMainStation==StateManager.MainState.Normal 
				and not self.gameData.IsAutoState )
	Debug.LogError("当前是否能滑动滚动==>")
	Debug.LogError(IsRun)
	return IsRun
end


function GameLogicManager:GetCurrentExitState()
	local IsRun=(not self.gameData.IsIconRuning and not StateManager.GetInstance():GetGameStateWaitResult() 
				and self.gameData.MainStation==StateManager.MainState.Normal and self.gameData.NextMainStation==StateManager.MainState.Normal 
				 )
				
	return IsRun
end



function GameLogicManager:__delete()

end


