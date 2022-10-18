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


function GameUIManager:ClearPlayPanel()
	GameLogicManager.GetInstance():ResetAllGamePanelState()
	PlayerManager.GetInstance():ResetAllPlayerPanelState()
end


function GameUIManager:RequestQuitGameMsg()
	local sendMsg={}
	sendMsg.reserved=3001	
	local bytes = LuaProtoBufManager.Encode("ChessQZNN_Msg.ExitGameReq",sendMsg)
	GameManager.GetInstance():SendLobbyNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_CS_MSG_ExitGameReq"),bytes)
end



--同步游戏状态
function GameUIManager:RequestSyncGameStateMsg()
	local sendMsg={}
	sendMsg.gameId=3001	
	local bytes = LuaProtoBufManager.Encode("ChessQZNN_Msg.GameStatusReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_CS_MSG_GameStatusReq"),bytes)
end


--抢庄
function GameUIManager:RequestQiangZhuangMsg(index)
	local sendMsg={}
	sendMsg.chipMulIndex=index	
	local bytes = LuaProtoBufManager.Encode("ChessQZNN_Msg.UserQiangNtReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_CS_MSG_UserQiangNtReq"),bytes)
end

--下注
function GameUIManager:RequestPlayerBetMsg(index)
	local sendMsg={}
	sendMsg.n64BetMulIndex=index	
	local bytes = LuaProtoBufManager.Encode("ChessQZNN_Msg.UserXiaZhuReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_CS_MSG_UserXiaZhuReq"),bytes)
end


--开牌
function GameUIManager:RequestOpenCardMsg()
	local sendMsg={}
	sendMsg.Reserved=1	
	local bytes = LuaProtoBufManager.Encode("ChessQZNN_Msg.UserOpenCardsReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_CS_MSG_UserOpenCardsReq"),bytes)
end


---------------------------------------------------------------------------Handle----------------------------------------------------------------------------

function GameUIManager:AddEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_ExitGameRsp"),self.ResponesQuitGameMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SCMSG_SystemError"),self.ResponesSystemError,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_GameStartRsp"),self.ResponesStartGameMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_StartQiangNtRsp"),self.ResponesStartQiangZhuangMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_UserQiangNtRsp"),self.ResponesPlayerQiangZhuangMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_NtInfoRsp"),self.ResponesConfirmQiangZhuangMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_StartXiaZhuRsp"),self.ResponesStartBetMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_UserXiaZhuRsp"),self.ResponesPlayerStartBetMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_SendCardsRsp"),self.ResponesSendCardMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_StartOpenCardsRsp"),self.ResponesOpenCardMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_UserOoenCardsRsp"),self.ResponesPlayerOpenCardMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_AccountRsp"),self.ResponesAccountMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_UserEnterDeskRsp"),self.ResponesPlayerEnterRoomMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_UserLeaveDeskRsp"),self.ResponesPlayerLeaveRoomMsg,self)
end


function GameUIManager:RemoveEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_ExitGameRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SCMSG_SystemError"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_GameStartRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_StartQiangNtRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_UserQiangNtRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_NtInfoRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_StartXiaZhuRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_UserXiaZhuRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_SendCardsRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_StartOpenCardsRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_UserOoenCardsRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_AccountRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_UserEnterDeskRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_UserLeaveDeskRsp"))
end




function GameUIManager:ResponesQuitGameMsg(msg)
	Debug.LogError("事件回调==>1024")
	local data=LuaProtoBufManager.Decode("ChessQZNN_Msg.ExitGameRsp",msg)
	pt(data)
	SetManager.GetInstance():QuitGameProcess(data)
end


function GameUIManager:ResponesSystemError(msg)
	Debug.LogError("事件回调==>11001")
	local data=LuaProtoBufManager.Decode("ChessQZNN_Msg.SystemError",msg)
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



function GameUIManager:ResponesPlayerEnterRoomMsg(msg)
	Debug.LogError("其它玩家进入====>>>")
	local data=LuaProtoBufManager.Decode("ChessQZNN_Msg.UserEnterDeskRsp",msg)
	pt(data)
	if data.playerInfo then
		PlayerManager.GetInstance():PlayerEnter(data.playerInfo)
	else
		Debug.LogError("其它玩家进入失败")
	end
end


function GameUIManager:ResponesPlayerLeaveRoomMsg(msg)
	Debug.LogError("玩家离开====>>>")
	local data=LuaProtoBufManager.Decode("ChessQZNN_Msg.UserLeaveDeskRsp",msg)
	pt(data)
	if data.chair_id then
		PlayerManager.GetInstance():OtherPlayerLeave(data.chair_id)
	else
		Debug.LogError("玩家离开异常===>>>")
	end
end


------游戏逻辑

function GameUIManager:ResponesStartGameMsg(msg)
	Debug.LogError("开始游戏====>>>")
	local data=LuaProtoBufManager.Decode("ChessQZNN_Msg.GameStartRsp",msg)
	pt(data)
	
	PlayerManager.GetInstance():ResetAllPlayerdStateData(data.Players)
	self:ClearPlayPanel()
	TipsManager.GetInstance():PlayStartGameTipsAnim(true)
	AudioManager.GetInstance():PlayNormalAudio(21)
end





function GameUIManager:ResponesStartQiangZhuangMsg(msg)
	Debug.LogError("开始抢庄====>>>")
	local data=LuaProtoBufManager.Decode("ChessQZNN_Msg.StartQiangNtRsp",msg)
	pt(data)
	
	GameLogicManager.GetInstance():ResetAllGamePanelState()
	
	if PlayerManager.GetInstance():GetMyObservedState() then  return end
	
	local remainTime=data.leftTime or 5000
	TipsManager.GetInstance():SetCountDownTimer(2,remainTime)
	SetManager.GetInstance():IsShowQiangZhunagBtnPanel(true)
end


function GameUIManager:ResponesPlayerQiangZhuangMsg(msg)
	Debug.LogError("抢庄响应====>>>")
	local data=LuaProtoBufManager.Decode("ChessQZNN_Msg.UserQiangNtRsp",msg)
	pt(data)
	
	if data.usErrorCode~=0 then return end
	
	if data.usChairId ==self.gameData.PlayerChairId then
		GameLogicManager.GetInstance():ResetAllGamePanelState()
		local remainTime=TipsManager.GetInstance():GetCurrentCountDoenTime()
		if remainTime>0 then
			TipsManager.GetInstance():SetCountDownTimer(3,remainTime*1000)
		end	
	end
	
	PlayerManager.GetInstance():SetPlayerQiangZhuangTips(data)
end


function GameUIManager:ResponesConfirmQiangZhuangMsg(msg)
	Debug.LogError("分配庄家====>>>")
	local data=LuaProtoBufManager.Decode("ChessQZNN_Msg.NtInfoRsp",msg)
	pt(data)
	self.gameData.ZJChairId=data.usChairId
	GameLogicManager.GetInstance():ResetAllGamePanelState()
	AudioManager.GetInstance():PlayNormalAudio(13)
	PlayerManager.GetInstance():AllocateZhuangJiaTips(data)
end


function GameUIManager:ResponesStartBetMsg(msg)
	Debug.LogError("开始下注====>>>")
	local data=LuaProtoBufManager.Decode("ChessQZNN_Msg.StartXiaZhuRsp",msg)
	pt(data)
	
	GameLogicManager.GetInstance():ResetAllGamePanelState()
	
	if PlayerManager.GetInstance():GetMyObservedState() then  return end
	
	local remainTime=data.leftTime or 5000

	if tonumber(self.gameData.ZJChairId)==tonumber(self.gameData.PlayerChairId) then
		SetManager.GetInstance():IsShowBetBtnPanel(false)
		TipsManager.GetInstance():SetCountDownTimer(5,remainTime)
	else
		TipsManager.GetInstance():SetCountDownTimer(4,remainTime)
		SetManager.GetInstance():IsShowBetBtnPanel(true)
	end
	
end


function GameUIManager:ResponesPlayerStartBetMsg(msg)
	Debug.LogError("响应开始下注====>>>")
	local data=LuaProtoBufManager.Decode("ChessQZNN_Msg.UserXiaZhuRsp",msg)
	pt(data)
	
	if data.usErrorCode~=0 then return end
	
	if data.usChairId ==self.gameData.PlayerChairId then
		GameLogicManager.GetInstance():ResetAllGamePanelState()
		local remainTime=TipsManager.GetInstance():GetCurrentCountDoenTime()
		if remainTime>0 then
			TipsManager.GetInstance():SetCountDownTimer(5,remainTime*1000)
		end	
	end
	
	PlayerManager.GetInstance():SetPlayerBetTips(data)
end


function GameUIManager:ResponesSendCardMsg(msg)
	Debug.LogError("开始发牌====>>>")
	local data=LuaProtoBufManager.Decode("ChessQZNN_Msg.SendCardsRsp",msg)
	pt(data)

	GameLogicManager.GetInstance():ResetAllGamePanelState()
	AudioManager.GetInstance():PlayNormalAudio(22)
	PlayerManager.GetInstance():SendCard(data.palyerCardList)
end


function GameUIManager:ResponesOpenCardMsg(msg)
	Debug.LogError("开始摊牌====>>>")
	local data=LuaProtoBufManager.Decode("ChessQZNN_Msg.StartOpenCardsRsp",msg)
	pt(data)
	
	GameLogicManager.GetInstance():ResetAllGamePanelState()
	
	if PlayerManager.GetInstance():GetMyObservedState() then  return end
	
	local remainTime=data.leftTime or 5000
	TipsManager.GetInstance():SetCountDownTimer(6,remainTime)
	SetManager.GetInstance():IsShowTanPaiBtnPanel(true)
	
end


function GameUIManager:ResponesPlayerOpenCardMsg(msg)
	Debug.LogError("响应玩家摊牌====>>>")
	local data=LuaProtoBufManager.Decode("ChessQZNN_Msg.UserOpenCardsRsp",msg)
	pt(data)
	
	if data.usErrorCode~=0 then return end
	
	if data.usChairId ==self.gameData.PlayerChairId then
		GameLogicManager.GetInstance():ResetAllGamePanelState()
		local remainTime=TipsManager.GetInstance():GetCurrentCountDoenTime()
		if remainTime>1 then
			TipsManager.GetInstance():SetCountDownTimer(7,remainTime*1000)
		end	
	end
	
	PlayerManager.GetInstance():TPCard(data)
end


function GameUIManager:ResponesAccountMsg(msg)
	Debug.LogError("游戏结算====>>>")
	local data=LuaProtoBufManager.Decode("ChessQZNN_Msg.AccountRsp",msg)
	pt(data)
	
	GameLogicManager.GetInstance():ResetAllGamePanelState()
	local remainTime=data.leftTime or 10000
	TipsManager.GetInstance():SetCountDownTimer(1,remainTime)
	PlayerManager.GetInstance():SetSettleAccounts(data.playerlist)
end













function GameUIManager:__delete()
	self:RemoveEventListenner()
	CommonHelper.Destroy(self.gameObject)
	Instance=nil
end