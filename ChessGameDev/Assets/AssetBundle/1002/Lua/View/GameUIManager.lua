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
function GameUIManager:RequestGameResultMsg(chipIndex)
	local sendMsg={}
	sendMsg.chipIndex=chipIndex
	local bytes = LuaProtoBufManager.Encode("Link_Msg.FaFaFaPlayReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_CS_MSG_FaFaFaPlayReq"),bytes)
end


--收分请求
function GameUIManager:RequestRecieveScoreMsg()
	local sendMsg={}
	sendMsg.Reserved=0
	local bytes = LuaProtoBufManager.Encode("Link_Msg.FaFaFaAccountReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_CS_MSG_AccountReq"),bytes)
end



---------------------------------------------------------------------------Handle----------------------------------------------------------------------------

function GameUIManager:AddEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_ExitGameRsp"),self.ResponesQuitGameMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SCMSG_SystemError"),self.ResponesSystemError,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_FaFaFaPlayRsp"),self.ResponesGameResultMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_AccountRsp"),self.ResponesRecieveScoreMsg,self)
	
	
end


function GameUIManager:RemoveEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_ExitGameRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SCMSG_SystemError"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_FaFaFaPlayRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Link_Msg.Proto_Link_CMD","NF_SC_MSG_AccountRsp"))
	
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
		Debug.LogError("钱不够============>"..errorInfo.errorType)
		GameLogicManager.GetInstance():ResetAutoGameTimer()
	end
	
	Debug.LogError("当前状态为==>"..errorInfo.curGameStatus)
	StateManager.GetInstance():SetGameMainStation(errorInfo.curGameStatus)
end




function GameUIManager:ResponesGameResultMsg(msg)
	Debug.LogError("游戏结果回调==>10012")
	local data=LuaProtoBufManager.Decode("Link_Msg.FaFaFaPlayRsp",msg)
	pt(data)
	if data.errorcode==0 then
		self:SetGameIconResultProcess(data)
	elseif data.errorcode==1 then
		Debug.LogError("玩家下注金额不足")
		GameLogicManager.GetInstance():ResetAutoGameTimer()
	end
end


------解析游戏结果流程------

function GameUIManager:SetGameIconResultProcess(data)
	self:DeductBetPoints(data.userScore)
	self:ParseGameIconResult(data.winIconId)
	self:ParseGameStateData(data)
	self:SetBetMultiple(data.winScore)
	self:ParseGameData(data)
	GameLogicManager.GetInstance():RecieveGameIconResultCallBack()
end


function GameUIManager:ParseGameIconResult(iconResult)
	if iconResult  then
		--pt(iconResult)
		local result={}
		table.insert(result,iconResult)
		self.gameData.GameIconResult[1]=result
		if iconResult==14 then
			self.gameData.IsBang=true
		else
			self.gameData.IsBang=false
		end
	else
		Debug.LogError("解析图标结果异常")
	end
end





function GameUIManager:ParseGameStateData(data)
	StateManager.GetInstance():SetGameMainStation(data.winType)
	Debug.LogError("当前主游戏状态为==>"..data.winType)
	if data.triggerMiniGame and data.triggerMiniGame>=0  then
		Debug.LogError("下一局的游戏状态为：==>"..data.triggerMiniGame)
		StateManager.GetInstance():SetNextMainStation(data.triggerMiniGame)
		
	else
		Debug.LogError("下一局的游戏状态为：==>Normal")
		StateManager.GetInstance():SetNextMainStation(StateManager.MainState.Normal)
	end
end




function GameUIManager:ParseGameData(data)
	self.gameData.PlayerWinScore=data.winScore
	self.gameData.AddPlayerWinScore=data.totalWinScore
	self.gameData.PlayerMoney=data.userScore
	
end



function GameUIManager:ResponesRecieveScoreMsg(msg)
	Debug.LogError("游戏结果回调==>10014")
	local data=LuaProtoBufManager.Decode("Link_Msg.FaFaFaAccountRsp",msg)
	pt(data)
	if data.errorcode==0 then
		BaseFctManager.GetInstance():RecieveScoreProcess(data)
	else
		Debug.LogError("收分失败==>"..data.errorcode)
	end
end














function GameUIManager:__delete()
	self:RemoveEventListenner()
	CommonHelper.Destroy(self.gameObject)
	Instance=nil
end