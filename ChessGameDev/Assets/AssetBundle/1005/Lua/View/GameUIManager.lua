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
		local gameObj=GameManager.GetInstance():LoadGameResuorce(aseetPath,false,true)
		if gameObj then
			local gameObject=CommonHelper.Instantiate(gameObj)
			GameUIManager.New(gameObject)
			Instance:LoadComplete()
		else
			--TODO 加载失败跳回大厅
		end
		
	end
	return Instance
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
function GameUIManager:DeductBetPoints(remainScore)
	BaseFctManager.GetInstance():SetPlayerMoney(remainScore)
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



function GameUIManager:IsEnterFreeGame(beforeState,nextState)
	if beforeState==StateManager.MainState.SelectMiniGame and nextState==StateManager.MainState.FreeGame then
		Debug.LogError("小游戏退出==>进入FreeGame游戏状态")
		StateManager.GetInstance():SetSubGameStation(StateManager.SubState.FreeGame)
		StateManager.GetInstance():SetNextMainStation(nextState)
		GameLogicManager.GetInstance():IsFreeGameProcess()
	end
end


function GameUIManager:IsFreeGameOver(beforeState,nextState)
	if beforeState==StateManager.MainState.FreeGame and nextState==StateManager.MainState.Normal then
		Debug.LogError("小游戏退出==>退出免费游戏状态")
		StateManager.GetInstance():SetSubGameStation(StateManager.SubState.FreeGameOver)
		StateManager.GetInstance():SetNextMainStation(nextState)
	end
end


function GameUIManager:IsEnterBBG(beforeState,nextState)
	if beforeState==StateManager.MainState.SelectMiniGame and nextState==StateManager.MainState.BBG then
		Debug.LogError("小游戏退出==>进入BBG游戏状态")
		StateManager.GetInstance():SetSubGameStation(StateManager.SubState.BBG)
		StateManager.GetInstance():SetNextMainStation(nextState)
		GameLogicManager.GetInstance():IsBBGProcess()
	end
end

function GameUIManager:IsBBGOver(beforeState,nextState)
	if beforeState==StateManager.MainState.BBG  then
		Debug.LogError("小游戏退出==>退出bbg游戏状态")
		StateManager.GetInstance():SetSubGameStation(StateManager.SubState.BBGOver)
		StateManager.GetInstance():SetNextMainStation(nextState)
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


--请求SelectMiniGame游戏结果
function GameUIManager:RequesSelectMiniGameResultMsg(miniGameType,selectTypeIndex)
	local sendMsg={}
	sendMsg.gameType=miniGameType
	sendMsg.usSelectValue=selectTypeIndex
	local bytes = LuaProtoBufManager.Encode("Link_Msg.SelectGameSelectOneReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_SelectGameSelectOneReq"),bytes)
end



---------------------------------------------------------------------------Handle----------------------------------------------------------------------------

function GameUIManager:AddEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_ExitGameRsp"),self.ResponesQuitGameMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SCMSG_SystemError"),self.ResponesSystemError,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_LinkPlayRsp"),self.ResponesGameResultMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_EnterFuXingFreeGameRsp"),self.ResponesEnterFreeGameMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_FinishMiniGameRsp"),self.ResponesFinishMiniGameMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_EnterSelectGameRsp"),self.ResponesSelectMiniGameMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_EnterBuBuGaoGameRsp"),self.ResponesEnterBBGMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_UpdateJackpotRsp"),self.ResponesHandselMsg,self)
	
end


function GameUIManager:RemoveEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_ExitGameRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SCMSG_SystemError"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_LinkPlayRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_EnterFuXingFreeGameRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_FinishMiniGameRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_EnterSelectGameRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_EnterBuBuGaoGameRsp"))
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
	self:DeductBetPoints(data.chipScore)
	self:ParseGameIconResult(data.cols)
	self:ParsePrizeLine(data)
	self:ParseGameStateData(data)
	self:ParseFreeGameData(data)
	self:ParseBBGData(data)
	self:SetBetMultiple(data.winScore)
	self:ParseGameData(data)
	GameLogicManager.GetInstance():RecieveGameIconResultCallBack()
end


function GameUIManager:ParseGameIconResult(iconResult)
	if iconResult and #iconResult then
		for i=1,#iconResult do
			self.gameData.GameIconResult[i]=iconResult[i].row
		end
		
	else
		Debug.LogError("解析图标结果异常")
		pt(iconResult)
	end
end


function GameUIManager:ParsePrizeLine(data)
	self.gameData.PrizeLineResultList={}
	if data.lineCount>0 then
		if data.prizeLines then
			self.gameData.PrizeLineResultList=data.prizeLines
		else
			Debug.LogError("服务端解析中线异常")
		end
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
	if self.gameData.MainStation==StateManager.MainState.FreeGame or self.gameData.MainStation==StateManager.MainState.BBG then
		self.gameData.FreeGameTotalCount=data.freeGameCount
		self.gameData.RemainFreeGameCount=data.freeGameCount-data.freeGameIndex
		self.gameData.FreeGameTotalWinScore=data.freeGameScore
		Debug.LogError("免费游戏剩余次数：==>"..self.gameData.RemainFreeGameCount)
		BaseFctManager.GetInstance():SetFreeGameCountTips(self.gameData.RemainFreeGameCount)
		self:CaculateFreeGameWildPos()
	end
end


function GameUIManager:CaculateFreeGameWildPos()
	if self.gameData.MainStation==StateManager.MainState.FreeGame then
		self.gameData.FreeGameWildPosList={}
		for i=1,5 do
			for j=1,#self.gameData.GameIconResult[i] do
				if self.gameData.GameIconResult[i][j]==10 then
					tempPos={}
					tempPos.colmun=i
					tempPos.row=j+1
					tempPos.value=self.gameData.GameIconResult[i+5][j]
					table.insert(self.gameData.FreeGameWildPosList,tempPos)
				end
			end
		end
	end
end



function GameUIManager:ParseBBGData(data)
	self:SetBBGInitData()
	self:SetBBGStateData(data)
	--pt(self.gameData.BBGCoordinateState)
	--pt(self.gameData.BBGMultipleList)
	--pt(self.gameData.BBGNewMultipleList)
end


function GameUIManager:SetBBGInitData()
	if self.gameData.NextMainStation==StateManager.MainState.SelectMiniGame or self.gameData.NextMainStation==StateManager.MainState.BBG then
		self.gameData.BBGCoordinateState={}
		self.gameData.BBGNewMultipleList.GreenIcon={}
		self.gameData.BBGNewMultipleList.YellowIcon={}
		self.gameData.BBGMultipleList={}
		self.gameData.BBGMultipleList[1]={}		--9
		self.gameData.BBGMultipleList[2]={}		--10
		self.gameData.BBGMultipleList[3]={}		--11
		for i=1,5 do
			self.gameData.BBGCoordinateState[i]={}
			for j=1,#self.gameData.GameIconResult[i] do
				local value=self.gameData.GameIconResult[i][j]
				if value==9 or value==10 or value==11 then
					self.gameData.BBGCoordinateState[i][j]=true
					local tempList={}
					tempList.colmunIndex=i
					tempList.rowIndex=j+1
					tempList.value=self.gameData.GameIconResult[i+5][j]
					tempList.iconNum=value
					local index=1
					if value==10 then
						index=2
					elseif value==11 then
						index=3
					end
					table.insert(self.gameData.BBGMultipleList[index],tempList)
				else
					self.gameData.BBGCoordinateState[i][j]=false
				end
				
			end
			
		end
	end
end




function GameUIManager:SetBBGStateData(data)
	if self.gameData.MainStation==StateManager.MainState.BBG then
		self.gameData.BBGNewMultipleList.GreenIcon={}
		self.gameData.BBGNewMultipleList.YellowIcon={}
		for i=1,5 do
			for j=1,#self.gameData.GameIconResult[i] do
				self:SetBBGSingleData(self.gameData.GameIconResult[i][j],10,i,j,self.gameData.BBGNewMultipleList.GreenIcon)
				self:SetBBGSingleData(self.gameData.GameIconResult[i][j],11,i,j,self.gameData.BBGNewMultipleList.YellowIcon)
			end
		end
		
	end
	
end


function GameUIManager:SetBBGSingleData(value,compareVaule,cloumIndex,rowIndex,list)
	if value==compareVaule then
		if self.gameData.BBGCoordinateState[cloumIndex][rowIndex]==false then
			--self.gameData.BBGCoordinateState[cloumIndex][rowIndex]=true
			local tempList={}
			tempList.colmunIndex=cloumIndex
			tempList.rowIndex=rowIndex+1
			tempList.value=self.gameData.GameIconResult[cloumIndex+5][rowIndex]
			tempList.iconNum=compareVaule
			table.insert(list,tempList)
		end
	end
end



function GameUIManager:ParseGameData(data)
	self.gameData.PlayerWinScore=data.winScore
	self.gameData.PlayerMoney=data.userScore
	self.gameData.BeforeWildTotalMultiple=data.usWildIconLastTotalMul or 0
	self.gameData.currentWildTotalMultiple=data.usWildIconTotalMul or 0
end



----------免费游戏

function GameUIManager:ResponesEnterFreeGameMsg(msg)
	Debug.LogError("进入免费游戏事件回调==>10060")
	local data=LuaProtoBufManager.Decode("Link_Msg.EnterFuXingFreeGameRsp",msg)
	pt(data)
	GameLogicManager.GetInstance():SetEnterFreeGame(data)
end




-----------BBG

function GameUIManager:ResponesEnterBBGMsg(msg)
	Debug.LogError("进入BBG游戏事件回调==>10070")
	local data=LuaProtoBufManager.Decode("Link_Msg.EnterBuBuGaoGameRsp",msg)
	pt(data)
	GameLogicManager.GetInstance():SetEnterBBG(data)
end


-----------SelectMiniGame

function GameUIManager:ResponesSelectMiniGameMsg(msg)
	Debug.LogError("进入SelectMiniGame事件回调==>10050")
	local data=LuaProtoBufManager.Decode("Link_Msg.EnterSelectGameRsp",msg)
	pt(data)
	GameLogicManager.GetInstance():SetEnterSelectGame(data)
end







---------小游戏结束

function GameUIManager:ResponesFinishMiniGameMsg(msg)
	Debug.LogError("结束小游戏事件回调==>10016")
	local data=LuaProtoBufManager.Decode("Link_Msg.FinishMiniGameRsp",msg)
	pt(data)
	Debug.LogError("之前的主游戏状态为：==>"..data.curGameType)
	Debug.LogError("当前主游戏状态为：==>"..data.nextGameType)
	StateManager.GetInstance():SetGameMainStation(data.curGameType)
	
	self.gameData.PlayerMoney=data.userScore
	self.gameData.FreeGameTotalWinScore=data.winGameScore
	self.gameData.FreeGameTotalCount=data.nextGameCount
	self.gameData.RemainFreeGameCount=data.nextGameCount-data.nextGameCurPlayCount
	self.gameData.NextGameTotalScore=data.nextGameTotalScore
	self.gameData.FreeGameWildMultiple=data.usWildIconMul or 0
	self.gameData.SingleLineMul=data.usSingleLineMul or 0
	self.gameData.WildIconScore=data.usWildIconScore or 0
	self:FinishMiniProcess(data.curGameType,data.nextGameType)
end



function GameUIManager:FinishMiniProcess(curGameType,nextGameType)
	self:IsFreeGameOver(curGameType,nextGameType)
	self:IsEnterFreeGame(curGameType,nextGameType)
	self:IsEnterBBG(curGameType,nextGameType)
	self:IsBBGOver(curGameType,nextGameType)
	
end





function GameUIManager:ResponesHandselMsg(msg)
	--Debug.LogError("事件回调==>11000")
	local data=LuaProtoBufManager.Decode("Link_Msg.UpdateJackpotRsp",msg)
	--pt(data)
	if data and #data.JackpotValues>0 then
		for i=1,#data.JackpotValues do
			HandselManager.GetInstance():SetHandselData(data.JackpotValues[i].jackpotType,data.JackpotValues[i])
		end
	end
end







function GameUIManager:__delete()
	self:RemoveEventListenner()
	CommonHelper.Destroy(self.gameObject)
	Instance=nil
end