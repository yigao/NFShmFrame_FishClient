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
	self.winBeforeMainState=1
	self.IsPlayWinScoreAudio=false
end




function GameLogicManager:ResetIconRunData()
	self.IsOnclickStop=false
	self.IsStopRun=false
	self.gameData.IsIconRuning=false
	self.gameData.IsRecieveSeverData=false
	self.IsPlayWinScoreAudio=true
	
	LineManager.GetInstance():HideAllLine()
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
	AudioManager.GetInstance():PlayNormalAudio(24)
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
	AudioManager.GetInstance():PlayNormalAudio(25)
	
end



--停止所有滚动回调
function GameLogicManager:AllIconStopRunProcess()
	self.IsStopRun=true
	self.gameData.IsIconRuning=false
	AudioManager.GetInstance():StopNormalAudio(24)
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
	--IconManager.GetInstance():IsChangAllIconItemColor(true)
	if #self.gameData.PrizeLineResultList>0 then
		local PrizeLineLoppFunc=function ()
			self:PlayAllPrizeLine(2.2)
			self:LoopPlayPrizeLine(2.2)
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
		LineManager.GetInstance():SelectShowLine(self.gameData.PrizeLineResultList[i].lineId+1,true)
	end
	yield_return(WaitForSeconds(delayTime))
	for i=1,#allPrizeLineIconInsList do
		allPrizeLineIconInsList[i]:StopPlayBaseIconAnim()
	end
	LineManager.GetInstance():HideAllLine()
	yield_return(WaitForSeconds(0.3))
end

local IconAudioList={22,39,18,28,27,41,42,50,40}
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
			
			LineManager.GetInstance():SelectShowLine(self.gameData.PrizeLineResultList[i].lineId+1,true)
			if self.gameData.SubStation==StateManager.SubState.Normal  then
				AudioManager.GetInstance():PlayNormalAudio(IconAudioList[self.gameData.PrizeLineResultList[i].winIconId+1],0.5)
			end
			yield_return(WaitForSeconds(dealyTime))
			LineManager.GetInstance():SelectShowLine(self.gameData.PrizeLineResultList[i].lineId+1,false)
			if self.gameData.SubStation==StateManager.SubState.Normal  then
				AudioManager.GetInstance():StopNormalAudio(IconAudioList[self.gameData.PrizeLineResultList[i].winIconId+1])
			end
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
	local StartGameProcessFunc=function ()
		if self.gameData.PlayerWinScore>0 then
			yield_return(WaitForSeconds(2.2))
			self:SetBaseWinScoreProcess()
		else
			self:ContinueStateProcess()
		end
		
	end
	startCorotine(StartGameProcessFunc)
	
end


function GameLogicManager:SetBaseWinScoreProcess()
	local WinScoreCallBack=function ()
		self:ContinueStateProcess()
	end
	self.IsPlayWinScoreAudio=false
	EarningsManager.GetInstance():SetEarningsWinScoreProcess(self.gameData.PlayerWinScore,0.2,WinScoreCallBack)
end


function GameLogicManager:IsWinScoreProcess()
	local currentWinIndex=0
	local showTime=0
	local isWin=true
	if self.gameData.CurrentBetMultiple>=self.MaxBetMultiple then
		currentWinIndex=4
		showTime=1.5
	elseif self.gameData.CurrentBetMultiple>=self.MidBetMultiple then
		currentWinIndex=3
		showTime=1.5
	elseif self.gameData.CurrentBetMultiple>=self.MinBetMultiple then
		currentWinIndex=2
		showTime=1.5
	elseif self.gameData.CurrentBetMultiple>0 then
		currentWinIndex=1
		showTime=1.5
	else
		isWin=false
	end
	
	if isWin then
		StateManager.GetInstance():EnableGameState(true)
		StateManager.GetInstance():SetSubGameStation(StateManager.SubState.Win)
		--WinManager.GetInstance():SetWinState(currentWinIndex,showTime,self.gameData.PlayerWinScore)
	end
	
	return isWin
end



function GameLogicManager:ContinueStateProcess()
	self:SetOtherStateProcess()
	self:IsChangeStartBtnState()
	self:AutoStartGame()
end



function GameLogicManager:SetOtherStateProcess()
	--self:IsFreeGameOverProcess()
	--self:IsFreeGameProcess()
	self:IsBonusProcess()
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
	StateManager.GetInstance():SetGameMainStation(StateManager.MainState.FreeGame)
	StateManager.GetInstance():SetSubGameStation(StateManager.SubState.FreeGame)
	self:GetBeforeAutoState()
	AudioManager.GetInstance():PlayNormalAudio(12)
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
		self.IsPlayWinScoreAudio=false
		GameUIManager.GetInstance():RequestMiniGameMsg(self.gameData.NextMainStation-1)
		if GameManager.GetInstance().isGamePlaying==true then return end
		StateManager.GetInstance():EnableGameState(true)
	end
end


function GameLogicManager:EndStateCallBack()
	
	if self.gameData.SubStation==StateManager.SubState.Guess then
		Debug.LogError("Guess状态回调")
		StateManager.GetInstance():SetGameMainStation(self.winBeforeMainState)
		StateManager.GetInstance():SetSubGameStation(self.WinBeforeSubState)
		self:ContinueStateProcess()
		AudioManager.GetInstance():PlayBGAudio(12,0.3)
		self.IsPlayWinScoreAudio=true
		return
	elseif self.gameData.SubStation==StateManager.SubState.FreeGame then
		Debug.LogError("免费游戏状态结束回调")
		StateManager.GetInstance():SetSubGameStation(StateManager.SubState.Normal)
		self.gameData.IsAutoState=true
		self.IsFreeGameState=true
--		AudioManager.GetInstance():PlayBGAudio(2)
		--BaseFctManager.GetInstance():SetPlayerWinScore(0,0,false)
	elseif self.gameData.SubStation==StateManager.SubState.FreeGameOver then
		Debug.LogError("免费游戏结束状态结束回调")
		StateManager.GetInstance():SetGameMainStation(self.gameData.NextMainStation)
		StateManager.GetInstance():SetSubGameStation(self.gameData.NextMainStation)
		self:RevivificationAutoState()
		self.IsFreeGameState=false
		BaseFctManager.GetInstance():IsShowFreeGameCount(false)
--		AudioManager.GetInstance():PlayBGAudio(1)
		--BaseFctManager.GetInstance():SetPlayerWinScore(0,0,false)
	elseif self.gameData.SubStation==StateManager.SubState.Bonus then
		Debug.LogError("bonus结束回调")
		StateManager.GetInstance():SetGameMainStation(self.gameData.NextMainStation)
		StateManager.GetInstance():SetSubGameStation(self.gameData.NextMainStation)
		AudioManager.GetInstance():PlayBGAudio(12,0.3)
		self.IsPlayWinScoreAudio=true
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


