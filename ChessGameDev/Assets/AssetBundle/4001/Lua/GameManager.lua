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
	self.Time = CS.UnityEngine.Time
	self.Slider = CS.UnityEngine.UI.Slider
	self.Vector3 = CS.UnityEngine.Vector3
	self.MeshRenderer = CS.UnityEngine.MeshRenderer
	self.Button=CS.UnityEngine.UI.Button
	self.Animation=CS.UnityEngine.Animation
	self.Animator = CS.UnityEngine.Animator
	self.SkeletonGraphic=CS.Spine.Unity.SkeletonGraphic
	self.SkeletonAnimation=CS.Spine.Unity.SkeletonAnimation
	self.UIFormScript = CS.UIFormScript
	self.UIListScript = CS.UIListScript
	self.UIListElementScript = CS.UIListElementScript
	self.Tween = CS.DG.Tweening.Tween
	self.Sequence = CS.DG.Tweening.Sequence
	self.Ease = CS.DG.Tweening.Ease
	self.DOTween = CS.DG.Tweening.DOTween
	self.TweenExtensions = CS.DG.Tweening.TweenExtensions
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
	BaseFctManager.GetInstance():InitSoundState()
	GameUIManager.GetInstance():IsShowGamePanel(true)
	AudioManager.GetInstance():PlayBGAudio(1,0.5)
	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.LoadGameAssetsComplete_EventName,false,self.gameData.gameConfigList.RoomConfig_1005List)
end



--------------------------------------------------------Handle????????????----------------------------------------------------------
function GameManager:AddEventListenner()
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.Network_Reconnect_Succeed_EventName,self.ResetGameState,self)
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.EnterGame_EventName,self.RoomEnterGameCallBack,self)
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.UnloadGameAssets_EventName,self.ClearGameResources,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_EnterGameRsp"),self.EnterGame,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_GameStatusRsp"),self.SyncGameState,self)
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.OpenGameIntroduction_EventName,self.OpenHelpPanel,self)
end


function GameManager:RemoveEventListenner()
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.Network_Reconnect_Succeed_EventName)
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.EnterGame_EventName)
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.UnloadGameAssets_EventName)
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_EnterGameRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_GameStatusRsp"))
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
		GameUIManager.GetInstance():BaseResetState()
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
	self.roomEnterGameCallBack = roomEnterGameCallBack
	pt(sendMsg)
	local bytes = LuaProtoBufManager.Encode("Lhd_Msg.EnterGameReq",sendMsg)
	self:SendLobbyNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_CS_MSG_EnterGameReq"),bytes)
end

function GameManager:EnterGame(msg)
	Debug.LogError("????????????==>1020")
	local data=LuaProtoBufManager.Decode("Lhd_Msg.EnterGameRsp",msg)
	self:SetBaseDeskInfoState(data)	
	
end


function GameManager:SetBaseDeskInfoState(data)
	if data.result==0 then
		self.gameData.PlayerChairId=data.my_chair_id
		GameUIManager.GetInstance():RequestSyncGameStateMsg()
		CommonHelper.AddOnApplicationFocus(self.OnApplicationFocus,self)
	else
		 if self.isAutoAllotRoom == true then
			local ExitGameCallBack = function(  )
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
	Debug.LogError("????????????==>10002")
	local data=LuaProtoBufManager.Decode("Lhd_Msg.GameStatusRsp",msg)
	pt(data)
	if self:InitGameConfigData(data) == false then
		self:ShowUITips("????????????????????????",3)
		return
	end
	if self.roomEnterGameCallBack then
		self.roomEnterGameCallBack()
	end
end


function GameManager:InitGameConfigData(data)
	local isConfigScucess=true
	 --??????????????????
	if data.gameChipMoneyList and #data.gameChipMoneyList>0 then
		self.gameData.GameChipMoneyList=data.gameChipMoneyList
		BaseFctManager.GetInstance():InitBetChipValue()
	else
		isConfigScucess=false
		self:ShowUITips("?????????????????????????????????",3)
	end
	
	self.gameData.PrizeTotalCount = data.prizeTotalCount   			--???????????????
	self.gameData.PrizeDragonCount = data.prizeDragonCount 			--???????????????
	self.gameData.PrizeTigerCount = data.prizeTigerCount 			--???????????????
	self.gameData.PrizePeaceCount = data.prizePeaceCount			--???????????????

	--???50???????????????
	if data.prizeHistoryRecord and #data.prizeHistoryRecord>0 then
		self.gameData.PrizeHistoryRecord=data.prizeHistoryRecord
	else
		isConfigScucess=false
	end
	
	--?????????????????????????????? ????????????
	if data.ownBetMoney and #data.ownBetMoney>0 then
		self.gameData.OwnBetMoney=data.ownBetMoney
	else
		isConfigScucess=false
	end

	--???????????????????????? ????????????
	if data.allBetMoney and #data.allBetMoney>0 then
		self.gameData.AllBetMoney = data.allBetMoney
	else
		isConfigScucess=false
	end
	
	--????????????
	if data.aryPlayerIndo and #data.aryPlayerIndo>0 then
		PlayerManager.GetInstance():InitPlayerListData(data.aryPlayerIndo)
	else
		isConfigScucess=false
		self:ShowUITips("??????????????????????????????",3)
	end
	self.gameData.BeBankMinMoney = data.ullNtMinMoney 			--??????????????????
	self.gameData.BankMaxNtCount = data.usMaxNtCount			--??????????????????

	--???????????????????????????
	if data.ntWaitList and #data.ntWaitList>0 then
		self.gameData.WaitBankerVoList = data.ntWaitList
	else
		isConfigScucess=false
		self:ShowUITips("??????????????????????????????",3)
	end

	--???????????????
	if  data.ntCurInfo then
		self.gameData.CurBankerVo = data.ntCurInfo
	else
		isConfigScucess=false
		self:ShowUITips("??????????????????????????????",3)
	end

	--???50???????????????
	if data.prizeHistoryRecord and #data.prizeHistoryRecord>0 then
		self.gameData.PrizeHistoryRecord = data.prizeHistoryRecord
	else
		isConfigScucess=false
	end

	self.gameData.MainStation= data.gameStatus				--???????????????
	self.gameData.CurStationLifeTime = data.curStationLifeTime * 0.001 --????????????????????????
	self.gameData.CurStationTotalTime = data.curStationTotalTime * 0.001 --?????????????????????
	if self.gameData.MainStation ==  StateManager.MainState.STATE_GameStart then
		BaseFctManager.GetInstance():EnterGameStart()
		BeBankerManager.GetInstance():EnterGameStart()
		BetChipManager.GetInstance():EnterGameStart()
		BaseFctManager.GetInstance().HistoryRecordView:InitRecordItemView()
	elseif self.gameData.MainStation == StateManager.MainState.STATE_BetChip then
		BaseFctManager.GetInstance():EnterBetChipStatus()
		BetChipManager.GetInstance():EnterBetChip(data.ownBetMoney,data.allBetMoney)
		BaseFctManager.GetInstance().HistoryRecordView:InitRecordItemView()
		BaseFctManager.GetInstance().BankerSimpleView:SetCurBankerValue()
	elseif self.gameData.MainStation == StateManager.MainState.STATE_OpenPrize then
		if self.gameData.CurStationLifeTime <= 4.5 then
			BetChipManager.GetInstance():PrizeBetChip(data.ownBetMoney,data.allBetMoney)
		end
		BaseFctManager.GetInstance():EnterOpenPrizeStatus(data.dragonAreaCard,data.tigerAreaCard,data.prizeType)
		BaseFctManager.GetInstance().HistoryRecordView:InitRecordItemView()
		BaseFctManager.GetInstance().BankerSimpleView:SetCurBankerValue()
	end
	return isConfigScucess
end

function GameManager:InitGameState(gameType)
	Debug.LogError("????????????????????????==>"..gameType)
end


function GameManager:ClearGameResources()
	GameUIManager.GetInstance():BaseResetState()
	self:Destroy()
end


function GameManager:__delete()
	self:RemoveEventListenner()
	ModuleManager.GetInstance():RemoveCurrentGameSpriteAtlas()
	CommonHelper.RemoveOnApplicationFocus()
	BGManager.GetInstance():Destroy()
	PlayerManager.GetInstance():Destroy()
	BetChipManager.GetInstance():Destroy()
	BaseFctManager.GetInstance():Destroy()
	BeBankerManager.GetInstance():Destroy()
	GameUIManager.GetInstance():Destroy()
	self:UnloadManifestAssetBundle(self.gameId,true)
	self:UnloadScripts()
end