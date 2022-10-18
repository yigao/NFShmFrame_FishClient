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
	self.IconRunSpeedLevel=1.5
	self.IsOnclickStop=false		--是否手动点击快速停止
	self.IsStopRun=false			--是否停止滚动
	self.currentAutoState=false		--当前自动状态
	self.IsFreeGameState=false		--是否是免费游戏状态
	self.WinBeforeSubState=1
	self.winBeforeMainState=1
	self.midZhuanLunType={
		LSZL=1,	--老鼠转轮
		JSZL=2,	--金鼠转轮
	}
	
	self.IsAddRunSpeed=false
	self.FreeIconCount=0
end




function GameLogicManager:ResetIconRunData()
	self.IsOnclickStop=false
	self.IsStopRun=false
	self.gameData.IsIconRuning=false
	self.gameData.IsRecieveSeverData=false
	self.IsAddRunSpeed=false
	self.FreeIconCount=0
	
	self:RemoveAutoTimer()
	
	if self.gameData.MainStation==StateManager.MainState.Normal then
		BaseFctManager.GetInstance():SetPlayerWinScore(0,0,false)
	end
	IconManager.GetInstance():ClearAllIconItemInsListState()
	BaseFctManager.GetInstance():IsEnableBetButton(false)
	
	if IconManager.GetInstance():GetSelectionIconRunState(1)==false then
		IconManager.GetInstance():StartSelectionIconRun(1)
	end
	
	IconManager.GetInstance():IsCloseSilderTipsPanel()
	SpeedManager.GetInstance():HideAllSpeedEffectPanel()
end


function GameLogicManager:SetSendState()
	local chipLevel=BaseFctManager.GetInstance():GetCurrentBetChipIndex()
	local currentGameTypeIndex=0
	if self.gameData.MainStation==StateManager.MainState.FreeGame then
		currentGameTypeIndex=1
	elseif self.gameData.MainStation==StateManager.MainState.SLB then
		currentGameTypeIndex=5
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
		GameManager.GetInstance():ShowUITips("下注值不够",3)
		self.gameData.IsAutoState=false
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
	if self.gameData.MainStation==StateManager.MainState.Normal then
		local isPlaying=AudioManager.GetInstance():CheckAudioIsPlaying(1)
		if isPlaying==false then
			AudioManager.GetInstance():PlayNormalAudio(1)
		end
	end
	
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
			self.delayStopTimer:ModifyDelayTime(0)	
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


function GameLogicManager:StopGameIconRunProcess()
	
	local StopGameIconRunProcessFunc=function ()
		local beforeFreeCount=0
		for i=1,self.GameConfig.Coordinate_COL do
			local tempColumnIconResult=self.gameData.GameIconResult[i]
			if tempColumnIconResult then
				if CommonHelper.IsContainValueForDic(11,tempColumnIconResult) then
					self.FreeIconCount=self.FreeIconCount+1
				end
				
				if i>2 and beforeFreeCount>=2 then
					self.IsAddRunSpeed=true
				end

				if self.IsAddRunSpeed==false then
					yield_return(WaitForSeconds(self.stopIntervalTime))
				else
					yield_return(WaitForSeconds(0.3))
					SpeedManager.GetInstance():ShowSpeedEffectPanel(i-2,true)
					IconManager.GetInstance():SetSingleColumnIconSpeedRun(i,8)
					AudioManager.GetInstance():PlayNormalAudio(49)
					yield_return(WaitForSeconds(1.5))
				end
				
				self:StopSingleColumnIconRun(i,tempColumnIconResult)
				beforeFreeCount=self.FreeIconCount
				--yield_return(WaitForSeconds(0.2))
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
	local tempIconResult=self.gameData.GameIconResult[columnIndex]
	self:ShowSpecialIconAnim(columnIndex,tempIconResult)
	local aduioIndex=12
	for i=1,#tempIconResult do
		if tempIconResult[i]==12 then
			aduioIndex=11
		elseif tempIconResult[i]==11 then
			aduioIndex=(3+columnIndex)
		end
	end
	
	AudioManager.GetInstance():PlayNormalAudio(aduioIndex)
	
end

function GameLogicManager:ShowSpecialIconAnim(columnIndex,tempIconResult)
	for i=1,#tempIconResult do
		if tempIconResult[i]==12 or tempIconResult[i]==11 then
			local tempInconIns=IconManager.GetInstance():GetSingleRunIconInsByCoordinate(columnIndex,i+1)
			if tempInconIns then
				tempInconIns:PlayShowAnim()
				tempInconIns:PlayTextAnim()
			end
		end
	end
end



--停止所有滚动回调
function GameLogicManager:AllIconStopRunProcess()
	SpeedManager.GetInstance():HideAllSpeedEffectPanel()
	local IconStopRunProcessFunc=function ()
		self:ChangeWilIcon()
		--self:SetSLBGameMaskIcon()
		local isZL=self:IsMidZhuanLunState()
		if isZL==false then
			self:GameEndProcess()
		else
			Debug.LogError("等待转轮状态")
		end
		
	end
	startCorotine(IconStopRunProcessFunc)
	
	
end


function GameLogicManager:SetSLBGameMaskIcon()
	if self.gameData.SLBMiniGameIconMaskStateList  then
		local count=#self.gameData.SLBMiniGameIconMaskStateList
		if count>0 then
			for i=1,count do
				
			end
		else
			Debug.LogError("SLBGameMaskIcon结果异常")
		end
	end
	
end


function GameLogicManager:ChangeWilIcon()
	if self.gameData.WildStateList and #self.gameData.WildStateList>0 then
		
		local changWildList=self:CaculateChangeWild()
		--pt(changWildList)
		if changWildList then
			self:ChangAllWildIcon(changWildList)
		end
		
	end
	
end


function GameLogicManager:CaculateChangeWild()
	local changWildList={}
	for k,v in pairs(self.gameData.WildStateList) do
		if v then
			for i=2,5 do
				local isExit=false
				for j=1,#v.IconNumList do
					if i==v.IconNumList[j] then
						isExit=true
					end
				end
				if isExit==false then
					local tempList={}
					tempList.columnIndex=v.Colmun
					tempList.rowIndex=i
					table.insert(changWildList,tempList)
					
				end
			end
		end
	end
	return changWildList
end


function GameLogicManager:ChangAllWildIcon(changWildList)
	if #changWildList>0 then
		yield_return(WaitForSeconds(0.2))
		local tempParticleList={}
		for i=1,#changWildList do
			local wildEffect=ParticleManager.GetInstance():GetAllocateEffect("WildEffect")
			if wildEffect then
				table.insert(tempParticleList,wildEffect)
			end
			local MountPoint=IconManager.GetInstance():GetAllocateIconCInsMountPoint(changWildList[i].columnIndex,changWildList[i].rowIndex)
			if MountPoint then
				wildEffect.transform.position=CSScript.Vector3(MountPoint.transform.position.x,MountPoint.transform.position.y,0)
			else
				Debug.LogError("获取MountPoint失败")
			end
		end
		yield_return(WaitForSeconds(0.2))
		for i=1,#changWildList do
			IconManager.GetInstance():ChangeAllocateIconIns(changWildList[i].columnIndex,changWildList[i].rowIndex,10)
		end
		
		for i=1,#tempParticleList do
			ParticleManager.GetInstance():RecycleEffect(tempParticleList[i])
		end
		yield_return(WaitForSeconds(0.2))
	end
end



function GameLogicManager:IsMidZhuanLunState()
	if self.gameData.midZhuanLunData then
		local selectionIndex=1
		local selectionAudioIndex=0
		if self.gameData.midZhuanLunData.WheelType==self.midZhuanLunType.LSZL then
			selectionIndex=1
			selectionAudioIndex=35
		elseif self.gameData.midZhuanLunData.WheelType==self.midZhuanLunType.JSZL then
			selectionIndex=2
			selectionAudioIndex=36
		else
			Debug.LogError("WheelType异常==>")
			selectionIndex=0
		end
		AudioManager.GetInstance():PlayNormalAudio(37)
		self.MidZLIns=IconManager.GetInstance():GetSingleRunIconInsByCoordinate(self.gameData.midZhuanLunData.PrizePos.posX+1,self.gameData.midZhuanLunData.PrizePos.posY+2)
		self.MidZLIns:PlayBaseIconAnim()
		self.MidZLIns:PlayWinAnim("Item13_1")
		yield_return(WaitForSeconds(0.6))
		AudioManager.GetInstance():PlayNormalAudio(selectionAudioIndex,1,true)
		IconManager.GetInstance():StartSelectionIconRun(selectionIndex,1)
		yield_return(WaitForSeconds(2))
		IconManager.GetInstance():StopSelectionIconRun(selectionIndex,self.gameData.midZhuanLunData.PrizeIndex)
		return true
	end
	return false
end


function GameLogicManager:MidZhuanLunCallBack()
	self.MidZLIns:PlayWinAnim("Item13_1_1")
	if self.gameData.midZhuanLunData then
		local DelayPlayMidZhuanLunFun=function ()
			AudioManager.GetInstance():PlayNormalAudio(23)
			TimerManager.GetInstance():RecycleTimerIns(self.ZhuanLunTimer)
			local changeBianBaoIcon=IconManager.GetInstance():ChangeAllocateIconIns(self.gameData.midZhuanLunData.PrizePos.posX+1,self.gameData.midZhuanLunData.PrizePos.posY+2,12)
			if changeBianBaoIcon then
				local value=0
				if self.gameData.midZhuanLunData.PrizeIndex<7 then
					value=self.gameData.midZhuanLunData.PrizeValue
				else
					value=self.gameData.midZhuanLunData.PrizeIndex
				end
				local MountPoint=IconManager.GetInstance():GetAllocateIconCInsMountPoint(self.gameData.midZhuanLunData.PrizePos.posX+1,self.gameData.midZhuanLunData.PrizePos.posY+2)
				if MountPoint then
					local wildEffect=ParticleManager.GetInstance():GetAllocateEffect("WildEffect")
					wildEffect.transform.position=CSScript.Vector3(MountPoint.transform.position.x,MountPoint.transform.position.y,0)
					local DelayRecycleEffectFunc=function ()
						TimerManager.GetInstance():RecycleTimerIns(self.WildEffectTime)
						ParticleManager.GetInstance():RecycleEffect(wildEffect)
						self:GameEndProcess()
					end
					self.WildEffectTime=TimerManager.GetInstance():CreateTimerInstance(0.5,DelayRecycleEffectFunc)
				end
				IconManager.GetInstance():SetBianPaoIconValue(value,changeBianBaoIcon)
				
			end
			
		end
		self.ZhuanLunTimer=TimerManager.GetInstance():CreateTimerInstance(0.5,DelayPlayMidZhuanLunFun)
	end
	
end


function GameLogicManager:SetSLBChangeMidMaskIcon()
	if self.gameData.MainStation==StateManager.MainState.SLB or self.gameData.NextMainStation==StateManager.MainState.SLB then
		if self.gameData.midZhuanLunData then
			local value=0
			if self.gameData.midZhuanLunData.PrizeIndex<7 then
				value=self.gameData.midZhuanLunData.PrizeValue
			else
				value=self.gameData.midZhuanLunData.PrizeIndex
			end
			IconManager.GetInstance():ChangeAllocateIconMaskInsIcon(self.gameData.midZhuanLunData.PrizePos.posX+1,self.gameData.midZhuanLunData.PrizePos.posY+2,12,value)
		end	
	end
end


function GameLogicManager:SetSLBNormalIconChangeMask()
	if self.gameData.MainStation==StateManager.MainState.SLB or self.gameData.NextMainStation==StateManager.MainState.SLB then
		if self.gameData.SLBMiniGameIconMaskStateList then
			for k,v in pairs(self.gameData.SLBMiniGameIconMaskStateList) do
				local xPos=v.posX+1
				local yPos=v.posY+2
				local iconValue=self.gameData.GameIconResult[5+xPos][yPos-1]
				IconManager.GetInstance():ChangeAllocateIconMaskInsIcon(xPos,yPos,12,iconValue)
			end
		end
	end
end


function GameLogicManager:SetSLBChangeMaskIconProcess()
	self:SetSLBChangeMidMaskIcon()
	self:SetSLBNormalIconChangeMask()
end




function GameLogicManager:GameEndProcess()
	self:SetSLBChangeMaskIconProcess()
	
	self.IsStopRun=true
	self.gameData.IsIconRuning=false
	self:IsChangeStartBtnState()
	self:PrizeLineProcess()
end




function GameLogicManager:IsChangeStartBtnState()
	BaseFctManager.GetInstance():IsEnableStartButton(true)
	if self.gameData.IsAutoState==false then
		BaseFctManager.GetInstance():SetStartState(false)
		BaseFctManager.GetInstance():IsEnableBetButton(true)
		
	end
end


function GameLogicManager:PrizeLineProcess()
	self:IsShowPrizeLine()
	self:SetGameProcess()
	BaseFctManager.GetInstance():SetPlayerMoney(self.gameData.PlayerMoney)
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
	if self.gameData.CurrentBetMultiple>=self.MinBetMultiple then  return end
	AudioManager.GetInstance():PlayNormalAudio(16)
	local allPrizeLineIconInsList={}
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
	if self.gameData.CurrentBetMultiple>=self.MinBetMultiple then yield_return(WaitForSeconds(1)) end
	
	if self.gameData.NextMainStation==StateManager.MainState.FreeGame then return end
	while self.IsStopRun do
		for i=1,#self.gameData.PrizeLineResultList do
			--if StateManager.GetInstance():GetGameStateWaitResult()==false then
				if self.IsStopRun==false then return end
				local singleLineIconInsList={}
				local linePoints=self.gameData.PrizeLineResultList[i].linePoints
				for j=1,#linePoints do
					local LineIconIns=IconManager.GetInstance():GetSingleRunIconInsByCoordinate(linePoints[j].posX+1,linePoints[j].posY+2)
					LineIconIns:PlayBaseIconAnim()
					table.insert(singleLineIconInsList,LineIconIns)
				end
				yield_return(WaitForSeconds(dealyTime))
				for k=1,#singleLineIconInsList do
					singleLineIconInsList[k]:StopPlayBaseIconAnim()
				end
			--end
			
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
	
	local StartGameProcessFunc=function ()
		
		self:SetWinBeforeState()
		
		local IsWin=self:IsWinScoreProcess()
		if IsWin then
			Debug.LogError("等待WinState")
		else
			self:SetBaseWinScoreProcess()
			if self.gameData.PlayerWinScore>0 then
				yield_return(WaitForSeconds(1.5))
			end
			self:ContinueStateProcess()
		end
		
		
	end
	startCorotine(StartGameProcessFunc)
	
end


function GameLogicManager:SetBaseWinScoreProcess()
	if self.gameData.MainStation==StateManager.MainState.Normal then
		BaseFctManager.GetInstance():SetPlayerWinScore(self.gameData.PlayerWinScore,0.5,false)
	else
		BaseFctManager.GetInstance():SetPlayerWinScore(self.gameData.PlayerWinScore,0.5,true)
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
	local DelayContinueAutoStartFunc=function ()
		self:RemoveAutoTimer()
		self:AutoStartGame()
	end
	self.DelayAutoTimer=TimerManager.GetInstance():CreateTimerInstance(0.5,DelayContinueAutoStartFunc)
end


function GameLogicManager:RemoveAutoTimer()
	if self.DelayAutoTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.DelayAutoTimer)
		self.DelayAutoTimer=nil
	end
end



function GameLogicManager:SetOtherStateProcess()
	self:IsFreeGameOverProcess()
	self:IsFreeGameProcess()
	self:IsSLBOverProcess()
	self:IsSLBProcess()
end



function GameLogicManager:IsFreeGameOverProcess()
	if self.gameData.SubStation==StateManager.SubState.FreeGameOver then
		StateManager.GetInstance():EnableGameState(true)
		Debug.LogError("退出免费游戏")
		FreeGameManager.GetInstance():QuitFreeGameProcess(self.gameData.FreeGameTotalCount,self.gameData.FreeGameTotalWinScore)
	end
end



function GameLogicManager:IsSLBOverProcess()
	if self.gameData.SubStation==StateManager.SubState.SLBOver then
		StateManager.GetInstance():EnableGameState(true)
		Debug.LogError("退出SLB游戏")
		IconManager.GetInstance():IsShowAllIconMask(false)
		SLBManager.GetInstance():QuitSLBProcess(self.gameData.FreeGameTotalWinScore)
	end
end


function GameLogicManager:IsFreeGameProcess()
	self:CommonChangMainStateProcess(StateManager.MainState.FreeGame)
end

function GameLogicManager:SetEnterFreeGame(msg)
	BaseFctManager.GetInstance():SetPlayerWinScore(0,0,false)
	self.gameData.FreeGameTotalCount=msg.freeGameCount
	self.gameData.RemainFreeGameCount=msg.freeGameCount-msg.freeGameIndex
	--print("免费游戏剩余次数==>"..self.gameData.RemainFreeGameCount)
	self.gameData.FreeGameTotalWinScore=msg.freeGameScore
	StateManager.GetInstance():SetGameMainStation(StateManager.MainState.FreeGame)
	StateManager.GetInstance():SetSubGameStation(StateManager.SubState.FreeGame)
	BaseFctManager.GetInstance():ResetAddScoreState(self.gameData.FreeGameTotalWinScore)
	if GameManager.GetInstance().isGamePlaying==true then
		GameManager.GetInstance().isGamePlaying=false
		return
	end
	
	self:GetBeforeAutoState()
	
	local SetEnterFreeGameIconTipsProcessFunc=function ()
		local tempIconInsList=IconManager.GetInstance():GetAllocateIconInsByIconValue(11)
		if tempIconInsList and #tempIconInsList>=3 then
			for i=1,#tempIconInsList do
				tempIconInsList[i]:PlayWinAnim("Item11_1")
			end
			AudioManager.GetInstance():PlayNormalAudio(15)
			yield_return(WaitForSeconds(1.9))
			AudioManager.GetInstance():PlayNormalAudio(45)
			yield_return(WaitForSeconds(1.5))
		end
		FreeGameManager.GetInstance():EnterFreeGameProcess(self.gameData.RemainFreeGameCount)
	end
	startCorotine(SetEnterFreeGameIconTipsProcessFunc)
	
	
end


function GameLogicManager:GetBeforeAutoState()
	if self.IsFreeGameState==false then
		self.currentAutoState=self.gameData.IsAutoState
	end
end

function GameLogicManager:RevivificationAutoState()
	self.gameData.IsAutoState=self.currentAutoState
end


function GameLogicManager:IsSLBProcess()
	self:CommonChangMainStateProcess(StateManager.MainState.SLB)
end


function GameLogicManager:SetEnterSLB(msg)
	StateManager.GetInstance():SetGameMainStation(StateManager.MainState.SLB)
	StateManager.GetInstance():SetSubGameStation(StateManager.SubState.SLB)
	self.gameData.FreeGameTotalCount=msg.ShuLaiBaoGameCount
	self.gameData.RemainFreeGameCount=msg.ShuLaiBaoGameCount-msg.ShuLaiBaoGameIndex
	print("SLB免费游戏剩余次数==>"..self.gameData.RemainFreeGameCount)
	self.gameData.FreeGameTotalWinScore=msg.ShuLaiBaoGameScore
	if GameManager.GetInstance().isGamePlaying==true then
		GameManager.GetInstance().isGamePlaying=false
		BaseFctManager.GetInstance():ResetAddScoreState(self.gameData.FreeGameTotalWinScore)
		return
	end
	self:GetBeforeAutoState()
	SLBManager.GetInstance():EnterSLBProcess(self.gameData.RemainFreeGameCount,self.gameData.FreeGameTotalCount)
end



function GameLogicManager:CommonChangMainStateProcess(nextMainState)
	if self.gameData.NextMainStation==nextMainState then
		GameUIManager.GetInstance():RequestMiniGameMsg(self.gameData.NextMainStation)
		
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
		self.gameData.IsAutoState=true
		self.IsFreeGameState=true
		AudioManager.GetInstance():PlayBGAudio(2)
		--BaseFctManager.GetInstance():SetPlayerWinScore(0,0,false)
	elseif self.gameData.SubStation==StateManager.SubState.FreeGameOver then
		Debug.LogError("免费游戏结束状态结束回调")
		StateManager.GetInstance():SetGameMainStation(self.gameData.NextMainStation)
		StateManager.GetInstance():SetSubGameStation(self.gameData.NextMainStation+1)
		self:RevivificationAutoState()
		self.IsFreeGameState=false
		BaseFctManager.GetInstance():IsShowFreeGameBtn(false)
		--AudioManager.GetInstance():PlayBGAudio(1,0.2)
		AudioManager.GetInstance():StopBgMusic()
		BaseFctManager.GetInstance():SetPlayerWinScore(0,0,false)
		if IconManager.GetInstance():GetSelectionIconRunState(1)==false then
			IconManager.GetInstance():StartSelectionIconRun(1)
		end
	elseif self.gameData.SubStation==StateManager.SubState.SLB then
		Debug.LogError("SLB状态结束回调")
		StateManager.GetInstance():SetSubGameStation(StateManager.SubState.SLB)
		self.gameData.IsAutoState=true
		
		AudioManager.GetInstance():PlayBGAudio(3)
	elseif self.gameData.SubStation==StateManager.SubState.SLBOver then
		Debug.LogError("SLB结束回调")
		StateManager.GetInstance():SetGameMainStation(self.gameData.NextMainStation)
		StateManager.GetInstance():SetSubGameStation(self.gameData.NextMainStation+1)
		self:RevivificationAutoState()
		BaseFctManager.GetInstance():IsShowSpineBtn(false)
		if IconManager.GetInstance():GetSelectionIconRunState(1)==false then
			IconManager.GetInstance():StartSelectionIconRun(1)
		end
		--AudioManager.GetInstance():PlayBGAudio(1,0.2)
		AudioManager.GetInstance():StopBgMusic()
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


