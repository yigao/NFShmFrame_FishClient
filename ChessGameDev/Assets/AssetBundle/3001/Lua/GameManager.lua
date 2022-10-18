GameManager=Class(GameBaseController)

local Instance=nil
function GameManager:ctor(gameId)
	Instance=self
	self.gameId=gameId
	self:InitAddScripts()
end 

function GameManager.GetInstance()
	return Instance
end

function GameManager:InitAddScripts()
	self:AddScriptsPath("Config/GameConfig")
	self:AddScriptsPath("View/Vo/GameData")
	self:AddScriptsPath("Control/GameLogicManager")
	self:AddScriptsPath("State/StateManager")
	self:AddScriptsPath("Module/ModuleManager")
end




function GameManager:Init()
	self:BaseInit()
	self:InitData()
	self:InitInstance()
	self:AddEventListenner()
end

function GameManager:InitData()
	self:InitUnityScripts()
end


function GameManager:InitUnityScripts()
	self.Image=CS.UnityEngine.UI.Image
	self.Camera=CS.UnityEngine.Camera
	self.Canvas=CS.UnityEngine.Canvas
	self.Text=CS.UnityEngine.UI.Text
	self.Button=CS.UnityEngine.UI.Button
	self.Animation=CS.UnityEngine.Animation
	self.DOTween = CS.DG.Tweening.DOTween
	self.Ease = CS.DG.Tweening.Ease
	self.SkeletonGraphic=CS.Spine.Unity.SkeletonGraphic
	self.SkeletonAnimation=CS.Spine.Unity.SkeletonAnimation
end


function GameManager:InitInstance()
	self:LoadManifestFile(self.gameId)
	self.gameData=GameData.New()
	self.GameConfig=GameConfig.New()
	self.GameLogicManager=GameLogicManager.New()
	self.StateManager=StateManager.New()
	self.ModuleManager=ModuleManager.New()
end




function GameManager:GameAssetLoadCompleteCallBack()
	SetManager.GetInstance():InitSoundState()
	GameUIManager.GetInstance():IsShowGamePanel(true)
	AudioManager.GetInstance():PlayBGAudio(1,0.5)
	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.LoadGameAssetsComplete_EventName,false,self.gameData.gameConfigList.RoomConfig_1005List)
end



--------------------------------------------------------Handle事件回调----------------------------------------------------------

function GameManager:AddEventListenner()
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.Network_Reconnect_Succeed_EventName,self.ResetGameState,self)
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.EnterGame_EventName,self.RoomEnterGameCallBack,self)
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.UnloadGameAssets_EventName,self.ClearGameResources,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_EnterGameRsp"),self.EnterGame,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_GameStatusRsp"),self.SyncGameState,self)
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.OpenGameIntroduction_EventName,self.OpenHelpPanel,self)
end


function GameManager:RemoveEventListenner()
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.Network_Reconnect_Succeed_EventName)
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.EnterGame_EventName)
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.UnloadGameAssets_EventName)
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_EnterGameRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_SC_MSG_GameStatusRsp"))
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.OpenGameIntroduction_EventName)
end


function GameManager:OnApplicationFocus(isFocus)
	if(isFocus) then
		self:ResetGameState()	
	end
	
end


function GameManager:ResetGameState()
	if LuaStateControl.GetInstance():GetCurrentStateType() == LuaStateControl.StateType.Game then
		CommonHelper.ClearNetMsgQueue()
		SetManager.GetInstance():BaseResetState()
		GameUIManager.GetInstance():RequestSyncGameStateMsg()
	end
end


function GameManager:RoomEnterGameCallBack(roomID,deskID,chairID,isAutoAllotRoom,roomEnterGameCallBack)
	local sendMsg={}
	sendMsg.game_id=self.gameId
	sendMsg.room_id=roomID
	sendMsg.desk_id=deskID
	sendMsg.chair_id=chairID
	self.isAutoAllotRoom = isAutoAllotRoom
	self.roomEnterGameCallBack=roomEnterGameCallBack
	pt(sendMsg)
	local bytes = LuaProtoBufManager.Encode("ChessQZNN_Msg.EnterGameReq",sendMsg)
	self:SendLobbyNetMessage(LuaProtoBufManager.Enum("ChessQZNN_Msg.Proto_CS_CMD","NF_CS_MSG_EnterGameReq"),bytes)
	
end

function GameManager:EnterGame(msg)
	Debug.LogError("事件回调==>1020")
	local data=LuaProtoBufManager.Decode("ChessQZNN_Msg.EnterGameRsp",msg)
	pt(data)
	self:SetBaseDeskInfoState(data)
	
end


function GameManager:SetBaseDeskInfoState(data)
	if data.result==0 then
		self.gameData.PlayerTotalCount=data.chair_count
		self.gameData.PlayerChairId=data.my_chair_id
		GameUIManager.GetInstance():RequestSyncGameStateMsg()
		CommonHelper.AddOnApplicationFocus(self.OnApplicationFocus,self)
	else
		Debug.LogError("进入游戏错误ErrorID==>"..data.result)
		--self:ShowUITips("进入游戏错误ErrorID==>"..data.result,2)
		if self.isAutoAllotRoom then
			local ExitGameCallBack = function()
				GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.EnterGameFailure_EventName)
			end
			XLuaUIManager.GetInstance():OpenMessageBox(HallLuaDefine.Client_Failure_Code.C_EnterGame_Failure_Error,true,false,false,ExitGameCallBack,nil,nil)
		else
			self:EnterGameErrorTips(data.result)
		end
	end
	
end


function GameManager:EnterGameErrorTips(errorId)
	if errorId and errorId>0 then
		local str = HallLuaDefine.Tips_Info_Str[errorId]
		if str then
			self:ShowUITips(str,2)
		end
	end
end



function GameManager:SyncGameState(msg)
	Debug.LogError("事件回调==>10002")
	local data=LuaProtoBufManager.Decode("ChessQZNN_Msg.GameStatusRsp",msg)
	pt(data)
	
	if self:InitGameConfigData(data)==false then Debug.LogError("初始化数据异常===>>>")  return end 
	
	SetManager.GetInstance():InitQZAndBetValue(self.gameData.QZMulptileList,self.gameData.BetMulptileList)
	self:InitGameState(data)
	
	if self.roomEnterGameCallBack then
		self.roomEnterGameCallBack()
	end
	
end


function GameManager:InitGameConfigData(data)
	local isConfigScucess=true
	if data.qiangNtMulList and #data.qiangNtMulList>0 then
		self.gameData.QZMulptileList=data.qiangNtMulList
	else
		Debug.LogError("抢庄值列表异常")
		isConfigScucess=false
	end
	
	if data.xiaZhuMulList and #data.xiaZhuMulList>0 then
		self.gameData.BetMulptileList=data.xiaZhuMulList
	else
		Debug.LogError("下注值列表异常")
		isConfigScucess=false
	end
	
	if data.betMoney and data.betMoney>0 then
		self.gameData.BaseBetScore=data.betMoney
		TipsManager.GetInstance():SetBaseScoreTipsValue(data.betMoney)
	else
		Debug.LogError("下注底分异常")
		isConfigScucess=false
	end
	
	if data.Players and #data.Players>0 then
		PlayerManager.GetInstance():InitEnterPlayer(data.Players)
	else
		Debug.LogError("玩家列表异常")
		isConfigScucess=false
	end
	
	if data.ZhuangJiaChairdId and data.ZhuangJiaChairdId>=0 and data.ZhuangJiaChairdId<6 then
		self.gameData.ZJChairId=data.ZhuangJiaChairdId
	else
		Debug.LogError("初始化庄家异常==>>>")
		Debug.LogError(data.ZhuangJiaChairdId)
	end
	
	
	
	return isConfigScucess
end



function GameManager:InitGameState(data)
	local gameType=data.gameStatus
	Debug.LogError("当前游戏状态为：==>"..gameType)
	
	if gameType>1 and gameType<8 then
		GameLogicManager.GetInstance():SetMyObsevedStateProcessTips()
	end
	
	if gameType==StateManager.MainState.WaitOtherPlayerState then
		TipsManager.GetInstance():PlayWaitTipsPanel(1,true)
	elseif gameType==StateManager.MainState.GrabTheVillageState then
		GameLogicManager.GetInstance():InitQiangZhuangState(data)
	elseif gameType==StateManager.MainState.AllocateGrabTheVillage then
		GameLogicManager.GetInstance():InitAllocateGrabTheVillage(data)
	elseif gameType==StateManager.MainState.BetState then
		GameLogicManager.GetInstance():InitBetState(data)
	elseif gameType==StateManager.MainState.SendCard then
		GameLogicManager.GetInstance():InitSendCardState(data)
	elseif gameType==StateManager.MainState.OpenCard then
		GameLogicManager.GetInstance():InitOpenCardState(data)
	elseif gameType==StateManager.MainState.NextWaitGame then
		TipsManager.GetInstance():SetCountDownTimer(1,data.curStausLeftTime)
	end
end


function GameManager:OpenHelpPanel()
	SetManager.GetInstance():SetOpenHelpPanel()
end


function GameManager:ClearGameResources()
	SetManager.GetInstance():BaseResetState()
	self:Destroy()
end



function GameManager:__delete()
	CommonHelper.RemoveOnApplicationFocus()
	self:RemoveEventListenner()
	ModuleManager.GetInstance():RemoveCurrentGameSpriteAtlas()
	GameUIManager.GetInstance():Destroy()
	
	self:UnloadManifestAssetBundle(self.gameId,true)
	
	self:UnloadScripts()
	
end