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
	self.DOTween = GameManager.GetInstance().DOTween
	self.Ease =GameManager.GetInstance().Ease
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
	self.IconMultiple=0				--步步高中每个图标累加值
end




function GameLogicManager:ResetIconRunData()
	self.IsOnclickStop=false
	self.IsStopRun=false
	self.gameData.IsIconRuning=false
	self.gameData.IsRecieveSeverData=false

	if not self.IsFreeGameState then
		BaseFctManager.GetInstance():SetPlayerWinScore(0,0,false)
	end
	
	BaseFctManager.GetInstance():IsEnableBetButton(false)
	IconManager.GetInstance():ClearAllIconItemInsListState()
end


function GameLogicManager:SetSendState()
	local chipLevel=BaseFctManager.GetInstance():GetCurrentBetChipIndex()
	Debug.LogError("当前下注值==>"..chipLevel)
	local currentGameTypeIndex=0
	if self.gameData.MainStation==StateManager.MainState.FreeGame  then
		currentGameTypeIndex=7
	elseif self.gameData.MainStation==StateManager.MainState.BBG then
		currentGameTypeIndex=8
	end
	Debug.LogError("当前主游戏状态为：==>"..self.gameData.MainStation)
	GameUIManager.GetInstance():RequestGameResultMsg(chipLevel,currentGameTypeIndex)
	self:CheckSendRequestGameResult()
end

function GameLogicManager:CheckPlayerBetValid()
	if self.gameData.MainStation==StateManager.MainState.Normal then 
		local chipValue=BaseFctManager.GetInstance():GetCurrentBetChipValue()
		if chipValue>self.gameData.PlayerMoney then
			Debug.LogError("下注值不够")
			GameManager.GetInstance():ShowUITips("下注值不够",3)
			return true
		end
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
	if self.gameData.MainStation==StateManager.MainState.Normal then
		local isPlaying=AudioManager.GetInstance():CheckAudioIsPlaying(17)
		if isPlaying==false then
			AudioManager.GetInstance():PlayNormalAudio(17)
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
		self:SetStopIntervalTime(0.5)
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
	local tempIconResult=self.gameData.GameIconResult[columnIndex]
	self:ShowSpecialIconAnim(columnIndex,tempIconResult)
	local aduioIndex=38
	if self.gameData.MainStation==StateManager.MainState.Normal or self.gameData.MainStation==StateManager.MainState.FreeGame then
		for i=1,#tempIconResult do
			if tempIconResult[i]>=9 and tempIconResult[i]<=11 then
				aduioIndex=19
			end
		end
	end	
	AudioManager.GetInstance():PlayNormalAudio(aduioIndex)
	
end


function GameLogicManager:ShowSpecialIconAnim(columnIndex,tempIconResult)
	for i=1,#tempIconResult do
		if tempIconResult[i]==8 then
			local tempInconIns=IconManager.GetInstance():GetSingleRunIconInsByCoordinate(columnIndex,i+1)
			if tempInconIns then
				tempInconIns:PlayShowAnim()
			end
		end
	end
end



--停止所有滚动回调
function GameLogicManager:AllIconStopRunProcess()
	local IconStopRunProcessFunc=function ()
		self:IsBBGEffectProcess()
		self:SetFreeGameWildProcess()
		self:GameEndProcess()
	end
	startCorotine(IconStopRunProcessFunc)
end



function GameLogicManager:AddIconMask(colmunIndex,rowIndex,iconNum,iconValue)
	IconManager.GetInstance():ChangeAllocateIconMaskInsIcon(colmunIndex,rowIndex,iconNum,iconValue)
end


function GameLogicManager:SetBBGIconMask()
	if self.gameData.MainStation==StateManager.MainState.BBG then
		if self.gameData.BBGNewMultipleList.GreenIcon and #self.gameData.BBGNewMultipleList.GreenIcon>0 then
			for i=1,#self.gameData.BBGNewMultipleList.GreenIcon do
				local greenItem=self.gameData.BBGNewMultipleList.GreenIcon[i]
				self:AddIconMask(greenItem.colmunIndex,greenItem.rowIndex,10,greenItem.value)
			end
			
		end
		
		if self.gameData.BBGNewMultipleList.YellowIcon and #self.gameData.BBGNewMultipleList.YellowIcon>0 then
			for i=1,#self.gameData.BBGNewMultipleList.YellowIcon do
				local yellowItem=self.gameData.BBGNewMultipleList.YellowIcon[i]
				self:AddIconMask(yellowItem.colmunIndex,yellowItem.rowIndex,11,yellowItem.value)
			end
			
		end

	end
end



function GameLogicManager:SetInitBBGIconMask()
	if self.gameData.BBGMultipleList and #self.gameData.BBGMultipleList>0 then
		for k,v in ipairs(self.gameData.BBGMultipleList) do
			if(v and #v>0) then
				for _k,_v in ipairs(v) do
					self:AddIconMask(_v.colmunIndex,_v.rowIndex,_v.iconNum,_v.value)
				end
			end
		end
	end
end


function GameLogicManager:IsBBGEffectProcess()
	if self.gameData.MainStation==StateManager.MainState.BBG then
		--IconManager.GetInstance():IsShowAllIconMask(false)
		if self.gameData.BBGNewMultipleList.GreenIcon and #self.gameData.BBGNewMultipleList.GreenIcon>0 then
			for i=1,#self.gameData.BBGNewMultipleList.GreenIcon do
				self.IconMultiple=0
				self:SetGreeIconEffectProcess(self.gameData.BBGNewMultipleList.GreenIcon[i])
				table.insert(self.gameData.BBGMultipleList[2],self.gameData.BBGNewMultipleList.GreenIcon[i])
				self.gameData.BBGCoordinateState[self.gameData.BBGNewMultipleList.GreenIcon[i].colmunIndex][self.gameData.BBGNewMultipleList.GreenIcon[i].rowIndex-1]=true
			end
			
		end
		
		if self.gameData.BBGNewMultipleList.YellowIcon and #self.gameData.BBGNewMultipleList.YellowIcon>0 then
			for i=1,#self.gameData.BBGNewMultipleList.YellowIcon do
				self.IconMultiple=0
				self:SetYellowIconEffectProcess(self.gameData.BBGNewMultipleList.YellowIcon[i])
				table.insert(self.gameData.BBGMultipleList[3],self.gameData.BBGNewMultipleList.YellowIcon[i])
				self.gameData.BBGCoordinateState[self.gameData.BBGNewMultipleList.YellowIcon[i].colmunIndex][self.gameData.BBGNewMultipleList.YellowIcon[i].rowIndex-1]=true
			end
			
		end
		
		yield_return(WaitForSeconds(1))
		self:SetBBGIconMask()
	end
end





function GameLogicManager:SetGreeIconEffectProcess(greenItem)
	for i=1,#self.gameData.BBGMultipleList[1] do
		self:SetBBGFlyEffectProcess(self.gameData.BBGMultipleList[1][i],greenItem)
	end
	
	if self.gameData.BBGMultipleList[2] and #self.gameData.BBGMultipleList[2]>0 then
		for i=1,#self.gameData.BBGMultipleList[2] do
			self:SetBBGFlyEffectProcess(self.gameData.BBGMultipleList[2][i],greenItem)
		end
	end
end


function GameLogicManager:SetYellowIconEffectProcess(yellowItem)
	
	self:SetGreeIconEffectProcess(yellowItem)
	
	if self.gameData.BBGMultipleList[3] and #self.gameData.BBGMultipleList[3]>0 then
		for i=1,#self.gameData.BBGMultipleList[3] do
			self:SetBBGFlyEffectProcess(self.gameData.BBGMultipleList[3][i],yellowItem)
		end
	end
	
end



function GameLogicManager:SetBBGFlyEffectProcess(startInfo,endInfo,time)
	local tempEffect=ParticleManager.GetInstance():GetAllocateEffect("BBGFlyEffect")
	local tempEffect1=ParticleManager.GetInstance():GetAllocateEffect("IconStartEffect")
	local tempEffect2=nil
	if tempEffect then
		local startIconIns=IconManager.GetInstance():GetSingleRunIconInsByCoordinate(startInfo.colmunIndex,startInfo.rowIndex)
		local endIconIns=IconManager.GetInstance():GetSingleRunIconInsByCoordinate(endInfo.colmunIndex,endInfo.rowIndex)
		if startIconIns and endIconIns then
			tempEffect.transform.position=startIconIns.gameObject.transform.position
			local tempTween=tempEffect.transform:DOMove(endIconIns.gameObject.transform.position, 0.5)
			tempTween:SetEase(self.Ease.Linear)
			
			local tempCure=GameUIManager.GetInstance().AnimationCureConfig[0]
			local startMaskIconIns=IconManager.GetInstance():GetAllocateIconMaskIns(startInfo.colmunIndex,startInfo.rowIndex)
			if startMaskIconIns then
				tempEffect1.transform.position=startIconIns.gameObject.transform.position
				AudioManager.GetInstance():PlayNormalAudio(22)
				local tempTween1=startMaskIconIns.gameObject.transform:DOScale(CSScript.Vector3(1.2,1.2,0), 0.5)
				tempTween1:SetEase(tempCure)
			end
			
			yield_return(WaitForSeconds(0.4))
			AudioManager.GetInstance():PlayNormalAudio(21)
			tempEffect2=ParticleManager.GetInstance():GetAllocateEffect("IconEndEffect")
			tempEffect2.transform.position=endIconIns.gameObject.transform.position
			self.IconMultiple=self.IconMultiple+startInfo.value
			IconManager.GetInstance():SetIconValue(self.IconMultiple,endIconIns)
			
			yield_return(WaitForSeconds(0.6))
		end
		ParticleManager.GetInstance():RecycleEffect(tempEffect)
		ParticleManager.GetInstance():RecycleEffect(tempEffect1)
		ParticleManager.GetInstance():RecycleEffect(tempEffect2)
	end
end



function GameLogicManager:SetFreeGameWildProcess()
	if self.gameData.MainStation==StateManager.MainState.FreeGame and self.gameData.FreeGameWildPosList and #self.gameData.FreeGameWildPosList>0 then
		for i=1,#self.gameData.FreeGameWildPosList do
			local startIconIns=IconManager.GetInstance():GetSingleRunIconInsByCoordinate(self.gameData.FreeGameWildPosList[i].colmun,self.gameData.FreeGameWildPosList[i].row)
			if startIconIns then
				local flyIconText=ParticleManager.GetInstance():GetAllocateEffect("IconText10")
				if flyIconText then
					flyIconText.transform:Find("IconText"):GetComponent(typeof(GameManager.GetInstance().Text)).text=self.gameData.FreeGameWildPosList[i].value
					flyIconText.transform.position=startIconIns:GetIconTextPos()
					startIconIns:IsShowIconText(false)
					local tempTween=flyIconText.transform:DOMove(HandselManager.GetInstance():GetFFCJPostion(), 0.5)
					tempTween:SetEase(self.Ease.Linear)
					AudioManager.GetInstance():PlayNormalAudio(32)
					yield_return(WaitForSeconds(0.51))
					ParticleManager.GetInstance():RecycleEffect(flyIconText)
					self.gameData.BeforeWildTotalMultiple=self.gameData.BeforeWildTotalMultiple+self.gameData.FreeGameWildPosList[i].value
					HandselManager.GetInstance():SetFFCJAddScore(self.gameData.BeforeWildTotalMultiple)
				end
			end
		end
	end
	
end



function GameLogicManager:GameEndProcess()
	self.IsStopRun=true
	self.gameData.IsIconRuning=false
	AudioManager.GetInstance():StopNormalAudio(5)
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
	local allPrizeLineIconInsList={}
	for i=1,#self.gameData.PrizeLineResultList do
		local linePoints=self.gameData.PrizeLineResultList[i].linePoints
		for j=1,#linePoints do
			local LineIconIns=IconManager.GetInstance():GetSingleRunIconInsByCoordinate(linePoints[j].posX+1,linePoints[j].posY+2)
			LineIconIns:PlayBaseIconAnim()
			table.insert(allPrizeLineIconInsList,LineIconIns)
		end
		--LineManager.GetInstance():SelectShowLine(self.gameData.PrizeLineResultList[i].lineId+1,true)
	end
	yield_return(WaitForSeconds(delayTime))
	for i=1,#allPrizeLineIconInsList do
		allPrizeLineIconInsList[i]:StopPlayBaseIconAnim()
	end
	--LineManager.GetInstance():HideAllLine()
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
			--LineManager.GetInstance():SelectShowLine(self.gameData.PrizeLineResultList[i].lineId+1,true)
			yield_return(WaitForSeconds(dealyTime))
			--LineManager.GetInstance():SelectShowLine(self.gameData.PrizeLineResultList[i].lineId+1,false)
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
	self:AutoStartGame()
end



function GameLogicManager:SetOtherStateProcess()
	self:IsSelectGameProcess()
	self:IsFreeGameOverProcess()
	self:IsBBGOverProcess()
	
end


function GameLogicManager:IsSelectGameProcess()
	self:CommonChangMainStateProcess(StateManager.MainState.SelectMiniGame)
end


function GameLogicManager:SetEnterSelectGame(msg)
	StateManager.GetInstance():SetGameMainStation(StateManager.MainState.SelectMiniGame)
	StateManager.GetInstance():SetSubGameStation(StateManager.SubState.SelectMiniGame)
	if GameManager.GetInstance().isGamePlaying==true then
		GameManager.GetInstance().isGamePlaying=false
		return
	end
	AudioManager.GetInstance():StopAllNormalAudio()
	local SetEnterSelectGameProcessFunc=function ()
		local tempIconInsList=IconManager.GetInstance():GetAllocateIconInsByIconValue(9)
		pt(tempIconInsList)
		if tempIconInsList and #tempIconInsList>=6 then
			for i=1,#tempIconInsList do
				tempIconInsList[i]:PlayBaseIconAnim()
			end
			AudioManager.GetInstance():PlayNormalAudio(41)
			yield_return(WaitForSeconds(1.9))
			for i=1,#tempIconInsList do
				tempIconInsList[i]:StopPlayBaseIconAnim()
			end
		end
		SelectGameManager.GetInstance():SetSelectGameProcess()
	end
	startCorotine(SetEnterSelectGameProcessFunc)
	
	
end


function GameLogicManager:IsFreeGameProcess()
	self:CommonChangMainStateProcess(StateManager.MainState.FreeGame)
end

function GameLogicManager:SetEnterFreeGame(msg)
	self.gameData.FreeGameTotalCount=msg.freeGameCount
	self.gameData.RemainFreeGameCount=msg.freeGameCount-msg.freeGameIndex
	self.gameData.fuIconMul=msg.fuIconMul or 0
	self.gameData.fuIconTotalMul=msg.fuIconTotalMul or 0
	--print("免费游戏剩余次数==>"..self.gameData.RemainFreeGameCount)
	self.gameData.FreeGameTotalWinScore=msg.freeGameScore
	StateManager.GetInstance():SetGameMainStation(StateManager.MainState.FreeGame)
	StateManager.GetInstance():SetSubGameStation(StateManager.SubState.FreeGame)
	HandselManager.GetInstance():SetFFCJAddScore(self.gameData.fuIconTotalMul)
	HandselManager.GetInstance():SetFreeFFCJAddScore(self.gameData.fuIconMul)
	BaseFctManager.GetInstance():ResetAddScoreState(self.gameData.FreeGameTotalWinScore)
	if GameManager.GetInstance().isGamePlaying==true then
		GameManager.GetInstance().isGamePlaying=false
		return
	end
	
	self:GetBeforeAutoState()
	SelectGameManager.GetInstance():EndSelectGameCallBack(2)
	
end

function GameLogicManager:IsFreeGameOverProcess()
	if self.gameData.SubStation==StateManager.SubState.FreeGameOver then
		StateManager.GetInstance():EnableGameState(true)
		Debug.LogError("退出免费游戏")
		self:SmallGameSettleAccountsProcess(2)
	end
end




function GameLogicManager:IsBBGProcess()
	self:CommonChangMainStateProcess(StateManager.MainState.BBG)
end


function GameLogicManager:SetEnterBBG(msg)
	StateManager.GetInstance():SetGameMainStation(StateManager.MainState.BBG)
	StateManager.GetInstance():SetSubGameStation(StateManager.SubState.BBG)
	self.gameData.fuIconTotalMul=msg.fuIconTotalMul or 0
	HandselManager.GetInstance():SetFFCJAddScore(self.gameData.fuIconTotalMul)
	if GameManager.GetInstance().isGamePlaying==true then
		GameManager.GetInstance().isGamePlaying=false
		return
	end
	self:GetBeforeAutoState()
	SelectGameManager.GetInstance():EndSelectGameCallBack(1)
	
end


function GameLogicManager:IsBBGOverProcess()
	if self.gameData.SubStation==StateManager.SubState.BBGOver then
		StateManager.GetInstance():EnableGameState(true)
		Debug.LogError("退出BBG")
		IconManager.GetInstance():IsShowAllIconMask(false)
		self:SetBBGOverProcess()
	end
end


function GameLogicManager:SetBBGOverProcess()
	local BBGScoreFlyProcessFunc=function ()
		if self.gameData.BBGMultipleList and #self.gameData.BBGMultipleList>0 then
			local addBBGScore=0
			for k,v in ipairs(self.gameData.BBGMultipleList) do
				if(v and #v>0) then
					for _k,_v in ipairs(v) do
						local tempIconIns=IconManager.GetInstance():GetSingleRunIconInsByCoordinate(_v.colmunIndex,_v.rowIndex)
						if tempIconIns then
							local flyIconText=ParticleManager.GetInstance():GetAllocateEffect("IconText".._v.iconNum)
							if flyIconText then
								flyIconText.transform:Find("IconText"):GetComponent(typeof(GameManager.GetInstance().Text)).text=_v.value
								flyIconText.transform.position=tempIconIns:GetIconTextPos()
								tempIconIns:IsShowIconText(false)
								local tempTween=flyIconText.transform:DOMove(HandselManager.GetInstance():GetFFCJPostion(), 0.5)
								tempTween:SetEase(self.Ease.Linear)
								AudioManager.GetInstance():PlayNormalAudio(32)
								yield_return(WaitForSeconds(0.51))
								ParticleManager.GetInstance():RecycleEffect(flyIconText)
								addBBGScore=addBBGScore+_v.value
								HandselManager.GetInstance():SetFFCJAddScore(addBBGScore)
							end
							
						end
					end
				end
			end
		end
		self:SmallGameSettleAccountsProcess(1)
	end
	startCorotine(BBGScoreFlyProcessFunc)
end


function GameLogicManager:SmallGameSettleAccountsProcess(indexType)
	local EnterSmallGameSettleAccountsFunc=function ()
		local finishData={self.gameData.FreeGameWildMultiple,self.gameData.SingleLineMul,self.gameData.FreeGameTotalWinScore}
		if indexType==2 then
			HandselManager.GetInstance().HandselView:SetFreeGameAddSocre(self.gameData.FreeGameTotalWinScore-self.gameData.WildIconScore)
		end
		HandselManager.GetInstance():SetSetAccountsData(finishData)
		HandselManager.GetInstance().HandselView:PlaySetsettleAccountsAnim(indexType)
		AudioManager.GetInstance():PlayNormalAudio(33)
		yield_return(WaitForSeconds(0.4))
		AudioManager.GetInstance():PlayNormalAudio(27)
		yield_return(WaitForSeconds(1.4))
		AudioManager.GetInstance():PlayNormalAudio(28)
		yield_return(WaitForSeconds(1.7))
		SelectGameManager.GetInstance():ChangeBGScence()
		yield_return(WaitForSeconds(2))
		BaseFctManager.GetInstance():SetPlayerMoney(self.gameData.PlayerMoney)
		StateManager.GetInstance():GameStateOverCallBack()
	end
	startCorotine(EnterSmallGameSettleAccountsFunc)
end




function GameLogicManager:GetBeforeAutoState()
	if self.IsFreeGameState==false then
		self.currentAutoState=self.gameData.IsAutoState
	end
end

function GameLogicManager:RevivificationAutoState()
	self.gameData.IsAutoState=self.currentAutoState
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
		BaseFctManager.GetInstance():SetFreeGameCountTips(self.gameData.RemainFreeGameCount)
		BaseFctManager.GetInstance():IsShowFreeGameBtn(true)
		self.gameData.IsAutoState=true
		self.IsFreeGameState=true
		BaseFctManager.GetInstance():SetPlayerWinScore(0,0,false)
	elseif self.gameData.SubStation==StateManager.SubState.FreeGameOver then
		Debug.LogError("免费游戏结束状态结束回调")
		StateManager.GetInstance():SetGameMainStation(self.gameData.NextMainStation)
		StateManager.GetInstance():SetSubGameStation(self.gameData.NextMainStation+1)
		self:RevivificationAutoState()
		self.IsFreeGameState=false
		HandselManager.GetInstance():ChangeHandselState(false)
		BaseFctManager.GetInstance():IsShowFreeGameBtn(false)
		BGManager.GetInstance():IsShowIconBGPanel(1,true)
		BaseFctManager.GetInstance():SetPlayerWinScore(0,0,false)
		self.gameData.BBGCoordinateState=nil
		self.gameData.BBGMultipleList=nil
		StopAllCorotines()
		IconManager.GetInstance():ClearAllIconItemInsListState()
		AudioManager.GetInstance():StopAllAudio()
	elseif self.gameData.SubStation==StateManager.SubState.BBG then
		Debug.LogError("BBG回调")
		StateManager.GetInstance():SetSubGameStation(StateManager.SubState.Normal)
		BaseFctManager.GetInstance():SetFreeGameCountTips(self.gameData.RemainFreeGameCount)
		BaseFctManager.GetInstance():IsShowFreeGameBtn(true)
		self.gameData.IsAutoState=true
		BaseFctManager.GetInstance():SetPlayerWinScore(0,0,false)
		self:SetInitBBGIconMask()
	elseif self.gameData.SubStation==StateManager.SubState.BBGOver then
		Debug.LogError("BBG结束回调")
		Debug.LogError(self.gameData.NextMainStation)
		StateManager.GetInstance():SetGameMainStation(self.gameData.NextMainStation)
		StateManager.GetInstance():SetSubGameStation(self.gameData.NextMainStation+1)
		self:RevivificationAutoState()
		HandselManager.GetInstance():ChangeHandselState(false)
		BaseFctManager.GetInstance():IsShowFreeGameBtn(false)
		BaseFctManager.GetInstance():SetPlayerWinScore(0,0,false)
		BGManager.GetInstance():IsShowIconBGPanel(1,true)
		self.gameData.BBGCoordinateState=nil
		self.gameData.BBGMultipleList=nil
		AudioManager.GetInstance():StopAllAudio()
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


