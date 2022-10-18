GuessManager=Class()

local Instance=nil
function GuessManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function GuessManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Guess
		local BuildGuessPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				GuessManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildGuessPanelCallBack)
		
	else
		return Instance
	end
	
	
end


function GuessManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function GuessManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function GuessManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitViewData()
	self:InitView()
	
end


function GuessManager:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.LotteryHostoryInsList={}
	self.CurrentLotteryHostoryIndex=1
	self.CurrentWinScore=0
	self.BeforeWinScore=0
end


function GuessManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_Guess/View/AnimaView/AnimationView",
		"View/Panel/Panel_Guess/View/GuessView",
		"View/Panel/Panel_Guess/View/HostoryView/LotteryHostoryView",
		"View/Panel/Panel_Guess/LotteryHostory/LotteryHostoryItem",
		
	}
end


function GuessManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function GuessManager:InitInstance()
	self.AnimationView=AnimationView.New(self.gameObject)
	self.GuessView=GuessView.New(self.gameObject)
	self.LotteryHostoryView=LotteryHostoryView.New(self.gameObject)
	self.LotteryHostoryItem=LotteryHostoryItem
end


function GuessManager:IsShowGuessPanel(isShow)
	CommonHelper.SetActive(self.gameObject,isShow)
end


function GuessManager:InitViewData()
	
end


function GuessManager:InitView()
	self:IsShowGuessPanel(false)
	self:InitLotteryHostory()
end


function GuessManager:InitLotteryHostory()
	self:CreateLotteryHostoryIns()
end


function GuessManager:CreateLotteryHostoryIns()
	local lotteryHostoryObjList=self.LotteryHostoryView.LotterHostoryObjList
	for i=1,#lotteryHostoryObjList do
		local LHIns=self.LotteryHostoryItem.New(lotteryHostoryObjList[i])
		table.insert(self.LotteryHostoryInsList,LHIns)
	end
end


function GuessManager:IsShowLotteryHostory(index,isShow)
	local tempLHIns=self.LotteryHostoryInsList[index]
	if tempLHIns then
		tempLHIns:IsShowLotteryHostoryPanel(isShow)
	else
		Debug.LogError("LotteryHostory索引越界==>"..index)
	end
end


function GuessManager:HideAllLotteryHostory()
	for i=1,#self.LotteryHostoryInsList do
		self:IsShowLotteryHostory(i,false)
	end
end


function GuessManager:SetSingleLotteryHostory(index,result)
	if index<=#self.LotteryHostoryInsList then
		self.LotteryHostoryInsList[index]:SetSpriteProcess(result)
	else
		Debug.LogError("LotteryHostory超过当前最大限制==>"..index)
	end
	
end


function GuessManager:ResetLotteryHostory(serverHostoryList)
	if serverHostoryList and #serverHostoryList>0 then
		for i=1,#serverHostoryList do
			self:SetSingleLotteryHostory(i,serverHostoryList[i])
		end
	end
end




function GuessManager:EnterGuess()
	self:SetState()
	self:RequestEnterGuess()
end


function GuessManager:SetState()
	StateManager.GetInstance():EnableGameState(true)
	StateManager.GetInstance():SetSubGameStation(StateManager.SubState.Guess)
end


function GuessManager:RequestEnterGuess()
	GameUIManager.GetInstance():RequestMiniGameMsg(StateManager.MainState.Guess-1)
end



function GuessManager:ResponesEnterGuess(msg)
	self:ResetLotteryHostory(msg.resultRecord)
	EarningsManager.GetInstance():IsShowEarningsPanel(false)
	BaseFctManager.GetInstance():StopAutoGame()
	self.GuessView:IsShowWinScoreTips(false)
	self.GuessView:IsShowLoseScoreTips(false)
	self:IsShowGuessPanel(true)
	AudioManager.GetInstance():PlayBGAudio(13,0.5)
	self:ResetEnterGuessView(msg.totalWinScore)
	self:SetEnterProcess()
end


function GuessManager:ResetEnterGuessView(currentWinScore)
	self.GuessView:InitViewData()
	self.GuessView:SetWinScore(currentWinScore)
	
end


function GuessManager:SetEnterProcess()
	local EnterGuessFunc=function ()
		self:ResetAnimStartState()
	end
	
	startCorotine(EnterGuessFunc)
end


function GuessManager:ResetAnimStartState()
	AudioManager.GetInstance():PlayNormalAudio(48)
	self.AnimationView:PlayLeftPesonAnim(1,true)
	self.AnimationView:PlayRightPesonAnim(1,true)
	self.AnimationView:PlayBookmakerAnim(1,true)
	yield_return(WaitForSeconds(1.1))
	self.AnimationView:PlayBookmakerAnim(2,true)
	yield_return(WaitForSeconds(0.3))
	self.GuessView:IsShowBetPanel(true)
	self.GuessView:IsEnableAllBetButton(true)
	self.GuessView:IsShowWinScoreTips(false)
	self.GuessView:IsShowLoseScoreTips(false)
	self.RandomAudioIndex=AudioManager.GetInstance():PlayNormalAudio(CommonHelper.GetRandom(31,35))
end


function GuessManager:RequestBetGuess(index)
	self.GuessView:IsEnableAllBetButton(false)
	GameUIManager.GetInstance():RequesGuessResultMsg(index)
	self:CheckBetGuessTimer()
end


function GuessManager:CheckBetGuessTimer()
	local BetGuessFunc=function ()
		self:ResetCheckBetGuessTimer()
		self.GuessView:IsEnableAllBetButton(true)
		self.GuessView:IsShowBetPanel(true)
		self.GuessView:IsShowBetGoldTips(false)
	end
	self.CheckBetGuessTimer=TimerManager.GetInstance():CreateTimerInstance(5,BetGuessFunc)
end

function GuessManager:ResetCheckBetGuessTimer()
	if self.CheckBetGuessTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.CheckBetGuessTimer)
		self.CheckBetGuessTimer=nil
	end
end


function GuessManager:ResponesBetGuess(msg)
	self:ResetCheckBetGuessTimer()
	self:ParseBetGuessReuslt(msg)
	self:SetPlayGuessProcess()
	
end

function GuessManager:ParseBetGuessReuslt(msg)
	self.GuessView:SetSaiZiValue(msg.diceNumber1,msg.diceNumber2)
	self.OpenResult=msg.gameResult
	Debug.LogError("开奖结果为==>"..msg.gameResult)
	if self.CurrentWinScore==0 then
		self.BeforeWinScore=msg.totalWinScore
	else
		self.BeforeWinScore=self.CurrentWinScore
	end
	self.SaiZiPoint=msg.diceNumber1+msg.diceNumber2
	self.CurrentWinScore=msg.totalWinScore
	Debug.LogError("赢分为==>"..msg.totalWinScore)
	self.IsWin=false
	if msg.resultStatus>0 then
		self.IsWin=true
	end
	Debug.LogError("是否赢==>")
	Debug.LogError(self.IsWin)
	
end


function GuessManager:SetPlayGuessProcess()
	AudioManager.GetInstance():StopNormalAudio(self.RandomAudioIndex)
	local PlayGuessFunc=function ()
		self.GuessView:IsShowBetPanel(false)
		self.AnimationView:PlayBookmakerAnim(3,true)
		yield_return(WaitForSeconds(0.4))
		self.GuessView:IsShowSaiZiPanel(true)
		
		AudioManager.GetInstance():PlayNormalAudio(self.SaiZiPoint-1)
		yield_return(WaitForSeconds(1))
		if self.IsWin then
			self.AnimationView:PlayBookmakerAnim(5,true)
			self.AnimationView:PlayLeftPesonAnim(CommonHelper.GetRandomTwo(3,4),true)
			self.AnimationView:PlayRightPesonAnim(CommonHelper.GetRandomTwo(3,4),true)
			AudioManager.GetInstance():PlayNormalAudio(38)
			--yield_return(WaitForSeconds(1))
			self.GuessView:IsShowWinScoreTips(true)
			self.GuessView:SetWinScore(self.CurrentWinScore)
			self.GuessView:SetWinScoreTips(self.CurrentWinScore)
			yield_return(WaitForSeconds(1.1))
			self.GuessView:ResetView()
			self:ResetAnimStartState()
			
			
		else
			AudioManager.GetInstance():PlayNormalAudio(49)
			self.AnimationView:PlayBookmakerAnim(4,true)
			self.AnimationView:PlayLeftPesonAnim(2,true)
			self.AnimationView:PlayRightPesonAnim(2,true)
			self.GuessView:IsShowLoseScoreTips(true)
			self.GuessView:SetWinScore(self.CurrentWinScore)
			self.GuessView:SetLoseScoreTips(self.BeforeWinScore)
			yield_return(WaitForSeconds(2))
			
			self:LoseCallBack()
		end
		
		
		
	end
	
	startCorotine(PlayGuessFunc)
end


function GuessManager:RequestCollectPoints()
	GameUIManager.GetInstance():RequesCollectPointsGuessMsg()
end



function GuessManager:LoseCallBack()
	GuessManager.GetInstance():IsShowGuessPanel(false)
	StateManager.GetInstance():GameStateOverCallBack()
end



function GuessManager:CollectPointsCallBack()
	GuessManager.GetInstance():IsShowGuessPanel(false)
	EarningsManager.GetInstance():GuessToEarningsWinScoreProcess(self.gameData.MiniGameWinScore,1)
	EarningsManager.GetInstance():IsShowEarningsPanel(true)
	
	
end





function GuessManager:__delete()
	Instance=nil
end