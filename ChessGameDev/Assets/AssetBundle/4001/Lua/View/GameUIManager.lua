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



--同步游戏状态
function GameUIManager:RequestSyncGameStateMsg()
	local sendMsg={}
	sendMsg.gameId=4001	
	local bytes = LuaProtoBufManager.Encode("Lhd_Msg.GameStatusReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_CS_MSG_GameStatusReq"),bytes)
end



---------------------------------------------------------------------------Handle----------------------------------------------------------------------------

function GameUIManager:AddEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_ExitGameRsp"),self.ResponesQuitGameMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_GameStartRsp"),self.ResponseGameStartMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_StartBetChipRsp"),self.ResponseStartBetChipMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_OpenPrizeRsp"),self.ResponseOpenPrizeMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_UserRequestNtRsp"),self.ResponseApplyUserBeBank,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_UserRequestOffNtRsp"),self.ResponseDropUserBeBank,self)
end


function GameUIManager:RemoveEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_ExitGameRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_GameStartRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_StartBetChipRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_OpenPrizeRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_UserRequestNtRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_UserRequestOffNtRsp"))
end

function GameUIManager:RequestQuitGameMsg()
	local sendMsg={}
	sendMsg.reserved=4001	
	local bytes = LuaProtoBufManager.Encode("Lhd_Msg.ExitGameReq",sendMsg)
	GameManager.GetInstance():SendLobbyNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_CS_MSG_ExitGameReq"),bytes)
end



function GameUIManager:ResponesQuitGameMsg(msg)
	Debug.LogError("事件回调==>1024")
	local data=LuaProtoBufManager.Decode("Lhd_Msg.ExitGameRsp",msg)
	if data.exit_type==0 then
		self:QuitGame()
	else
		Debug.LogError("退出游戏失败==>"..data.exit_type)
		GameManager.GetInstance():ShowUITips("游戏进行中，不能退出！",2)
	end
end

function GameUIManager:QuitGame()
	self:BaseResetState()
	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.QuitGame_EventName)
end

function GameUIManager:BaseResetState()
	StopAllCorotines()
	TimerManager.GetInstance():RecycleAllTimerIns()
	AudioManager.GetInstance():StopAllNormalAudio()
	BetChipManager.GetInstance():RecycleAllBetChipItem()
	PlayerListRankManager.GetInstance():IsShowPlayerListRankPanel(false)
	BeBankerManager.GetInstance():IsShowBeBankerPanel(false)
	HelpManager.GetInstance():IsShowHelpPanel(false)
end


function GameUIManager:ResponseGameStartMsg(msg)
	self.gameData.MainStation = StateManager.MainState.STATE_GameStart
	local data=LuaProtoBufManager.Decode("Lhd_Msg.GameStartRsp",msg)
	self.gameData.WaitBankerVoList = data.ntWaitList
	if self.gameData.CurBankerVo.usNtChairId ~= data.ntInfo.usNtChairId then
		local name = PlayerManager.GetInstance():GetPlayerVoByChairdId( data.ntInfo.usNtChairId).user_name
		GameManager.GetInstance():ShowUITips(string.format("庄家轮换，【%s】上庄",name),4)
		AudioManager.GetInstance():PlayNormalAudio(24)
	end
	self.gameData.CurBankerVo = data.ntInfo
	self.gameData.CurStationLifeTime = data.curStationLifeTime * 0.001
	self.gameData.CurStationTotalTime = data.curStationTotalTime * 0.001 --当前状态总时间
	BaseFctManager.GetInstance():EnterGameStart()
	BeBankerManager.GetInstance():EnterGameStart()
	PlayerManager.GetInstance():EnterGameStart()
	BetChipManager.GetInstance():EnterGameStart()
end

function GameUIManager:ResponseStartBetChipMsg(msg)
	local data=LuaProtoBufManager.Decode("Lhd_Msg.StartBetChipRsp",msg)
	self.gameData.MainStation = StateManager.MainState.STATE_BetChip 
	self.gameData.CurStationLifeTime = data.curStationLifeTime * 0.001
	self.gameData.CurStationTotalTime = data.curStationTotalTime * 0.001 --当前状态总时间
	BaseFctManager.GetInstance():EnterBetChipStatus()
	PlayerManager.GetInstance():EnterBetChip()
	BetChipManager.GetInstance():EnterBetChip(nil,nil)
end

function GameUIManager:ResponseOpenPrizeMsg(msg)
	self.gameData.MainStation = StateManager.MainState.STATE_OpenPrize 
	local data=LuaProtoBufManager.Decode("Lhd_Msg.OpenPrizeRsp",msg)
	self.gameData.CurStationLifeTime = data.curStationLifeTime * 0.001
	self.gameData.CurStationTotalTime = data.curStationTotalTime * 0.001 --当前状态总时间
	self.gameData.CurBankerVo = data.ntInfo
	self.gameData.PrizeHistoryRecord = data.prizeHistoryRecord
	PlayerManager.GetInstance():EnterOpenPrize(data.aryPlayerIndo)
	BaseFctManager.GetInstance():EnterOpenPrizeStatus(data.dragonAreaCard,data.tigerAreaCard,data.prizeType)
	BetChipManager.GetInstance():EnterOpenPrize()
	RoadManager.GetInstance():UpdateRoadPanel()
end


function GameUIManager:RequestApplyUserBeBank(ntMoney)
	local sendMsg={}
	sendMsg.NtMoney= ntMoney
	local bytes = LuaProtoBufManager.Encode("Lhd_Msg.UserRequestNtReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_CS_MSG_UserRequestNtReq"),bytes)
end

function GameUIManager:ResponseApplyUserBeBank(msg)
	local data=LuaProtoBufManager.Decode("Lhd_Msg.UserRequestNtRsp",msg)
	if data.result == 0 then
		self.gameData.WaitBankerVoList = data.ntWaitList
		BeBankerManager.GetInstance():UpdateBeBankerPanel()
		if self.gameData.PlayerChairId == data.ntInfo.usNtChairId then
			GameManager.GetInstance():ShowUITips("上庄申请成功,已加入上庄列表",3)
		end
	else
		GameManager.GetInstance():ShowUITips("上庄申请失败！！！",3)
	end
end

function GameUIManager:RequestDropUserBeBank()
	local sendMsg={}
	sendMsg.reserved= 0
	local bytes = LuaProtoBufManager.Encode("Lhd_Msg.UserRequestOffNtReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_CS_MSG_UserRequestOffNtReq"),bytes)
end

function GameUIManager:ResponseDropUserBeBank(msg)
	local data=LuaProtoBufManager.Decode("Lhd_Msg.UserRequestOffNtRsp",msg)
	if data.result == 0 then
		GameManager.GetInstance():ShowUITips("您的请求已发送，本局结束后自动下庄",3)
	else
		GameManager.GetInstance():ShowUITips("下庄失败！！！",3)
	end
end


------解析游戏结果流程------
function GameUIManager:__delete()
	self:RemoveEventListenner()
	CommonHelper.Destroy(self.gameObject)
	Instance=nil
end