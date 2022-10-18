GameUIManager=Class()

local Instance=nil
function GameUIManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:Init(gameObj)
	
end


--Root面板必须使用同步加载
function GameUIManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Root
		local BuildGamePanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				GameUIManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildGamePanelCallBack)
	else
		return Instance
	end
	
	
end


function GameUIManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
	
end


function GameUIManager:Init (gameObj)
	self:InitData()
	self:FindView()
	self:InitView()
	self:AddEventListenner()
end


function GameUIManager:InitData()
	self.gameData=GameManager.GetInstance().gameData 
end




function GameUIManager:FindView()
	local tf=self.gameObject.transform
	self.GamePanelRoot=tf:Find("GamePanel").gameObject
	self.RenderCamera=tf:Find("Camera"):GetComponent(typeof(GameManager.GetInstance().Camera))
	self.AnimationCureConfig=tf:GetComponent(typeof(CS.AnimationCurveConfig)).gameCurve
end


function GameUIManager:InitView()
	self:IsShowGamePanel(false)
end


function GameUIManager:IsShowGamePanel(isShow)
	CommonHelper.SetActive(self.gameObject,isShow)
end

--扣除下注
function GameUIManager:DeductBetPoints(data)
	BaseFctManager.GetInstance():SetPlayerMoney(data.chipScore)
end


function GameUIManager:SetBetMultiple(winScore)
	local tempChipValue=BaseFctManager.GetInstance():GetCurrentBetChipValue()
	if tempChipValue then
		self.gameData.CurrentBetMultiple=winScore/tempChipValue
		Debug.LogError("当前下注倍数为==>"..self.gameData.CurrentBetMultiple)
	else
		Debug.LogError("获取下注值异常")
	end
	
end


function GameUIManager:IsFreeGameOver(beforeState,nextState)
	if beforeState==StateManager.MainState.FreeGame and nextState==StateManager.MainState.Normal then
		Debug.LogError("小游戏退出==>退出免费游戏状态")
		StateManager.GetInstance():SetSubGameStation(StateManager.SubState.FreeGameOver)
	end
end


function GameUIManager:IsBonusOver(beforeState,nextState)
	if beforeState==StateManager.MainState.Bonus then
		Debug.LogError("小游戏退出==>退出Bonus游戏状态")
		StateManager.GetInstance():SetSubGameStation(StateManager.SubState.Bonus)
		StateManager.GetInstance():SetNextMainStation(nextState)
		BonusManager.GetInstance():SetBonusRemainCount(0)
	end
end



function GameUIManager:RequestQuitGameMsg()
	local sendMsg={}
	sendMsg.reserved=1001	
	local bytes = LuaProtoBufManager.Encode("Link_Msg.ExitGameReq",sendMsg)
	GameManager.GetInstance():SendLobbyNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_CS_MSG_ExitGameReq"),bytes)
end


--同步游戏状态
function GameUIManager:RequestSyncGameStateMsg()
	local sendMsg={}
	sendMsg.gameId=1001	
	local bytes = LuaProtoBufManager.Encode("Link_Msg.GameStatusReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_CS_MSG_GameStatusReq"),bytes)
end



----请求游戏结果
function GameUIManager:RequestGameResultMsg(chipIndex,gameType)
	local sendMsg={}
	sendMsg.chipIndex=chipIndex
	sendMsg.gameType=gameType
	local bytes = LuaProtoBufManager.Encode("Link_Msg.LinkPlayReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_CS_MSG_LinkPlayReq"),bytes)
end


--请求进入小游戏类型
function GameUIManager:RequestMiniGameMsg(miniGameType)
	local sendMsg={}
	sendMsg.gameType=miniGameType
	local bytes = LuaProtoBufManager.Encode("Link_Msg.EnterMiniGameReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_EnterMiniGameReq"),bytes)
end


--请求Bonus游戏结果
function GameUIManager:RequesBonusResultMsg(miniGameType)
	local sendMsg={}
	sendMsg.gameType=miniGameType
	local bytes = LuaProtoBufManager.Encode("Link_Msg.MiniMaryGamePlayReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_CS_MSG_MiniMaryGamePlayReq"),bytes)
end



---------------------------------------------------------------------------Handle----------------------------------------------------------------------------

function GameUIManager:AddEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_ExitGameRsp"),self.ResponesQuitGameMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SCMSG_SystemError"),self.ResponesSystemError,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_LinkPlayRsp"),self.ResponesGameResultMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_EnterFreeGameRsp"),self.ResponesEnterFreeGameMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_FinishMiniGameRsp"),self.ResponesFinishMiniGameMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_EnterMaryGameRsp"),self.ResponesEnterBonusMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_MiniMaryGamePlayRsp"),self.ResponesBonusResultMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_UpdateJackpotRsp"),self.ResponesHandselMsg,self)
end


function GameUIManager:RemoveEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_ExitGameRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SCMSG_SystemError"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_LinkPlayRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_EnterFreeGameRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_FinishMiniGameRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_EnterMaryGameRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_MiniMaryGamePlayRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_UpdateJackpotRsp"))
end




function GameUIManager:ResponesQuitGameMsg(msg)
	Debug.LogError("事件回调==>1024")
	local data=LuaProtoBufManager.Decode("Link_Msg.ExitGameRsp",msg)
	pt(data)
	BaseFctManager.GetInstance():QuitGameProcess(data)
end



function GameUIManager:ResponesSystemError(msg)
	Debug.LogError("事件回调==>11001")
	local data=LuaProtoBufManager.Decode("Link_Msg.SystemError",msg)
	pt(data)
	if data and data.errorType>0 then
		self:SystemErrorCode(data)
	end
end


function GameUIManager:SystemErrorCode(errorInfo)
	if errorInfo.errorType==1 then
		Debug.LogError("状态错误============>"..errorInfo.errorType)
		GameLogicManager.GetInstance():ResetAutoGameTimer()
	end
	
	Debug.LogError("当前状态为==>"..errorInfo.curGameStatus)
	StateManager.GetInstance():SetGameMainStation(errorInfo.curGameStatus)
end




function GameUIManager:ResponesGameResultMsg(msg)
	Debug.LogError("事件回调==>10012")
	local data=LuaProtoBufManager.Decode("Link_Msg.LinkPlayRsp",msg)
	pt(data)
	self:SetGameIconResultProcess(data)
end


------解析游戏结果流程------

function GameUIManager:SetGameIconResultProcess(data)
	self:DeductBetPoints(data)
	self:ParseGameIconResult(data.cols)
	self:ParsePrizeLine(data)
	self:ParseGameStateData(data)
	self:ParseFreeGameData(data)
	self:SetBetMultiple(data.winScore)
	self:ParseGameData(data)
	GameLogicManager.GetInstance():RecieveGameIconResultCallBack()
end


function GameUIManager:ParseGameIconResult(iconResult)
	if iconResult and #iconResult>0 then
		for i=1,#iconResult do
			self.gameData.GameIconResult[i]=iconResult[i].row
		end
		self:CaculateFreeIconPosInfo()
	else
		Debug.LogError("解析图标结果异常")
		pt(iconResult)
	end
end


function GameUIManager:CaculateFreeIconPosInfo()
	self.gameData.FreeIconPosInfoList={}
	local freeIndex=0
	
	for i=1,#self.gameData.GameIconResult do
		self.gameData.FreeIconPosInfoList[i]={}
		self.gameData.FreeIconPosInfoList[i].isFree=false
		if CommonHelper.IsContainValueForDic(9,self.gameData.GameIconResult[i]) then
			self.gameData.FreeIconPosInfoList[i].isFree=true
			freeIndex=freeIndex+1
			self.gameData.FreeIconPosInfoList[i].freeIndex=freeIndex
		end
	end
end


function GameUIManager:ParsePrizeLine(data)
	self.gameData.PrizeLineResultList={}
	if data.lineCount>0 then
		self.gameData.TotalPrizeLine=data.lineCount
		if data.prizeLines then
			self.gameData.PrizeLineResultList=data.prizeLines
		else
			Debug.LogError("服务端解析中线异常")
		end
	else
		self.gameData.TotalPrizeLine=0
	end
end


function GameUIManager:ParseGameStateData(data)
	StateManager.GetInstance():SetGameMainStation(data.gameType)
	Debug.LogError("当前主游戏状态为==>"..data.gameType)
	if data.triggerMiniGame and data.triggerMiniGame>=0  then
		Debug.LogError("下一局的游戏状态为：==>"..data.triggerMiniGame)
		StateManager.GetInstance():SetNextMainStation(data.triggerMiniGame)
		
	else
		Debug.LogError("下一局的游戏状态为：==>Normal")
		StateManager.GetInstance():SetNextMainStation(StateManager.MainState.Normal)
	end
end


function GameUIManager:ParseFreeGameData(data)
	if self.gameData.MainStation==StateManager.MainState.FreeGame then
		self.gameData.FreeGameTotalCount=data.freeGameCount
		self.gameData.RemainFreeGameCount=data.freeGameCount-data.freeGameIndex
		self.gameData.FreeGameTotalWinScore=data.freeGameScore
		Debug.LogError("免费游戏剩余次数：==>"..self.gameData.RemainFreeGameCount)
		BaseFctManager.GetInstance():SetFreeGameCountTips(self.gameData.RemainFreeGameCount)
	end
end


function GameUIManager:ParseGameData(data)
	self.gameData.PlayerWinScore=data.winScore
	self.gameData.PlayerMoney=data.userScore
end



----------免费游戏

function GameUIManager:ResponesEnterFreeGameMsg(msg)
	Debug.LogError("进入免费游戏事件回调==>10014")
	local data=LuaProtoBufManager.Decode("Link_Msg.EnterFreeGameRsp",msg)
	pt(data)
	GameLogicManager.GetInstance():SetEnterFreeGame(data)
end




-----------Bonus

function GameUIManager:ResponesEnterBonusMsg(msg)
	Debug.LogError("进入Bonus事件回调==>10018")
	local data=LuaProtoBufManager.Decode("Link_Msg.EnterMaryGameRsp",msg)
	pt(data)
	GameLogicManager.GetInstance():SetEnterBouns(data)
end



function GameUIManager:ResponesBonusResultMsg(msg)
	Debug.LogError("BonusResult事件回调==>10020")
	local data=LuaProtoBufManager.Decode("Link_Msg.MiniMaryGamePlayRsp",msg)
	pt(data)
	BonusManager.GetInstance():PlayBonus(data)
end



---------小游戏结束

function GameUIManager:ResponesFinishMiniGameMsg(msg)
	Debug.LogError("结束小游戏事件回调==>10016")
	local data=LuaProtoBufManager.Decode("Link_Msg.FinishMiniGameRsp",msg)
	pt(data)
	Debug.LogError("之前的主游戏状态为：==>"..data.curGameType)
	Debug.LogError("当前主游戏状态为：==>"..data.nextGameType)
	StateManager.GetInstance():SetGameMainStation(data.curGameType)
	self:IsFreeGameOver(data.curGameType,data.nextGameType)
	self:IsBonusOver(data.curGameType,data.nextGameType)
	self.gameData.PlayerMoney=data.userScore
end




function GameUIManager:ResponesHandselMsg(msg)
	--Debug.LogError("事件回调==>11000")
	local data=LuaProtoBufManager.Decode("Link_Msg.UpdateJackpotRsp",msg)
	--pt(data)
	if data and #data.JackpotValues>0 then
		for i=1,#data.JackpotValues do
			HandselManager.GetInstance():SetSingleHandselInsValue(data.JackpotValues[i].jackpotType,data.JackpotValues[i])
		end
	end
end










function GameUIManager:__delete()
	self:RemoveEventListenner()
	CommonHelper.Destroy(self.gameObject)
	Instance=nil
end